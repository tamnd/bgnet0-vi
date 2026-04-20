# Dự Án: Web Server Tốt Hơn

Đã đến lúc cải thiện web server để nó phục vụ các file thực sự!

Chúng ta sẽ làm cho nó hoạt động sao cho khi một web client (trong trường hợp này chúng ta dùng trình duyệt) yêu cầu một file cụ thể, webserver sẽ trả về file đó.

Dọc đường sẽ có một số chi tiết thú vị.

## Hạn Chế

Để hiểu sâu hơn về sockets API ở cấp độ thấp hơn, dự án này **không được** dùng bất kỳ hàm helper nào sau đây:

* Hàm `socket.create_connection()`.
* Hàm `socket.create_server()`.
* Bất cứ thứ gì trong các module `urllib` (ngoại trừ `urllib.parse` --- điều đó OK).

Sau khi code xong dự án, sẽ rõ hơn các hàm helper này được thực hiện như thế nào.

## Chạy Server

Giống như dự án trước, server nên bắt đầu lắng nghe trên cổng 28333 ***trừ khi*** người dùng chỉ định một cổng trên dòng lệnh. Ví dụ:

``` {.sh}
$ python webserver.py       # Listens on port 28333
$ python webserver.py 3490  # Listens on port 3490
```

## Quy Trình

Nếu bạn vào trình duyệt và nhập một URL như thế này (thay thế số cổng của server đang chạy của bạn):

``` {.default}
http://localhost:33490/file2.html
```

Client sẽ gửi một yêu cầu đến server của bạn trông giống thế này:

``` {.default}
GET /file2.html HTTP/1.1
Host: localhost
Connection: close

```

Chú ý tên file ngay ở đó trong yêu cầu `GET` trên dòng đầu tiên!

Server của bạn sẽ:

1. Phân tích header yêu cầu đó để lấy tên file.
2. Loại bỏ đường dẫn vì lý do bảo mật.
3. Đọc dữ liệu từ file có tên đó.
4. Xác định loại dữ liệu trong file, HTML hay text.
5. Tạo một gói phản hồi HTTP với dữ liệu file trong payload.
6. Gửi phản hồi HTTP đó trở lại client.

Phản hồi sẽ trông giống như file ví dụ này:

``` {.default}
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 373
Connection: close

<!DOCtype html>

<html>
<head>
...
```

[Phần còn lại của file HTML đã bị cắt bớt trong ví dụ này.]

Lúc này, trình duyệt sẽ hiển thị file.

Chú ý một vài thứ trong header cần tính toán: `Content-Type` sẽ được đặt theo loại dữ liệu trong file đang được phục vụ, và `Content-Length` sẽ được đặt bằng độ dài tính bằng byte của dữ liệu đó.

Chúng ta muốn có thể hiển thị ít nhất hai loại file khác nhau: HTML và file text.

## Phân Tích Header Yêu Cầu

