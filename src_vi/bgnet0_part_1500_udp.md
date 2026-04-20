# User Datagram Protocol (UDP)

Nếu bạn thích sự đơn giản và có tư duy lạc quan, UDP dành cho bạn. Đây
là chuẩn mực gần như tối thượng của việc truyền dữ liệu nhẹ nhàng qua
Internet.

Bạn bắn ra các UDP packet và hy vọng chúng đến nơi. Có thể chúng đến,
hoặc có thể ai đó đào đứt cáp quang bằng máy xúc, hoặc có tia vũ trụ,
hoặc một router quá tải hay cáu kỉnh và cứ thế vứt bỏ. Không thương
tiếc.

Đây là sống trên ranh giới dữ liệu Internet! Hầu như tất cả những đảm
bảo dễ chịu và đáng tin cậy của TCP --- biến mất hết!

## Mục tiêu của UDP

* Cung cấp cách gửi dữ liệu không có lỗi từ máy tính này sang máy tính
  khác.

Chỉ vậy thôi.

Những điều sau đây **không** phải là mục tiêu của UDP:

* Cung cấp dữ liệu theo đúng thứ tự
* Cung cấp dữ liệu không bị mất
* Cung cấp dữ liệu không bị trùng lặp

Nếu những điều đó cần thiết, TCP là lựa chọn tốt hơn. UDP cung cấp zero
bảo vệ chống lại dữ liệu bị mất hoặc sai thứ tự. Đảm bảo duy nhất là
_nếu_ dữ liệu đến nơi, nó sẽ là chính xác.

Nhưng những gì UDP cho bạn là overhead rất thấp và thời gian phản hồi
nhanh. Nó không có bất kỳ quá trình tái hợp packet, flow control hay
packet ACK hay bất cứ thứ gì mà TCP làm. Hệ quả là header nhỏ hơn
nhiều.

## Vị trí trong Network Stack

Hãy nhớ lại các tầng của Network Stack:

<!-- CAPTION: Internet Layered Network Model -->
|Layer|Responsibility|Example Protocols|
|:-:|-|-|
|Application|Structured application data|HTTP, FTP, TFTP, Telnet, SSH, SMTP, POP, IMAP|
|Transport|Data Integrity, packet splitting and reassembly|TCP, UDP|
|Internet|Routing|IP, IPv6, ICMP|
|Link|Physical, signals on wires|Ethernet, PPP, token ring|

Bạn có thể thấy UDP ở tầng Transport (Vận chuyển). IP bên dưới nó chịu
trách nhiệm routing. Và tầng Application bên trên tận dụng tất cả các
tính năng UDP cung cấp. Mà không có nhiều lắm.

## UDP Port

UDP dùng port (cổng), tương tự TCP. Thực ra, bạn có thể có một chương
trình TCP dùng cùng số port với một chương trình UDP khác.

IP dùng địa chỉ IP để xác định host.

Nhưng khi đã đến host đó, số port là thứ hệ điều hành dùng để chuyển dữ
liệu đến đúng tiến trình.

Dùng phép so sánh: địa chỉ IP giống như địa chỉ đường phố, còn số port
giống như số căn hộ tại địa chỉ đó.

## Tổng quan về UDP

UDP là _connectionless_ (không kết nối). Bạn biết TCP nhận mạng
packet-switched và làm nó trông như một kết nối đáng tin cậy giữa hai
máy tính không? UDP không làm vậy.

Bạn gửi một UDP datagram (gói dữ liệu) đến một địa chỉ IP và port. IP
định tuyến nó đến đó và máy tính nhận gửi nó đến chương trình đang bind
vào port đó.

Không có kết nối. Tất cả đều dựa trên từng packet riêng lẻ.

Khi packet đến, receiver có thể biết IP và port nó đến từ đâu. Cách này
receiver có thể gửi phản hồi.

## Tính toàn vẹn dữ liệu (Data Integrity)

Có rất nhiều thứ có thể xảy ra sai. Dữ liệu có thể đến không đúng thứ
tự. Nó có thể bị hỏng. Nó có thể bị trùng lặp. Hoặc có thể không đến
được.

UDP hầu như không có cơ chế nào để xử lý tất cả những trường hợp này.

Thực ra, nó chỉ làm mỗi một thứ: phát hiện lỗi.

### Phát hiện lỗi (Error Detection)

