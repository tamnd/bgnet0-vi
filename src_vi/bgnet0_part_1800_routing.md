# Định tuyến IP (IP Routing)

Chương này nói về định tuyến (routing) qua IP. Công việc này được xử lý bởi
các máy tính gọi là _router_ (bộ định tuyến) --- chúng biết cách điều hướng
lưu lượng qua các đường kết nối khác nhau gắn vào chúng.

Như ta sẽ thấy, mọi máy tính kết nối Internet thực ra đều là router, nhưng
chúng đều dựa vào các router khác để đưa gói tin đến đích.

Ta sẽ nói về hai ý tưởng lớn:

* **Routing Protocols** (Giao thức định tuyến): cách các router học "bản đồ"
  mạng.

* **Routing Algorithm** (Thuật toán định tuyến): cách các router quyết định
  hướng chuyển tiếp gói tin sau khi đã học bản đồ.

Bắt đầu thôi!

## Routing Protocols (Giao thức định tuyến)

Giao thức định tuyến nói chung có mục tiêu này: cung cấp đủ thông tin để các
router có thể đưa ra quyết định định tuyến.

Tức là, khi một router nhận gói tin trên một giao diện (interface), làm sao
nó quyết định chuyển tiếp ra giao diện nào? Làm sao nó biết con đường nào
dẫn đến đích cuối cùng của gói tin?

### Interior Gateway Protocols (Giao thức cổng nội bộ)

Khi nói đến định tuyến gói tin trên Internet, ta nhìn từ góc cao hơn. Hãy
xem Internet như một đống cụm mạng (clump) kết nối lỏng lẻo với nhau. "Cụm"
không phải thuật ngữ chính thức trong ngành --- thuật ngữ chính thức là
_autonomous system_ (AS, hệ thống tự trị), mà Wikipedia định nghĩa là:

> [...] một tập hợp các prefix định tuyến IP (IP routing prefix) kết nối
> với nhau, dưới sự kiểm soát của một hoặc nhiều nhà điều hành mạng, đại
> diện cho một thực thể hoặc miền quản trị duy nhất, trình bày một chính
> sách định tuyến chung và rõ ràng ra Internet.

Nhưng cứ nghĩ nó là một cụm mạng cho đơn giản.

