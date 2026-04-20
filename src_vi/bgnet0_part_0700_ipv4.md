# Giao Thức Internet Phiên Bản 4

Đây là phiên bản đầu tiên phổ biến của Giao thức Internet, và nó vẫn đang được sử dụng phổ biến cho đến ngày nay.

## Địa Chỉ IP

Địa chỉ IPv4 được viết theo ký hiệu "chấm và số", như thế này:

``` {.default}
198.51.100.125
```

Luôn luôn là bốn con số. Mỗi số đại diện cho một byte, vì vậy nó có thể từ 0 đến 255 (`00000000` đến `11111111` nhị phân).

Điều này có nghĩa là mọi địa chỉ IPv4 đều có kích thước bốn byte (32 bit).

## Subnet (Mạng Con)

Toàn bộ không gian địa chỉ IP được chia thành các _subnet_ (mạng con). Phần đầu tiên của địa chỉ IP cho biết số subnet ta đang nói đến. Phần còn lại cho biết máy tính trên subnet đó là máy nào.

Và có bao nhiêu bit "phần đầu tiên của IP" cấu thành là biến đổi được.

Khi bạn thiết lập một mạng với các địa chỉ IP công cộng, bạn được cấp phát một subnet bởi bất kỳ ai bạn đang trả tiền để cung cấp kết nối. Subnet hỗ trợ càng nhiều host thì càng đắt.

Vì vậy bạn có thể nói, "Tôi cần 180 địa chỉ IP tĩnh."

Và nhà cung cấp của bạn nói, OK, có nghĩa là bạn sẽ có 180 IP và 2 dành riêng (0 và số cao nhất), vậy tổng là 182. Chúng ta cần 8 bit để biểu diễn các số 0-255, đây là số bit nhỏ nhất bao gồm 182.

Vì vậy họ cấp phát cho bạn một subnet có 24 bit mạng và 8 bit host.

Họ có thể viết ra như thế này:

``` {.default}
Your subnet is 198.51.100.0 and there are 24 network bits and 8 host
bits.
```

Nhưng điều đó rất dài dòng. Vì vậy ta dùng ký hiệu slash (gạch chéo):

``` {.default}
198.51.100.0/24
```

Điều này cho ta biết 24 bit của địa chỉ IP đại diện cho số mạng. (Và do đó `32-24=8` bit đại diện cho host.) Nhưng điều đó có nghĩa gì?

Vẽ ra:

``` {.default}
24 network bits
----------
198.51.100.0
           -
         8 host bits
```

Hoặc chuyển đổi tất cả những số đó sang nhị phân:

``` {.default}
       24 network bits         | 8 host bits
-------------------------------+---------
11000110 . 00110011 . 01100100 . 00000000
     198         51        100          0
```

Kết quả là mỗi IP duy nhất trên mạng giả tưởng của chúng ta ở đây sẽ bắt đầu bằng `198.51.100.x`. Và byte cuối cùng đó sẽ cho biết host nào ta đang nói đến.

Đây là một số ví dụ IP trên mạng của chúng ta:

``` {.default}
198.51.100.2
198.51.100.3
198.51.100.4
198.51.100.30
198.51.100.212
```

Nhưng hai địa chỉ này có ý nghĩa đặc biệt (xem bên dưới):

``` {.default}
198.51.100.0     Reserved
198.51.100.255   Broadcast (see below)
```

nhưng ngoài những cái đó, ta có thể dùng các IP khác tùy ý.

Bây giờ, tôi cố tình chọn một ví dụ ở đó subnet kết thúc trên ranh giới byte vì dễ thấy hơn nếu toàn bộ byte cuối là số host.

Nhưng không có quy định nào về điều đó. Ta có thể dễ dàng có một subnet như thế này:

``` {.default}
198.51.100.96/28
```

Trong trường hợp đó ta có:

``` {.default}
           28 network bits           | 4 host bits
-------------------------------------+----
11000110 . 00110011 . 01100100 . 0110 0000
     198         51        100          96
```

