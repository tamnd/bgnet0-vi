# Network Address Translation (NAT)

Trong chương này ta sẽ xem xét _network address translation_ (dịch địa chỉ mạng),
hay NAT.

Đây là dịch vụ được cung cấp trên router nhằm ẩn một mạng LAN "riêng tư" (private)
khỏi phần còn lại của thế giới.

Router đóng vai trò trung gian, dịch các địa chỉ IP nội bộ thành một địa chỉ IP bên
ngoài duy nhất. Nó giữ một bảng các kết nối này để khi gói tin đến từ bất kỳ interface
nào, router có thể viết lại chúng cho phù hợp.

Ta nói mạng LAN đằng sau router NAT là "mạng riêng tư" (private network), và địa chỉ
IP bên ngoài mà router đại diện cho LAN đó là "IP công khai" (public IP).

## Phép Ẩn Dụ Thư Tín Ốc Sên

Hãy tưởng tượng cách một chương trình thư tín ốc sên ẩn danh có thể hoạt động.

Bạn viết một lá thư gửi đến người nhận với địa chỉ trả lời của bạn trên đó.

Thay vì gửi trực tiếp, bạn đưa thư cho một bên ẩn danh hóa (anonymizer). Bên ẩn
danh hóa lấy thư của bạn ra khỏi phong bì và cho vào một phong bì khác với cùng
người nhận, nhưng thay địa chỉ trả lời bằng địa chỉ của chính bên ẩn danh hóa. Nó
cũng ghi lại rằng người gửi này đã viết thư cho người nhận này.

Người nhận nhận được thư. Tất cả những gì họ thấy là địa chỉ trả lời của bên ẩn
danh hóa trên thư.

Người nhận trả lời thư và gửi phản hồi lại cho bên ẩn danh hóa. Người nhận liệt kê
bản thân là địa chỉ trả lời.

Bên ẩn danh hóa nhận thư và ghi nhận nó đến từ người nhận. Nó tra cứu hồ sơ để xác
định người đã gửi thư ban đầu cho người nhận.

Bên ẩn danh hóa lấy phản hồi ra khỏi phong bì và cho vào một phong bì mới với địa
chỉ đích là người gửi ban đầu, và địa chỉ trả lời vẫn là người nhận ban đầu.

Người gửi ban đầu nhận được phản hồi.

Lưu ý rằng người nhận ban đầu không bao giờ biết địa chỉ của người gửi ban đầu; họ
chỉ biết địa chỉ của bên ẩn danh hóa.

## Tại Sao?

NAT rất, rất phổ biến. Hầu như chắc chắn nó chạy trên mọi mạng LAN IPv4.

Nhưng tại sao?

Có hai lý do chính để dùng loại dịch vụ này.

1. Bạn muốn ẩn chi tiết mạng của mình khỏi phần còn lại của thế giới.

2. Bạn cần nhiều địa chỉ IP hơn (a) những gì ai đó sẵn sàng cấp cho bạn hoặc (b)
   bạn sẵn sàng trả tiền.

### Ẩn Mạng Của Bạn

Không có cách dễ dàng nào để đưa các gói tin ngẫu nhiên, không được yêu cầu vào mạng
riêng tư thông qua gateway đang chạy NAT.

> Bạn có thể làm được với thứ gọi là _source routing_ (định tuyến nguồn), nhưng điều
> đó không được các ISP bật theo mặc định.

Bạn phải có IP riêng tư trên gói tin **và** đưa gói tin đó đến router. Không có cách
nào làm điều này trừ khi bạn đang ở cùng LAN với router, và điều đó thực sự khó xảy
ra.

Về điểm thứ hai, ta nên nói về hiện tượng gọi là _cạn kiệt không gian địa chỉ_
(address space exhaustion).

### Cạn Kiệt IPv4

Thực sự có một số lượng giới hạn địa chỉ IPv4 trên thế giới. Do đó, việc lấy một
khối địa chỉ lớn tốn rất nhiều tiền.

Rẻ hơn nhiều khi chỉ lấy một số ít địa chỉ (ví dụ mạng `/20` hoặc `/24` hoặc `/4`)
rồi có các mạng riêng tư lớn đằng sau router NAT. Bằng cách này bạn có thể có _rất
nhiều_ IP, nhưng tất cả chúng đều thể hiện với thế giới là đến từ IP công khai duy
nhất.

Đây thực sự là động lực đằng sau việc dùng NAT ở khắp nơi. Có một thời điểm chúng ta
thực sự sắp hết địa chỉ IPv4, và NAT đã cứu chúng ta.

