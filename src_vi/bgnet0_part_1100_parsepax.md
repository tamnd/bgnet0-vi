# Phân Tích Gói Tin {#parsing-packets}

Chúng ta đã thấy một số vấn đề với việc nhận dữ liệu có cấu trúc từ một server. Bạn gọi `recv(4096)`, và bạn chỉ nhận lại 20 byte. Hoặc bạn gọi `recv(4096)` và hóa ra dữ liệu dài hơn thế, và bạn cần gọi nó lại.

Còn có một vấn đề tệ hơn ở đó nữa. Nếu server đang gửi cho bạn nhiều phần dữ liệu, bạn có thể nhận được phần đầu _và một phần của phần tiếp theo_. Bạn sẽ có một gói tin hoàn chỉnh và gói tin tiếp theo chỉ mới một phần! Làm thế nào để bạn tái tạo điều này?

Một ví dụ tương tự là nếu tôi cần bạn tách ra từng câu riêng lẻ từ một khối văn bản tôi đưa cho bạn, nhưng bạn chỉ có thể nhận được 20 ký tự một lần.

Bạn gọi `recv(20)` và nhận được:

``` {.default}
This is a test of th
```

Đó chưa phải câu hoàn chỉnh, nên bạn chưa thể in nó. Vì vậy bạn gọi `recv(20)` lại:

``` {.default}
This is a test of the emergency broadcas
```

Vẫn chưa có câu. Gọi lại:

``` {.default}
This is a test of the emergency broadcast system. This is on
```

Ồ! Có dấu chấm ở đó, vì vậy chúng ta có một câu hoàn chỉnh. Vì vậy chúng ta có thể in nó ra. Nhưng chúng ta cũng đã nhận được một phần của câu tiếp theo rồi!

Làm thế nào chúng ta xử lý tất cả điều này một cách khéo léo?

## Biết Không, Cái Gì Sẽ Làm Điều Này Dễ?

Biết không, cái gì sẽ làm điều này dễ? Nếu chúng ta trừu tượng hóa nó ra thì chúng ta có thể làm gì đó như thế này:

``` {.py}
while the connection isn't closed:
    sentence = get_next_packet()
    print(sentence)
```

Đó không phải dễ hơn để nghĩ về sao? Một khi chúng ta có code đó trích xuất gói tin hoàn chỉnh tiếp theo từ luồng dữ liệu, chúng ta chỉ có thể dùng nó.

Và nếu code đó đủ phức tạp, nó thực sự có thể trích xuất các loại gói tin khác nhau từ stream:

``` {.py}
packet = get_next_packet()

if packet.type == PLAYER_POSITION:
    set_player_position(packet.player_index, packet.player_position)

elif packet.type == PRIVATE_CHAT:
    display_chat(packet.player_from, packet.message, private=True)
```

và cứ thế tiếp tục.

Dễ dàng hơn rất nhiều so với việc cố suy luận về các gói tin như các tập hợp byte có thể hoặc không thể hoàn chỉnh.

Tất nhiên, thực hiện xử lý đó mới là thủ thuật thực sự. Hãy nói về cách thực hiện nó.

## Xử Lý Stream Thành Gói Tin

Bí mật lớn để làm điều này hoạt động là: tạo một buffer (vùng đệm) toàn cục lớn.

> Buffer chỉ là từ khác cho vùng lưu trữ dành cho một loạt byte.
> Trong Python, nó sẽ là một bytestring, điều này thuận tiện vì bạn đã nhận
> được những thứ đó trở lại từ `recv()`.

Buffer này sẽ giữ các byte bạn đã thấy cho đến nay. Bạn sẽ kiểm tra buffer để xem nó có chứa một gói dữ liệu hoàn chỉnh không.

Nếu có một gói tin hoàn chỉnh ở đó, bạn sẽ trả về nó (dưới dạng bytestring hoặc đã xử lý). Và cũng, một cách quan trọng, bạn sẽ cắt nó khỏi phần đầu của buffer.

Ngược lại, bạn sẽ gọi `recv()` lại để cố điền đầy buffer cho đến khi bạn có một gói tin hoàn chỉnh.

Trong Python, hãy nhớ dùng từ khóa `global` để truy cập biến toàn cục, ví dụ:

``` {.py}
packet_buffer = b''

def get_next_packet(s):
    global packet_buffer

    # Now we can use the global version in here
```

Ngược lại Python sẽ chỉ tạo ra một biến cục bộ khác che khuất biến toàn cục.

## Ví Dụ Về Câu Lại

Hãy xem lại ví dụ về câu từ đầu chương này.