Trước khi sender gửi một segment, một _checksum_ được tính cho packet
đó.

Checksum hoạt động hoàn toàn giống như với TCP, ngoại trừ UDP header
được dùng. So với TCP header, UDP header cực kỳ đơn giản:

``` {.default}
 0      7 8     15 16    23 24    31  
+--------+--------+--------+--------+ 
|     Source      |   Destination   | 
|      Port       |      Port       | 
+--------+--------+--------+--------+ 
|                 |                 | 
|     Length      |    Checksum     | 
+--------+--------+--------+--------+ 
|                                     
|          data octets ...            
+---------------- ...                 
```

Khi receiver nhận packet, nó tính checksum của riêng mình cho packet đó.

Nếu hai checksum khớp nhau, dữ liệu được coi là không có lỗi. Nếu chúng
khác nhau, dữ liệu bị loại bỏ.

Hết. Receiver thậm chí không biết rằng có dữ liệu nào đó nhắm đến mình.
Nó chỉ tan biến vào hư không.

Checksum là một số 16-bit là kết quả của việc đưa toàn bộ dữ liệu UDP
header, payload và các địa chỉ IP liên quan vào một hàm để tóm tắt chúng.

Cái này hoạt động giống như TCP checksum. (Jon Postel đã viết RFC đầu
tiên cho cả TCP và UDP nên không có gì ngạc nhiên khi chúng dùng cùng
thuật toán.)

Chi tiết về cách checksum hoạt động có trong project tuần này. Chỉ cần
thay UDP header vào chỗ TCP header là xong.

## Payload tối đa không bị phân mảnh (Maximum Payload Without Fragmentation)

Hơi sớm một chút, nhưng các tầng thấp hơn có thể quyết định tách một
UDP packet thành các packet nhỏ hơn. Có thể có một phần Internet mà UDP
packet phải đi qua chỉ có thể xử lý dữ liệu kích thước nhất định.

Chúng ta gọi điều này là "fragmentation" (phân mảnh), khi một UDP packet
được chia ra thành nhiều IP packet.

Kích thước packet tối đa có thể gửi trên một đường truyền cụ thể gọi là
MTU (maximum transmission unit --- đơn vị truyền tối đa). MTU nhỏ nhất
có thể trên Internet (IPv4) là 576 bytes. IP header lớn nhất là 60 bytes.
Và UDP header là 8 bytes. Vậy còn lại 576-60-8 = 508 bytes payload mà
bạn có thể đảm bảo sẽ không bị phân mảnh[^Nếu bạn gửi qua VPN, có thể ít
hơn thế, nhưng chúng ta bỏ qua điều đó cho đơn giản.]. Vì IP header đôi
khi nhỏ hơn 60 bytes, nhiều nguồn cho rằng 512 bytes là giới hạn.

Phân mảnh có tệ không? Một số router có thể bỏ UDP packet bị phân mảnh.
Vậy nên giữ dưới MTU tối thiểu thường là ý tưởng hay với UDP.

## Thì dùng UDP để làm gì? (What's the Use?)

Nếu UDP có thể bỏ packet ở khắp nơi, tại sao lại dùng nó?

Thật ra, lợi ích về hiệu suất rất đáng kể, đó là điểm hấp dẫn.

Có một số trường hợp bạn sẽ dùng UDP:

1. Nếu bạn không quan tâm đến việc mất vài packet. Nếu bạn đang truyền
   giọng nói, video hay thậm chí thông tin frame game, có thể ổn khi bỏ
   vài packet. Luồng chỉ bị giật một chút rồi tiếp tục khi các packet
   tiếp theo đến.

   Đây là cách dùng phổ biến nhất. Game nhiều người chơi với tốc độ
   khung hình cao dùng cái này cho các cập nhật frame-by-frame, và cũng
   dùng TCP cho các nhu cầu băng thông thấp hơn như tin nhắn chat và
   thay đổi trang bị của nhân vật.

2. Nếu bạn không thể chấp nhận mất packet, bạn có thể cài đặt một giao
   thức khác trên UDP. TFTP (Trivial File Transfer Protocol --- Giao thức
   truyền file đơn giản) làm điều này. Nó đặt sequence number vào mỗi
   packet và chờ phía kia phản hồi bằng packet TFTP ACK trước khi gửi
   cái tiếp theo. Không nhanh vì sender phải chờ ACK trước khi gửi
   packet tiếp theo, nhưng thực sự đơn giản để cài đặt.

   Đây là cách dùng hiếm hơn. TFTP được dùng bởi các máy tính không có
   đĩa chưa cài OS. Chúng truyền OS qua mạng khi khởi động và cần một
   network stack nhỏ tích hợp sẵn để làm được điều đó. Cài đặt
   Ethernet/IP/UDP stack dễ hơn nhiều so với Ethernet/IP/TCP stack.

