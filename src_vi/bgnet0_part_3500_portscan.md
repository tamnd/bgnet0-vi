# Quét cổng (Port Scanning)

**LƯU Ý VỀ PHÁP LÝ**: Chưa rõ việc quét cổng (portscan) một máy tính
không thuộc sở hữu của bạn có hợp pháp hay không. Chúng ta sẽ chỉ
quét cổng trên `localhost`. **Đừng quét cổng những máy tính bạn không
có quyền!**

Quét cổng (port scan) là phương pháp xác định những cổng nào trên một
máy tính đang sẵn sàng chấp nhận kết nối. Nói cách khác --- những
cổng nào đang có server lắng nghe.

Quét cổng thường là bước tấn công đầu tiên vào một hệ thống. Trước
khi kết nối để tìm kiếm lỗ hổng trong các server đang lắng nghe, ta
cần biết những server nào đang chạy.

## Cơ chế hoạt động của Portscanner

Một portscanner sẽ cố gắng tìm các tiến trình server đang lắng nghe
trên một dải cổng tại một IP xác định. (Đôi khi dải đó bao gồm tất cả
các cổng.)

Với TCP, cách tiếp cận chung là thử thiết lập kết nối bằng lệnh gọi
`connect()` trên cổng cần kiểm tra. Nếu thành công, đó là cổng mở, và
portscanner in ra thông tin đó. Không có dữ liệu nào được gửi qua kết
nối, và kết nối đó bị đóng ngay lập tức.

> Nhiệm vụ của portscanner là xác định các cổng đang mở, không phải
> gửi hay nhận dữ liệu không cần thiết.

Việc gọi `connect()` khiến kết nối TCP hoàn thành bắt tay ba bước
(three-way handshake). Thực ra điều này không bắt buộc --- nếu
portscanner nhận được bất kỳ phản hồi nào từ server (tức phần thứ hai
của bắt tay ba bước), ta đã biết cổng đó mở. Hoàn thành bắt tay sẽ
khiến hệ điều hành phía xa đánh thức server trên cổng đó cho một kết
nối mà ta biết rõ là sẽ đóng ngay.

Một số TCP portscanner sẽ tự tạo gói TCP SYN để khởi động bắt tay và
gửi đến cổng đó. Nếu nhận được phản hồi SYN-ACK, chúng biết cổng đang
mở. Nhưng thay vì hoàn thành bắt tay bằng ACK, chúng gửi RST (reset)
khiến hệ điều hành phía xa hủy kết nối đang hình thành --- và không
đánh thức server trên cổng đó.

> Bạn có thể viết phần mềm tạo các gói TCP tùy chỉnh với [raw
> sockets](https://en.wikipedia.org/wiki/Network_socket#Types). Thường
> bạn cần quyền superuser/admin để dùng chúng.

### Quét cổng UDP

Vì UDP không có kết nối (connectionless), việc quét cổng UDP kém chính
xác hơn một chút.

Một kỹ thuật là gửi một gói UDP đến một cổng và xem có nhận được thông
báo [ICMP](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol)
"destination unreachable" (đích không thể tiếp cận) không. Nếu có,
cổng đó không mở.

Nếu không nhận được phản hồi, _có thể_ cổng đang mở. Hoặc cũng có
thể gói UDP bị lọc và bỏ đi mà không có phản hồi ICMP nào.

Một cách khác là gửi gói UDP đến một cổng đã biết có thể có server.
Nếu nhận được phản hồi từ server, ta biết cổng đang mở. Nếu không,
cổng đóng hoặc lưu lượng của ta bị lọc.

## Reflect

* Tại sao không nên quét cổng những máy tính ngẫu nhiên trên Internet?

* Mục đích của việc dùng portscanner là gì?
