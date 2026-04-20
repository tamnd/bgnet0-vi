# ARP: Giao thức Phân giải Địa chỉ (Address Resolution Protocol)

Ta --- với tư cách là một máy tính trong mạng --- đang có một vấn đề.

Ta muốn gửi dữ liệu trên LAN đến một máy tính khác trên cùng subnet.

Đây là những gì ta cần biết để xây dựng một Ethernet frame:

* Dữ liệu muốn gửi và độ dài của nó
* Địa chỉ MAC nguồn của ta
* Địa chỉ MAC đích của họ

Đây là những gì ta biết:

* Dữ liệu muốn gửi và độ dài của nó
* Địa chỉ MAC nguồn của ta
* Địa chỉ IP nguồn của ta
* Địa chỉ IP đích của họ

Còn thiếu gì? Dù ta biết địa chỉ IP của máy tính kia, _ta không biết địa chỉ
MAC của họ_. Làm sao xây dựng Ethernet frame mà không có địa chỉ MAC đích?
Không được. Ta phải lấy nó bằng cách nào đó.

> Nhắc lại, phần này nói về việc gửi trên LAN, tức Ethernet cục bộ. Không
> phải qua Internet với IP. Đây là giữa hai máy tính trên cùng mạng Tầng
> Physical.

Phần này nói hoàn toàn về ARP, giao thức phân giải địa chỉ (Address
Resolution Protocol). Đây là cách một máy tính có thể ánh xạ địa chỉ IP của
máy tính khác sang địa chỉ MAC của máy đó.

## Ethernet Broadcast Frames (Frame Broadcast Ethernet)

Ta cần một chút kiến thức nền trước.

Nhớ lại rằng phần cứng mạng lắng nghe các Ethernet frame được địa chỉ hóa
cụ thể đến nó. Các Ethernet frame đến địa chỉ MAC khác bị bỏ qua.

> Lưu ý: chúng bị bỏ qua trừ khi card mạng được đặt vào
> [_promiscuous mode_](https://en.wikipedia.org/wiki/Promiscuous_mode) (chế
> độ phổ thông), trong trường hợp đó nó nhận **tất cả** lưu lượng trên LAN
> và chuyển tiếp đến hệ điều hành.

Nhưng có một cách ghi đè: _broadcast frame_ (frame phát rộng). Đây là frame
có địa chỉ MAC đích là `ff:ff:ff:ff:ff:ff`. Tất cả thiết bị trên LAN đều
nhận frame đó.

Ta sẽ dùng điều này với ARP.

## ARP---Giao thức Phân giải Địa chỉ

Vậy ta có địa chỉ IP đích, nhưng không có địa chỉ MAC của nó. Ta muốn có
địa chỉ MAC đó.

Đây là những gì sẽ xảy ra:

1. Máy tính nguồn sẽ broadcast một Ethernet frame chuyên biệt chứa địa chỉ
   IP đích. Đây là _ARP request_ (yêu cầu ARP).

   (Nhớ trường EtherType từ chương trước không? Các gói ARP có EtherType
   0x0806 để phân biệt chúng với các gói Ethernet dữ liệu thông thường.)

2. Tất cả máy tính trên LAN nhận ARP request và kiểm tra nó. Nhưng chỉ máy
   tính có địa chỉ IP được chỉ định trong ARP request mới tiếp tục. Các máy
   tính khác hủy gói tin.

3. Máy tính đích với địa chỉ IP được chỉ định xây dựng một _ARP response_
   (phản hồi ARP). Ethernet frame này chứa địa chỉ MAC của máy tính đích.

4. Máy tính đích gửi ARP response về cho máy tính nguồn.

5. Máy tính nguồn nhận ARP response, và bây giờ nó biết địa chỉ MAC của máy
   tính đích.

Và thế là xong! Giờ ta biết địa chỉ MAC, ta có thể gửi thoải mái.

## ARP Caching (Bộ đệm ARP)

Vì phải hỏi địa chỉ MAC của máy tính mỗi lần muốn gửi gì đó thật phiền, ta
sẽ _cache_ (lưu vào bộ đệm) kết quả một thời gian.

Sau đó, khi muốn gửi đến một IP cụ thể trên LAN, ta có thể tra _ARP cache_
(bộ đệm ARP) để xem cặp IP/Ethernet đã có ở đó chưa. Nếu có, không cần gửi
ARP request --- ta có thể truyền dữ liệu ngay lập tức.

Các bản ghi trong cache sẽ hết hạn và bị xóa sau một khoảng thời gian nhất
định. Không có thời gian hết hạn chuẩn, nhưng mình thấy các con số từ 60
giây đến 4 giờ.

Các bản ghi có thể trở nên lỗi thời nếu địa chỉ MAC thay đổi cho một địa chỉ
IP cho trước. Khi đó bản ghi cache sẽ bị lỗi thời. Cách dễ nhất để điều đó
xảy ra là nếu ai đó đóng laptop và rời mạng (mang địa chỉ MAC theo), rồi
một người khác với laptop khác (và địa chỉ MAC khác) xuất hiện và được gán
cùng địa chỉ IP. Nếu điều đó xảy ra, các máy tính có bản ghi lỗi thời sẽ
gửi frame cho IP đó đến địa chỉ MAC (cũ) sai.

