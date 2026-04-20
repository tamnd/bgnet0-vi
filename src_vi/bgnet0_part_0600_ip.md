# Giao Thức Internet (IP)

Giao thức này chịu trách nhiệm định tuyến các gói dữ liệu quanh Internet, tương tự như cách bưu điện chịu trách nhiệm định tuyến thư qua mạng thư tín.

Giống như với bưu điện, dữ liệu trên Internet phải được dán nhãn với địa chỉ nguồn và đích, gọi là _địa chỉ IP_ (IP address).

Địa chỉ IP là một chuỗi byte xác định duy nhất mọi máy tính trên Internet.

## Thuật Ngữ

* **Host** --- tên gọi khác của "máy tính".

## Hai Phiên Bản Phổ Biến

Có hai phiên bản IP thường dùng: phiên bản 4 và phiên bản 6.

IP phiên bản 4 được gọi là "IPv4" hoặc đơn giản là "IP".

IP phiên bản 6 thường được chỉ định rõ ràng là "IPv6".

Bạn có thể phân biệt hai loại bằng cách nhìn nhanh vào một địa chỉ IP:

* Ví dụ địa chỉ IP phiên bản 4: 192.168.1.3

* Ví dụ địa chỉ IP phiên bản 6: fe80::c2b6:f9ff:fe7e:4b4

Sự khác biệt chính là số byte tạo nên không gian địa chỉ. IPv4 dùng 4 byte mỗi địa chỉ, và IPv6 dùng 16 byte.

## Subnet (Mạng Con)

Mỗi địa chỉ IP được chia thành hai phần.

Các bit đầu của địa chỉ IP xác định các mạng riêng lẻ.

Các bit cuối của địa chỉ IP xác định các host riêng lẻ (tức là các máy tính) trên mạng đó.

Các mạng riêng lẻ này được gọi là _subnet_ (mạng con) và số host chúng có thể hỗ trợ phụ thuộc vào có bao nhiêu bit được dành cho việc xác định host trên subnet đó.

Như một ví dụ giả định không phải Internet, hãy xem một "địa chỉ" 8-bit, và ta nói 6 bit đầu là số mạng và 2 bit cuối là số host.

Vậy một địa chỉ như thế này:

``` {.default}
00010111
```

được chia thành hai phần (vì ta nói 6 bit đầu là số mạng):

``` {.default}
Network  Host
-------  ----
000101   11
```

Vậy đây là mạng 5 (`101` nhị phân), host 3 (`11` nhị phân).

Phần mạng luôn đứng trước phần host.

Lưu ý rằng nếu chỉ có hai bit "host", chỉ có thể có 4 host trên mạng, được đánh số 0, 1, 2 và 3 (hoặc `00`, `01`, `10` và `11` nhị phân).

Và với IP, thực ra chỉ có hai host, vì các host có tất cả bit bằng không hoặc tất cả bit bằng một đều được dành riêng.

Các chương tiếp theo sẽ xem xét các ví dụ subnet cụ thể cho IPv4 và IPv6. Điều quan trọng bây giờ là mỗi địa chỉ được chia thành phần mạng và phần host, với phần mạng đứng trước.

## Các Giao Thức Bổ Sung Tầng IP

Có một số giao thức liên quan cũng hoạt động cùng với IP và ở cùng lớp trong network stack.

* **ICMP**: Internet Control Message Protocol (Giao thức Thông điệp Kiểm soát Internet), một cơ chế cho phép các IP node giao tiếp về metadata kiểm soát IP với nhau.

* **IPSec**: Internet Protocol Security (Bảo mật Giao thức Internet), chức năng mã hóa và xác thực. Thường dùng với VPN (Virtual Private Networks --- Mạng riêng ảo).

Người dùng thường tương tác với ICMP khi dùng tiện ích `ping`. Tiện ích này dùng các thông điệp ICMP "echo request" (yêu cầu phản hồi) và "echo response" (phản hồi).

Tiện ích `traceroute` dùng các thông điệp ICMP "time exceeded" (hết thời gian) để tìm hiểu cách các gói tin được định tuyến.

## Mạng Riêng Tư

Có các mạng riêng tư ẩn sau các router không có địa chỉ IP duy nhất toàn cầu trên máy của chúng. (Mặc dù chúng có địa chỉ duy nhất trong LAN đó.)

Điều này được thực hiện thông qua cơ chế NAT (Network Address Translation --- Dịch địa chỉ mạng). Nhưng đây là câu chuyện cho tương lai.

Bây giờ, hãy cứ giả vờ tất cả địa chỉ của ta đều là duy nhất toàn cầu.

## Địa Chỉ IP Tĩnh Và Động, Và DHCP

Nếu bạn có client truy cập vào website của bạn, hoặc bạn có một server mà bạn muốn SSH vào nhiều lần, bạn sẽ cần một _static IP_ (địa chỉ IP tĩnh). Điều này có nghĩa là bạn được gán một địa chỉ IP duy nhất toàn cầu và nó không bao giờ thay đổi.

Điều này giống như có một số nhà không bao giờ thay đổi. Nếu bạn cần người khác có thể tìm thấy nhà bạn nhiều lần, điều này cần phải như vậy.

Nhưng vì số lượng địa chỉ IPv4 có hạn, IP tĩnh tốn thêm tiền. Thông thường một ISP (nhà cung cấp dịch vụ Internet) sẽ có một khối IP trên subnet mà họ _động_ (dynamic) phân bổ theo nhu cầu.

Điều này có nghĩa là khi bạn khởi động lại modem broadband, nó có thể nhận được địa chỉ IP công cộng khác khi khởi động lại. (Trừ khi bạn đã trả tiền cho IP tĩnh.)

Thật vậy, khi bạn kết nối laptop vào WiFi, bạn cũng thường nhận được địa chỉ IP động. Máy tính của bạn kết nối với LAN và phát một gói tin nói, "Này, tôi ở đây! Ai có thể cho tôi biết địa chỉ IP của tôi không? Xin vui lòng?"

Và điều này ổn vì người ta thường không cố kết nối đến server trên laptop của bạn. Thường là laptop đang kết nối đến các server khác.

Nó hoạt động như thế nào? Trên một trong các server trên LAN là một chương trình đang lắng nghe các request đó, theo chuẩn DHCP (_Dynamic Host Configuration Protocol_ --- Giao thức Cấu hình Host Động). DHCP server theo dõi địa chỉ IP nào trên subnet đang được cấp phát để sử dụng, và cái nào còn trống. Nó cấp phát một cái trống và gửi lại DHCP response có địa chỉ IP mới của laptop bạn, cũng như dữ liệu khác về LAN mà máy tính bạn cần (như subnet mask, v.v.).

Nếu bạn có WiFi ở nhà, rất có thể bạn đã có DHCP server rồi. Hầu hết các router từ ISP của bạn đều đã cài DHCP sẵn, đó là cách laptop bạn nhận địa chỉ IP trên LAN của bạn.

## Reflect

* Có bao nhiêu địa chỉ IPv6 nhiều hơn địa chỉ IPv4?

* Các ứng dụng thường cũng triển khai mã hóa riêng của chúng (ví dụ: ssh hoặc trình duyệt web với HTTPS). Hãy suy đoán về lợi thế hay bất lợi của việc có IPSec ở tầng Internet thay vì mã hóa ở tầng Application.

* Nếu subnet dành 5 bit để xác định host, nó có thể hỗ trợ bao nhiêu host? Đừng quên rằng tất cả-bit-không và tất cả-bit-một cho host đều được dành riêng.

* Lợi ích của việc có IP tĩnh là gì? Nó liên quan đến DNS như thế nào?
