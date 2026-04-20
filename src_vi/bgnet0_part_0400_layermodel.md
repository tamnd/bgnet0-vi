# Mô Hình Mạng Phân Lớp

Trước khi bắt đầu, đây là một số thuật ngữ cần biết:

* **IP Address** (địa chỉ IP) -- theo lịch sử là một số 4-byte xác định duy nhất máy tính của bạn trên Internet. Viết theo ký hiệu chấm-và-số, như sau: `198.51.100.99`.

  Đây là các địa chỉ IP phiên bản 4 ("IPv4"). Thông thường "v4" được ngầm hiểu khi không có định danh phiên bản nào khác.

* **Port** (cổng) -- Các chương trình giao tiếp qua port, được đánh số 0-65535 và liên kết với giao thức TCP hoặc UDP.

  Vì nhiều chương trình có thể chạy trên cùng một địa chỉ IP, port cung cấp cách xác định duy nhất những chương trình đó trên mạng.

  Ví dụ, rất phổ biến là một web server lắng nghe các kết nối đến trên port 80.

  Công khai số port thực sự quan trọng với các chương trình server vì các chương trình client cần biết nơi để kết nối đến chúng.

  Client thường để OS chọn một port chưa dùng vì không ai cố kết nối đến client.

  Trong một URL, số port đứng sau dấu hai chấm. Ở đây ta thử kết nối đến `example.com` trên port `3490`: `http://example.com:3490/foo.html`

  Port dưới 1024 cần quyền root/administrator để bind vào (nhưng không cần để kết nối đến).

* **TCP** -- Transmission Control Protocol (Giao thức Kiểm soát Truyền tải), chịu trách nhiệm truyền dữ liệu đáng tin cậy và theo thứ tự. Nhìn từ góc độ cao hơn, nó làm cho một mạng chuyển mạch gói (packet-switched) cảm giác giống như mạng chuyển mạch kênh (circuit-switched) hơn.

  TCP dùng số port để xác định bên gửi và bên nhận dữ liệu.

  Giao thức này được phát minh vào năm 1974 và vẫn đang được sử dụng rất nhiều ngày nay.

  Trong sockets API, TCP socket được gọi là _stream socket_ (socket luồng).

* **UDP** -- anh em của TCP, nhưng nhẹ hơn. Không đảm bảo dữ liệu sẽ đến nơi, không đảm bảo thứ tự, không đảm bảo không bị trùng lặp. Nếu đến được, nó sẽ không bị lỗi, nhưng đó là tất cả những gì bạn nhận được.

  Trong sockets API, UDP socket được gọi là _datagram socket_ (socket gói tin).

* **IPv6 Address** (địa chỉ IPv6) -- Bốn byte không đủ để chứa một địa chỉ duy nhất, nên IP phiên bản 6 mở rộng kích thước địa chỉ đáng kể lên 16 byte. Địa chỉ IPv6 trông như thế này: `::1` hoặc `2001:db8::8a2e:370:7334`, hoặc thậm chí dài hơn.

* **NAT** -- Network Address Translation (Dịch địa chỉ mạng). Một cách cho phép các tổ chức có mạng con riêng tư với các địa chỉ không duy nhất toàn cầu được dịch sang các địa chỉ duy nhất toàn cầu khi chúng đi qua router.

  Mạng con riêng tư thường bắt đầu với địa chỉ `192.168.x.x` hoặc `10.x.x.x`.

* **Router** -- Một máy tính chuyên dụng chuyển tiếp các gói tin qua mạng chuyển mạch gói. Nó kiểm tra địa chỉ IP đích để xác định tuyến đường nào sẽ đưa gói tin đến gần đích hơn.

* **IP** -- Internet Protocol (Giao thức Internet). Chịu trách nhiệm xác định máy tính bằng địa chỉ IP và dùng những địa chỉ đó để định tuyến dữ liệu đến người nhận qua nhiều router khác nhau.

* **LAN** -- Local Area Network (Mạng cục bộ). Một mạng trong đó tất cả máy tính về cơ bản được kết nối trực tiếp với nhau, không qua router.

* **Interface** (giao diện mạng) -- phần cứng mạng vật lý trên máy tính. Một máy tính có thể có nhiều interface. Máy tính của bạn có thể có hai: một interface Ethernet có dây và một interface Ethernet không dây.

  Router có thể có nhiều interface để có thể định tuyến gói tin đến nhiều đích khác nhau. Router tại nhà bạn có lẽ chỉ có hai interface: một hướng vào LAN của bạn và cái kia hướng ra phần còn lại của Internet.

  Mỗi interface thường có một địa chỉ IP và một địa chỉ MAC.

  OS đặt tên các interface trên máy cục bộ của bạn. Chúng có thể là những tên như `wlan0` hoặc `eth2` hay gì đó khác. Tùy thuộc vào phần cứng và hệ điều hành.