3. Bạn muốn ghép kênh (multiplex) các "luồng" dữ liệu khác nhau mà
   không cần nhiều kết nối TCP. Bạn có thể gắn thẻ mỗi UDP packet với
   một identifier để chúng đều vào đúng bucket khi đến nơi.

4. Xử lý sớm là có thể. Có thể bạn có thể bắt đầu xử lý packet 4 dù
   packet 3 chưa đến.

5. Vân vân.

## UDP (Datagram) Sockets

Với UDP socket, có một số điểm khác biệt so với TCP:

* Bạn không còn gọi `listen()`, `connect()`, `accept()`, `send()`, hay
  `recv()` nữa vì không có "kết nối".
* Bạn gọi `sendto()` để gửi dữ liệu UDP.
* Bạn gọi `recvfrom()` để nhận dữ liệu UDP.

### Quy trình Server

Quy trình chung cho một server là tạo socket mới kiểu `SOCK_DGRAM`, đó
là datagram/UDP socket. (Chúng ta đã dùng mặc định `SOCK_STREAM` là TCP
socket.)

Sau đó server gọi `bind()` để bind vào một port. Port này là nơi client
sẽ gửi packet đến.

Sau đó, server có thể vòng lặp nhận dữ liệu và gửi phản hồi.

Khi nhận được dữ liệu, `recvfrom()` sẽ trả về host và port mà dữ liệu
đã được gửi từ đó. Điều này có thể được dùng để trả lời, gửi dữ liệu
ngược lại cho sender.

Đây là một server ví dụ:

``` {.py}
# UDP Server

import sys
import socket

# Parse command line
try:
    port = int(sys.argv[1])
except:
    print("usage: udpserver.py port", file=sys.stderr)
    sys.exit(1)

# Make new UDP (datagram) socket
s = socket.socket(type=socket.SOCK_DGRAM)

# Bind to a port
s.bind(("", port))

# Loop receiving data
while True:
    # Get data
    data, sender = s.recvfrom(4096)
    print(f"Got data from {sender[0]}:{sender[1]}: \"{data.decode()}\"")

    # Send a reply back to the original sender
    s.sendto(f"Got your {len(data)} byte(s) of data!".encode(), sender)
```

### Quy trình Client

Về cơ bản giống quy trình server, ngoại trừ nó sẽ không `bind()` vào
một port cụ thể. Nó để cho hệ điều hành chọn port bind cho mình lần đầu
tiên nó gọi `sendto()`.

Nhớ rằng: UDP không đáng tin cậy, vậy nên có khả năng dữ liệu không đến
nơi! Nếu không đến, thử lại. (Nhưng gần như chắc chắn sẽ đến khi chạy
trên localhost.)

Client ví dụ có thể giao tiếp với server trên:

``` {.py}
# UDP Client

import socket
import sys

# Parse command line
try:
    server = sys.argv[1]
    port = int(sys.argv[2])
    message = sys.argv[3]
except:
    print("usage: udpclient.py server port message", file=sys.stderr)
    sys.exit(1)

# Make new UDP (datagram) socket
s = socket.socket(type=socket.SOCK_DGRAM)

# Send data to the server
print("Sending message...")
s.sendto(message.encode(), (server, port))

# Wait for a reply
data, sender = s.recvfrom(4096)
print(f"Got reply: \"{data.decode()}\"")

s.close()
```

## Reflect (Suy ngẫm)

* TCP cung cấp gì mà UDP không cung cấp về mặt đảm bảo phân phối?

* Tại sao mọi người khuyến nghị giữ UDP packet nhỏ?

* Tại sao UDP header nhỏ hơn nhiều so với TCP header?

* `sendto()` yêu cầu bạn chỉ định IP đích và port. Tại sao hàm `send()`
  hướng TCP không yêu cầu những đối số đó?

* Tại sao người ta lại dùng UDP thay vì TCP nếu nó tương đối không đáng
  tin cậy?
