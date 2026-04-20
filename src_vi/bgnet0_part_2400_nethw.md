# Phần Cứng Mạng

Trong chương này ta sẽ xem qua một số thành phần phần cứng mạng.

Một số thứ trong đó bạn đã có ở nhà hoặc trên máy tính rồi.

## Thuật Ngữ và Các Thành Phần

* **Network Topology (cấu trúc liên kết mạng)**: mô tả bố cục của một mạng,
  cách các thiết bị và node kết nối với nhau, và cách dữ liệu di chuyển
  từ phần này sang phần khác của mạng.

* **Mbs**: Megabit mỗi giây (so sánh với "MBs", megabyte mỗi giây).

* **Gbs**: Gigabit mỗi giây, 1000 Mbs (so sánh với "GBs", gigabyte mỗi giây).

* **Bandwidth (băng thông)**: Đo bằng bit mỗi giây, lượng dữ liệu một loại
  cáp nhất định có thể truyền trong một khoảng thời gian nhất định.
  Ví dụ: 500 Mbs.

* **ISP**: Internet Service Provider (nhà cung cấp dịch vụ Internet), công ty
  bạn trả tiền để có kết nối Internet. (Hoặc là công ty cung cấp nó,
  dù bạn có trả tiền hay không!)

* **Twisted Pair Cable (cáp xoắn đôi)**: Thứ mà người ta thường nghĩ đến
  khi nói đến "cáp Ethernet". Đó là cáp có jack cắm ở cả hai đầu. Bên trong,
  các cặp dây được xoắn lại với nhau để giảm nhiễu. Các loại cáp này có
  chiều dài "chạy" tối đa được công bố để xác định bạn có thể kéo cáp bao xa
  trước khi gặp vấn đề, thường là 50-100 mét tùy loại cáp và tốc độ lưu lượng.
  * **10baseT**: 10 Mbs twisted-pair cho Ethernet
  * **100baseTX**: 100 Mbs twisted-pair cho _Fast Ethernet_.
  * **1000baseT**: 1 Gbs twisted-pair cho _Gigabit Ethernet_.
  * **10GbaseT**: 10 Gbs twisted-pair cho _10 Gigabit Ethernet_.
  * **Category-5**: Gọi tắt là _cat-5_, dây xoắn đôi theo chuẩn category-5.
    Tốt cho Fast Ethernet.
  * **Category-6**: Gọi tắt là _cat-6_, dây xoắn đôi theo chuẩn category-6.
    Tốt cho Gigabit Ethernet.

* **Network Port (cổng mạng)**: Không nhầm với số port TCP hay UDP vốn hoàn
  toàn khác nhé --- trong ngữ cảnh này là ổ cắm vật lý trên thiết bị để
  bạn cắm cáp mạng vào.

* **Ethernet Cable (cáp Ethernet)**: Thuật ngữ thông thường chỉ cáp xoắn đôi
  mà bạn cắm vào các thiết bị Ethernet.

* **Crossover Cable (cáp đấu chéo)**: Cáp mà các chân transmit (phát) và
  receive (nhận) bị hoán đổi ở một đầu. Thường dùng khi kết nối hai thiết
  bị trực tiếp với nhau mà bình thường phải qua switch hay hub làm trung gian.
  Nếu cắm một máy tính trực tiếp vào máy tính khác bằng cáp Ethernet,
  thì nên dùng crossover cable. Ngược lại với cáp _straight-through_.

* **Auto-sensing (tự cảm nhận)**: Cổng mạng có thể phát hiện xem đang có
  cáp straight-through hay cross-over cắm vào, và có thể đảo ngược tín hiệu
  transmit và receive nếu cần.

* **Thin-net/Thick-net**: Cáp đồng trục lỗi thời dùng cho Ethernet.

* **LAN**: Local Area Network (mạng cục bộ). Với Ethernet, đây là mạng
  ở nhà bạn. Hãy nghĩ đến một subnet IP đơn lẻ.

