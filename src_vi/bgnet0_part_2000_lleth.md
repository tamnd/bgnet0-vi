# Tầng Liên kết và Ethernet (The Link Layer and Ethernet)

Ta đang đi vào phần ruột của vấn đề: Tầng Liên kết (Link Layer).

<!-- CAPTION: Internet Layered Network Model -->
|Tầng|Trách nhiệm|Giao thức ví dụ|
|:-:|-|-|
|Application (Ứng dụng)|Dữ liệu ứng dụng có cấu trúc|HTTP, FTP, TFTP, Telnet, SSH, SMTP, POP, IMAP|
|Transport (Vận chuyển)|Toàn vẹn dữ liệu, chia và ghép gói tin|TCP, UDP|
|Internet (Mạng)|Định tuyến|IP, IPv6, ICMP|
|Link (Liên kết)|Vật lý, tín hiệu trên dây|Ethernet, PPP, token ring|

Tầng link là nơi mọi hành động xảy ra --- nơi các byte biến thành điện.

Đây cũng là nơi Ethernet tồn tại, như ta sẽ sớm thấy.

## A Quick Note on Octets (Một lưu ý nhỏ về Octet)

Ta đã dùng "byte" để chỉ 8 bit, nhưng giờ là lúc cần chính xác hơn.

Về mặt lịch sử, byte không nhất thiết phải là 8 bit. (Nổi tiếng là ngôn ngữ
lập trình C không quy định chính xác bao nhiêu bit trong một byte.) Và không
có gì ngăn các nhà thiết kế máy tính tự đặt ra quy tắc riêng. Chỉ tình cờ
là hầu hết mọi máy tính hiện đại đều dùng 8 bit cho một byte.

Để chính xác hơn, người ta đôi khi dùng từ _octet_ để biểu thị 8 bit. Nó
được định nghĩa chính xác là 8 bit, không có gì tranh cãi.

Khi ai đó nói (hay viết) "byte" theo kiểu thông thường, họ thường có ý là
8 bit. Khi ai đó nói "octet" thì chắc chắn họ có ý là chính xác 8 bit, hết.

## Frames versus Packets (Frame so với Packet)

Khi đến Tầng Liên kết, ta có thêm một chút thuật ngữ cần làm quen. Dữ liệu
gửi qua Ethernet là một packet (gói tin), nhưng bên trong packet đó có một
_frame_ (khung). Nó giống như một sub-packet (gói con).

Trong giao tiếp hàng ngày, người ta dùng "frame" và "packet" của Ethernet
thay thế cho nhau. Nhưng như ta sẽ thấy sau, có sự phân biệt trong mô hình
mạng ISO OSI đầy đủ.

Trong mô hình mạng phân tầng Internet đơn giản hóa, sự phân biệt này không
được thực hiện, dẫn đến thuật ngữ gây nhầm lẫn đó.

Câu chuyện hấp dẫn này sẽ tiếp tục ở phần sau của chương.

## MAC Addresses (Địa chỉ MAC)

Mọi thiết bị giao diện mạng (network interface device) đều có một địa chỉ
MAC (Media Access Control, Kiểm soát truy cập phương tiện). Đây là địa chỉ
duy nhất trên LAN (mạng cục bộ) được dùng để gửi và nhận dữ liệu.

Địa chỉ MAC Ethernet có dạng 6 byte hex (12 chữ số hex) được ngăn cách bởi
dấu hai chấm (hoặc gạch ngang hoặc dấu chấm). Ví dụ, đây là các cách bạn có
thể thấy một địa chỉ MAC được biểu diễn:

``` {.default}
ac:d1:b8:df:20:85
ac-d1-b8-df-20-85
acd1.b8df.2085
```

Địa chỉ MAC phải là duy nhất trên LAN. Các con số được gán bởi nhà sản xuất
và thường không được thay đổi bởi người dùng cuối. (Bạn chỉ muốn thay đổi
nếu xui xẻo mua hai card mạng tình cờ được gán cùng địa chỉ MAC.)

