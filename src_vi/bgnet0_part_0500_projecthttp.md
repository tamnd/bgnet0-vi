# Dự Án: HTTP Client và Server

Chúng ta sẽ viết một chương trình socket có thể tải xuống file từ web server! Đây sẽ là "web client" của chúng ta. Nó sẽ hoạt động với hầu hết mọi web server ngoài kia, nếu ta code đúng.

Và chưa đủ thì thôi, ta sẽ tiếp tục bằng cách viết một web server đơn giản! Chương trình này sẽ xử lý được các request từ web client ta viết... hay thực ra là bất kỳ web client nào khác như Chrome hay Firefox!

Những chương trình này sẽ dùng một giao thức bạn có lẽ đã nghe đến: HTTP (HyperText Transport Protocol --- Giao thức Truyền tải HyperText).

Và vì chúng nói HTTP, và các trình duyệt web như Chrome cũng nói HTTP, chúng sẽ có thể giao tiếp với nhau!

## Giới Hạn

Để hiểu sâu hơn về sockets API ở mức thấp hơn, dự án này **không được** dùng bất kỳ hàm trợ giúp nào sau đây:

* Hàm `socket.create_connection()`.
* Hàm `socket.create_server()`.
* Bất cứ thứ gì trong module `urllib`.

Sau khi code xong dự án, sẽ thấy rõ hơn những hàm trợ giúp này được triển khai như thế nào.

## Mã Hóa Ký Tự Trong Python

Socket trong Python gửi và nhận các chuỗi byte, khác với chuỗi Python. Bạn sẽ phải chuyển đổi qua lại khi muốn gửi một chuỗi, hoặc khi muốn in một chuỗi byte dưới dạng chuỗi.

Các chuỗi byte phụ thuộc vào _character encoding_ (mã hóa ký tự) được dùng bởi chuỗi. Mã hóa ký tự xác định byte nào tương ứng với ký tự nào. Một số mã hóa bạn có thể đã nghe là ASCII và UTF-8. Có hàng trăm loại.

Mã hóa ký tự mặc định của web là "ISO-8859-1".

Điều này quan trọng vì bạn phải encode chuỗi Python thành chuỗi byte và bạn có thể chỉ định encoding khi làm vậy. (Mặc định là UTF-8.)

Để chuyển từ chuỗi Python sang chuỗi byte ISO-8859-1:

``` {.py}
s = "Hello, world!"          # String
b = s.encode("ISO-8859-1")   # Sequence of bytes
```

Chuỗi byte đó đã sẵn sàng để gửi qua socket.

Để chuyển từ chuỗi byte nhận được từ socket ở định dạng ISO-8859-1 thành chuỗi:

``` {.py}
s = b.decode("ISO-8859-1")
```

Và rồi nó đã sẵn sàng để in.

Tất nhiên, nếu dữ liệu không được mã hóa bằng ISO-8859-1, bạn sẽ nhận được ký tự lạ trong chuỗi hoặc gặp lỗi.

Các mã hóa ASCII, UTF-8 và ISO-8859-1 đều giống nhau cho các chữ cái latin cơ bản, số và dấu câu của bạn, vì vậy các chuỗi sẽ hoạt động như mong đợi trừ khi bạn bắt đầu đi vào một số ký tự Unicode kỳ lạ.

Nếu bạn đang viết bằng C, có lẽ tốt nhất là không lo lắng về điều đó và in các byte ra khi nhận được. Một vài cái có thể là rác, nhưng nó sẽ hoạt động được phần lớn.

## Tóm Tắt HTTP

HTTP hoạt động dựa trên khái niệm _request_ (yêu cầu) và _response_ (phản hồi). Client yêu cầu một trang web, server phản hồi bằng cách gửi nó lại.

Một HTTP request đơn giản từ client trông như thế này:

``` {.default}
GET / HTTP/1.1
Host: example.com
Connection: close

```

Phần đó cho thấy _header_ của request bao gồm phương thức request, đường dẫn và giao thức trên dòng đầu tiên, theo sau là bất kỳ số lượng trường header nào. Có một dòng trống ở cuối header.

Request này đang nói "Lấy trang web gốc từ server example.com và tôi sẽ đóng kết nối ngay khi nhận được response của bạn."

Cuối dòng được phân cách bằng tổ hợp Carriage Return/Linefeed. Trong Python hay C, bạn viết CRLF như thế này:

``` {.py}
"\r\n"
```

Nếu bạn đang request một file cụ thể, nó sẽ ở trên dòng đầu tiên đó, ví dụ:

