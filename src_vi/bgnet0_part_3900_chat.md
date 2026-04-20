# Dự án: Chat Client và Server Nhiều Người Dùng

Đã đến lúc tổng hợp tất cả lại trong dự án cuối cùng này!

Chúng ta sẽ xây dựng một chat server nhiều người dùng và một chat client đi kèm.

Chat server phải chấp nhận số lượng kết nối tùy ý từ các client. Tất cả các client đều
thấy những gì người khác đang nói.

Không chỉ vậy, còn phải có thông báo khi người dùng tham gia hoặc rời khỏi chat.

Đây là ảnh chụp màn hình mẫu. Dòng nhập liệu ở dưới là nơi người dùng ("pat" trong
ví dụ này) đang gõ nội dung sắp gửi. Vùng phía trên là nơi tất cả output tích lũy lại.

``` {.default}
*** pat has joined the chat
pat: Hello?
*** leslie has joined the chat
leslie: hi everyone!
pat: hows it going
*** chris has joined the chat
chris: OK, now we can start!
pat: lol
leslie: Why are you always last?
*** chris has left the chat

pat> oh no!! :)█
```

## Kiến Trúc Tổng Thể

Sẽ có một server duy nhất, xử lý nhiều client đồng thời.

### Server

Server sẽ dùng `select()` để xử lý nhiều kết nối, kiểm tra xem kết nối nào sẵn sàng đọc.

Bản thân socket listener cũng được đưa vào tập hợp này. Khi nó hiện "ready-to-read"
(sẵn sàng đọc), có nghĩa là có kết nối mới cần `accept()`. Nếu bất kỳ socket nào đã
được accept hiện "ready-to-read", nghĩa là client đó đã gửi dữ liệu cần xử lý.

Khi server nhận được chat packet từ một client, nó phát lại (rebroadcast) tin nhắn chat
đó đến tất cả các client đang kết nối.

> Lưu ý: khi dùng thuật ngữ "broadcast" ở đây, ta dùng theo nghĩa chung là gửi một thứ gì đó
> đến nhiều người. Chúng ta **không** nói đến địa chỉ IP hay Ethernet broadcast. Ta sẽ không
> dùng những thứ đó trong dự án này.

Khi có client mới kết nối hoặc ngắt kết nối, server cũng broadcast thông tin đó đến
tất cả các client.

Vì nhiều client sẽ gửi data stream đến server, server cần duy trì một packet buffer
_cho mỗi client_.

> Bạn có thể đặt đây là một Python `dict` dùng chính socket của client làm key, ánh xạ
> từ socket sang buffer.

Server sẽ được khởi động bằng cách chỉ định số cổng trên dòng lệnh. Đây là bắt buộc;
không có cổng mặc định.

``` {.sh}
python chat_server.py 3490
```

### Client

Khi client được khởi động, người dùng chỉ định biệt danh (nickname, hay còn gọi là
"nick") trên dòng lệnh cùng với thông tin server.

Packet đầu tiên nó gửi là packet "hello" chứa nickname. (Đây là cách server liên kết
kết nối với một nick và phát lại sự kiện kết nối đến các client khác.)

Sau đó, mỗi dòng người dùng gõ vào client sẽ được gửi đến server dưới dạng chat packet.

Mỗi chat packet (hoặc packet kết nối hay ngắt kết nối) mà client nhận được từ server
sẽ được hiển thị trên màn hình.

Client có **giao diện người dùng văn bản** (TUI --- text user interface) giúp output
gọn gàng. Vì output xảy ra bất đồng bộ trên phần khác của màn hình so với input, ta
cần làm một chút phép thuật terminal để tránh chúng ghi đè lên nhau. Code TUI này sẽ
được cung cấp sẵn và được mô tả trong phần tiếp theo.

Vì có thể có dữ liệu đến trong khi người dùng đang gõ, ta cần một cách để xử lý điều đó.
Client sẽ **đa luồng** (multithreaded). Sẽ có hai luồng thực thi (thread).

* Luồng gửi chính (main sending thread) sẽ:
  * Đọc input từ bàn phím
  * Gửi chat message từ người dùng đến server
* Luồng nhận (receiving thread) sẽ:
  * Nhận packet từ server
  * Hiển thị kết quả lên màn hình

