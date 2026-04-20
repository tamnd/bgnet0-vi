# Tin tưởng Dữ liệu Người dùng (Trusting User Data)

> "You won't know who to trust..."
>
> ---Gregor Ivanovich, _Sneakers_

Khi server của bạn nhận dữ liệu từ ai đó trên Internet, không đủ nếu
chỉ tin rằng họ có ý định tốt.

Ngoài kia có rất nhiều kẻ xấu. Bạn phải thực hiện các bước để ngăn
họ gửi những thứ làm crash tiến trình server của bạn hoặc, tệ hơn,
cho phép họ truy cập vào chính máy chủ của bạn.

Trong chương này, ta sẽ nhìn tổng quát về một số vấn đề có thể phát
sinh khi người dùng cố gửi dữ liệu độc hại.

Hai ý tưởng lớn ở đây là:

* _Nghĩ như kẻ phản diện_. Ai đó có thể truyền gì vào code của bạn
  để làm crash nó hoặc khiến nó hành xử theo cách không mong muốn?

* Đừng tin **bất cứ thứ gì** từ phía xa. Đừng tin rằng nó sẽ có độ
  dài hợp lý. Đừng tin rằng nó sẽ chứa dữ liệu hợp lý.

## Tràn bộ đệm (Buffer Overflow/Overrun)

Đây là thứ chủ yếu ảnh hưởng đến các ngôn ngữ không an toàn bộ nhớ
(memory-unsafe) như C hay C++.

Ý tưởng là:

1. Chương trình của bạn cấp phát một vùng bộ nhớ có kích thước cố định.

2. Chương trình của bạn đọc một số dữ liệu vào vùng bộ nhớ đó qua kết
   nối mạng.

3. Kẻ tấn công gửi nhiều dữ liệu hơn vùng bộ nhớ đó có thể chứa. Dữ
   liệu này được xây dựng cẩn thận để chứa một payload.

4. Chương trình của bạn, không nghĩ ngợi gì, ghi dữ liệu từ kẻ tấn
   công, lấp đầy vùng bộ nhớ và tràn sang vùng bộ nhớ kế tiếp.

5. Tùy theo cách mọi thứ được viết, kẻ tấn công có thể ghi đè lên
   giá trị địa chỉ trả về trên stack, khiến hàm trả về vào payload của
   kẻ tấn công và chạy nó. Payload đó thao túng hệ thống để cài virus
   hoặc thay đổi hệ thống theo cách cho phép truy cập từ xa.

Các hệ điều hành hiện đại cố giảm thiểu bằng cách làm vùng stack và
heap không thể thực thi, và vùng code không thể ghi.

Là lập trình viên, bạn cần viết code C thực hiện kiểm tra giới hạn
(bounds-checking) đúng cách và không bao giờ ghi vào vùng bộ nhớ
ngoài ý muốn.

## Tấn công Injection (Injection Attacks)

Đây là những cuộc tấn công nơi bạn xây dựng một lệnh (command) sử
dụng dữ liệu người dùng cung cấp. Rồi chạy lệnh đó.

Một người dùng độc hại có thể đưa cho bạn dữ liệu khiến một lệnh
khác được chạy.

### Lệnh hệ thống (System Commands)

Trong nhiều ngôn ngữ, có tính năng cho phép chạy một lệnh qua shell.

Ví dụ, trong Python bạn có thể chạy lệnh `ls` để lấy danh sách thư
mục như này:

``` {.py}
import os

os.system("ls")
```

Giả sử bạn viết một server nhận dữ liệu từ người dùng. Người dùng sẽ
gửi `1`, `2` hoặc `3` tùy theo chức năng họ muốn chọn.

Bạn chạy đoạn code sau trong server:

``` {.py}
os.system("mycommand " + user_input)
```

Nếu người dùng gửi `2`, nó sẽ chạy `mycommand 2` như mong đợi và trả
về output cho người dùng.

Để an toàn, chương trình `mycommand` kiểm tra rằng đầu vào chỉ được
phép là `1`, `2`, hoặc `3` và trả về lỗi nếu có gì khác được truyền
vào.

Chúng ta có an toàn không?

Không. Bạn thấy tại sao không?

Người dùng có thể truyền đầu vào:

