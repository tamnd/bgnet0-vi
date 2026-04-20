# Tổng quan về Mạng

Ý tưởng lớn của mạng là chúng ta sẽ trao đổi các byte dữ liệu tùy ý
giữa hai (hoặc nhiều) máy tính trên Internet hoặc LAN.

Vậy ta cần:

* Một cách nhận diện máy tính nguồn và đích.
* Một cách duy trì tính toàn vẹn dữ liệu.
* Một cách định tuyến dữ liệu từ máy tính này sang máy tính khác
  (trong số hàng tỷ chiếc).

Và cần toàn bộ hỗ trợ phần cứng và phần mềm để làm được chuyện này.

Hãy xem qua hai loại mạng truyền thông cơ bản.

## Chuyển mạch (Circuit Switched)

Đừng hoảng! Internet không dùng loại mạng này (ít nhất là không biết
về nó). Nên bạn có thể đọc phần còn lại của mục này với sự tự tin
rằng bạn sẽ không cần dùng đến nó nữa.

Để hiểu loại mạng này, hãy hình dung một tổng đài điện thoại kiểu
cũ (tức là một người thật ngồi điều khiển). Hồi trước khi bạn có thể
quay số trực tiếp, một cuộc gọi diễn ra kiểu như thế này:

Bạn nhấc ống nghe và quay tay cần trên máy để tạo tín hiệu điện gọi
một cái chuông ở đầu dây kia, tức là trong một tổng đài điện thoại
nào đó.

Tổng đài nghe chuông và nhấc đầu dây kia, nói một câu gì đó phù hợp
kiểu như, "Tổng đài nghe."

Và bạn nói (bằng giọng) cho tổng đài biết bạn muốn kết nối đến số
nào.

Rồi tổng đài cắm dây jumper vào bảng mạch trước mặt để hoàn tất kết
nối điện vật lý giữa máy bạn và máy của người bạn muốn gọi. Bạn có
một đường dây thẳng từ máy của bạn đến máy của họ.

Cách này mở rộng rất kém. Và nếu bạn cần gọi đường dài, chi phí sẽ
cao hơn, vì tổng đài phải liên hệ với tổng đài khác qua một số hữu
hạn đường dây đường dài.

Cuối cùng, người ta nhận ra họ có thể thay thế các tổng đài người
bằng các relay và switch điện cơ mà bạn có thể điều khiển bằng cách
gửi các tín hiệu được mã hóa cẩn thận xuống đường dây, dưới dạng xung
điện (gửi bởi điện thoại quay số cũ) hoặc các âm thanh "touch"
còn được nhận ra đến ngày nay.

Nhưng ta vẫn còn vấn đề:

* Cần một mạch chuyên dụng cho mỗi cuộc gọi.
* Dù bạn ngồi im không nói gì, mạch vẫn bị chiếm và không ai khác
  dùng được.
* Nhiều người không thể dùng cùng một đường dây cùng lúc.
* Số lượng dây dẫn bạn có thể kéo là có hạn.

Vậy nên Internet chọn một hướng tiếp cận khác.

## Chuyển gói (Packet Switched)

Trong mạng _chuyển gói_ (packet switched), dữ liệu bạn muốn gửi
được chia thành các gói (packet) riêng lẻ với số byte khác nhau. Nếu
muốn gửi 83.234 byte dữ liệu, nó có thể bị chia thành 50 hoặc 60
gói.

Sau đó mỗi gói này được gửi riêng lẻ qua các đường dây khi có chỗ
trống.

Hãy hình dung các gói dữ liệu nhỏ từ máy tính khắp Bắc Mỹ đổ vào một
router ở bờ Đại Tây Dương, router này gửi chúng, từng cái một, qua
một cáp biển dài hàng nghìn dặm sang châu Âu.

Khi các gói đến máy đích, máy đó tái tạo dữ liệu từ các gói riêng lẻ.

Điều này tương tự như viết một lá thư gửi bưu điện và bỏ vào hộp thư.
Nó kết thúc trên xe tải cùng với hàng đống thư khác không đi đến cùng
chỗ với thư của bạn.

Bưu điện định tuyến thư qua các cơ sở bưu chính phù hợp cho đến khi
chúng đến nơi.

Có lẽ thư của bạn lên máy bay đến phía bên kia đất nước cùng nhiều
thư khác. Và khi máy bay đến nơi, những lá thư đó có thể phân nhánh,
một số đi về hướng Bắc, một số đi về hướng Nam.

Họ không dùng nguyên một chiếc máy bay cho một lá thư---các thư giống
như gói, và chúng được chuyển từ phương tiện vận chuyển này sang
phương tiện khác.

Tương tự, các gói dữ liệu trên Internet sẽ di chuyển từ máy tính này
sang máy tính khác, chia sẻ đường truyền với lưu lượng khác, cho đến
khi chúng đến đúng chỗ.