## Mạng Riêng Tư (Private Networks)

Có những subnet được dành riêng để dùng làm mạng riêng tư. Router không chuyển tiếp
các địa chỉ này trực tiếp. Nếu một router trên Internet rộng lớn thấy IP từ một trong
các subnet này, nó sẽ loại bỏ.

Với IPv4 có ba subnet như vậy:

* `10.0.0.0/8`
* `172.16.0.0/12`
* `192.168.0.0/16`

Cái cuối cùng rất phổ biến trên các mạng LAN gia đình.

Một lần nữa, các router trên Internet sẽ loại bỏ gói tin với các địa chỉ này. Cách
duy nhất để dữ liệu từ các IP này lên Internet là qua NAT.

## Cách Hoạt Động

Trong demo này, ta dùng ký hiệu `IP:port`. Số sau dấu hai chấm là số port.

Ngoài ra, ta dùng thuật ngữ "Máy Tính Cục Bộ" (Local Computer) để chỉ máy tính trên
LAN, và "Máy Tính Từ Xa" (Remote Computer) hoặc "Server Từ Xa" (Remote Server) để
chỉ máy tính ở xa mà nó đang kết nối đến.

Và cuối cùng, router LAN cục bộ sẽ chỉ được gọi là "The Router" hoặc "NAT Router".

Bắt đầu thôi!

Trên mạng LAN của tôi, tôi muốn đi từ `192.168.1.2:1234` trên mạng LAN riêng tư đến
địa chỉ công khai `203.0.113.24:80` --- đó là port `80`, HTTP server.

Điều đầu tiên máy tính của tôi làm là kiểm tra xem địa chỉ IP đích có nằm trên LAN
của tôi không... Vì LAN của tôi là `192.168.0.0/16` hoặc nhỏ hơn, thì không, nó
không nằm trên LAN.

Vậy máy tính của tôi gửi nó đến default gateway, tức router đã bật NAT.

Router sẽ đóng vai trò "bên ẩn danh hóa" trung gian như trong ví dụ ẩn dụ trước. Và
nhớ rằng router có hai interface --- một mặt hướng vào mạng LAN riêng tư
`192.168.0.0/16`, và cái kia hướng ra Internet rộng lớn với một IP công khai bên
ngoài. Ta dùng `192.168.1.1` là IP riêng tư trên router và `198.51.100.99` là IP
công khai.

Vậy mạng LAN trông như thế này:

``` {.default}
+----------+-------------+
|  Local   |             |
| Computer | 192.168.1.2 |>-------+
+----------+-------------+        |
                                  |
                                  ^
                          +---------------+
                          |  192.168.1.1  |  Internal IP
                          +---------------+
                          |    Router     |  NAT-enabled
                          +---------------+
                          | 198.51.100.99 |  External IP
                          +---------------+
                                  v
                                  |
                                  |
                       {The Greater Internet}
```

Router bây giờ phải "đóng gói lại" dữ liệu cho Internet rộng lớn. Điều này có nghĩa
là viết lại nguồn gói tin thành IP công khai của router và một port chưa dùng trên
interface công khai của router. (Port không cần phải giống với port ban đầu trên gói
tin. Router cấp phát một port ngẫu nhiên chưa dùng khi gói tin mới được gửi ra.)

Vậy router ghi lại tất cả thông tin này:

<!-- CAPTION: NAT router connection record -->

|Computer|IP|Port|Protocol|
|-|-|-|-|
|Local Private Address|192.168.1.2|1234|TCP|
|Remote Public Address|203.0.113.24|80|TCP|
|Router Public Address|198.51.100.99|5678|TCP|

(Lưu ý: ngoại trừ `80` vì ta đang kết nối HTTP trong ví dụ này, tất cả số port đều
được chọn ngẫu nhiên.)

Vậy trong khi gói tin gốc là:

``` {.default}
192.168.1.2:1234 --> 203.0.113.24:80

     Local               Remote
    Computer            Computer
```

NAT router viết lại nó để có cùng đích, nhưng router là nguồn.

``` {.default}
198.51.100.99:5678 --> 203.0.113.24:80

    NAT router             Remote
                          Computer
```

Từ góc nhìn của đích, nó hoàn toàn không biết rằng gói tin này không phải từ router.

Vậy đích trả lời với một số dữ liệu HTTP, gửi lại cho router:

``` {.default}
203.0.113.24:80 --> 198.51.100.99:5678

    Remote              NAT router
   Computer
```