* **Header** (tiêu đề) -- Một số dữ liệu được thêm vào trước dữ liệu khác bởi một giao thức cụ thể. Header chứa thông tin phù hợp với giao thức đó. Một TCP header sẽ bao gồm một số thông tin phát hiện và sửa lỗi cùng số port nguồn và đích. IP sẽ bao gồm địa chỉ IP nguồn và đích. Ethernet sẽ bao gồm địa chỉ MAC nguồn và đích. Và một HTTP response sẽ bao gồm những thứ như độ dài dữ liệu, ngày sửa đổi, và liệu request có thành công không.

  Đặt header trước dữ liệu tương tự như đặt thư vào phong bì trong phép ẩn dụ thư tay. Hoặc đặt phong bì đó vào trong một phong bì khác.

  Khi dữ liệu di chuyển qua mạng, các header bổ sung được thêm vào và loại bỏ. Thông thường chỉ header ngoài cùng (trên cùng?) được loại bỏ hoặc thêm vào trong vận hành bình thường, như một stack. (Nhưng một số phần mềm và phần cứng nhìn sâu hơn.)

  **Network Adapter** (card mạng) -- Tên khác của "network card" (card mạng), phần cứng trên máy tính của bạn thực hiện việc mạng.

  **MAC Address** (địa chỉ MAC) -- Các interface Ethernet có địa chỉ MAC, có dạng `aa:bb:cc:dd:ee:ff`, trong đó các trường là các số hex một byte ngẫu nhiên. Địa chỉ MAC dài 6 byte và phải là duy nhất trên LAN. Khi một card mạng được sản xuất, nó được gán một địa chỉ MAC duy nhất mà nó giữ suốt đời, thường là vậy.

## Mô Hình Mạng Phân Lớp

Khi bạn gửi dữ liệu qua Internet, dữ liệu đó được _đóng gói_ (encapsulated) trong các lớp giao thức khác nhau.

Các lớp của mô hình mạng phân lớp khái niệm tương ứng với các lớp giao thức khác nhau.

Và những giao thức đó chịu trách nhiệm cho những thứ khác nhau, ví dụ: mô tả dữ liệu, bảo toàn tính toàn vẹn dữ liệu, định tuyến, phân phối cục bộ, v.v.

Vì vậy nó hơi giống bài toán con gà và quả trứng, vì ta không thực sự thảo luận được cái này mà không đề cập đến cái kia.

Tốt nhất là cứ nhảy vào luôn và nhìn vào các giao thức đang thêm header lên trên dữ liệu.

## Một Ví Dụ Về Phân Lớp Giao Thức Trên Dữ Liệu

Hãy xem điều gì xảy ra với một HTTP request.

1. Web browser xây dựng HTTP request trông như thế này:

   ``` {.default}
   GET / HTTP/1.1
   Host: example.com
   Connection: close

   ```

   Và đó là tất cả những gì browser quan tâm. Nó không quan tâm đến định tuyến IP hay tính toàn vẹn dữ liệu TCP hay Ethernet.

   Nó chỉ nói "Gửi dữ liệu này đến máy tính đó trên port 80".

2. OS tiếp quản và nói, "OK, bạn yêu cầu tôi gửi cái này qua socket hướng luồng, và tôi sẽ dùng giao thức TCP để làm điều đó và đảm bảo tất cả dữ liệu đến nguyên vẹn và theo thứ tự."

   Vì vậy OS lấy dữ liệu HTTP và bọc nó trong một TCP header bao gồm số port.

3. Và rồi OS nói, "Và bạn muốn gửi nó đến máy tính từ xa này có địa chỉ IP là 198.51.100.2, vậy ta sẽ dùng giao thức IP để làm điều đó."

   Và nó lấy toàn bộ dữ liệu TCP-HTTP và bọc nó lên trong một IP header. Vậy bây giờ chúng ta có dữ liệu trông như thế này: IP-TCP-HTTP.