Và điều này mang lại một số lợi thế tuyệt vời trong mạng máy tính:

* Không cần mạch chuyên dụng giữa mọi cặp máy tính giao tiếp (điều
  này có lẽ là bất khả thi về mặt vật lý nếu muốn hỗ trợ lượng lưu
  lượng hiện có ngày nay).

* Nhiều máy tính có thể dùng cùng một đường dây để gửi dữ liệu
  "đồng thời". (Các gói thực ra đi lần lượt, nhưng chúng xen kẽ nhau
  nên trông có vẻ đồng thời.)

* Đường dây có thể được sử dụng hết công suất; không có "không khí
  chết" bị lãng phí nếu ai đó muốn dùng nó. Sự im lặng của một máy
  tính là cơ hội của máy tính khác để truyền trên cùng đường dây.

## Kiến trúc Client/Server

Bạn đã biết điều này từ khi dùng web---bạn đã nghe đến web server.

_Server_ (máy chủ) là chương trình _lắng nghe_ các kết nối đến,
_chấp nhận_ chúng, rồi thông thường nhận yêu cầu từ _client_ (máy
khách) và gửi lại phản hồi cho client.

Các cuộc trao đổi thực tế giữa server và client có thể phức tạp hơn
nhiều tùy thuộc vào việc server làm gì.

Nhưng cả client lẫn server đều là các chương trình mạng. Sự khác biệt
thực tế là server là chương trình ngồi chờ client gọi đến.

Thông thường một server phục vụ nhiều client. Nhiều server có thể tồn
tại trong một _server farm_ (trang trại server) để phục vụ rất, rất,
rất nhiều client. Hãy nghĩ xem có bao nhiêu người dùng Google cùng
lúc.

## OS, Lập trình Mạng và Sockets

Mạng là phần cứng, và OS kiểm soát mọi truy cập vào phần cứng. Vậy
nếu muốn viết phần mềm dùng mạng, bạn phải làm qua OS.

Trong lịch sử, và đến tận ngày nay, điều này được thực hiện bằng
một API gọi là _sockets_ API, tiên phong trên Unix.

Sockets API của Unix rất đa năng, nhưng một trong nhiều thứ nó có
thể làm là cho bạn cách đọc và ghi dữ liệu qua Internet.

Các ngôn ngữ và hệ điều hành khác đã thêm chức năng Internet tương
tự theo thời gian, và nhiều trong số chúng dùng các lệnh gọi khác
trong API. Nhưng như một lời tri ân tới bản gốc, nhiều API này vẫn
được gọi là "sockets" API dù không khớp với bản gốc.

Nếu muốn dùng sockets API gốc, bạn có thể lập trình bằng C trên Unix.

## Protocol (Giao thức)

Bạn biết cuộc trò chuyện giữa client và server đó không? Người ta viết
rất cụ thể những byte nào được gửi khi nào và từ ai đến ai. Bạn không
thể gửi bất kỳ dữ liệu nào đến web server---nó phải được đóng gói
theo một cách nhất định.

Giống như bạn không thể lấy một lá thư, bọc nó trong giấy nhôm không
có địa chỉ, và kỳ vọng bưu điện giao đến người nhận mình muốn. Đó là
vi phạm _giao thức_ của bưu điện.

Cả người gửi và người nhận phải nói cùng một giao thức thì giao tiếp
mới đúng.

> "Cảm ơn đã gọi đến Nhà hàng Pizza. Tôi có thể giúp gì không?"
> "Bạn có muốn thêm khoai tây chiên không?"
>
> Một người gọi đến nhà hàng pizza bị vi phạm giao thức.

Có rất nhiều giao thức, và chúng ta sẽ đề cập chi tiết một vài cái
sau. Chúng được phát minh bởi con người để giải quyết các loại vấn
đề khác nhau. Nếu bạn cần truyền dữ liệu giữa hai chương trình
chuyên dụng bạn viết, bạn cũng phải định nghĩa một giao thức cho
việc đó!

Dưới đây là một số giao thức phổ biến bạn có thể đã nghe đến:

* TCP - dùng để truyền dữ liệu đáng tin cậy.
* UDP - dùng để truyền dữ liệu nhanh và không đáng tin cậy.
* IP - dùng để định tuyến gói từ máy tính này sang máy tính khác
  trên mạng.
* HTTP - dùng để lấy trang web và thực hiện các yêu cầu web khác.
* Ethernet - dùng để gửi dữ liệu qua LAN.

Như chúng ta sẽ thấy sau, các giao thức này "sống" ở các tầng khác
nhau của phần mềm mạng.

## Các Tầng Mạng và Abstraction

Dưới đây là tổng quan nhanh về những gì xảy ra khi dữ liệu đi ra
mạng. Chúng ta sẽ đề cập chi tiết hơn nhiều trong các chương tiếp.

