# Transmission Control Protocol (TCP)

Khi ai đó đào đứt một cáp quang bằng máy xúc, packet có thể bị mất. (Đã
có cả quốc gia bị mất mạng vì một chiếc neo thuyền kéo qua cáp ngầm dưới
biển!) Lỗi phần mềm, máy tính treo, router hỏng --- tất cả đều có thể
gây ra vấn đề.

Nhưng chúng ta không muốn phải nghĩ đến chuyện đó. Chúng ta muốn có một
thứ gì đó xử lý tất cả những chuyện đó rồi báo cho ta biết khi nào dữ
liệu đã đầy đủ, nguyên vẹn và đúng thứ tự.

TCP là thứ đó. Nó lo lắng về các packet bị mất để chúng ta không phải
lo. Và chỉ khi nó chắc chắn đã có đủ dữ liệu chính xác, _lúc đó_ nó mới
đưa dữ liệu cho chúng ta.

Chúng ta sẽ xem xét:

* Mục tiêu tổng thể của TCP
* Vị trí của nó trong network stack (ngăn xếp mạng)
* Ôn lại về TCP port (cổng TCP)
* Cách TCP tạo, sử dụng và đóng kết nối
* Các cơ chế đảm bảo tính toàn vẹn dữ liệu
  * Duy trì thứ tự packet
  * Phát hiện lỗi
* Flow control (kiểm soát luồng) --- cách receiver (máy nhận) tránh bị
  quá tải
* Congestion Control (kiểm soát tắc nghẽn) --- cách sender (máy gửi)
  tránh làm quá tải Internet

TCP là một chủ đề rất phức tạp và chúng ta chỉ lướt qua những điểm nổi
bật ở đây. Nếu bạn muốn tìm hiểu thêm, cuốn sách tham khảo kinh điển là
_TCP/IP Illustrated Volume 1_ của cố tác giả vĩ đại W. Richard Stevens.

## Mục tiêu của TCP

* Cung cấp giao tiếp đáng tin cậy (reliable communication)
* Mô phỏng kết nối kiểu circuit trên mạng packet-switched (chuyển mạch
  gói)
* Cung cấp flow control
* Cung cấp congestion control
* Hỗ trợ dữ liệu out-of-band

## Vị trí trong Network Stack

Hãy nhớ lại các tầng của Network Stack:

<!-- CAPTION: Internet Layered Network Model -->
|Layer|Responsibility|Example Protocols|
|:-:|-|-|
|Application|Structured application data|HTTP, FTP, TFTP, Telnet, SSH, SMTP, POP, IMAP|
|Transport|Data Integrity, packet splitting and reassembly|TCP, UDP|
|Internet|Routing|IP, IPv6, ICMP|
|Link|Physical, signals on wires|Ethernet, PPP, token ring|

Bạn có thể thấy TCP ở tầng Transport (Vận chuyển). IP bên dưới nó chịu
trách nhiệm routing (định tuyến). Và tầng Application bên trên tận dụng
tất cả các tính năng TCP cung cấp.

Đó là lý do tại sao khi chúng ta viết HTTP client và server, chúng ta
không phải lo về tính toàn vẹn dữ liệu chút nào. Chúng ta dùng TCP nên
nó lo hết cho ta rồi!

## TCP Port

Nhớ lại rằng khi dùng TCP chúng ta phải chỉ định số port để kết nối đến.
Và ngay cả client cũng được hệ điều hành tự động gán port cục bộ (nếu
chúng ta không tự `bind()`).

IP dùng địa chỉ IP để xác định host (máy chủ).

Nhưng khi đã đến host đó, số port là thứ hệ điều hành dùng để chuyển dữ
liệu đến đúng tiến trình.

Dùng phép so sánh: địa chỉ IP giống như địa chỉ đường phố, còn số port
giống như số căn hộ tại địa chỉ đó.

## Tổng quan về TCP

Có ba việc chính TCP thực hiện trong một kết nối:

1. Tạo kết nối
2. Truyền dữ liệu
3. Đóng kết nối

Mỗi việc đều liên quan đến việc gửi qua lại các packet đặc biệt không
chứa dữ liệu người dùng giữa client và server. Chúng ta sẽ xem xét các
loại packet đặc biệt SYN, SYN-ACK, ACK và FIN.

### Tạo kết nối (Making the Connection)