Ví dụ, OSU có một cụm mạng riêng. Nó có router nội bộ và các subnet riêng
đang "trên Internet". Một [công ty FAANG
(Big Tech)](https://en.wikipedia.org/wiki/Big_Tech#FAANG) có thể có cụm
Internet khác.

Bên trong các cụm Internet này, _interior gateway protocol_ (IGP, giao thức
cổng nội bộ) được dùng để định tuyến. Đây là thuật toán định tuyến tối ưu
cho mạng nhỏ hơn với ít subnet hơn.

Một số ví dụ về interior gateway protocol:

<!-- CAPTION: Interior Gateway Protocols -->
|Viết tắt|Tên đầy đủ|Ghi chú|
|-|-|-|
|OSPF|Open Shortest Path First|Phổ biến nhất, tầng IP|
|IS-IS|Intermediate System to Intermediate System|Tầng link|
|EIGRP|Enhanced Interior Gateway Routing Protocol|Cisco bán độc quyền|
|RIP|Routing Information Protocol|Cũ, ít dùng|

Tất nhiên bạn vẫn cần giao tiếp giữa các cụm Internet với nhau --- xét cho
cùng, cả Internet vẫn là một. Sẽ buồn lắm nếu không dùng được server của
Google từ Oregon State. Nhưng rõ ràng server Google không có bản đồ mạng của
OSU... vậy chúng biết định tuyến lưu lượng như thế nào?

### Exterior Gateway Protocols (Giao thức cổng ngoài)

Yêu cầu mỗi router có bản đồ đầy đủ của cả Internet là không thực tế. Ổn
với các cụm nhỏ, nhưng không khả thi cho toàn bộ Internet.

Vì vậy ta thay đổi cách tiếp cận khi giao tiếp giữa các cụm, dùng _exterior
gateway protocol_ (EGP, giao thức cổng ngoài) để định tuyến giữa các cụm.

Còn nhớ thuật ngữ chính thức của "cụm" không? Autonomous Systems (hệ thống
tự trị). Mỗi autonomous system trên Internet được gán một _autonomous system
number_ (ASN, số hiệu hệ thống tự trị), được dùng bởi _border gateway
protocol_ (BGP, giao thức cổng biên) để giúp xác định nơi định tuyến gói tin.

<!-- CAPTION: Exterior Gateway Protocols -->
|Viết tắt|Tên đầy đủ|Ghi chú|
|-|-|-|
|BGP|Border Gateway Protocol|Dùng ở khắp nơi|
|EGP|Exterior Gateway Protocol|Đã lỗi thời|

BGP có thể hoạt động ở hai chế độ: internal BGP và external BGP. Ở chế độ
internal, nó hoạt động như một interior gateway protocol; còn chế độ external
thì hoạt động như một exterior gateway protocol.

Có một [fl[video hay từ _Eye on
Tech_|https://www.youtube.com/watch?v=A1KXPpqlNZ4]] giải thích ngắn gọn
điều này. Mình rất khuyến khích bỏ hai phút xem để gắn kết mọi thứ lại.

## Routing tables (Bảng định tuyến)

Bảng định tuyến (routing table) định nghĩa nơi chuyển tiếp các gói tin để
đưa chúng tiến gần hơn đến đích. Hoặc, nếu router đang ở trên LAN đích thì
bảng định tuyến hướng dẫn router gửi lưu lượng ra ngoài ở tầng vật lý
(physical layer, ví dụ Ethernet).

Mục tiêu của các giao thức định tuyến nói trên là giúp các router trên Internet
xây dựng bảng định tuyến của chúng.

Tất cả máy tính kết nối Internet --- cả router lẫn máy thường --- đều có bảng
định tuyến. Ngay cả laptop của bạn, hệ điều hành cũng phải biết xử lý các địa
chỉ đích khác nhau như thế nào. Đích là localhost thì sao? Là máy khác trên
cùng subnet thì sao? Hay là gì khác?

Lấy ví dụ laptop thông thường, hệ điều hành giữ lưu lượng localhost trên
_loopback device_ (thiết bị loopback) và thường không gửi ra mạng thật. Từ
góc nhìn lập trình viên, có vẻ như đang làm mạng, nhưng hệ điều hành biết
định tuyến lưu lượng `127.0.0.1` nội bộ.

Nhưng nếu bạn ping một máy khác cùng LAN thì sao? Khi đó hệ điều hành kiểm
tra bảng định tuyến, xác định đích ở cùng LAN, rồi gửi qua Ethernet đến đích.

Còn nếu bạn ping một máy ở LAN hoàn toàn khác? Khi đó hệ điều hành không thể
chỉ gửi một Ethernet frame và trông chờ nó đến đích. Đích không nằm trên cùng
mạng Ethernet! Thay vào đó, máy của bạn chuyển tiếp gói tin đến _default
gateway_ (cổng mặc định) --- tức là router cuối cùng được hỏi. Nếu máy không
có bản ghi bảng định tuyến cho subnet đích, nó gửi đến default gateway, router
này sẽ chuyển tiếp ra Internet rộng lớn hơn.

Hãy xem một bảng định tuyến mẫu từ máy Linux của mình, được gán địa chỉ
`192.168.1.230` trong ví dụ này.

<!-- CAPTION: Example Routing Table -->
||Nguồn|Đích|Gateway|Thiết bị|
|-|-|-|-|-|
|1|`127.0.0.1`|`127.0.0.1`||`lo`|
|2|`127.0.0.1`|`127.0.0.0/8`||`lo`|
|3|`127.0.0.1`|`127.255.255.255`||`lo`|
|4|`192.168.1.230`|`192.168.1.230`||`wlan0`|
|5|`192.168.1.230`|`192.168.1.0/24`||`wlan0`|
|6|`192.168.1.230`|`192.168.1.255`||`wlan0`|
|7|`192.168.1.230`|`default`|`192.168.1.1`|`wlan0`|

Hãy xem trường hợp kết nối từ `localhost` đến `localhost` (`127.0.0.1`). Khi
đó, hệ điều hành tra xem route nào khớp rồi gửi dữ liệu qua giao diện tương
ứng. Trong trường hợp này là giao diện _loopback_ (`lo`) --- một giao diện
"giả" mà hệ điều hành giả vờ là giao diện mạng thật (vì lý do hiệu suất).

Nếu gửi dữ liệu từ `127.0.0.1` đến bất kỳ đâu trong subnet `127.0.0.0/8`?
Cũng dùng giao diện `lo`. Tương tự khi gửi đến địa chỉ broadcast
`127.255.255.255` (trên subnet `127.0.0.0/8`).

Các bản ghi còn lại thú vị hơn. Nhớ là máy mình được gán `192.168.1.230`.

Nhìn dòng 4, ta xét trường hợp mình gửi từ máy tới chính nó. Giống localhost
nhưng mình cố tình dùng IP gắn với card WiFi `wlan0`. Hệ điều hành dùng thiết
bị đó nhưng đủ thông minh để không gửi ra dây --- vì _đây_ chính là đích.

Tiếp theo là trường hợp gửi đến bất kỳ host nào trên subnet `192.168.1.0/24`.
Nghĩa là mình gửi từ `192.168.1.230` đến một máy khác, chẳng hạn
`192.168.1.22`, hay bất kỳ máy nào trên subnet đó.

Dòng 6 là địa chỉ broadcast của LAN, cũng ra qua thiết bị WiFi.

Còn nếu tất cả đều thất bại? Nếu mình gửi từ `192.168.1.230` đến
`203.0.113.37`? Đó không phải IP hay subnet nào trong bảng định tuyến của
mình.

Đây là lúc dòng 7 phát huy tác dụng: _default gateway_ (cổng mặc định). Đây
là nơi router gửi gói tin khi không biết định tuyến theo cách nào khác.

Ở nhà bạn, đây là cái router bạn nhận từ ISP, hoặc router bạn tự mua và lắp
đặt nếu bạn thích tự làm.

Vậy khi mình ping `example.com` (`93.184.216.34` tại thời điểm viết bài) từ
máy nhà, các gói tin được gửi đến default gateway vì IP đó và subnet tương
ứng không xuất hiện trong bảng định tuyến của máy mình.

(Và chúng cũng không có trong bảng định tuyến của default gateway. Nên router
đó lại tiếp tục chuyển tiếp theo default route của nó.)

## Routing Algorithm (Thuật toán định tuyến)

Giờ giả sử các giao thức định tuyến đã hoàn thành việc của mình và tất cả
router đều có thông tin cần thiết để biết chuyển tiếp gói tin đi đâu.

Khi gói tin đến, router thực hiện theo một chuỗi các bước để quyết định làm
gì tiếp theo. (Trong phần thảo luận này ta bỏ qua loopback và giả sử toàn bộ
lưu lượng đều trên mạng thật.)

![IP Routing Algorithm](ip-routing.pdf)

* Nếu địa chỉ IP đích nằm trên mạng cục bộ (local network) gắn với router
  * Giao gói tin trực tiếp trên link (tầng vật lý, ví dụ Ethernet)
* Ngược lại, nếu bảng định tuyến có bản ghi cho mạng của IP đích
  * Giao cho router tiếp theo hướng đến đích đó
* Ngược lại, nếu tồn tại một default route:
  * Giao cho router default gateway
* Ngược lại
  * Hủy gói tin
  * Gửi thông báo lỗi
    [ICMP](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol)
    "Destination Unreachable" (Không thể đến đích) về cho người gửi

Nếu có nhiều route khớp, route có subnet mask dài nhất được chọn.

Nếu vẫn còn tình trạng hòa, route có metric thấp nhất được dùng.

Nếu vẫn còn hòa, có thể dùng định tuyến ECMP (Equal Cost Multi-Path, đa đường
đồng chi phí) --- gửi gói tin theo cả hai hướng.

## Routing Example (Ví dụ định tuyến)

Ta chạy vài ví dụ. [flx[Bạn có thể tải PDF của sơ đồ này để xem rõ
hơn|ip-routing-demo.pdf]].

Trong sơ đồ này có nhiều thứ bị bỏ qua. Đáng chú ý là mỗi giao diện router
đều có địa chỉ IP gắn với nó.

Cũng lưu ý, ví dụ Router 1 được kết nối trực tiếp với 3 subnet, và có một
địa chỉ IP trên mỗi subnet đó.

![Network Diagram](ip-routing-demo.pdf)

Truy vết đường đi của các gói tin sau:

<!-- Example Sources and Destinations -->
|Nguồn|Đích|
|-|-|-|
|`10.1.23.12`|`10.2.1.16`||
|`10.1.99.2`|`10.1.99.6`||
|`192.168.2.30`|`8.8.8.8`||
|`10.2.12.37`|`192.168.2.12`|`10.0.0.0/8` và `192.168.0.0/16` là mạng riêng tư và không được định tuyến qua Internet ngoài|
|`10.1.17.22`|`10.1.17.23`||
|`10.2.12.2`|`10.1.23.12`||

## Routing Loops and Time-To-Live (Vòng lặp định tuyến và TTL)

Dễ thấy rằng hoàn toàn có thể thiết lập một vòng lặp mà gói tin đi vòng mãi
mãi.

Để giải quyết vấn đề này, IP có một trường trong header: _time to live_
(TTL, thời gian sống). Đây là một bộ đếm một byte bắt đầu từ 255 và giảm
đi mỗi lần một router chuyển tiếp gói tin.

Khi bộ đếm về không, gói tin bị loại bỏ và một thông báo lỗi
[ICMP](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol)
"Time Exceeded" (Hết thời gian) được gửi về cho người gửi.

Vậy số hop tối đa một gói tin có thể thực hiện là 255, ngay cả trong vòng lặp.

Tiện ích `traceroute` hoạt động bằng cách gửi gói tin đến đích với TTL là 1
và xem ai gửi lại thông báo ICMP. Sau đó gửi tiếp với TTL là 2 và xem ai
phản hồi. Cứ như vậy tăng dần TTL cho đến khi đích cuối cùng phản hồi.

## The Broadcast Address (Địa chỉ broadcast)

IPv4 có một địa chỉ đặc biệt gọi là _broadcast address_ (địa chỉ phát rộng).
Đây là địa chỉ gửi gói tin đến mọi máy tính trên LAN.

Đây là địa chỉ trên một subnet với tất cả các bit host được đặt thành `1`.

Ví dụ:

<!-- CAPTION Broadcast Addresses -->
|Subnet|Subnet Mask|Broadcast Address|
|-|-|-|
|`10.20.30.0/24`|`255.255.255.0`|`10.20.30.255`|
|`10.20.0.0/16`|`255.255.0.0`|`10.20.255.255`|
|`10.0.0.0/8`|`255.0.0.0`|`10.255.255.255`|

Còn có _địa chỉ_ broadcast: `255.255.255.255`. Cái này gửi đến tất cả mọi người...

...Và "tất cả mọi người" ở đây có nghĩa là mọi người trên LAN. Không có gói
broadcast nào vượt qua được router, kể cả `255.255.255.255`. Các router không
chuyển tiếp chúng đi đâu cả.

Thế giới sẽ cực kỳ ồn ào nếu chúng làm thế.

Một trong những ứng dụng chính là khi bạn mở laptop lần đầu trên WiFi. Laptop
chưa biết IP, subnet mask, default gateway, thậm chí không biết hỏi ai. Vậy
nó gửi một gói broadcast đến `255.255.255.255` với một gói
[DHCP](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol)
yêu cầu thông tin đó. Một DHCP server đang lắng nghe có thể phản hồi với thông
tin cần thiết.

À, và vì bạn chắc chắn tò mò: IPv6 không có broadcast address --- nó được thay
thế bởi thứ gọi là IPv6 multicast. Ý tưởng tương tự, chỉ là tập trung hơn.

## Reflect (Ôn lại)

* Sự khác biệt giữa interior gateway protocol và exterior gateway protocol là
  gì?

* Mục tiêu chung của một giao thức định tuyến là gì?

* Ví dụ về nơi dùng interior gateway protocol là đâu? Còn exterior?

* Router dùng bảng định tuyến để xác định điều gì?

* Router IP làm gì tiếp theo với một gói tin nếu địa chỉ IP đích không nằm
  trên bất kỳ subnet cục bộ nào của nó?

* Tại sao một tiến trình lại gửi thứ gì đó đến địa chỉ broadcast?