``` {.default}
1; cat /etc/passwd
```

Điều này sẽ khiến đoạn sau được thực thi:

``` {.default}
mycommand 1; cat /etc/passwd
```

Dấu chấm phẩy là dấu phân cách lệnh trong bash. Điều này khiến
chương trình `mycommand` thực thi, theo sau là lệnh hiển thị nội dung
file mật khẩu Unix.

Để an toàn, tất cả các ký tự đặc biệt trong đầu vào cần được loại bỏ
hoặc escape để shell không diễn giải chúng.

### Lệnh SQL (SQL Commands)

Có một cuộc tấn công tương tự gọi là SQL Injection, nơi một truy vấn
SQL không được xây dựng cẩn thận có thể cho phép người dùng độc hại
thực thi các truy vấn SQL tùy ý.

Giả sử bạn xây dựng một truy vấn SQL trong Python như này, nơi ta lấy
biến `username` qua mạng theo cách nào đó:

``` {.py}
q = f"SELECT * FROM users WHERE name = '{username}'
```

Nếu tôi nhập `Alice` cho user, ta nhận được truy vấn hoàn toàn hợp lệ:

``` {.sql}
SELECT * FROM users WHERE name = 'Alice'
```

Rồi chạy nó, không vấn đề gì.

Nhưng hãy _nghĩ như kẻ phản diện_.

Nếu ta nhập cái này:

``` {.sql}
Alice' or 1=1 --
```

Bây giờ ta nhận được:

``` {.sql}
SELECT * FROM users WHERE name = 'Alice' or 1=1 -- '
```

`--` là dấu phân cách comment trong SQL. Bây giờ ta đã tạo ra một truy
vấn hiển thị thông tin tất cả người dùng, không chỉ của Alice.

Không chỉ vậy, một triển khai ngây thơ có thể hỗ trợ cả dấu `;` phân
cách lệnh. Nếu vậy, kẻ tấn công có thể làm gì đó như này:

``` {.sql}
Alice'; SELECT * FROM passwords --
```

Bây giờ ta nhận được lệnh này:

``` {.sql}
SELECT * FROM users WHERE name = 'Alice'; SELECT * FROM passwords -- '
```

Và ta nhận được output từ bảng `passwords`.

Để tránh cái bẫy này, hãy dùng _parameterized query generators_ (trình
tạo truy vấn tham số hóa). Đây là thứ trong thư viện SQL cho phép bạn
xây dựng truy vấn an toàn với bất kỳ đầu vào người dùng nào.

Đừng bao giờ tự xây dựng chuỗi SQL.

### Cross-Site Scripting

Đây là thứ xảy ra với HTML/JS.

Giả sử bạn có một form chấp nhận comment của người dùng, và server
thêm comment đó vào trang web.

Nếu người dùng nhập:

``` {.default}
This site has significant problems. I feel uncomfortable using it.

Love, FriendlyTroll
```

Cái đó được thêm vào cuối trang.

Nhưng nếu người dùng nhập:

``` {.html}
LOL
<script>alert("Pwnd!")</script>
```

Bây giờ mọi người sẽ thấy hộp alert đó mỗi khi họ xem phần comment!

Và đó là ví dụ khá vô hại. JavaScript có thể là bất cứ thứ gì và sẽ
được thực thi trên site từ xa (nghĩa là nó có thể thực hiện các API
call và fetch dưới dạng domain đó). Nó cũng có thể viết lại trang để
phần nhập login/password gửi thông tin đó đến website của kẻ tấn công.

> "It would be bad."
>
> ---Egon Spengler, _Ghostbusters_

Hầu hết các thư viện hướng HTML đều có hàm để làm sạch (sterilize)
chuỗi để trình duyệt render chúng mà không diễn giải (ví dụ: tất cả
`<` thay bằng `&gt;` và tương tự).

Hãy chắc chắn chạy bất kỳ dữ liệu nào do người dùng tạo ra qua hàm
như vậy trước khi hiển thị trên trình duyệt.

## Reflect

* Nói chung, vấn đề của việc tin tưởng đầu vào người dùng là gì?

* Tại sao tràn bộ đệm (buffer overflow) không phải vấn đề lớn với các
  ngôn ngữ như Python, Go, hay Rust như với C?
