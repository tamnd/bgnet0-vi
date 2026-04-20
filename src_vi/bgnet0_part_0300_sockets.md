# Giới Thiệu Sockets API

Trong Unix, sockets API (giao diện lập trình socket) nhìn chung cung cấp cho các tiến trình một cách để giao tiếp với nhau. Nó hỗ trợ nhiều phương thức giao tiếp khác nhau, và một trong số đó là giao tiếp qua Internet.

Và đó chính là thứ chúng ta quan tâm lúc này.

Trong C và Unix, sockets API là sự kết hợp giữa các lời gọi thư viện và lời gọi hệ thống (system call --- các hàm gọi thẳng vào hệ điều hành).

Trong Python, Python sockets API là một thư viện gọi xuống C sockets API cấp thấp hơn. Ít nhất là trên các hệ thống giống Unix. Trên các nền tảng khác, nó sẽ gọi bất kỳ API nào mà hệ điều hành đó cung cấp cho giao tiếp mạng.

Chúng ta sẽ dùng thứ này để viết các chương trình giao tiếp qua Internet!

## Quy Trình Kết Nối Phía Client

Phần rắc rối nhất khi dùng socket là thường có nhiều bước bạn phải thực hiện để kết nối đến máy tính khác, và chúng không hề rõ ràng ngay từ đầu.

Nhưng chúng là:

1. **Yêu cầu OS cấp một socket**. Trong C, đây chỉ là một file descriptor (mô tả tập tin --- một số nguyên) sẽ được dùng từ đây trở đi để chỉ kết nối mạng này. Python sẽ trả về một đối tượng đại diện cho socket. Các API ngôn ngữ khác có thể trả về những thứ khác nhau.

   Điều quan trọng ở bước này là bạn có một cách để tham chiếu socket này cho việc truyền dữ liệu sắp tới. Lưu ý rằng nó chưa được kết nối đến bất kỳ đâu cả.

2. **Thực hiện tra cứu DNS** để chuyển đổi tên dễ đọc (như `example.com`) thành địa chỉ IP (như 198.51.100.12). DNS (hệ thống tên miền) là cơ sở dữ liệu phân tán lưu trữ ánh xạ này, và ta truy vấn nó để lấy địa chỉ IP.

   Chúng ta cần địa chỉ IP để biết máy nào cần kết nối đến.

   Gợi ý Python: Mặc dù bạn có thể tra cứu DNS trong Python với `socket.getaddrinfo()`, chỉ cần gọi `socket.connect()` với hostname là nó sẽ tự tra DNS cho bạn. Vậy nên bạn có thể bỏ qua bước này.

   Gợi ý C (tùy chọn): Dùng `getaddrinfo()` để thực hiện tra cứu này.

3. **Kết nối socket** đến địa chỉ IP đó trên một cổng (port) cụ thể.

   Hãy nghĩ số port như một cánh cửa mở mà bạn có thể kết nối qua. Chúng là các số nguyên trong khoảng từ 0 đến 65535.

   Một ví dụ port hay nhớ là 80, đây là port tiêu chuẩn dùng cho các server sử dụng giao thức HTTP (không mã hóa).

   Phải có một server đang lắng nghe trên port đó ở máy tính từ xa kia, nếu không kết nối sẽ thất bại.

4. **Gửi và nhận dữ liệu**. Đây là phần ta đã chờ đợi.

   Dữ liệu được gửi dưới dạng một chuỗi các byte.

5. **Đóng kết nối**. Khi xong việc, ta đóng socket để báo cho phía bên kia biết rằng ta không còn gì để nói nữa. Phía bên kia cũng có thể đóng kết nối bất cứ lúc nào nó muốn.

## Quy Trình Lắng Nghe Phía Server

Viết một chương trình server thì hơi khác một chút.

1. **Yêu cầu OS cấp một socket**. Giống như với client.

2. **Bind (gắn) socket vào một port**. Đây là nơi bạn gán số port cho server mà các client khác có thể kết nối đến. Kiểu như "Tôi sẽ lắng nghe trên port 80!" chẳng hạn.

   Lưu ý: các chương trình không chạy với quyền root/administrator không thể bind vào các port dưới 1024 --- những port đó được dành riêng. Hãy chọn một số port lớn, ít phổ biến cho server của bạn, kiểu như trong khoảng 15.000-30.000. Nếu bạn cố bind vào một port mà server khác đang dùng, bạn sẽ nhận được lỗi "Address already in use" (địa chỉ đã được sử dụng).

   Port gắn liền với máy tính. Hai máy tính khác nhau dùng cùng port thì không sao. Nhưng hai chương trình trên cùng một máy tính không thể dùng cùng port trên máy đó.

   Thú vị là: client cũng được bind vào một port. Nếu bạn không bind tường minh, chúng sẽ được gán một port chưa dùng khi kết nối --- thường thì đó là điều ta muốn.

3. **Lắng nghe các kết nối đến**. Ta phải cho OS biết khi nào có một yêu cầu kết nối đến trên port ta đã chọn.

4. **Chấp nhận các kết nối đến**. Server sẽ block (ngủ) khi bạn cố chấp nhận kết nối mới nếu không có kết nối nào đang chờ. Sau đó nó thức dậy khi ai đó cố kết nối.

   Accept trả về một socket mới! Điều này gây nhầm lẫn. Socket gốc mà server tạo ở bước 1 vẫn còn đó lắng nghe các kết nối mới. Khi kết nối đến, OS tạo một socket mới _đặc biệt cho kết nối đó_. Nhờ vậy server có thể xử lý nhiều client cùng lúc.

   Đôi khi server tạo một thread hoặc tiến trình mới để xử lý mỗi client mới. Nhưng không có quy định nào bắt buộc phải làm vậy.

5. **Gửi và nhận dữ liệu**. Đây thường là nơi server nhận request từ client, và server gửi lại response cho request đó.

6. **Quay lại chấp nhận kết nối tiếp theo**. Server thường là các tiến trình chạy lâu dài và xử lý nhiều request trong suốt vòng đời của chúng.

## Reflect

* `bind()` đóng vai trò gì ở phía server?

* Liệu client có bao giờ gọi `bind()` không? (Có thể phải tìm kiếm cái này trên Internet.)

* Hãy suy đoán tại sao `accept()` trả về một socket mới thay vì chỉ tái sử dụng cái mà ta đã gọi `listen()`.

* Điều gì sẽ xảy ra nếu server không vòng lặp lại để gọi `accept()` tiếp? Điều gì sẽ xảy ra khi client thứ hai cố kết nối?

* Nếu một máy tính đang dùng TCP port 3490, máy tính khác có thể dùng port 3490 không?

* Hãy suy đoán tại sao port tồn tại. Chúng tạo ra chức năng gì mà địa chỉ IP thuần túy không làm được?

## Tài Nguyên

* [Python Sockets Documentation](https://docs.python.org/3/library/socket.html)
* [flbg[_Beej's Guide to Network Programming_|bgnet]] --- tùy chọn, dành cho lập trình viên C