Đây là "bắt tay ba bước" (three-way handshake) nổi tiếng. Vì bất kỳ
packet nào cũng có thể bị mất trong quá trình truyền, TCP đặc biệt cẩn
thận để đảm bảo cả hai bên của kết nối sẵn sàng trước khi tiến hành.

1. Client gửi packet SYN (synchronize --- đồng bộ hóa) đến server.
2. Server trả lời bằng packet SYN-ACK (synchronize acknowledge --- xác
   nhận đồng bộ) về client.
3. Client trả lời bằng packet ACK (acknowledge --- xác nhận) về server.

Nếu không có phản hồi trong thời gian hợp lý cho bất kỳ bước nào trong
số này, packet sẽ được gửi lại.

### Truyền dữ liệu (Transmitting Data)

TCP nhận một luồng dữ liệu và chia thành các chunk (đoạn nhỏ). Mỗi chunk
được gắn một TCP header và sau đó được gửi xuống tầng IP để phân phối.
Header và chunk gộp lại gọi là một TCP _segment_ (phân đoạn).

(Chúng ta sẽ dùng "TCP packet" và "TCP segment" thay thế cho nhau, nhưng
"segment" mới là thuật ngữ chính xác hơn.)

Khi TCP gửi một segment, nó kỳ vọng người nhận sẽ phản hồi bằng một ACK
(acknowledgment --- xác nhận). Nếu TCP không nhận được ACK, nó sẽ giả
định có sự cố xảy ra và cần gửi lại segment đó.

Các segment được đánh số thứ tự để dù đến không đúng thứ tự, TCP vẫn có
thể sắp xếp lại đúng.

### Đóng kết nối (Closing the Connection)

Khi một bên muốn đóng kết nối, nó gửi packet FIN (finis [_sic_]). Phía
kia thường trả lời bằng ACK và FIN của riêng mình. Bên cục bộ sau đó
hoàn tất việc ngắt kết nối bằng một ACK nữa.

Trong một số hệ điều hành, nếu một host đóng kết nối trong khi còn dữ
liệu chưa đọc, nó gửi RST (reset --- đặt lại) để thông báo điều đó. Các
chương trình socket có thể in thông điệp "Connection reset by peer" khi
điều này xảy ra.

## Tính toàn vẹn dữ liệu (Data Integrity)

Có rất nhiều thứ có thể xảy ra sai. Dữ liệu có thể đến không đúng thứ
tự. Nó có thể bị hỏng. Nó có thể bị trùng lặp. Hoặc có thể không đến
được.

TCP có các cơ chế để xử lý tất cả những trường hợp này.

### Thứ tự Packet (Packet Ordering)

Sender đặt một sequence number (số thứ tự) tăng dần vào mỗi segment.
"Đây là segment 3490. Đây là segment 3491."

Receiver trả lời sender bằng packet ACK chứa sequence number đó. "Tôi đã
nhận segment 3490. Tôi đã nhận segment 3491."

Nếu hai segment đến không đúng thứ tự, TCP có thể đặt lại thứ tự bằng
cách sắp xếp theo sequence number.

> Đến lúc dùng phép ví von rồi! Nếu bạn có một chồng giấy và tung chúng
> lên không trung, làm sao bạn biết thứ tự ban đầu của chúng? Thật ra,
> nếu bạn đã đánh số trang đúng, chỉ cần sắp xếp lại thôi. Đó là vai
> trò của sequence number trong TCP.

Nếu một segment trùng lặp đến, TCP biết nó đã thấy sequence number đó
rồi, nên có thể bỏ qua bản sao đó một cách an toàn.

Nếu một segment bị thiếu, TCP có thể yêu cầu gửi lại. Nó làm điều này
bằng cách liên tục ACK segment trước đó. Sender sẽ gửi lại segment tiếp
theo.

Ngoài ra, nếu sender không nhận được ACK cho một segment cụ thể trong
một thời gian, nó có thể tự mình gửi lại segment đó, nghĩ rằng segment
có thể đã bị mất. Việc gửi lại này ngày càng bi quan hơn với mỗi lần
timeout; server tăng gấp đôi thời gian timeout mỗi lần điều đó xảy ra.

Cuối cùng, sequence number được khởi tạo với các giá trị ngẫu nhiên
trong quá trình bắt tay ba bước khi kết nối đang được thiết lập.