Ba byte đầu tiên của địa chỉ MAC Ethernet gọi là _OUI_ (Organizationally
Unique Identifier, Định danh duy nhất theo tổ chức) được gán cho nhà sản
xuất. Điều này để lại cho mỗi nhà sản xuất ba byte để định danh duy nhất cho
các card họ sản xuất. (Đó là 16.777.216 tổ hợp duy nhất có thể. Nếu nhà sản
xuất hết, họ có thể luôn xin thêm OUI khác --- có đến 16 triệu OUI khả dụng!)

> Tin đồn vui trên Internet: có một nhà sản xuất hàng nhái của card mạng
> NE2000, vốn đã được biết đến là card mạng "hàng bình dân". Nhà sản xuất
> hàng nhái đó lười đến mức ghi cùng một địa chỉ MAC vào mọi card họ làm.
> Điều này bị phát hiện khi một công ty mua một số lượng lớn và thấy chỉ có
> một máy tính hoạt động tại một thời điểm. Tất nhiên, ở mạng gia đình nơi
> ai đó chỉ có thể có một trong những card này, sẽ không có vấn đề --- đó là
> điều nhà sản xuất đang tính. Để thêm phần tức, không có cách nào thay đổi
> địa chỉ MAC trong các card nhái đó. Công ty buộc phải vứt bỏ tất cả.
>
> Trừ một cái, chắc vậy.

## We're All In The Same Room (Typically) (Tất cả chúng ta đều trong cùng một phòng)

Nhiều giao thức tầng link hiện đại mà bạn sẽ tiếp xúc trực tiếp hoạt động
dựa trên ý tưởng rằng tất cả chúng đang phát trên một phương tiện dùng chung
và lắng nghe lưu lượng được địa chỉ hóa đến chúng.

Giống như đang trong phòng đông người và ai đó hét tên bạn --- bạn nhận dữ
liệu được địa chỉ hóa đến bạn và mọi người khác bỏ qua nó.

Điều này hoạt động trong cuộc sống thực và trong các giao thức như Ethernet.
Khi bạn truyền một packet trên mạng Ethernet, mọi người khác trên cùng LAN
Ethernet đều có thể thấy lưu lượng đó. Chỉ là card mạng của họ bỏ qua lưu
lượng trừ khi nó được địa chỉ hóa cụ thể đến họ.

> Lưu ý: có một vài điểm xấp xỉ trong đoạn đó.
>
> Một là trong mạng Ethernet có dây hiện đại, một thiết bị gọi là _switch_
> (bộ chuyển mạch) thường ngăn các packet đi đến các node không được đến.
> Vậy mạng không thực sự ồn ào như hình ảnh phòng đông người gợi ý. Trước
> khi có switch, chúng ta dùng thứ gọi là `hub` (bộ tập trung), không đủ
> thông minh để phân biệt các đích. Chúng broadcast tất cả gói Ethernet đến
> tất cả đích.

Tuy nhiên, không phải mọi giao thức tầng link đều hoạt động như vậy. Mục
tiêu chung của tất cả chúng là gửi và nhận dữ liệu ở cấp độ dây.

## Multiple Access Method (Phương thức truy cập đa điểm)

Sẵn sàng nghe thêm lịch sử không?

Nếu tất cả mọi người trên cùng Ethernet đều ở trong cùng phòng hét vào người
khác, điều đó thực sự hoạt động trên dây như thế nào? Làm sao nhiều thực thể
truy cập một phương tiện dùng chung mà không xung đột?

> Khi nói "phương tiện" ở đây, ta có ý là dây (nếu bạn đã cắm máy vào mạng)
> hoặc sóng radio (nếu bạn dùng WiFi).

Phương thức mà các giao thức tầng link cụ thể dùng để cho phép nhiều thực
thể truy cập phương tiện dùng chung gọi là _multiple access method_ (phương
thức truy cập đa điểm) hay _channel access method_ (phương thức truy cập
kênh).