và ta chỉ có thể điền vào 4 bit cuối đó với các số khác nhau để đại diện cho các host của ta.

`0000` và `1111` được dành riêng và broadcast, để lại cho ta 14 cái nữa ta có thể dùng làm số host.

Ví dụ, ta có thể điền vào [4
bit](https://en.wikipedia.org/wiki/Nibble) cuối đó với số host 2 (là `0010` nhị phân):

``` {.default}
           28 network bits           | 4 host bits
-------------------------------------+----
11000110 . 00110011 . 01100100 . 0110 0010
     198         51        100          98
```

Cho địa chỉ IP `198.51.100.98`.

Tất cả địa chỉ IP trên subnet này là, đầy đủ `198.51.100.96` đến `198.51.100.111` (mặc dù IP đầu tiên và cuối cùng này được dành riêng và broadcast, tương ứng).

Cuối cùng, nếu bạn có một subnet bạn sở hữu, không có gì ngăn bạn tiếp tục subnetting nó --- khai báo rằng nhiều bit hơn được dành riêng cho phần mạng của địa chỉ.

Các ISP (Internet Service Provider --- Nhà cung cấp dịch vụ Internet, như công ty cáp hay DSL của bạn) làm điều này mọi lúc. Họ được giao một subnet lớn với, chẳng hạn, 12 bit mạng (20 bit host, cho 1 triệu host có thể). Và họ có các khách hàng muốn subnet riêng. Vì vậy ISP quyết định 9 bit tiếp theo (ví dụ) sẽ được dùng để xác định duy nhất các subnet bổ sung trong subnet của ISP. Và nó bán những cái đó cho khách hàng, và mỗi khách hàng nhận được 11 bit cho host (hỗ trợ 2048 host).

``` {.default}
  ISP network  |   Subnets  |    Hosts
   (12 bits)   |  (9 bits)  |  (11 bits)
---------------+------------+--------------
11010110 . 1100 0101 . 11011 001 . 00101101   [example IP]
```

Nhưng thậm chí không dừng ở đó nhất thiết. Có thể một trong những khách hàng bạn bán subnet 11-bit muốn chia nhỏ nó thêm --- họ có thể thêm bit mạng hơn để định nghĩa subnet riêng của họ. Tất nhiên, mỗi lần bạn thêm bit mạng hơn, bạn đang lấy đi từ số host bạn có thể có, nhưng đó là sự đánh đổi bạn phải thực hiện với subnetting.

## Subnet Mask (Mặt Nạ Mạng Con)

Một cách khác để viết subnet là với một _subnet mask_ (mặt nạ mạng con). Đây là một số mà khi AND bit-wise với bất kỳ địa chỉ IP nào sẽ cho bạn số subnet.

Điều đó có nghĩa gì? Và tại sao?

Subnet mask cũng được viết theo ký hiệu chấm-và-số, và trông giống như một địa chỉ IP với tất cả các bit subnet được đặt thành `1`.

Ví dụ, nếu ta có subnet `198.51.100.0/24`, điều đó có nghĩa là ta có:

``` {.default}
       24 network bits         | 8 host bits
-------------------------------+---------
11000110 . 00110011 . 01100100 . 00000000
     198         51        100          0
```

Đặt `1` vào cho tất cả các bit mạng, ta nhận được:

``` {.default}
       24 network bits         | 8 host bits
-------------------------------+---------
11111111 . 11111111 . 11111111 . 00000000
     255        255        255          0
```

Vì vậy subnet mask cho `198.51.100.0/24` là `255.255.255.0`. Đó là cùng subnet mask cho _bất kỳ_ subnet `/24` nào.

Subnet mask cho subnet `/16` có 16 bit đầu được đặt thành `1`: `255.255.0.0`.

Nhưng tại sao? Hóa ra một router có thể lấy bất kỳ địa chỉ IP nào và nhanh chóng xác định subnet đích của nó bằng cách AND địa chỉ IP với subnet mask.


``` {.default}
         24 network bits         | 8 host bits
  -------------------------------+---------
  11000110 . 00110011 . 01100100 . 01000011    198. 51.100.67
& 11111111 . 11111111 . 11111111 . 00000000  & 255.255.255. 0
-------------------------------------------  ----------------
  11000110 . 00110011 . 01100100 . 00000000    198. 51.100. 0
```

Và vì vậy subnet cho địa chỉ IP `198.51.100.67` với subnet mask `255.255.255.0` là `198.51.100.0`.

## Subnet Lịch Sử

_(Thông tin này chỉ được đưa vào vì mục đích lịch sử.)_

Trước khi có ý tưởng rằng bất kỳ số bit nào đều có thể được dành riêng cho mạng, các subnet được chia thành 3 lớp chính:

* **Class A** --- Subnet mask `255.0.0.0` (hoặc `/8`), hỗ trợ 16.777.214 host
* **Class B** --- Subnet mask `255.255.0.0` (hoặc `/16`), hỗ trợ 65.534 host
* **Class C** --- Subnet mask `255.255.255.0` (hoặc `/24`) hỗ trợ 254 host

Vấn đề là điều này gây ra phân phối subnet không đều, với một số công ty lớn nhận được 16 triệu host (mà họ không cần), và không có lớp subnet nào hỗ trợ số lượng máy tính hợp lý, như 1.000.

Vì vậy ta đã chuyển sang cách tiếp cận linh hoạt hơn là "bất kỳ số bit nào trong mặt nạ".

## Địa Chỉ Đặc Biệt

Có một vài địa chỉ phổ biến đáng ghi nhớ:

* **127.0.0.1** --- đây là máy tính bạn đang dùng bây giờ. Nó thường được ánh xạ với tên `localhost`.

* **0.0.0.0** --- Dành riêng. Host 0 trên bất kỳ subnet nào được dành riêng.

* **255.255.255.255** --- Broadcast (phát sóng). Dành cho tất cả host trên subnet. Mặc dù có vẻ như điều này sẽ phát sóng đến toàn bộ Internet, nhưng router không chuyển tiếp các gói tin dành cho địa chỉ này.

  Bạn cũng có thể broadcast đến subnet cục bộ của mình bằng cách gửi đến host với tất cả bit được đặt thành 1. Ví dụ, địa chỉ broadcast subnet cho `198.51.100.0/24` là `198.51.100.255`.

## Subnet Đặc Biệt

Có một số subnet được dành riêng mà bạn có thể gặp:

* **10.0.0.0/8** --- Địa chỉ mạng riêng tư (_rất phổ biến_)
* **127.0.0.0/8** --- Máy tính này, qua thiết bị _loopback_.
* **172.16.0.0/12** --- Địa chỉ mạng riêng tư
* **192.0.0.0/24** --- Địa chỉ mạng riêng tư
* **192.0.2.0/24** --- Tài liệu
* **192.168.0.0/16** --- Địa chỉ mạng riêng tư (_rất phổ biến_)
* **198.18.0.0/15** --- Địa chỉ mạng riêng tư
* **198.51.100.0/24** --- Tài liệu
* **203.0.113.0/24** --- Tài liệu
* **233.252.0.0/24** --- Tài liệu

Bạn sẽ thấy IP nhà bạn nằm trong một trong các dải địa chỉ "Riêng tư". Có lẽ là `192.168.x.x`.

Bất kỳ tài liệu nào bạn viết cần địa chỉ IP ví dụ (không phải thực) đều nên dùng bất kỳ cái nào được đánh dấu "Tài liệu" ở trên.

## Reflect

* `192.168.262.12` không phải là địa chỉ IP hợp lệ. Tại sao?

* Hãy suy nghĩ về một số lợi thế của khái niệm subnet như một cách chia không gian địa chỉ toàn cầu.

* Địa chỉ IPv4 và subnet mask của máy tính bạn hiện tại là gì? (Bạn có thể phải tìm cách tìm điều này cho hệ điều hành cụ thể của bạn.)

* Nếu một địa chỉ IP được liệt kê là 10.37.129.212/17, có bao nhiêu bit được dùng để đại diện cho các host?