4. Sau đó, OS nhìn vào bảng định tuyến (routing table) của nó và quyết định gửi dữ liệu đến đâu tiếp theo. Có thể web server ở trên LAN thì tiện lắm. Nhiều khả năng hơn là nó ở đâu đó khác, nên dữ liệu sẽ được gửi đến router của nhà bạn hướng đến Internet rộng lớn hơn.

   Trong cả hai trường hợp, nó sẽ gửi dữ liệu đến một server trên LAN, hoặc đến router ra ngoài của bạn, cũng trên LAN. Vậy nên nó đang đến một máy tính trên LAN.

   Và các máy tính trên LAN có địa chỉ Ethernet (hay còn gọi là _MAC address_ --- viết tắt của "Media Access Control"), vì vậy OS gửi tra cứu địa chỉ MAC tương ứng với địa chỉ IP đích tiếp theo, dù đó là web server cục bộ hay router ra ngoài. (Điều này xảy ra qua tra cứu trong thứ gọi là _ARP Cache_, nhưng ta sẽ đến phần đó của câu chuyện sau.)

   Và nó bọc toàn bộ gói IP-TCP-HTTP trong một Ethernet header, nên nó trở thành Ethernet-IP-TCP-HTTP. HTTP request vẫn còn đó, bị chôn vùi dưới các lớp giao thức!

5. Và cuối cùng, dữ liệu đi ra trên dây (dù là WiFi, ta vẫn nói "trên dây").

Máy tính có địa chỉ MAC đích, đang lắng nghe cẩn thận, thấy gói Ethernet trên dây và đọc nó vào. (Các gói Ethernet được gọi là _Ethernet frames_ --- khung Ethernet.)

Nó lột bỏ Ethernet header, để lộ IP header bên dưới. Nó nhìn vào địa chỉ IP đích.

1. Nếu máy tính đang kiểm tra là một server và có địa chỉ IP đó, OS của nó lột bỏ IP header và nhìn sâu hơn. (Nếu nó không có địa chỉ IP đó, có gì đó không ổn và nó loại bỏ gói tin.)

2. Nó nhìn vào TCP header và thực hiện tất cả những phép thuật TCP cần thiết để đảm bảo dữ liệu không bị hỏng. Nếu bị hỏng, nó trả lời lại với các thần chú TCP, nói "Này, tôi cần bạn gửi lại dữ liệu đó, xin vui lòng."

   Lưu ý rằng web browser hay server không bao giờ biết về cuộc trò chuyện TCP đang xảy ra này. Tất cả là ở đằng sau hậu trường. Với tất cả những gì chúng có thể thấy, dữ liệu chỉ kỳ diệu đến nguyên vẹn và theo thứ tự.

   Lý do là chúng đang ở một lớp cao hơn của mạng. Chúng không cần lo về định tuyến hay bất cứ thứ gì. Các lớp thấp hơn lo việc đó.

3. Nếu mọi thứ đều ổn với TCP, header đó bị lột và OS còn lại với dữ liệu HTTP. Nó đánh thức tiến trình (web server) đang chờ đọc nó, và đưa cho nó dữ liệu HTTP.

Nhưng nếu địa chỉ Ethernet đích là một router trung gian thì sao?

1. Router lột bỏ Ethernet frame như thường lệ.

2. Router nhìn vào địa chỉ IP đích. Nó tham khảo bảng định tuyến của mình và quyết định chuyển tiếp gói tin đến interface nào.

3. Nó gửi ra interface đó, cái đó bọc nó trong một Ethernet frame khác và gửi đến router tiếp theo trong hàng.

   (Hoặc có thể nó không phải Ethernet! Ethernet là một giao thức, và có các giao thức cấp thấp khác đang được dùng với đường cáp quang và các thứ khác. Đây là một phần vẻ đẹp của các lớp trừu tượng này --- bạn có thể chuyển đổi giao thức giữa chừng trong quá trình truyền và dữ liệu HTTP phía trên nó hoàn toàn không biết chuyện đó đã xảy ra.)

## Mô Hình Internet Phân Lớp

Hãy bắt đầu với mô hình dễ hơn chia việc truyền này thành các lớp khác nhau từ trên xuống. (Lưu ý rằng danh sách các giao thức không phải là đầy đủ.)

<!-- CAPTION: Internet Layered Network Model -->
|    Layer    | Responsibility                                  | Example Protocols                             |
|:-----------:|-------------------------------------------------|-----------------------------------------------|
| Application | Structured application data                     | HTTP, FTP, TFTP, Telnet, SSH, SMTP, POP, IMAP |
|  Transport  | Data Integrity, packet splitting and reassembly | TCP, UDP                                      |
|  Internet   | Routing                                         | IP, IPv6, ICMP                                |
|    Link     | Physical, signals on wires                      | Ethernet, PPP, token ring                     |

Bạn có thể thấy cách các giao thức khác nhau đảm nhận trách nhiệm của từng lớp trong mô hình.

Một cách khác để nghĩ về điều này là tất cả các chương trình triển khai HTTP hoặc FTP hoặc SMTP đều có thể dùng TCP hoặc UDP để truyền dữ liệu. (Thông thường tất cả các chương trình socket và ứng dụng bạn viết triển khai bất kỳ giao thức nào đều sẽ nằm ở lớp application.)