### Phát hiện lỗi (Error Detection)

Trước khi sender gửi một segment, một _checksum_ (tổng kiểm tra) được
tính cho segment đó.

Khi receiver nhận segment, nó tính checksum của riêng mình cho segment
đó.

Nếu hai checksum khớp nhau, dữ liệu được coi là không có lỗi. Nếu chúng
khác nhau, dữ liệu bị loại bỏ và sender phải timeout rồi gửi lại.

Checksum là một số 16-bit là kết quả của việc đưa toàn bộ dữ liệu TCP
header, payload và các địa chỉ IP liên quan vào một hàm để tóm tắt
chúng.

Chi tiết có trong project tuần này.

## Flow Control (Kiểm soát luồng)

_Flow Control_ là cơ chế mà qua đó hai thiết bị đang giao tiếp cảnh báo
nhau rằng dữ liệu cần được gửi chậm hơn. Bạn không thể đổ 1000 Mbs
(megabit mỗi giây) vào một thiết bị chỉ xử lý được 100 Mbs. Thiết bị
cần một cách để cảnh báo sender hãy chậm lại.

> Phép ví von: bạn làm điều này trên điện thoại khi nói với người kia
> "Bạn nói nhanh quá tôi không hiểu được! Nói chậm lại đi!"

Cách đơn giản nhất để làm điều này (và đây không phải cách TCP làm) là
sender gửi dữ liệu, rồi chờ receiver gửi lại packet ACK với sequence
number đó. Sau đó gửi packet dữ liệu khác. Cách này cho phép receiver
trì hoãn ACK nếu nó cần sender chậm lại.

Nhưng đây là cách làm chậm chạp, và mạng thường đủ tin cậy để sender
đẩy ra nhiều segment mà không cần chờ phản hồi.

Tuy nhiên, nếu chúng ta làm vậy, chúng ta có nguy cơ sender gửi dữ liệu
nhanh hơn receiver có thể xử lý!

Trong TCP, vấn đề này được giải quyết bằng thứ gọi là _sliding window_
(cửa sổ trượt). Nó nằm trong trường "window" của TCP header trong packet
ACK của receiver.

Trong trường đó, data receiver có thể chỉ định có thể nhận thêm bao
nhiêu dữ liệu (tính bằng bytes). Sender không được gửi nhiều hơn mức
này mà không nhận được ACK từ receiver. Và ACK nó nhận được sẽ chứa
thông tin window mới.

Sử dụng cơ chế này, receiver có thể nói với sender "khi bạn đã gửi X
bytes, bạn phải chờ ACK cho biết có thể gửi thêm bao nhiêu nữa".

Quan trọng cần lưu ý rằng đây là đếm byte, không phải đếm segment.
Sender tự do gửi nhiều segment mà không cần nhận ACK miễn là tổng số
bytes không vượt quá kích thước window receiver đã quảng bá.

## Congestion Control (Kiểm soát tắc nghẽn)

Flow control hoạt động giữa hai máy tính, nhưng có một vấn đề lớn hơn
của Internet nói chung. Nếu một router bị quá tải, nó có thể bắt đầu bỏ
packet khiến sender bắt đầu gửi lại, điều này không giúp ích gì cho vấn
đề. Và nó còn không nằm trong tầm kiểm soát của flow control vì các
packet không đến được receiver.

