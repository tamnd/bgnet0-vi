# Giao thức Cấu hình Host Động (DHCP)

Khi bạn mở laptop lần đầu ở quán cà phê, nó chưa có địa chỉ IP. Nó
thậm chí không biết mình _nên_ có địa chỉ IP nào. Cũng không biết name
server là gì. Hay subnet mask là bao nhiêu.

Tất nhiên, bạn có thể cấu hình thủ công! Cứ gõ vào mấy con số mà
thu ngân đưa kèm ly cà phê thôi!

Ừ thì chuyện đó không xảy ra. Chẳng ai muốn làm vậy. Hoặc họ sẽ dùng
địa chỉ trùng nhau. Rồi mọi thứ sẽ hỏng. Và họ sẽ uống cà phê trong
bực bội rồi không bao giờ quay lại.

Sẽ tiện hơn nhiều nếu có cách tự động cấu hình cho một máy tính vừa
kết nối vào mạng, phải không?

Đó chính là lý do tồn tại của _Giao thức Cấu hình Host Động_ (Dynamic
Host Configuration Protocol --- DHCP).

## Hoạt động (Operation)

Tổng quan:

``` {.default}
Client --> [DHCPDISCOVER packet] --> Server

Client <-- [DHCPOFFER packet] <-- Server

Client --> [DHCPREQUEST packet] --> Server

Client <-- [DHCPACK packet] <-- Server
```

Chi tiết hơn:

Khi laptop của bạn lần đầu kết nối vào mạng, nó gửi một gói
`DHCPDISCOVER` đến địa chỉ broadcast (`255.255.255.255`) qua UDP đến
cổng `67` --- cổng của DHCP server.

Nhớ lại rằng địa chỉ broadcast chỉ lan ra trong LAN --- default
gateway không chuyển tiếp nó ra ngoài.

Trên LAN có một máy tính khác đang đóng vai DHCP server, với một tiến
trình đang lắng nghe trên cổng `67`.

Tiến trình DHCP server nhận được gói DISCOVER và quyết định xử lý nó
như thế nào.

Trường hợp phổ biến nhất là client muốn xin một địa chỉ IP. Ta gọi
việc này là _thuê_ (leasing) IP từ DHCP server. DHCP server theo dõi
những IP nào đã được cấp phát và IP nào còn trong pool của nó.

Để đáp lại gói `DHCPDISCOVER`, DHCP server gửi phản hồi `DHCPOFFER`
về cho client trên cổng `68`.

Gói offer chứa một địa chỉ IP và có thể còn nhiều thông tin khác,
bao gồm nhưng không giới hạn:

* Subnet mask (mặt nạ mạng con)
* Địa chỉ default gateway (cổng mặc định)
* Thời gian thuê (lease time)
* DNS servers (máy chủ tên miền)

Client có thể chấp nhận hoặc bỏ qua offer. (Có thể có nhiều DHCP
server cùng gửi offer, nhưng client chỉ chấp nhận một trong số đó.)

Nếu chấp nhận, client gửi `DHCPREQUEST` lại cho server để thông báo
rằng nó muốn địa chỉ IP đó.

Cuối cùng, nếu mọi thứ ổn, server trả lời bằng gói xác nhận
`DHCPACK`.

Đến đây, client đã có đủ thông tin để tham gia vào mạng.

## Reflect

* Suy nghĩ về những ưu điểm của việc dùng DHCP so với cấu hình thủ
  công cho các thiết bị trên LAN của bạn.

* Client DHCP nhận được những loại thông tin gì từ DHCP server?