``` {.default}
GET /path/to/file.html HTTP/1.1
```

(Và nếu có payload đi kèm với header này, nó sẽ nằm ngay sau dòng trống. Cũng sẽ có một header `Content-Length` cho biết độ dài của payload tính bằng byte. Ta không cần lo về điều này cho dự án này.)

Một HTTP response đơn giản từ server trông như thế này:

``` {.default}
HTTP/1.1 200 OK
Content-Type: text/plain
Content-Length: 6
Connection: close

Hello!
```

Response này nói, "Request của bạn thành công và đây là response 6 byte plain text. Ngoài ra, tôi sẽ đóng kết nối ngay sau khi gửi cho bạn. Và payload của response là 'Hello!'."

Lưu ý rằng `Content-Length` được đặt bằng kích thước payload: 6 byte cho `Hello!`.

Một `Content-Type` phổ biến khác là `text/html` khi payload chứa dữ liệu HTML.

## Client

Client nên được đặt tên là `webclient.py`.

Bạn có thể viết client trước server và test nó trên một web server thực đang tồn tại. Không cần viết cả client lẫn server trước khi test.

Mục tiêu với client là bạn có thể chạy nó từ command line, như thế này:

``` {.sh}
$ python webclient.py example.com
```

cho output như thế này:

``` {.default}
HTTP/1.1 200 OK
Age: 586480
Cache-Control: max-age=604800
Content-Type: text/html; charset=UTF-8
Date: Thu, 22 Sep 2022 22:20:41 GMT
Etag: "3147526947+ident"
Expires: Thu, 29 Sep 2022 22:20:41 GMT
Last-Modified: Thu, 17 Oct 2019 07:18:26 GMT
Server: ECS (sec/96EE)
Vary: Accept-Encoding
X-Cache: HIT
Content-Length: 1256
Connection: close

<!doctype html>
<html>
<head>
    <title>Example Domain</title>
    ...
```

(Output bị cắt ngắn, nhưng sẽ hiển thị phần còn lại của HTML cho trang.)

Lưu ý cách phần đầu tiên của output là HTTP response với tất cả những trường đó từ server, rồi có một dòng trống, và mọi thứ theo sau dòng trống là payload của response.

**NGOÀI RA**: bạn cần có thể chỉ định số port để kết nối đến trên command line. Mặc định là port 80 nếu không chỉ định. Vì vậy bạn có thể kết nối đến một web server trên port khác như thế này:

``` {.sh}
$ python webclient.py example.com 8088
```

Điều này sẽ đưa bạn đến port 8088.

Đầu tiên, bạn cần module socket trong Python, vậy nên

``` {.py}
import socket
```

ở đầu. Sau đó bạn có quyền truy cập vào các chức năng.

Đây là một số chi tiết cụ thể cho Python:

* Dùng `socket.socket()` để tạo socket mới. Bạn không cần truyền bất cứ thứ gì --- các giá trị tham số mặc định hoạt động cho dự án này.

* Dùng `s.connect()` để kết nối socket mới đến đích. Bạn có thể bỏ qua bước DNS vì `.connect()` làm điều đó cho bạn.

  Hàm này nhận một tuple làm đối số chứa host và port để kết nối đến, ví dụ:

  ``` {.py}
  ("example.com", 80)
  ```