1. Một chương trình người dùng nói, "Tôi muốn gửi các byte 'GET /
   HTTP/1.1' đến web server kia." (Server được xác định bằng _địa chỉ
   IP_ và một _port_ trên Internet---sẽ nói thêm về sau.)

2. OS lấy dữ liệu và bọc nó trong một _header_ (tức là thêm dữ liệu
   vào đầu) cung cấp thông tin phát hiện lỗi (và có thể là thứ tự).
   Cấu trúc chính xác của header này được định nghĩa bởi một giao thức
   như TCP hoặc UDP.

3. OS lấy tất cả _điều đó_, và bọc nó trong một header khác giúp định
   tuyến. Header này được định nghĩa bởi giao thức IP.

4. OS chuyển toàn bộ dữ liệu đó cho card giao diện mạng (_NIC_---
   miếng phần cứng chịu trách nhiệm về mạng).

5. NIC bọc toàn bộ _dữ liệu đó_ vào một header khác được định nghĩa
   bởi một giao thức như Ethernet giúp phân phối trên LAN.

6. NIC gửi toàn bộ dữ liệu đã được bọc nhiều lớp ra qua dây, hoặc
   qua không khí (với WiFi).

Khi máy tính nhận được gói, quá trình ngược lại xảy ra. NIC bóc
header Ethernet, OS kiểm tra địa chỉ IP có đúng không, tìm ra chương
trình nào đang lắng nghe trên port đó, và gửi dữ liệu đã bóc hết vỏ.

Tất cả các tầng khác nhau làm tất cả việc bọc này được gọi chung là
_protocol stack_ (ngăn xếp giao thức). (Đây là cách dùng khác của từ
"stack" so với kiểu dữ liệu trừu tượng stack.)

Điều này hoạt động tốt vì mỗi tầng chịu trách nhiệm về các phần khác
nhau của quy trình, ví dụ một tầng xử lý tính toàn vẹn dữ liệu, tầng
khác xử lý định tuyến gói qua mạng, và tầng khác xử lý dữ liệu thực
sự được truyền giữa các chương trình. Và mỗi tầng không quan tâm đến
những gì các tầng bên dưới đang làm với dữ liệu.

Chính khái niệm cuối đó mới thực sự quan trọng: khi dữ liệu đi qua
WiFi, phần cứng WiFi thậm chí không quan tâm dữ liệu là gì, có phải
dữ liệu Internet không, tính toàn vẹn được đảm bảo (hoặc không) thế
nào. WiFi chỉ quan tâm đến việc truyền một khối dữ liệu lớn qua
không khí đến máy tính khác. Khi đến máy tính kia, máy đó sẽ bóc
phần Ethernet và nhìn sâu hơn vào gói, quyết định làm gì với nó.

Và vì các tầng không quan tâm dữ liệu nào được đóng gói bên dưới,
bạn có thể hoán đổi các giao thức ở các tầng khác nhau và vẫn để phần
còn lại hoạt động. Vậy nếu bạn đang viết chương trình ở tầng trên
cùng (nơi chúng ta thường viết nhiều nhất), bạn không cần quan tâm
chuyện gì đang xảy ra ở các tầng phía dưới. Đó là Vấn đề của Người
Khác.

Ví dụ, bạn có thể đang lấy trang web với HTTP/TCP/IP/Ethernet, hoặc
đang truyền tập tin đến máy tính khác với TFTP/UDP/IP/Ethernet. IP và
Ethernet đều hoạt động tốt trong cả hai trường hợp, vì chúng thờ ơ
với dữ liệu chúng đang gửi.

Có rất nhiều chi tiết bị bỏ qua trong mô tả này, nhưng chúng ta vẫn
đang ở vùng tổng quan cấp cao.

## Có dây so với Không dây

Khi nói về LAN, chúng ta có thể coi lập trình mạng như thể hai thứ
này là giống nhau:

* Các máy tính trên LAN kết nối bằng cáp Ethernet vật lý[1].
* Các máy tính trên LAN đều kết nối đến cùng một điểm truy cập WiFi.

Hóa ra cả hai đều dùng giao thức Ethernet để giao tiếp cấp thấp.

Vậy khi chúng ta nói các máy tính ở cùng LAN, chúng ta có nghĩa là
chúng được kết nối có dây hoặc đang dùng cùng một điểm truy cập WiFi.

[1] Gọi chúng là "cáp Ethernet" hơi không chính xác vì chúng chỉ là
dây, và Ethernet là giao thức định nghĩa hiệu quả các mẫu điện đi qua
những dây đó. Nhưng ý tôi là, "một cáp thường được dùng với Ethernet".

## Ôn lại

* Internet là chuyển mạch hay chuyển gói?

* Mối quan hệ giữa chương trình client và chương trình server là gì?

* OS đóng vai trò gì khi bạn đang viết các chương trình mạng?

* Giao thức là gì?

* Lý do nào để có protocol stack và đóng gói dữ liệu?

* Sự khác biệt thực tế giữa mạng WiFi và mạng có dây là gì?