Và tất cả dữ liệu được truyền bằng TCP hoặc UDP đều có thể dùng IP hoặc IPv6 để định tuyến.

Và tất cả dữ liệu dùng IP hoặc IPv6 để định tuyến đều có thể dùng Ethernet hoặc PPP, v.v. để đi qua dây.

Và khi một gói tin di chuyển xuống qua các lớp trước khi được truyền qua dây, các giao thức thêm header của riêng chúng lên trên tất cả mọi thứ cho đến nay.

Mô hình này đủ phức tạp để làm việc trên Internet. Bạn biết người ta hay nói: đơn giản nhất có thể, nhưng không đơn giản hơn nữa.

Nhưng có thể có các mạng khác trong Vũ trụ không phải Internet, vì vậy có một mô hình tổng quát hơn mà mọi người đôi khi dùng: mô hình OSI.

## Mô Hình Lớp Mạng ISO OSI

Điều này quan trọng cần biết nếu bạn đang thi chứng chỉ hoặc nếu bạn đang bước vào lĩnh vực này nhiều hơn một lập trình viên thông thường.

Mô hình Internet là một trường hợp đặc biệt của mô hình chi tiết hơn này gọi là mô hình ISO OSI. (Thêm điểm vì là palindrome.) Đó là mô hình Kết nối Hệ thống Mở (Open Systems Interconnect) của Tổ chức Tiêu chuẩn Quốc tế (International Organization for Standardization). Tôi biết rằng "ISO" không phải là viết tắt trực tiếp tiếng Anh của "International Organization for Standardization", nhưng tôi không có đủ ảnh hưởng chính trị toàn cầu để thay đổi điều đó.

Quay lại thực tế, mô hình OSI giống như mô hình Internet nhưng chi tiết hơn.

Mô hình Internet ánh xạ sang mô hình OSI, như vậy, với một lớp đơn của mô hình Internet ánh xạ sang nhiều lớp của mô hình OSI:

<!-- CAPTION: OSI to Internet Layer Mapping -->
| ISO OSI Layer | Internet Layer |
|:-------------:|:--------------:|
|  Application  |  Application   |
| Presentation  |  Application   |
|    Session    |  Application   |
|   Transport   |   Transport    |
|    Network    |    Network     |
|   Data link   |      Link      |
|   Physical    |      Link      |

Và nếu ta nhìn vào mô hình OSI, ta có thể thấy một số giao thức tồn tại ở các lớp khác nhau đó, tương tự với những gì ta thấy với mô hình Internet ở trên.

<!-- CAPTION: ISO OSI Network Layer Model -->
| ISO OSI Layer | Responsibility                                                 | Example Protocols                        |
|:-------------:|----------------------------------------------------------------|------------------------------------------|
|  Application  | Structured application data                                    | HTTP, FTP, TFTP, Telnet, SMTP, POP, IMAP |
| Presentation  | Encoding translation, encryption, compression                  | MIME, SSL/TLS, XDR                       |
|    Session    | Suspending, terminating, restarting sessions between computers | Sockets, TCP                             |
|   Transport   | Data integrity, packet splitting and reassembly                | TCP, UDP                                 |
|    Network    | Routing                                                        | IP IPv6, ICMP                            |
|   Data link   | Encapsulation into frames                                      | Ethernet, PPP, SLIP                      |
|   Physical    | Physical, signals on wires                                     | Ethernet physical layer, DSL, ISDN       |

Chúng ta sẽ gắn bó với mô hình Internet cho khóa học này vì nó đủ tốt cho 99,9% công việc lập trình mạng bạn có thể sẽ làm. Nhưng hãy lưu ý về mô hình OSI nếu bạn đang chuẩn bị phỏng vấn cho một vị trí lập trình đặc thù về mạng.

## Reflect

* Khi một router thấy một địa chỉ IP, nó biết cần chuyển tiếp đến đâu như thế nào?

* Nếu một địa chỉ IPv4 là 4 byte, khoảng bao nhiêu máy tính khác nhau mà nó có thể đại diện tổng cộng, giả sử mỗi máy tính có địa chỉ IP duy nhất?

* Câu hỏi tương tự, nhưng cho IPv6 và địa chỉ 16-byte của nó?

* Câu hỏi thêm cho những người mê thống kê: Xác suất trúng jackpot xổ số super lotto là khoảng 300 triệu trên 1. Xác suất để chọn ngẫu nhiên đúng số 16-byte (128-bit) mà tôi đã chọn trước là bao nhiêu?

* Hãy suy đoán tại sao IP header bọc TCP header trong mô hình phân lớp, chứ không phải ngược lại.

* Nếu UDP không đáng tin cậy và TCP đáng tin cậy, hãy suy đoán tại sao người ta có thể dùng UDP.
