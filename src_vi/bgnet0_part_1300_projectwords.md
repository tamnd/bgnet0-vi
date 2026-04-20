# Project: The Word Server

Đây là project xoay quanh việc đọc packet (gói tin).

Bạn sẽ nhận một luồng dữ liệu mã hóa từ một server (đã được cung cấp
sẵn) và phải viết code để xác định khi nào bạn đã nhận đủ một packet
hoàn chỉnh, rồi in dữ liệu đó ra.

## Tổng quan (Overview)

**Đầu tiên:** tải các file này về:

* [fls[**`wordserver.py`**|word/wordserver.py]]: server chạy sẵn,
  phát ra danh sách các từ ngẫu nhiên.

* [fls[**`wordclient.py`**|word/wordclient.py]]: code khung (skeleton)
  cho phía client.

**HẠN CHẾ! Không được sửa bất kỳ đoạn code đã có sẵn nào!** Chỉ cần
tìm `TODO` và điền code vào đó. Bạn có thể thêm hàm và biến mới nếu
muốn.

**YÊU CẦU! Code phải hoạt động với mọi giá trị dương truyền vào
`recv()` từ `1` đến `4096`!** Hãy thử các giá trị như `1`, `5`, và
`4096` để chắc chắn tất cả đều chạy được.

**YÊU CẦU! Code phải hoạt động với các từ có độ dài từ 1 đến 65535.**
Server sẽ không gửi từ quá dài, nhưng bạn có thể tự sửa server để test.
Để tạo một chuỗi Python có số ký tự nhất định, bạn có thể dùng:

``` {.py}
long_str = "a" * 256   # Make a string of 256 "a"s
```

**PROTIP! Đọc và hiểu toàn bộ code client hiện có trước khi bắt đầu.**
Điều này sẽ cứu bạn khỏi vô số rắc rối. Và lưu ý rằng cấu trúc code
chính không hề quan tâm đến bytes hay stream --- nó chỉ bận tâm đến
từng packet hoàn chỉnh. Sạch hơn nhiều đúng không?

Bạn sẽ hoàn thiện hai hàm sau:

* **`get_next_word_packet()`**: lấy packet từ tiếp theo hoàn chỉnh từ
  luồng dữ liệu. Hàm này phải trả về _toàn bộ packet_, bao gồm header
  và phần dữ liệu.

* **`extract_word()`**: trích xuất và trả về từ từ một packet từ hoàn
  chỉnh.

Chúng làm gì? Đọc tiếp thôi!

## "Word Packet" là gì?

Khi bạn kết nối đến server, nó sẽ gửi cho bạn một luồng dữ liệu.

Luồng này bao gồm một số lượng ngẫu nhiên (từ 1 đến 10, kể cả hai đầu)
các từ, mỗi từ được đặt trước bằng độ dài của từ đó tính bằng bytes.

Mỗi từ được mã hóa theo UTF-8.

Độ dài của từ được mã hóa dưới dạng số 2-byte big-endian.

Ví dụ, từ "hello" có độ dài 5 sẽ được mã hóa thành các bytes sau (dạng
hex):

``` {.default}
length 5
  |
+-+-+
|   | h  e  l  l  o
00 05 68 65 6C 6C 6F
```

Các số tương ứng với các chữ cái là mã UTF-8 của chúng.

> Fun fact: với các chữ cái và chữ số, UTF-8, ASCII và ISO-8859-1 đều
> có cùng encoding.

Từ "hi" theo sau là "encyclopedia" sẽ được mã hóa thành hai word
packet, truyền trong luồng như sau:

``` {.default}
length 2   length 12
  |           |
+-+-+       +-+-+
|   | h  i  |   | e  n  c  y  c  l  o  p  e  d  i  a
00 02 68 69 00 0C 65 6E 63 79 63 6C 6F 70 65 64 69 61
```

## Cài đặt: `get_next_word_packet()`

Hàm này nhận socket đã kết nối làm đối số. Nó sẽ trả về word packet
tiếp theo (bao gồm độ dài cộng với từ, như khi nhận được) dưới dạng
bytestring.

Nó sẽ tuân theo quy trình được mô tả trong chương [Parsing Packets
(Phân tích Packet)](#parsing-packets) để trích xuất packet từ luồng dữ
liệu.

Ví dụ, nếu các từ là "hi" và "encyclopedia" từ ví dụ trên, và chúng ta
nhận được 5 byte đầu tiên, packet buffer sẽ chứa:

``` {.default}
      h  i  
00 02 68 69 00
```

Ta thấy từ đầu tiên dài 2 bytes, và ta đã nhận đủ 2 bytes đó.

Ta sẽ trích xuất và trả về từ đầu tiên ("hi") cùng với độ dài của nó
(bytes `00` `02`) và trả về bytestring này:

``` {.default}
      h  i
00 02 68 69
```

Ta cũng sẽ bỏ các bytes đó ra khỏi packet buffer để chỉ còn lại byte
zero ở cuối.

``` {.default}
00
```

Lúc này, do trong buffer chưa có từ hoàn chỉnh, lần gọi hàm tiếp theo
sẽ kích hoạt `recv(5)` để lấy thêm dữ liệu, cho ta:

``` {.default}
      e  n  c  y
00 0C 65 6E 63 79
```

Cứ tiếp tục như vậy.

## Cài đặt: `extract_word()`

Hàm này nhận một word packet hoàn chỉnh làm đầu vào, chẳng hạn:

``` {.default}
      h  i
00 02 68 69
```

và trả về chuỗi ký tự của từ đó, `"hi"`.

Việc này bao gồm việc cắt bỏ phần đầu (2 byte độ dài) để lấy phần bytes
của từ.

Nhưng nhớ nhé: từ được mã hóa UTF-8! Vì vậy bạn phải gọi `.decode()`
để chuyển lại thành chuỗi. (Encoding mặc định là UTF-8, nên bạn không
cần truyền đối số vào `.decode()`.)

<!-- Rubric

55 points

-10 Code that was required to be unmodified was not modified
-5 Recv only called with 5 as the argument
-15 Function get_next_word_packet() returns only the next single complete packet as a bytestring
-5 Function get_next_word_packet() properly removes the complete single packet from the front of the global buffer
-5 Function get_next_word_packet() returns None when the connection was closed by the server
-5 Function extract_word() extracts the word from the packet
-10 Function extract_word() returns the word as a decoded UTF-8 string

 -->