Có [nhiều cách để làm điều
này](https://en.wikipedia.org/wiki/Channel_access_method). Trên cùng phương tiện:

* Bạn có thể truyền packet trên các tần số khác nhau.
* Bạn có thể gửi packet vào các thời điểm khác nhau, như timesharing.
* Bạn có thể dùng spread spectrum hoặc frequency hopping.
* Bạn có thể chia mạng thành các "cell" khác nhau.
* Bạn có thể thêm một dây khác để cho phép lưu lượng chạy hai chiều cùng lúc.

Hãy lại dùng Ethernet làm ví dụ. Ethernet giống nhất với chế độ "timesharing"
ở trên.

Nhưng điều đó vẫn để ngỏ nhiều lựa chọn về cách chúng ta thực hiện _điều đó_.

Ethernet có dây dùng thứ gọi là
[CSMA/CD](https://en.wikipedia.org/wiki/Carrier-sense_multiple_access_with_collision_detection)
(Carrier-Sense Multiple Access with Collision Detection, Đa truy cập cảm nhận
sóng mang có phát hiện xung đột). Dễ nói thật.

Phương thức này hoạt động như sau:

1. Card Ethernet chờ yên tĩnh trong phòng --- khi không có card mạng nào
   khác đang truyền. (Đây là phần "CSMA" của CSMA/CD.)

2. Bắt đầu gửi.

3. Cũng lắng nghe trong khi gửi.

4. Nếu nhận được đúng thứ đã gửi, mọi thứ ổn.

   Nếu không nhận được đúng thứ đã gửi, có nghĩa là một thiết bị mạng khác
   cũng bắt đầu truyền cùng lúc. Đây là phát hiện xung đột, phần "CD" của
   CSMA/CD.

5. Để giải quyết tình huống, card mạng truyền một tín hiệu đặc biệt gọi là
   "jam signal" (tín hiệu gây nhiễu) để cảnh báo các card khác trên mạng
   rằng xung đột đã xảy ra và chúng nên ngừng truyền. Card mạng sau đó chờ
   một khoảng thời gian ngẫu nhiên nhỏ, rồi quay lại bước 1 để thử lại.

WiFi (Ethernet không dây) dùng thứ tương tự, ngoại trừ đó là
[CSMA/CA](https://en.wikipedia.org/wiki/Carrier-sense_multiple_access_with_collision_avoidance)
(Carrier-Sense Multiple Access with Collision Avoidance, Đa truy cập cảm nhận
sóng mang có tránh xung đột). Cũng dễ nói thật.

Phương thức này hoạt động như sau:

1. Card Ethernet chờ yên tĩnh trong phòng --- khi không có card mạng nào
   khác đang truyền. (Đây là phần "CSMA" của CSMA/CA.)
  
2. Nếu kênh không yên tĩnh, card mạng chờ một khoảng thời gian ngẫu nhiên
   nhỏ, rồi quay lại bước 1 để thử lại.

Có một vài chi tiết bị bỏ qua ở đó, nhưng đó là ý chính.

## Ethernet

Nhớ lại mô hình mạng phân tầng cách mỗi tầng _đóng gói_ (encapsulate) dữ
liệu của tầng trước vào header của chính nó không?

Ví dụ, dữ liệu HTTP (Tầng Application) được gói vào header TCP (Tầng
Transport). Sau đó tất cả được gói vào header IP (Tầng Network). Rồi **tất cả
những thứ đó** được gói vào frame Ethernet (Tầng Link).

Và nhớ rằng mỗi giao thức có cấu trúc header riêng để giúp nó thực hiện
công việc.

Ethernet cũng không ngoại lệ. Nó sẽ đóng gói dữ liệu từ tầng bên trên.

Giờ, mình muốn chỉn chu về thuật ngữ. Toàn bộ khối dữ liệu được truyền là
Ethernet _packet_ (gói tin Ethernet). Nhưng bên trong đó là Ethernet _frame_
(khung Ethernet). Như ta sẽ thấy sau, chúng tương ứng với hai tầng của mô
hình mạng ISO OSI 7 tầng (đã được gom lại thành một "Tầng Link" duy nhất
trong mô hình mạng phân tầng Internet).

Dù mình viết frame "bên trong" packet ở đây, lưu ý rằng chúng đều được
truyền như một luồng bit duy nhất.

* **Packet:**
  * 7 octet: Preamble (tiền tố) (dạng hex: `AA AA AA AA AA AA AA`)
  * 1 octet: Start frame delimiter (dấu phân cách bắt đầu frame) (dạng hex: `AB`)
  * **Frame:**
    * 6 octet: Địa chỉ MAC đích
    * 6 octet: Địa chỉ MAC nguồn
    * 4 octet: ["Dot1q" tag](https://en.wikipedia.org/wiki/IEEE_802.1Q)
      dành cho phân biệt [virtual LAN](https://en.wikipedia.org/wiki/VLAN)
      (mạng LAN ảo).
    * 2 octet: Payload Length/Ethertype (xem bên dưới)
    * 46--1500 octet: Payload (tải trọng)
    * 4 octet: [CRC-32 checksum](https://en.wikipedia.org/wiki/Cyclic_redundancy_check#CRC-32_algorithm)
  * Dấu hiệu kết thúc frame, mất tín hiệu carrier
  * Khoảng trống giữa các packet, đủ thời gian để truyền 12 octet

Trường Payload Length/[EtherType](https://en.wikipedia.org/wiki/EtherType)
được dùng cho độ dài payload trong cách dùng thông thường. Nhưng các giá trị
khác có thể được đặt ở đó để chỉ ra một cấu trúc payload thay thế.

Payload lớn nhất có thể truyền là 1500 octet. Đây được gọi là MTU (Maximum
Transmission Unit, Đơn vị truyền tối đa) của mạng. Dữ liệu lớn hơn phải
được phân mảnh xuống kích thước này.

> Phần cứng Ethernet có thể dùng con số 1500 này để phân biệt trường header
> Payload Length/EtherType. Nếu là 1500 octet hoặc ít hơn, đó là độ dài.
> Ngược lại là giá trị EtherType.

Sau frame, có một dấu hiệu kết thúc frame. Điều này được chỉ ra bởi sự mất
tín hiệu carrier trên dây, hoặc bởi một số truyền tải rõ ràng trong một số
phiên bản Ethernet.

Cuối cùng, có một khoảng thời gian giữa các gói Ethernet tương ứng với thời
gian cần để truyền 12 octet.

### Two Layers of Ethernet? (Hai tầng Ethernet?)

Nhớ lại, mô hình tầng đơn giản hóa của ta thực sự là phiên bản rút gọn của
mô hình ISO OSI đầy đủ 7 tầng:

<!-- CAPTION: ISO OSI Network Layer Model -->
|Tầng ISO OSI|Trách nhiệm|Giao thức ví dụ|
|:-:|-|-|
|Application (Ứng dụng)|Dữ liệu ứng dụng có cấu trúc|HTTP, FTP, TFTP, Telnet, SMTP, POP, IMAP|
|Presentation (Trình bày)|Dịch mã hóa, mã hóa, nén|MIME, SSL/TLS, XDR|
|Session (Phiên)|Tạm dừng, kết thúc, khởi động lại phiên giữa các máy tính|Sockets, TCP|
|Transport (Vận chuyển)|Toàn vẹn dữ liệu, chia và ghép gói tin|TCP, UDP|
|Network (Mạng)|Định tuyến|IP IPv6, ICMP|
|Data link (Liên kết dữ liệu)|Đóng gói vào frame|Ethernet, PPP, SLIP|
|Physical (Vật lý)|Vật lý, tín hiệu trên dây|Tầng vật lý Ethernet, DSL, ISDN|

Cái ta gọi là "Tầng Link" Internet chính là tầng "Data Link" _và_ tầng
"Physical".

Tầng Data Link của Ethernet là _frame_. Nó là tập con của toàn bộ _packet_
(được phác thảo ở trên) được định nghĩa ở Tầng Physical.

Một cách khác để xem xét là Tầng Data Link bận tâm đến các thực thể logic
như ai có địa chỉ MAC nào và checksum payload là gì. Còn Tầng Physical thì
bận tâm đến việc xác định các mẫu tín hiệu nào cần gửi tương ứng với bắt đầu
và kết thúc của packet và frame, khi nào hạ tín hiệu carrier, và trì hoãn bao
lâu giữa các lần truyền.

## Reflect (Ôn lại)

* Địa chỉ MAC của bạn trên máy tính là gì? Tìm kiếm Internet để biết cách
  tra cứu.

* Sự khác biệt giữa _frame_ và _packet_ trong Ethernet là gì? Chúng nằm ở
  đâu trong mô hình mạng ISO OSI?

* Sự khác biệt giữa byte và octet là gì?

* Sự khác biệt chính giữa CSMA/CD và CSMA/CA là gì?