## ARP Structure (Cấu trúc ARP)

Dữ liệu ARP nằm trong phần payload của Ethernet frame. Nó có độ dài cố định.
Như đã đề cập trước, nó được nhận dạng bằng cách đặt trường EtherType/packet
length thành 0x0806.

Trong cấu trúc payload bên dưới, khi nói "Hardware" (phần cứng) có nghĩa là
Tầng Link (ví dụ Ethernet trong ví dụ này) và khi nói "Protocol" (giao thức)
có nghĩa là Tầng Network (ví dụ IP trong ví dụ này). Nó dùng các tên tổng
quát đó cho các trường vì không có yêu cầu nào buộc ARP phải dùng Ethernet
hay IP --- nó có thể hoạt động với các giao thức khác.

Cấu trúc payload, với tổng độ dài cố định là 28 octet:

* 2 octet: Hardware Type (Ethernet là `0x0001`)
* 2 octet: Protocol Type (IPv4 là `0x8000`)
* 1 octet: Độ dài địa chỉ hardware tính bằng octet (Ethernet là `0x06`)
* 1 octet: Độ dài địa chỉ protocol tính bằng octet (IPv4 là `0x04`)
* 2 octet: Operation (`0x01` cho request, `0x02` cho reply)
* 6 octet: Sender hardware address (Địa chỉ MAC của người gửi)
* 4 octet: Sender protocol address (Địa chỉ IP của người gửi)
* 6 octet: Target hardware address (Địa chỉ MAC của mục tiêu)
* 4 octet: Target protocol address (Địa chỉ IP của mục tiêu)

## ARP Request/Response (Yêu cầu/Phản hồi ARP)

Phần này hơi khó hiểu vì các trường "Sender" luôn được thiết lập từ góc nhìn
của máy tính đang truyền, không phải từ góc nhìn của người yêu cầu.

Vậy ta sẽ khai báo Máy tính 1 là máy gửi ARP request, còn Máy tính 2 sẽ
phản hồi nó.

Trong ARP request từ Máy tính 1 ("Nếu bạn có IP này, MAC của bạn là gì?"),
các trường sau được thiết lập (ngoài các trường mẫu ARP request còn lại đã
đề cập ở trên):

* **Sender hardware address**: Địa chỉ MAC của Máy tính 1
* **Sender protocol address**: Địa chỉ IP của Máy tính 1
* **Target hardware address**: không dùng
* **Target protocol address**: địa chỉ IP mà Máy tính 1 đang tìm kiếm

Trong ARP response từ Máy tính 2 ("Tôi có IP đó, và đây là MAC của tôi."),
các trường sau được thiết lập:

* **Sender hardware address**: Địa chỉ MAC của Máy tính 2
* **Sender protocol address**: Địa chỉ IP của Máy tính 2
* **Target hardware address**: Địa chỉ MAC của Máy tính 1
* **Target protocol address**: Địa chỉ IP của Máy tính 1

Khi Máy tính 1 nhận ARP reply đặt tên nó là mục tiêu, nó có thể tra các
trường Sender và lấy địa chỉ MAC cùng địa chỉ IP tương ứng.

Sau đó, Máy tính 1 có thể gửi lưu lượng Ethernet đến địa chỉ MAC đã biết
của Máy tính 2.

Và đó là cách địa chỉ MAC được phát hiện cho một địa chỉ IP cụ thể!

## Other ARP Features (Các tính năng ARP khác)

### ARP Announcements (Thông báo ARP)

Các máy tính vừa kết nối mạng thường thông báo thông tin ARP của chúng mà
không cần được yêu cầu. Điều này cho mọi người khác cơ hội thêm dữ liệu vào
cache của họ, và ghi đè dữ liệu có thể đã lỗi thời trong các cache đó.

### ARP Probe (Thăm dò ARP)

Một máy tính có thể gửi một ARP request được xây dựng đặc biệt về cơ bản
hỏi: "Có ai khác đang dùng địa chỉ IP này không?"

Thường nó hỏi bằng địa chỉ IP của chính mình; nếu nhận được phản hồi, nó
biết mình có xung đột IP.

## IPv6 and ARP (IPv6 và ARP)

IPv6 có phiên bản ARP riêng gọi là
[NDP](https://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol) (Neighbor
Discovery Protocol, Giao thức Khám phá Hàng xóm).

Những ai tinh ý có thể nhận thấy rằng ARP chỉ hỗ trợ địa chỉ protocol (ví
dụ địa chỉ IP) lên đến 4 byte, trong khi địa chỉ IPv6 là 16 byte.

NDP giải quyết vấn đề này và nhiều hơn nữa, định nghĩa một số loại thông điệp
[ICMPv6](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol_for_IPv6)
(Internet Message Control Protocol for IPv6) có thể được dùng để thay thế
ARP, trong số những thứ khác.

## Reflect (Ôn lại)

* Mô tả vấn đề mà ARP đang giải quyết.

* Tại sao các bản ghi trong ARP cache phải hết hạn?

* Tại sao IPv6 không thể dùng ARP?