Router sau đó nhìn vào hồ sơ của mình. Nó nói: "Khoan đã --- nếu tôi nhận dữ liệu
trên port `5678`, điều đó có nghĩa là tôi cần dịch cái này trở lại thành IP riêng tư
trên LAN!

Vậy nó dịch tin nhắn để nó không còn được gửi đến router nữa, mà thay vào đó được
gửi đến IP nguồn riêng tư đã ghi lại trước đó:

``` {.default}
203.0.113.24:80 --> 192.168.1.2:1234

    Remote               Local
   Computer             Computer
```

Và gửi nó ra trên LAN. Và nó được nhận! Máy tính LAN nghĩ nó đang nói chuyện với
server từ xa, còn server từ xa nghĩ nó đang nói chuyện với router! NAT!

Có thể hơi khó hiểu ở bước cuối cùng khi gói tin đến từ NAT router nhưng thực ra
được đánh địa chỉ IP như đến từ Máy Tính Từ Xa. Điều này không sao trên LAN vì NAT
router gửi gói tin IP đó ra với địa chỉ Ethernet của Máy Tính Cục Bộ trên LAN. Hay
nói cách khác, NAT router có thể dùng địa chỉ link layer để đưa gói tin đến Máy Tính
Cục Bộ và địa chỉ IP nguồn của gói tin không cần phải khớp với IP Internet của NAT
router.

## NAT và IPv6

Vì IPv6 có _rất nhiều_ địa chỉ, ta có thực sự cần NAT không? Và câu trả lời kỹ thuật
là "không". Một phần lý do IPv6 ra đời là để loại bỏ NAT trung gian phức tạp này.

Tuy nhiên, vẫn có một subnet IPv6 dành riêng cho các mạng riêng tư:

``` {.default}
fd00::/8
```

Có thêm một số cấu trúc trong phần "host" của địa chỉ, nhưng bạn có thể
[đọc về nó trên Wikipedia](https://en.wikipedia.org/wiki/Unique_local_address#Definition)
nếu muốn.

Giống như các subnet riêng tư IPv4, địa chỉ IP từ subnet này bị router trên Internet
rộng lớn loại bỏ.

NAT không hoạt động với IPv6, nhưng có một cách khác để thực hiện dịch bằng
[network prefix translation](https://en.wikipedia.org/wiki/IPv6-to-IPv6_Network_Prefix_Translation).

Còn về việc người ta không thể dễ dàng đưa gói tin không được yêu cầu vào LAN của
bạn thì sao? Thì bạn sẽ phải cấu hình firewall đúng cách để ngăn người khác vào.
Nhưng đó là chuyện kể sau.

## Chuyển Tiếp Cổng (Port Forwarding)

Nếu bạn có server chạy đằng sau NAT router, làm sao nó có thể phục vụ nội dung cho
thế giới bên ngoài? Xét cho cùng, không ai bên ngoài có thể tham chiếu đến nó qua
IP nội bộ --- tất cả những gì họ thấy là IP bên ngoài của router.

Nhưng bạn có thể cấu hình NAT router để làm điều gọi là _port forwarding_ (chuyển
tiếp cổng).

Ví dụ, bạn có thể nói với nó rằng lưu lượng gửi đến port 80 IP công khai của nó nên
được _chuyển tiếp_ (forwarded) đến một IP riêng tư nào đó trên port 80. Router chuyển
tiếp lưu lượng, và người gửi ban đầu không biết rằng lưu lượng của họ cuối cùng đến
một IP riêng tư.

Không có lý do gì phải dùng cùng một port.

Ví dụ, SSH dùng port 22, và điều đó ổn trên máy tính trong mạng riêng tư. Nhưng nếu
bạn chuyển tiếp từ port công khai 22, bạn sẽ thấy các tác nhân độc hại liên tục cố
đăng nhập qua đó. (Vâng, ngay cả trên máy tính của bạn ở nhà.) Vì vậy, phổ biến hơn
là dùng một port không phổ biến khác làm port SSH công khai, rồi chuyển tiếp nó đến
port 22 trên LAN.

## Ôn Tập

* Tra cứu địa chỉ IP nội bộ của máy tính. (Có thể phải tìm trên mạng cách làm điều
  này trên hệ điều hành của bạn.) Sau đó vào [google.com](https://google.com/) và
  gõ "what is my ip". Các số đó (rất có thể) khác nhau. Tại sao?

* NAT giải quyết những vấn đề gì?