Vì không có dữ liệu chia sẻ giữa hai luồng đó, không cần đồng bộ hóa (mutex, v.v.).

> Chúng có chia sẻ socket, nhưng OS đảm bảo rằng nhiều luồng dùng chung socket cùng lúc
> là OK. Nó _threadsafe_ (an toàn với đa luồng).

Nếu bạn cần thêm thông tin về threading trong Python, xem phần [Phụ lục:
Threading](#appendix-threading).

Client sẽ được khởi động bằng cách chỉ định nickname của người dùng, địa chỉ server,
và số cổng server trên dòng lệnh. Tất cả đều là đối số bắt buộc; không có giá trị mặc định.

``` {.sh}
python chat_client.py chris localhost 3490
```

## I/O của Client

Màn hình client được chia thành hai vùng chính:

* Vùng input, ở một hoặc hai dòng cuối màn hình.
* Vùng output, phần còn lại ở phía trên.

(Phần Client TUI bên dưới có chi tiết về cách thực hiện I/O này.)

Dòng input của client ở dưới cùng màn hình phải là nickname của người dùng theo sau
là `>` và một dấu cách. Input được nhập sau phần đó:

``` {.default}
alice> this is some sample input
```

Vùng output trên màn hình có hai loại message chính:

* **Chat message**: hiển thị nickname người nói theo sau là `:` và một dấu cách, rồi nội dung tin nhắn.

  ``` {.default}
  pat: hows it going
  ```

* **Thông báo thông tin** (informational message): hiển thị khi người dùng tham gia hay rời chat,
  hoặc bất kỳ thông tin nào cần in ra. Gồm `***` theo sau là dấu cách, rồi nội dung thông báo.
  Tin nhắn tham gia và rời được hiển thị ở đây:

  ``` {.default}
  *** leslie has joined the chat
  *** chris has left the chat
  ```

### Input Đặc Biệt Của Người Dùng

Nếu input của người dùng bắt đầu bằng `/`, nó có ý nghĩa đặc biệt và cần được phân tích
thêm để xác định hành động.

Hiện tại, input đặc biệt duy nhất được định nghĩa là `/q`:

* **`/q`**: nếu người dùng nhập lệnh này, client phải thoát. Không gửi gì đến server trong
  trường hợp này.

## TUI của Client

[fls[Tải xuống code Chat UI và demo tại đây|chat/chatui.zip]].

Trong file `chatui.py`, có bốn hàm bạn cần, và bạn có thể import chúng như sau:

``` {.py}
from chatui import init_windows, read_command, print_message, end_windows
```

Các hàm là:

* **init_windows()**: gọi hàm này trước khi thực hiện bất kỳ I/O nào liên quan đến UI.
  Nó cũng phải được gọi trước khi bạn khởi động luồng nhận vì luồng đó thực hiện I/O.

* **end_windows()**: gọi hàm này khi chương trình kết thúc để dọn dẹp mọi thứ.

* **read_command()**: hàm này in ra một prompt ở cuối màn hình và chấp nhận input từ người dùng.
  Nó trả về dòng người dùng đã nhập khi họ nhấn phím `ENTER`.

  Ví dụ:

  ``` {.py}
  s = read_command("Enter something> ")
  ```

  Hàm này tự xử lý việc đặt vị trí phần tử trên màn hình.

* **print_message()**: In một message ra vùng output trên màn hình. Xử lý việc cuộn
  và đảm bảo output không can thiệp vào input của `read_command()`.

  Không thêm ký tự xuống dòng vào output. Nó sẽ được thêm tự động.

**Lỗi đã biết**: trên Mac, nếu có gì đó được viết bởi `print_message()`, lần
backspace tiếp theo bạn gõ sẽ hiện `^R` và xuống dòng thêm một hàng. Chưa rõ tại sao điều này xảy ra.

### Biến thể Curses của `chatui`

Nếu thư viện `chatui` gây rắc rối cho bạn, có thể thử phiên bản thay thế `chatuicurses`.
Nó có cùng các hàm và được dùng theo cùng cách.

Trước khi dùng, bạn phải cài thư viện unicurses:

``` {.sh}
python3 -m pip install uni-curses
```

Sau khi cài xong, bạn chỉ cần thay `chatuicurses` vào chỗ `chatui` trong dòng import.

**Vấn đề đã biết trên Mac**: thử nghiệm của tôi báo rằng thư viện curses không được
cài dù thực ra đã có. Điều này có vẻ không ảnh hưởng đến Linux hay Windows.

**Một lưu ý nhỏ** là routine input không nghe lệnh `CTRL-C` để thoát app. Vì vậy,
bạn có thể phải nhấn `CTRL-C` rồi `RETURN` để thực sự thoát ra. Trên Windows,
bạn có thể thử `CTRL-BREAK`.

## Cấu Trúc Packet

Client và server sẽ giao tiếp qua socket TCP (stream) sử dụng cấu trúc packet được định nghĩa sẵn.

Tóm lại, một packet là một số 16-bit big-endian biểu diễn độ dài payload. Payload là
một chuỗi chứa dữ liệu định dạng JSON với mã hóa UTF-8.

> Bạn có thể encode chuỗi JSON sang bytes UTF-8 bằng cách gọi `.encode()` trên chuỗi.
> `.encode()` nhận đối số để chỉ định encoding, nhưng mặc định là `"UTF-8"`.

Vậy điều đầu tiên bạn phải làm khi nhìn vào data stream là đảm bảo bạn có ít nhất hai
bytes trong buffer để xác định độ dài JSON. Rồi sau đó, kiểm tra xem bạn có đủ
độ dài (cộng thêm 2 cho header 2-byte) trong buffer không.

Nếu chưa đủ, bạn phải tiếp tục nhận dữ liệu trong vòng lặp cho đến khi có đủ. Cũng nhớ
rằng bạn có thể nhận một phần dữ liệu của packet tiếp theo trong một lần gọi `recv()`.

Code của bạn phải hoạt động bất kể `recv()` trả về bao nhiêu bytes, dù nhiều hơn hay
ít hơn bạn mong đợi!

**Hãy có một hàm `get_next_packet()`** để trích xuất và trả về packet tiếp theo,
như bạn đã làm trong các dự án trước. Việc trừu tượng hóa byte stream thành packet
như vậy sẽ giúp cuộc sống của bạn dễ dàng hơn.

Ngoài ra: hãy chắc chắn dùng `sendall()` để tất cả dữ liệu bạn muốn gửi thực sự
được gửi đi!

## JSON Payload

Nếu kiến thức JSON của bạn đã hơi bị gỉ sét, xem phần [Phụ lục: JSON](#appendix-json).

Mỗi packet bắt đầu với hai byte chứa độ dài của payload, tiếp theo là payload.

Payload là một chuỗi được mã hóa UTF-8 biểu diễn một JSON object.

Mỗi payload là một Object, và có một trường tên `"type"` biểu diễn loại của payload.
Các trường còn lại thay đổi tùy theo loại.

Trong các ví dụ sau, dấu ngoặc vuông trong chuỗi được dùng để chỉ nơi bạn cần điền
thông tin liên quan. Dấu ngoặc **không** được đưa vào packet.

### Payload "Hello"

Khi client lần đầu kết nối đến server, nó gửi packet `hello` với nickname của người dùng.
Điều này cho phép server liên kết kết nối với một nick.

Packet này PHẢI được gửi trước tất cả các packet khác.

Từ client đến server:

``` {.json}
{
    "type": "hello"
    "nick": "[user nickname]"
}
```

### Payload "Chat"

Đây là tin nhắn chat. Nó có hai dạng tùy thuộc vào việc tin nhắn chat đến từ client
(tức là người dùng muốn gửi tin nhắn) hay từ server (tức là server đang phát lại tin
nhắn của người khác).

Từ client đến server:

``` {.json}
{
    "type": "chat"
    "message": "[message]"
}
```

Từ server đến các client:

``` {.json}
{
    "type": "chat"
    "nick": "[sender nickname]"
    "message": "[message]"
}
```

Client không cần gửi nick của người gửi cùng packet vì server đã có thể liên kết từ
packet `hello` đã gửi trước đó.

### Payload "Join"

Server gửi cái này đến tất cả các client khi có người tham gia chat.

``` {.json}
{
    "type": "join"
    "nick": "[joiner's nickname]"
}
```

### Payload "Leave"

Server gửi cái này đến tất cả các client khi có người rời chat.

``` {.json}
{
    "type": "leave"
    "nick": "[leaver's nickname]"
}
```

## Mở Rộng

Những cái này không tính điểm, nhưng nếu bạn muốn đi xa hơn, đây là một số ý tưởng.
**Lưu ý!** Hãy đảm bảo bài nộp có đầy đủ chức năng chính thức như đã mô tả. Những
mod này có thể là tập hợp cha của đó, hoặc bạn có thể fork một dự án mới để chứa chúng.

Tối thiểu, tôi khuyên bạn nên branch từ phiên bản đang hoạt động để nó không bị
vô tình làm hỏng!

* Thêm tin nhắn trực tiếp (direct messaging) --- nếu người dùng "pat" gửi:
  ``` {.default}
  /message chris how's it going?
  ```
  thì "chris" sẽ thấy:
  ``` {.default}
  pat -> chris: how's it going?
  ```
  (Nếu người dùng không tồn tại thì sao? Có lẽ bạn cần định nghĩa một error packet
  để server gửi lại!)

* Thêm cách liệt kê tên của tất cả mọi người trong chat

* Thêm emote (biểu cảm) --- nếu người dùng "pat" gửi:
  ``` {.default}
  /me goes out to buy some snacky cakes
  ```
  mọi người khác thấy:
  ``` {.default}
  [pat goes out to buy some snacky cakes]
  ```
  (Cách làm đúng là thêm một packet type mới!)

* Thêm chat room --- có thể có một phòng mặc định khi mọi người mới tham gia,
  với các tính năng thêm: tạo chat room, tham gia hoặc rời chat room,
  và liệt kê các chat room hiện có.

* Biến toàn bộ thứ này thành một [MUD](https://en.wikipedia.org/wiki/Multi-user_dungeon).
  Điều đó sẽ giữ bạn bận rộn!

## Một Số Gợi Ý

Đây là một số gợi ý có thể hữu ích.

  * Cho server dùng tập hợp (set) các socket đang kết nối mà nó truyền vào `select()`
    làm danh sách chính thức của tất cả những người đang kết nối.

    Nếu client ngắt kết nối, xóa nó khỏi tập hợp.

    Nếu có client mới kết nối, thêm nó vào tập hợp.

    Tập hợp sẽ luôn phản ánh tất cả những người đang kết nối tại thời điểm này.

  * Có một buffer cho mỗi kết nối trên server. Nhớ lại cách chúng ta có một buffer
    trong các dự án trước để tích lũy dữ liệu cho đến khi có một packet đầy đủ?
    Chúng ta cần một buffer như vậy _cho mỗi kết nối_. Và trong dự án này, ta có
    nhiều kết nối lắm.

    Dùng `dict` để lưu trữ các buffer. Key là chính socket đó, value là chuỗi với
    buffer cho socket đó.

  * Nhớ dự án mà ta viết code để trích xuất packet từ bytestring buffer không?

    Dùng chiến lược đó lại.

  * Bạn sẽ muốn dùng `.to_bytes()` và `.from_bytes()` để get và set độ dài packet.

  * Tận dụng các dự án cũ nhiều nhất có thể.

<!-- Rubric

5 points each

Client sends correct `chat` packet JSON (nickname not included)

Client sends correct `hello` packet JSON

Client handles `join` packet JSON

Client handles `leave` packet JSON

Client implements the text user interface from `chatui`

Client is multithreaded, one thread for receiving and one for input and sending

Client extracts len+JSON packets from stream correctly

Client JSON strings are UTF-8 encoded

Client encodes packets correctly with the length and JSON payload

Client accepts nickname, server, and port number on the command line

Client `/q` command implemented correctly

Server sends correct `chat` packet JSON

Server sends correct `join` packet JSON

Server sends correct `leave` packet JSON

Server handles `hello` packet JSON

Server uses select to handle multiple connections

Server extracts len+JSON packets from stream correctly

Server JSON strings are UTF-8 encoded

Server encodes packets correctly with the length and JSON payload

Server accepts port number on the command line
-->