* Xây dựng và gửi HTTP request. Bạn có thể dùng HTTP request đơn giản được hiển thị ở trên. **Đừng quên dòng trống ở cuối header, và đừng quên kết thúc tất cả các dòng bằng `"\r\n"`!**

  Tôi khuyến nghị dùng phương thức `s.sendall()` để làm điều này. Bạn có thể dùng `.send()` thay thế nhưng nó có thể chỉ gửi một phần dữ liệu.

  (Lập trình viên C sẽ tìm thấy một implementation của `sendall()` trong Beej's Guide.)

* Nhận web response bằng phương thức `s.recv()`. Nó sẽ trả về một số byte trong response. Bạn sẽ phải gọi nó nhiều lần trong một vòng lặp để lấy tất cả dữ liệu từ các trang lớn hơn.

  Nó sẽ trả về một mảng byte rỗng khi server đóng kết nối và không còn dữ liệu nào để đọc, ví dụ:

  ``` {.py}
  d = s.recv(4096)  # Receive up to 4096 bytes
  if len(d) == 0:
      # all done!
  ```

* Gọi `s.close()` trên socket của bạn khi xong.

Test client bằng cách truy cập một số trang web với nó:

``` {.sh}
$ python webclient.py example.com
$ python webclient.py google.com
$ python webclient.py oregonstate.edu
```

## Server

Server nên được đặt tên là `webserver.py`.

Bạn sẽ khởi động web server từ command line như thế này:

``` {.sh}
$ python webserver.py
```

và nó sẽ bắt đầu lắng nghe trên port 28333.

**NGOÀI RA** hãy code nó để ta cũng có thể chỉ định số port tùy chọn như thế này:

``` {.sh}
$ python webserver.py 12399
```

Server sẽ chạy mãi mãi, xử lý các request đến. (Mãi mãi có nghĩa là "cho đến khi bạn nhấn CTRL-C".)

Và nó chỉ gửi lại một thứ bất kể request là gì. Để nó gửi lại server response đơn giản, được hiển thị ở trên.

Vậy nên nó không phải là web server có nhiều tính năng. Nhưng đó là khởi đầu của một cái!

Đây là một số chi tiết cụ thể cho Python:

* Lấy một socket giống như bạn đã làm với client.

* Sau lời gọi `socket()`, bạn nên thêm dòng trông kỳ lạ này:

  ``` {.py}
  s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
  ```

  trong đó `s` là socket descriptor bạn nhận được từ `socket()`. Điều này sẽ ngăn lỗi "Address already in use" trên `bind()` trong một số trường hợp nhất định, điều này chắc chắn sẽ gây nhầm lẫn tại thời điểm đó. Thường xảy ra sau khi server crash. Sau này ta sẽ tìm hiểu tại sao lỗi đó xảy ra.

  Nếu bạn gặp lỗi đó và không muốn thêm dòng code này vì bạn cảm thấy bướng bỉnh, bạn cũng có thể đợi vài phút để OS bỏ cuộc với kết nối bị hỏng.

* Bind socket vào một port bằng `s.bind()`. Hàm này nhận một đối số, một tuple chứa địa chỉ và port bạn muốn bind vào. Địa chỉ có thể để trống để nó chọn địa chỉ cục bộ. Ví dụ, "Bất kỳ địa chỉ cục bộ nào, port 28333" sẽ được truyền như thế này:

  ``` {.py}
  ('', 28333)
  ```

* Thiết lập socket để lắng nghe bằng `s.listen()`.

* Chấp nhận kết nối mới bằng `s.accept()`. Lưu ý rằng hàm này trả về một tuple. Item đầu tiên trong tuple là một socket mới đại diện cho kết nối mới. (Socket cũ vẫn đang lắng nghe và bạn sẽ gọi `s.accept()` trên nó lại sau khi xử lý xong request này.)

  ``` {.py}
  new_conn = s.accept()
  new_socket = new_conn[0]  # This is what we'll recv/send on
  ```

* Nhận request từ client. Bạn nên gọi `new_socket.recv()` trong một vòng lặp tương tự cách bạn làm với client.

  Khi bạn thấy một dòng trống (tức là `"\r\n\r\n"`) trong request, bạn đã đọc đủ và có thể ngừng nhận.

  (Ta không xử lý payload trong request cho dự án này. Cách _đúng_ là tìm header `Content-Length` và sau đó nhận header cộng với nhiều byte đó. Nhưng đó là mục tiêu mở rộng cho bạn.)

  **Cẩn thận**: bạn không thể chỉ vòng lặp cho đến khi `recv()` trả về chuỗi rỗng lần này! Điều này chỉ xảy ra nếu client đóng kết nối, nhưng client không đóng kết nối và nó đang chờ response. Vì vậy bạn phải gọi `recv()` nhiều lần cho đến khi thấy dòng trống đó phân cách cuối header.

* Gửi response. Bạn chỉ cần gửi "simple server response" từ phần trên.

* Đóng socket mới bằng `new_socket.close()`.

* Vòng lặp lại `s.accept()` để lấy request tiếp theo.

Bây giờ chạy web server trong một cửa sổ và chạy client trong cửa sổ khác, và xem liệu nó có kết nối không!

Khi nó hoạt động với `webclient.py`, hãy thử với một trình duyệt web!

Chạy server trên một port chưa dùng (chọn một cái ngẫu nhiên lớn):

``` {.sh}
$ python webserver.py 20123
```

Truy cập URL [`http://localhost:20123/`](http://localhost:20123/) để xem trang. (`localhost` là tên của "máy tính này".)

Nếu nó hoạt động, tuyệt vời!

Hãy thử in giá trị trả về bởi `.accept()`. Có gì trong đó?

Bạn có nhận thấy rằng nếu bạn dùng trình duyệt web để kết nối đến server của bạn, trình duyệt thực ra tạo hai kết nối không? Tìm hiểu sâu hơn và xem bạn có thể tìm ra lý do tại sao không!

## Gợi Ý Và Trợ Giúp

### Address Already In Use

Nếu server của bạn crash và sau đó bạn bắt đầu nhận lỗi "Address already in use" khi cố khởi động lại nó, nghĩa là hệ thống chưa hoàn thành dọn dẹp port. (Trong trường hợp này "address" đề cập đến port.) Hãy chuyển sang một port khác cho server, hoặc đợi một hai phút để nó timeout và dọn dẹp.

### Nhận Dữ Liệu Một Phần

Dù bạn nói với `recv()` rằng bạn muốn nhận 4096 byte, không có gì đảm bảo bạn sẽ nhận được tất cả. Có thể server gửi ít hơn. Có thể dữ liệu bị tách ra trong quá trình truyền và chỉ một phần có ở đây.

Điều này có thể trở nên phức tạp khi xử lý HTTP request hay response vì bạn có thể gọi `recv()` và chỉ nhận được một phần dữ liệu. Tệ hơn, dữ liệu có thể bị tách ngay giữa delimiter dòng trống ở cuối header!

Đừng giả định rằng một lời gọi `recv()` cho bạn tất cả dữ liệu. Luôn gọi nó trong một vòng lặp, nối dữ liệu vào một buffer, cho đến khi bạn có dữ liệu bạn muốn.

`recv()` sẽ trả về một chuỗi rỗng (trong Python) hoặc `0` (trong C) nếu bạn cố đọc từ một kết nối mà phía bên kia đã đóng. Đây là cách bạn có thể phát hiện việc đóng kết nối đó.

### HTTP 301, HTTP 302

Nếu bạn chạy client và nhận được server response có mã `301` hoặc `302`, có lẽ kèm theo thông báo `Moved Permanently` hoặc `Moved Temporarily`, đây là server cho bạn biết rằng tài nguyên cụ thể bạn đang cố lấy ở URL đã chuyển đến URL khác.

Nếu bạn nhìn vào các header bên dưới đó, bạn sẽ tìm thấy trường header `Location:`.

Ví dụ, cố chạy `webclient.py google.com` cho kết quả:

``` {.default}
HTTP/1.1 301 Moved Permanently
Location: http://www.google.com/
Content-Type: text/html; charset=UTF-8
Date: Wed, 28 Sep 2022 20:41:09 GMT
Expires: Fri, 28 Oct 2022 20:41:09 GMT
Cache-Control: public, max-age=2592000
Server: gws
Content-Length: 219
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
Connection: close

<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
Connection closed by foreign host.
```

Lưu ý dòng đầu tiên cho ta biết tài nguyên ta đang tìm đã di chuyển.

Dòng thứ hai với trường `Location:` cho ta biết nó đã di chuyển đến đâu.

Khi trình duyệt web thấy redirect `301`, nó tự động đi đến URL khác nên bạn không phải lo về nó.

Hãy thử! Nhập `google.com` vào trình duyệt và xem nó cập nhật thành `www.google.com` sau một lúc.

### HTTP 400, HTTP 501 (hoặc bất kỳ 500s nào)

Nếu bạn chạy client và nhận được response từ server có mã `400` hoặc bất kỳ mã `500` nào, khả năng cao bạn đã gửi một bad request (yêu cầu không hợp lệ). Tức là dữ liệu request bạn gửi đi có định dạng sai theo cách nào đó.

Đảm bảo rằng mọi trường của header kết thúc bằng `\r\n` và header được kết thúc bởi một dòng trống (tức là `\r\n\r\n` là 4 byte cuối cùng của header).

### HTTP 404 Not Found!

Đảm bảo bạn đặt trường `Host:` đúng với hostname giống như bạn truyền vào trên command line. Nếu sai, nó sẽ `404`.

## Mở Rộng

Những mục này ở đây nếu bạn có thời gian để thử thách bản thân thêm để hiểu sâu hơn về tài liệu. Hãy ép bản thân!

* Chỉnh sửa server để in ra địa chỉ IP và port của client vừa kết nối với nó. Gợi ý: xem giá trị trả về bởi `accept()` trong Python.

* Chỉnh sửa client để có thể gửi payload. Bạn cần có thể đặt `Content-Type` và `Content-Length` dựa trên payload.

* Chỉnh sửa server để trích xuất và in "request method" từ request. Thường thấy nhất là `GET`, nhưng cũng có thể là `POST` hoặc `DELETE` hoặc nhiều loại khác.

* Chỉnh sửa server để trích xuất và in payload được gửi bởi client.