* **WAN**: Wide Area Network (mạng diện rộng). Mạng không phải LAN. Hãy nghĩ
  đến tập hợp các LAN trên khuôn viên trường đại học hoặc công ty.

* **Dynamic IP (IP động)**: Là khi IP của bạn được cài đặt tự động bằng
  [DHCP](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol)
  chẳng hạn. Địa chỉ IP có thể thay đổi theo thời gian.

* **Static IP (IP tĩnh)**: Là khi bạn hardcode (cài cứng) địa chỉ IP cho
  một thiết bị nhất định. Địa chỉ IP không đổi cho đến khi bạn chủ động
  nhập địa chỉ mới.

* **Network Interface Controller (NIC)** (bộ điều khiển giao diện mạng),
  **Network Interface Card** (card giao diện mạng),
  **Network Adapter** (bộ chuyển đổi mạng),
  **LAN Adapter**, **Network Card**: Một mớ tên khác nhau cho cùng một thiết
  bị phần cứng cho phép máy tính kết nối mạng. Card này có thể có cổng
  Ethernet, hoặc chỉ thuần wireless. Ngày nay có thể không còn là một
  [card](https://en.wikipedia.org/wiki/Expansion_card) đúng nghĩa nữa ---
  có thể tất cả đều tích hợp trên cùng chip với nhiều thiết bị I/O khác
  được gắn vào mainboard.

* **Network Device (OS) (thiết bị mạng trong hệ điều hành)**: Cấu trúc thiết
  bị phần mềm trong hệ điều hành thường map (ánh xạ) tới một NIC. Một số
  thiết bị mạng như _loopback device_ thực ra không dùng phần cứng vật lý
  mà chỉ "truyền" dữ liệu nội bộ trong OS. Trên Unix-like, các thiết bị này
  được đặt tên như `eth0`, `en1`, `wlan2` và tương tự. Loopback device thường
  được gọi là `lo`.

* **MAC address**: Media Access Control address (địa chỉ kiểm soát truy cập
  phương tiện). Địa chỉ Link Layer duy nhất cho máy tính. Với Ethernet,
  địa chỉ MAC dài 6 byte, thường viết dạng hex bytes cách nhau bằng dấu
  hai chấm: `12:34:56:78:9A:BC`. Các địa chỉ này phải là duy nhất trên
  một LAN để Ethernet hoạt động đúng.

* **Hub**: Thiết bị cho phép kết nối nhiều máy tính qua cáp Ethernet. Có 4,
  8 hoặc nhiều cổng hơn ở mặt trước. Tất cả thiết bị cắm vào các cổng đó
  thực chất trên cùng một "dây" khi được kết nối --- nghĩa là bất kỳ gói tin
  Ethernet nào được truyền đều được **tất cả** thiết bị cắm vào HUB nhìn thấy.
  Ngày nay bạn không còn thấy loại này nữa, vì switch thực hiện cùng chức năng
  nhưng tốt hơn.

* **Switch**: Hub có thêm não. Nó biết địa chỉ MAC ở phía bên kia các cổng
  nên không cần truyền lại gói tin Ethernet tới _tất cả mọi người_. Nó chỉ
  gửi xuống đúng dây tới đúng đích. Giúp ngăn quá tải mạng.

* **Router (bộ định tuyến)**: Thiết bị Network Layer có nhiều interface và
  chọn interface đúng để gửi lưu lượng đi sao cho cuối cùng đến được đích.
  Router chứa _routing table (bảng định tuyến)_ giúp quyết định nơi forward
  (chuyển tiếp) một gói tin với địa chỉ IP nhất định.

* **Default Gateway (cổng mặc định)**: Router xử lý lưu lượng đến tất cả
  các đích khác, khi không biết route (tuyến đường) cụ thể đến đích đó.
  Routing table của máy tính chỉ định default gateway. Trên LAN gia đình,
  đây là IP của "router" mà ISP cấp cho bạn.

  Hãy tưởng tượng một hòn đảo có một thị trấn nhỏ. Đảo được nối với đất
  liền bằng một cây cầu duy nhất. Nếu ai đó muốn biết đi đâu trong thị trấn,
  bạn chỉ đường trong thị trấn. Với **tất cả các điểm đến khác**, họ lái xe
  qua cầu. Trong ví dụ này, cây cầu là default gateway cho lưu lượng.

* **Broadcast (phát sóng)**: Gửi lưu lượng đến tất cả mọi người trên LAN.
  Có thể làm ở Link Layer bằng cách gửi Ethernet frame đến địa chỉ MAC
  `ff:ff:ff:ff:ff`, hoặc ở Network Layer bằng cách gửi gói IP với tất cả
  bit host đặt là `1`. Ví dụ, nếu mạng là `192.168.0.0/16`, địa chỉ
  broadcast sẽ là `192.168.255.255`. Bạn cũng có thể broadcast đến
  `255.255.255.255` để đạt hiệu quả tương tự. IP router không forward
  gói IP broadcast, nên chúng luôn bị giới hạn trong LAN.

* **Wi-Fi**: Viết tắt của _Wireless Fidelity_ (một thương hiệu marketing
  phi kỹ thuật được cho là chơi chữ với
  [Hi-Fi](https://en.wikipedia.org/wiki/High_fidelity)), đây là kết nối
  LAN không dây của bạn. Nói chuyện bằng Ethernet ở Link Layer. Rất giống
  dùng cáp Ethernet, chỉ khác là thay vì điện qua đồng, nó dùng sóng radio.

* **Firewall (tường lửa)**: Máy tính hoặc thiết bị tại hoặc gần nơi LAN
  kết nối với ISP, lọc lưu lượng, ngăn lưu lượng không mong muốn
  truyền qua LAN. Giữ bọn xấu ở ngoài --- hy vọng vậy.

* **NAT**: Network Address Translation (dịch địa chỉ mạng). Cách để có
  một subnet IP riêng tư đằng sau thiết bị NAT mà phần còn lại của
  Internet không nhìn thấy. Thiết bị NAT dịch địa chỉ IP và port nội bộ
  thành IP bên ngoài trên router. Đó là lý do nếu bạn hỏi Google "ip của
  tôi là gì", bạn sẽ nhận số khác so với khi nhìn vào cài đặt máy tính.
  NAT đứng ở giữa, dịch giữa địa chỉ IP LAN nội bộ và địa chỉ IP bên
  ngoài, công khai. Ta sẽ nói thêm về cơ chế chi tiết này sau.

* **Private Network IPv4 Addresses (địa chỉ IPv4 mạng riêng tư)**: Cho các
  LAN không kết nối Internet hoặc LAN đằng sau NAT, có ba subnet phổ biến
  được dùng: `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`. Chúng được
  dành riêng cho sử dụng cá nhân; không có trang web công khai nào dùng
  chúng, nên bạn có thể dùng trên LAN mà không lo xung đột.

* **WiFi Modem/WiFi Router**: Nói lỏng lẻo về thiết bị cấp người dùng bình
  thường bạn nhận được khi đăng ký dịch vụ ISP. Thường làm nhiều việc cùng lúc.

* **Rack-mount**: Nếu thiết bị không đến trong vỏ nhựa đẹp hoặc không được
  cắm trực tiếp vào máy tính, nó có thể là rack-mount. Đây là những thiết bị
  phi người dùng cỡ lớn hơn như router, switch, hoặc dãy đĩa, được xếp chồng
  trong "rack" (giá đỡ).

* **Upload (tải lên)**: Chuyển file từ thiết bị cục bộ của bạn lên thiết bị
  từ xa.

* **Download (tải xuống)**: Chuyển file từ thiết bị từ xa về thiết bị cục bộ
  của bạn.

* **Symmetric (đối xứng)**: Trong ngữ cảnh tốc độ truyền, nghĩa là kết nối
  cung cấp tốc độ như nhau ở cả hai chiều. "1 Gbs symmetric" nghĩa là tốc độ
  upload và download đều là 1 Gbs.

* **Asymmetric (bất đối xứng)**: Trong ngữ cảnh tốc độ truyền, nghĩa là kết
  nối cung cấp tốc độ khác nhau ở mỗi chiều. Thường viết như "600 Mbs down,
  20 Mbs up" chẳng hạn, chỉ tốc độ download và upload. Thường gọi ngắn là
  "600 by 20" khi nói chuyện. Vì đại đa số người dùng tải xuống nhiều hơn
  tải lên, các công ty cung cấp dịch vụ phân bổ nhiều băng thông hơn cho
  phía download.

* **Cable (từ công ty cáp)**: Nhiều công ty truyền hình cáp cung cấp kết nối
  Internet qua đường cáp đồng trục đã lắp đến nhà bạn. Tốc độ lên đến
  1 Gbs không phải hiếm. Thường một khu phố chia sẻ băng thông, nên tốc độ
  sẽ giảm vào buổi tối khi mọi người xung quanh đang xem phim. Hầu hết cáp
  là bất đối xứng.

* **DSL**: Digital Subscriber Line (đường dây thuê bao số). Nhiều công ty
  điện thoại cung cấp kết nối Internet qua đường dây điện thoại đã lắp đến
  nhà bạn. Chậm hơn cáp ở khoảng 100 Mbs, nhưng băng thông không chia sẻ
  với hàng xóm. Hầu hết DSL là bất đối xứng.

* **Fiber (cáp quang)**: Viết tắt của _optical fiber_ (sợi quang), dùng ánh
  sáng qua sợi thủy tinh thay vì điện qua dây đồng. Rất nhanh. Nhiều ISP
  cung cấp cáp quang giá tương đối rẻ với các gói 1 Gbs đối xứng.

* **Modem**: Viết tắt của _Modulator/Demodulator_ (điều chế/giải điều chế),
  chuyển đổi tín hiệu từ dạng này sang dạng khác. Truyền thống, điều này có
  nghĩa là chuyển âm thanh truyền qua đường dây điện thoại thành dữ liệu.
  Trong cách dùng hiện đại, là chuyển đổi tín hiệu trên LAN Ethernet của bạn
  thành dạng cần thiết cho ISP, ví dụ cáp hoặc DSL.

* **Bridge (cầu nối)**: Thiết bị kết nối hai mạng ở link level (tầng liên
  kết), cho phép chúng hoạt động như một mạng duy nhất. Một số bridge
  chuyển tiếp mù quáng toàn bộ lưu lượng, bridge khác thông minh hơn.
  Cable modem là một loại bridge, dù chúng thường đi kèm trong cùng hộp
  với router và switch.

* **Vampire Tap**: Ngày xưa, khi muốn kết nối máy tính với cáp thicknet, bạn
  dùng một trong [những thiết bị có tên tuyệt vời
  này](https://en.wikipedia.org/wiki/Vampire_tap). Đưa vào đây chỉ để vui thôi.

## Suy Ngẫm

* Sự khác biệt giữa hub và switch là gì?

* Router làm gì?

* Tại sao một router chỉ có một kết nối mạng lại không có ý nghĩa gì?

* Bạn kết nối với loại thiết bị nào ở nơi bạn sống?
  Bạn có dùng cáp vật lý để kết nối không?
  
* Không cần viết gì cho điểm suy ngẫm này trừ khi bạn thích, nhưng hãy suy
  nghĩ về cuộc sống [với modem 300 bps
  này](https://www.youtube.com/watch?v=PjwnIm5Y6XE). Modem đầu tiên của tác
  giả là một chiếc
  [VICMODEM](https://www.oldcomputr.com/commodore-vicmodem-1982/),
  chậm hơn kết nối cáp hiện đại đúng hai triệu lần.
  Đó là 40 năm trước. Giờ hãy tưởng tượng tốc độ mạng vào năm 2062.