Điều này đã xảy ra vào năm 1986 khi
[NSFNET](https://en.wikipedia.org/wiki/National_Science_Foundation_Network)
(về cơ bản là Internet thương mại tiền thân, cầu mong nó an nghỉ) bị
quá tải bởi các sender cố chấp không biết dừng việc gửi lại. Thông
lượng giảm xuống còn 0.1% bình thường. Không vui chút nào.

Để khắc phục điều này, một số cơ chế đã được TCP triển khai để ước tính
và loại bỏ tắc nghẽn mạng. Lưu ý rằng những cơ chế này bổ sung cho
Flow Control window do receiver quảng bá. Sender phải tuân thủ giới hạn
Flow Control **và** giới hạn tắc nghẽn mạng đã tính toán, tùy theo giá
trị nào thấp hơn. Nó không thể có nhiều segment chưa được xác nhận trên
mạng hơn giới hạn này. Nếu có, nó phải dừng gửi và chờ một số ACK đến.

Một cách khác để nghĩ về điều này là khi một sender đưa ra một TCP
segment mới, điều đó thêm vào tắc nghẽn mạng. Khi nó nhận được ACK,
điều đó chỉ ra rằng segment đó đã được xóa khỏi mạng, giảm tắc nghẽn.

Để giải quyết các vấn đề đã xảy ra với NFSNET, hai thuật toán lớn đã
được thêm vào: Slow Start (Khởi động chậm) và Congestion Avoidance
(Tránh tắc nghẽn).

**LƯU Ý:** Đây là cái nhìn đơn giản hóa về hai thuật toán này. Để biết
chi tiết đầy đủ về sự tương tác phức tạp giữa chúng và nhiều hơn về
congestion avoidance, xem [_TCP Congestion Control_ (RFC
5681)](https://www.rfc-editor.org/rfc/rfc5681.html).

### Slow Start (Khởi động chậm)

Khi kết nối lần đầu được thiết lập, sender không có cách nào biết mạng
tắc nghẽn đến mức nào. Giai đoạn đầu tiên này hoàn toàn là về việc có
được một ước tính sơ bộ.

Vì vậy nó sẽ bắt đầu một cách thận trọng, giả sử mức độ tắc nghẽn cao.
(Nếu đã có mức độ tắc nghẽn cao, việc xả dữ liệu ào ào vào sẽ không ích
gì.)

Nó bắt đầu bằng cách cho phép mình một _congestion window_ (cửa sổ tắc
nghẽn) ban đầu --- đó là số bytes chưa được ACK (và segment, nhưng hãy
cứ nghĩ theo bytes cho đơn giản) mà nó được phép có đang chờ xử lý.

Khi các ACK đến, kích thước congestion window tăng lên bằng số bytes đã
được xác nhận. Vậy nên, đại khái, sau khi một segment được ACK, hai
segment có thể được gửi ra. Nếu hai cái đó được ACK thành công, bốn cái
có thể được gửi ra.

Vậy nó bắt đầu với số lượng segment chưa được ACK rất hạn chế, nhưng
tăng rất nhanh.

Cuối cùng một trong những ACK đó bị mất và đó là lúc Slow Start quyết
định chậm lại đột ngột. Nó cắt kích thước congestion window xuống một
nửa và sau đó TCP chuyển sang thuật toán Congestion Avoidance.

### Congestion Avoidance (Tránh tắc nghẽn)

Thuật toán này tương tự Slow Start, nhưng thực hiện các bước di chuyển
kiểm soát hơn nhiều. Không còn cái trò tăng trưởng theo cấp số nhân nữa.

Mỗi lần một congestion window đáng dữ liệu được truyền thành công, nó
đẩy mạnh thêm một chút bằng cách thêm bytes tương đương một segment vào
window. Điều này cho phép nó có thêm một segment chưa được ACK trên
mạng. Nếu điều đó hoạt động tốt, nó tự cho phép thêm một cái nữa. Cứ
tiếp tục như vậy.

Vậy nên nó đang đẩy giới hạn của những gì có thể được gửi thành công mà
không làm tắc nghẽn mạng, nhưng đẩy chậm rãi. Chúng ta gọi điều này là
_additive-increase_ (tăng cộng) và nó thường là tuyến tính (so với Slow
Start vốn thường là hàm mũ).

Tuy nhiên, cuối cùng, nó đẩy quá xa và phải gửi lại một packet. Lúc
này, congestion window được đặt về kích thước nhỏ và thuật toán quay trở
lại Slow Start.

## Reflect (Suy ngẫm)

* Hãy kể tên một vài giao thức phụ thuộc vào TCP để đảm bảo tính toàn
  vẹn dữ liệu.

* Tại sao có bắt tay ba bước để thiết lập kết nối? Tại sao không chỉ
  bắt đầu truyền ngay?

* Checksum bảo vệ chống lại sự hỏng dữ liệu như thế nào?

* Sự khác biệt chính trong mục tiêu của Flow Control và Congestion
  Control là gì?

* Suy ngẫm về lý do chuyển đổi giữa Slow Start và Congestion Avoidance.
  Mỗi cái có ưu điểm gì trong các giai đoạn khác nhau của việc phát hiện
  tắc nghẽn?

* Mục đích của Flow Control là gì?