Chúng ta sẽ gọi hàm `get_sentence()` của mình, và nó sẽ xem tất cả dữ liệu đã nhận cho đến nay và xem có dấu chấm trong đó không.

Cho đến nay chúng ta có:

``` {.default}
  
```

Chưa có gì. Không có dữ liệu nào được nhận. Không có dấu chấm ở đó nên chúng ta không có câu, vì vậy chúng ta phải gọi `recv(20)` lại để lấy thêm byte:

``` {.default}
This is a test of th
```

Vẫn chưa có dấu chấm. Gọi `recv(20)` lại:

``` {.default}
This is a test of the emergency broadcas
```

Vẫn chưa có dấu chấm. Gọi `recv(20)` lại:

``` {.default}
This is a test of the emergency broadcast system. This is on
```

Có một cái! Vì vậy chúng ta làm hai việc:

1. Sao chép câu ra để chúng ta có thể trả về nó, và:

2. Cắt câu khỏi buffer.

Sau bước hai, câu đầu tiên đã biến mất và buffer trông như thế này:

``` {.default}
This is on
```

và chúng ta trả về câu đầu tiên "This is a test of the emergency broadcast system."

Và hàm gọi `get_sentence()` có thể in nó ra.

Và sau đó gọi `get_sentence()` lại!

Trong `get_sentence()`, chúng ta xem lại buffer. (Nhớ, buffer là toàn cục nên nó vẫn có dữ liệu trong đó từ lần gọi cuối.)

``` {.default}
This is on
```

Không có dấu chấm, vì vậy chúng ta gọi `recv(20)` lại, nhưng lần này chúng ta chỉ nhận được 10 byte trở lại:

``` {.default}
This is only a test.
```

Nhưng đó là một câu hoàn chỉnh, vì vậy chúng ta cắt nó khỏi buffer, để nó trống, và sau đó trả về nó cho caller để in.

### Nếu Bạn Nhận Nhiều Câu Cùng Lúc?

Nếu tôi gọi `recv(20)` và nhận lại cái này thì sao:

``` {.default}
Part 1. Part 2. Part
```

Chà, nó vẫn hoạt động! Hàm `get_sentence()` sẽ thấy dấu chấm đầu tiên ở đó, cắt câu đầu tiên khỏi buffer để nó chứa:

``` {.default}
Part 2. Part
```

và sau đó trả về `Part 1.`.

Lần tiếp theo bạn gọi `get_sentence()`, như thường lệ, điều đầu tiên nó làm là kiểm tra xem buffer có chứa một câu đầy đủ không. Có! Vì vậy chúng ta cắt nó ra:

``` {.default}
Part
```

và trả về `Part 2.`

Lần tiếp theo bạn gọi `get_sentence()`, nó không thấy dấu chấm trong buffer, vì vậy không có câu hoàn chỉnh, vì vậy nó gọi `recv(20)` lại để lấy thêm dữ liệu.

``` {.default}
Part 3. Part 4. Part 5.
```

Và bây giờ chúng ta có một câu hoàn chỉnh, vì vậy chúng ta cắt nó khỏi phần đầu:

``` {.default}
Part 4. Part 5.
```

và trả về `Part 3` cho caller. Và cứ thế.

## Sơ Đồ Tổng Thể

Nhìn chung, bạn có thể nghĩ sự trừu tượng này như một ống đầy dữ liệu. Khi có một gói tin hoàn chỉnh trong ống, nó được kéo ra từ phía trước và trả về.

Nhưng nếu không, ống nhận thêm dữ liệu ở phía sau và tiếp tục kiểm tra xem nó đã có toàn bộ gói tin chưa.

Đây là một số pseudocode (mã giả):

``` {.py}
global buffer = b''    # Empty bytestring

function get_packet():
    while True:
        if buffer starts with a complete packet
            extract the packet data
            strip the packet data off the front of the buffer
            return the packet data

        receive more data

        if amount of data received is zero bytes
            return connection closed indicator

        append received data onto the buffer
```

Trong Python, bạn có thể slice (cắt) buffer để loại bỏ dữ liệu gói tin khỏi phần đầu.

Ví dụ, nếu bạn biết dữ liệu gói tin là 12 byte, bạn có thể slice nó ra bằng:

``` {.py}
packet = buffer[:12]   # Grab the packet
buffer = buffer[12:]   # Slice it off the front
```

## Suy Ngẫm

* Mô tả những lợi thế từ góc độ lập trình khi trừu tượng hóa các gói tin
  ra khỏi một luồng dữ liệu.