Bạn sẽ muốn đọc vào toàn bộ header yêu cầu, nên bạn có thể đang làm gì đó như tích lũy dữ liệu từ tất cả các `recv()` của bạn trong một biến duy nhất và tìm kiếm trong đó (với thứ gì đó như phương thức `.find()` của string để tìm `"\r\n\r\n"` đánh dấu kết thúc header.

Sau đó, bạn có thể `.split()` dữ liệu header trên `"\r\n"` để lấy từng dòng riêng lẻ.

Dòng đầu tiên là dòng `GET`.

Bạn có thể `.split()` dòng đơn đó thành ba phần: phương thức yêu cầu (`GET`), đường dẫn (ví dụ `/file1.txt`), và giao thức (`HTTP/1.1`).

Đừng quên `.decode("ISO-8859-1")` dòng đầu tiên của yêu cầu để bạn có thể dùng nó như một string.

Chúng ta chỉ thực sự cần đường dẫn.

## Rút Gọn Đường Dẫn Xuống Tên File

**RỦI RO BẢO MẬT!** Nếu chúng ta không rút gọn đường dẫn, kẻ tấn công độc hại có thể dùng nó để truy cập các file tùy ý trên hệ thống của bạn. Bạn có thể nghĩ ra cách họ có thể xây dựng một URL đọc `/etc/password` không?

Web server thực sự chỉ kiểm tra để đảm bảo đường dẫn bị giới hạn trong một cây thư mục nhất định, nhưng chúng ta sẽ đi theo cách đơn giản và chỉ loại bỏ toàn bộ thông tin đường dẫn và chỉ phục vụ file từ thư mục mà webserver đang chạy trong đó.

Đường dẫn sẽ được tạo thành từ các tên thư mục được phân tách bằng dấu gạch chéo (`/`), nên cách dễ nhất tại đây là dùng `.split('/')` trên đường dẫn và tên file, rồi xem phần tử cuối cùng.

``` {.py}
fullpath = "/foo/bar/baz.txt"

file_name = fullpath.split("/")[-1]
```

Một cách linh hoạt hơn là dùng hàm thư viện chuẩn `os.path.split`. Giá trị trả về bởi `os.path.split` sẽ là một tuple với hai phần tử, phần tử thứ hai là tên file:

``` {.py}
fullpath = "/foo/bar/baz.txt"

os.path.split(fullpath)
=> ('/foo/bar', 'baz.txt')
```

Chọn phần tử cuối cùng:

``` {.py}
fullpath = "/foo/bar/baz.txt"

file_name = os.path.split(fullpath)[-1]
```

Dùng cái đó để lấy tên file bạn muốn phục vụ.

## MIME và Lấy `Content-Type`

Trong HTTP, payload có thể là bất cứ thứ gì --- bất kỳ tập hợp byte nào. Vậy làm thế nào trình duyệt web biết cách hiển thị nó?

Câu trả lời nằm trong header `Content-Type`, cho biết loại [MIME](https://en.wikipedia.org/wiki/MIME) (Multipurpose Internet Mail Extensions --- định dạng nội dung đa năng) của dữ liệu. Điều này đủ để client biết cách hiển thị nó.

Một số loại MIME ví dụ:

<!-- CAPTION: MIME Types -->
|MIME Type|Description|
|-|-|
|`text/plain`|Plain text file|
|`text/html`|HTML file|
|`application/pdf`|PDF file|
|`image/jpeg`|JPEG image|
|`image/gif`|GIF image|
|`application/octet-stream`|Generic unclassified data|

Có [rất nhiều loại MIME](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types) để xác định bất kỳ loại dữ liệu nào.

Bạn đặt chúng ngay trong phản hồi HTTP trong header `Content-Type`:

``` {.default}
Content-Type: application/pdf
```

Nhưng làm thế nào bạn biết file chứa loại dữ liệu gì?

Cách cổ điển để làm điều này là xem phần mở rộng file, tất cả mọi thứ sau dấu chấm cuối cùng trong tên file.

May mắn thay, [`os.path.splitext()`](https://docs.python.org/3/library/os.path.html#os.path.splitext) cung cấp cho chúng ta một cách dễ dàng để lấy phần mở rộng từ tên file:

``` {.py}
os.path.splitext('keyboardcat.gif')
```

trả về một tuple chứa:

``` {.py}
('keyboardcat', '.gif')
```

Bạn chỉ cần ánh xạ các phần mở rộng sau cho bài tập này:

<!-- CAPTION: Extension Mapping -->
|Extension|MIME Type|
|-|-|
|`.txt`|`text/plain`|
|`.html`|`text/html`|

Vì vậy nếu file có phần mở rộng `.txt`, hãy chắc chắn gửi lại:

``` {.default}
Content-Type: text/plain
```

trong phản hồi của bạn.

Nếu bạn thực sự muốn chính xác, hãy thêm `charset` vào header để chỉ định encoding ký tự:

``` {.default}
Content-Type: text/plain; charset=iso-8859-1
```

nhưng điều đó không cần thiết, vì trình duyệt thường mặc định về encoding đó.

## Đọc File, `Content-Length`, và Xử Lý Không Tìm Thấy

Đây là một đoạn code để đọc toàn bộ file và kiểm tra lỗi:

``` {.py}
try:
    with open(filename, "rb") as fp:
        data = fp.read()   # Read entire file
        return data

except:
    # File not found or other error
    # TODO send a 404
```

Dữ liệu bạn nhận lại từ `.read()` sẽ là payload.
Dùng `len()` để tính số byte.

Số byte sẽ được gửi lại trong header `Content-Length`, như sau:

``` {.default}
Content-Length: 357
```

(với số byte trong file của bạn).

> Bạn có thể đang thắc mắc `"rb"` là gì trong lời gọi `open()`.
> Cái này làm cho file mở để đọc ở chế độ nhị phân. Trong Python, một
> file mở để đọc ở chế độ nhị phân sẽ trả về một bytestring
> đại diện cho file mà bạn có thể gửi thẳng ra trên socket.

Còn cái chuyện `404 Not Found` thì sao? Nó phổ biến đến mức bạn có lẽ đã thấy nó trong sử dụng web thông thường từ thời gian đến thời gian.

Điều này chỉ có nghĩa là bạn đã yêu cầu một file hoặc tài nguyên khác không tồn tại.

Trong trường hợp của chúng ta, chúng ta sẽ phát hiện một số loại lỗi mở file (với khối `except` ở trên) và trả về phản hồi `404`.

Phản hồi `404` là một phản hồi HTTP, ngoại trừ thay vì

``` {.default}
HTTP/1.1 200 OK
```

phản hồi của chúng ta sẽ bắt đầu bằng

``` {.default}
HTTP/1.1 404 Not Found
```

Vì vậy khi bạn cố mở file và thất bại, bạn sẽ chỉ trả về nội dung sau (verbatim --- nguyên văn) và đóng kết nối:

``` {.default}
HTTP/1.1 404 Not Found
Content-Type: text/plain
Content-Length: 13
Connection: close

404 not found
```

(Cả content length và payload đều có thể hardcode trong trường hợp này, nhưng tất nhiên phải được `.encode()` thành bytes.)

## Mở Rộng

Các phần này dành cho bạn nếu có thời gian tự thử thách thêm để hiểu sâu hơn về tài liệu. Hãy thử sức!

* Thêm hỗ trợ MIME cho các loại file khác để bạn có thể phục vụ JPEG và các
  file khác.

* Thêm hỗ trợ hiển thị danh sách thư mục. Nếu người dùng không chỉ định file trong
  URL, hiển thị danh sách thư mục trong đó mỗi tên file là một liên kết đến file đó.

  Gợi ý:
  [`os.listdir`](https://docs.python.org/3/library/os.html#os.listdir)
  và
  [`os.path.join()`](https://docs.python.org/3/library/os.path.html#os.path.join)

* Thay vì chỉ bỏ toàn bộ đường dẫn, cho phép phục vụ từ các thư mục con từ
  một thư mục gốc bạn chỉ định trên server.

  **RỦI RO BẢO MẬT!** Hãy chắc chắn người dùng không thể thoát ra khỏi thư mục
  gốc bằng cách dùng một loạt `..` trong đường dẫn!

  Thông thường bạn sẽ có một biến cấu hình nào đó chỉ định thư mục gốc server
  như một đường dẫn tuyệt đối. Nhưng nếu bạn đang ở trong một trong các lớp của tôi,
  điều đó sẽ làm cuộc sống của tôi khổ sở khi tôi chấm điểm dự án. Vì vậy nếu
  đó là trường hợp, hãy dùng một đường dẫn tương đối cho thư mục gốc server của bạn
  và tạo một đường dẫn đầy đủ với hàm
  [`os.path.abspath()`](https://docs.python.org/3/library/os.path.html#os.path.abspath).

  ``` {.py}
  server_root = os.path.abspath('.')        # This...
  server_root = os.path.abspath('./root')   # or something like this
  ```

  Cái này sẽ đặt `server_root` thành một đường dẫn đầy đủ đến nơi bạn chạy
  server của mình. Ví dụ, trên máy của tôi, tôi có thể nhận được:

  ``` {.default}
  /home/beej/src/webserver                  # This...
  /home/beej/src/webserver/root             # or something like this
  ```

  Sau đó khi người dùng thử `GET` một đường dẫn nào đó, bạn chỉ cần nối nó vào
  server root để lấy đường dẫn đến file.

  ``` {.py}
  file_path = os.path.sep.join((server_root, get_path))
  ```

  Vì vậy nếu họ thử `GET /foo/bar/index.html`, thì `file_path` sẽ được đặt thành:

  ```
  /home/beej/src/webserver/foo/bar/index.html
  ```

  **Và bây giờ là điểm mấu chốt bảo mật!** Bạn phải đảm bảo rằng `file_path`
  nằm trong thư mục gốc server. Thấy không, một kẻ xấu có thể thử:

  ``` {.http}
  GET /../../../../../etc/passwd HTTP/1.1
  ```

  Và nếu họ làm vậy, chúng ta sẽ vô tình phục vụ file này:

  ```
  /home/beej/src/webserver/../../../../../etc/passwd
  ```

  điều đó sẽ đưa họ đến file password của tôi trong `/etc/passwd`. Tôi không
  muốn điều đó.

  Vì vậy tôi cần đảm bảo rằng dù họ kết thúc ở đâu vẫn còn trong cây thư mục
  `server_root` của tôi. Làm thế nào? Chúng ta có thể dùng `abspath()` lại.

  Nếu tôi chạy đường dẫn `..` điên rồ ở trên qua `abspath()`, nó chỉ trả về
  `/etc/passwd` cho tôi. Nó giải quyết tất cả các `..` và những thứ khác
  và trả về đường dẫn "thực".

  Nhưng tôi biết server root của tôi trong ví dụ này là
  `/home/beej/src/webserver`, vì vậy tôi chỉ cần xác minh rằng đường dẫn file
  tuyệt đối bắt đầu bằng cái đó. Và trả 404 nếu không.

  ``` {.py}
  # Convert to absolute path
  file_path = os.path.abspath(file_path)

  # See if the user is trying to break out of the server root
  if not file_path.startswith(server_root):
      send_404()
  ```

## File Ví Dụ

Bạn có thể sao chép và dán những thứ này vào file để thử nghiệm:

### `file1.txt`

``` {.default}
This is a sample text file that has all kinds of words in it that
seemingly go on for a long time but really don't say much at all.

And as that weren't enough, here is a second paragraph that continues
the tradition. And then goes for a further sentence, besides.
```

### `file2.html`

``` {.html}
<!DOCTYPE html>

<html>
<head>
<title>Test HTML File</title>
</head>

<body>
<h1>Test HTML</h1>

<p>This is my test file that has <i>some</i> HTML in in that the browser
should render as HTML.</p>

<p>If you're seeing HTML tags that look like this <tt>&lt;p&gt;</tt>,
you're sending it out as the wrong MIME type! It should be
<tt>text/html</tt>!</p>

<hr>
</body>
</html>
```

Ý tưởng là các URL này sẽ lấy các file trên (với cổng phù hợp được cấp):

``` {.default}
http://localhost:33490/file1.txt
http://localhost:33490/file2.html
```

<!--
Rubric

100 points

10 File name parsed from request header.
20 File path is either stripped off or sandboxed properly.
10 Data is read from the file named in the URL
15 Proper Content-Type set in header
15 Proper Content-Length set in header
15 HTTP response header is constructed correctly and ISO-8859-1 encoded
15 HTTP response payload is constructed correctly
-->
