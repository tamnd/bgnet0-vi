<!-- IP, Subnet, and Subnet Mask Review -->

<!--
Documentation subnets: 192.0.2.0/24, 198.51.100.0/24, 203.0.113.0/24
-->

# IP Subnets và Subnet Mask

[_Mọi thứ trong chương này sẽ dùng IPv4, không phải IPv6. Các khái niệm
về cơ bản giống nhau; chỉ là dễ học hơn với IPv4._]

**Nếu bạn cần ôn lại Bitwise Operations (phép toán bit), hãy xem
[Phụ lục: Bitwise Operations](#appendix-bitwise).**

Trong chương này:

* Biểu diễn địa chỉ (address representation)
* Chuyển đổi từ dots-and-numbers sang giá trị số
* Chuyển đổi từ giá trị số sang dots-and-numbers
* Ôn lại subnet và host
* Ôn lại subnet mask
* Tìm subnet mask từ slash notation (ký hiệu gạch chéo)
* Tìm subnet cho một địa chỉ IP, cho địa chỉ đó và subnet mask

## Biểu diễn địa chỉ (Address Representation)

Hãy nhớ rằng địa chỉ IPv4 thường được hiển thị ở dạng ký hiệu
dots-and-numbers (chấm và số), ví dụ `198.51.100.10`.

Và nhớ rằng mỗi số đó là một byte, có thể có giá trị 0-255 thập phân
(tương đương 00-FF thập lục phân, và 00000000-11111111 nhị phân).

Vậy thực ra, dots-and-numbers chỉ là để tiện cho chúng ta đọc thôi.

> Protip: nhớ rằng các hệ cơ số khác nhau như hex, nhị phân và thập phân
> chỉ là những cách khác nhau để viết một giá trị. Giống như các ngôn
> ngữ khác nhau để biểu diễn cùng một giá trị số.
>
> Khi một giá trị được lưu trong biến, tốt nhất hãy nghĩ nó tồn tại
> theo nghĩa số thuần túy --- không có hệ cơ số nào cả. Chỉ khi bạn
> viết nó xuống (trong code hoặc in ra) thì hệ cơ số mới quan trọng.
>
> Ví dụ, Python mặc định in mọi thứ theo thập phân (cơ số 10). Nó có
> nhiều phương thức để ghi đè điều đó và xuất ra theo hệ cơ số khác.

Hãy xem địa chỉ `198.51.100.10` theo hex: `c6.33.64.0a`.

Bây giờ hãy nhồi các byte đó lại thành một số hex duy nhất: `c633640a`.

Chuyển `c633640a` sang thập phân, chúng ta được: `3325256714`.

Vậy theo một nghĩa nào đó, tất cả những cái này đều đại diện cho cùng
một địa chỉ IP:

``` {.default}
198.51.100.10
c6.33.64.0a
c633640a
3325256714
```

Ổn chứ?

Nhưng tại sao?

Thật ra, chúng ta sắp thực hiện một số phép toán trên địa chỉ IP. Bây
giờ, chúng ta _có thể_ làm phép toán đó một byte một lần và nó vẫn chạy
được.

Nhưng hóa ra nếu chúng ta đóng gói tất cả các byte đó vào một số duy
nhất, chúng ta có thể thực hiện phép toán trên tất cả các byte cùng một
lúc, và nó trở nên dễ hơn. Hẹn gặp lại!

## Chuyển đổi từ Dots-and-Numbers

Mục tiêu của chúng ta trong mục này là lấy chuỗi dots-and-numbers như
`198.51.100.10` và chuyển nó thành giá trị tương ứng, như `3325256714`
(thập phân).

Chúng ta có thể làm bằng cách thao tác chuỗi như trong mục trước, nhưng
hãy làm theo nghĩa _bitwise_ (toán bit) hơn.

Hãy trích xuất các số riêng lẻ từ địa chỉ IP (Python có thể làm điều
này với `.split()`.)

Chuỗi:

``` {.py}
"198.51.100.10"
```

trở thành danh sách chuỗi:

``` {.py}
["198", "51", "100", "10"]
```

Bây giờ hãy chuyển mỗi cái thành số nguyên. (Python có thể làm điều này
với vòng lặp và hàm `int()`, hoặc `map()`, hoặc list comprehension.)

``` {.py}
[198, 51, 100, 10]
```

Bây giờ tôi sẽ viết các số này theo hex vì nó làm cho các bước tiếp theo
rõ ràng hơn. Nhưng nhớ rằng chúng chỉ được lưu dưới dạng giá trị số,
nên Python sẽ không in chúng theo hex trừ khi bạn yêu cầu.

``` {.py}
[0xc6, 0x33, 0x64, 0x0a]
```

Để xây dựng số của chúng ta, chúng ta sẽ dựa vào một vài phép toán bit:
bitwise-OR (OR bit) và bitwise-shift (dịch bit).

Để lấy ví dụ, hãy hardcode phép toán:

``` {.py}
(0xc6 << 24) | (0x33 << 16) | (0x64 << 8) | 0x0a
```

Chạy cái đó trong Python cho ra số thập phân `3325256714`. Chuyển sang
hex, chúng ta quay lại `0xc633640a`.

Bạn có thể dùng công thức trên để chuyển đổi bất kỳ bộ 4 bytes nào thành
số đóng gói.

> Cũng có một vòng lặp thông minh bạn có thể chạy để làm từng byte một.
> Xem bạn có tự nghĩ ra không nhé! DM instructor để xem bạn thông minh
> đến đâu.

## Chuyển đổi sang Dots-and-Numbers

Nếu bạn có giá trị từ mục trước, `3325256714`, và muốn chuyển lại thành
địa chỉ IP thì sao?

Chúng ta cũng có thể dùng một số phép dịch để làm điều đó! Nhưng chúng
ta phải dùng một số AND masking (mặt nạ AND) để lấy đúng phần số chúng
ta muốn.

Hãy chuyển sang hex vì mỗi byte chính xác là 2 chữ số hex và dễ nhìn
hơn: `0xc633640a`.

Bây giờ hãy xem số đó được dịch 0 bit, 8 bit, 16 bit và 24 bit:

``` {.py}
0xc633640a >> 24 == 0x000000c6
0xc633640a >> 16 == 0x0000c633
0xc633640a >> 8  == 0x00c63364
0xc633640a >> 0  == 0xc633640a
```

Nếu bạn chỉ nhìn vào hai chữ số bên phải, bạn sẽ thấy chúng là các byte
của số gốc:


``` {.py}
0xc633640a >> 24 == 0x000000 c6
0xc633640a >> 16 == 0x0000c6 33
0xc633640a >> 8  == 0x00c633 64
0xc633640a >> 0  == 0xc63364 0a
```

Vậy là chúng ta đang đi đúng hướng rồi, ngoại trừ nhìn vào right shift 8
chẳng hạn, chúng ta được cái này:

``` {.py}
0xc633640a >> 8  == 0x00c63364
```

Vâng, tôi quan tâm đến byte `0x64` như chúng ta thấy bên phải, nhưng
không phải phần `0xc633` của nó. Làm sao tôi có thể zero hóa phần cao
hơn đó, chỉ để lại `0x64`?

Chúng ta có thể dùng _AND mask_! Toán tử bitwise-AND có thể hoạt động
như một khuôn chữ, cho phép một phần số đi qua và zero hóa các phần
khác. Hãy thực hiện bitwise-AND trên số đó với byte `0xff`, là 8 bit tất
cả đều bằng `1` và tất cả các bit trên 8 bit đầu tiên có giá trị `0`
ngụ ý.

``` {.default}
  0x00c63364
& 0x000000ff
------------
  0x00000064
```

Này! `0x64` là byte từ địa chỉ IP chúng ta muốn! Thấy cách ở những chỗ
có `1` nhị phân trong mặt nạ (nhưng ở đây được biểu diễn bằng hex) nó
cho giá trị "hiện ra", còn ở mọi chỗ có số không thì bị che đi không?

Bây giờ chúng ta có thể trích xuất các chữ số của mình:

``` {.py}
(0xc633640a >> 24) & 0xff == 0x000000c6 == 0xc6
(0xc633640a >> 16) & 0xff == 0x00000033 == 0x33
(0xc633640a >> 8)  & 0xff == 0x00000064 == 0x64
(0xc633640a >> 0)  & 0xff == 0x0000000a == 0x0a
```

Và đó là các byte riêng lẻ của địa chỉ IP.

Để đi từ đó sang dots-and-numbers, bạn có thể dùng f-string hoặc
`.join()` trong Python.

## Ôn lại Subnet và Host

Nhớ rằng địa chỉ IP được chia thành hai phần: số subnet (mạng con) và
số host. Một số bit bên trái của địa chỉ IP là số network, và các bit
còn lại bên phải là số host.

Hãy xem ví dụ khi 24 bit bên trái (3 bytes) là số subnet và 8 bit bên
phải (1 byte) giữ số host.

``` {.default}
 Subnet   | Host
          | 
198.51.100.10
```

Vậy cái đó đại diện cho host `10` trên subnet `198.51.100.0`. (Chúng ta
thay các bit host bằng `0` khi nói về số subnet.)

Nhưng tôi vừa nói trên, một cách đơn phương, rằng có 24 bit network
trong địa chỉ IP đó. Điều đó không mấy súc tích. Nên người ta đã phát
minh ra slash notation (ký hiệu gạch chéo).

``` {.default}
198.51.100.0/24    24 bits are used for subnet
```

Hoặc bạn có thể dùng nó với địa chỉ IP:

``` {.default}
198.51.100.10/24   Host 10 on subnet 198.51.100.0
```

Hãy thử với 16 bit cho network:

``` {.default}
10.121.2.17/16    Host 2.17 on subnet 10.121.0.0
```

Hiểu chưa?

Trong các ví dụ đó chúng ta dùng bội số của 8 để căn chỉnh trực quan
trên ranh giới byte, nhưng không có lý do gì bạn không thể có phần nhỏ
lẻ của byte còn lại cho một subnet:

``` {.default}
10.121.2.68/28    Host 4 on subnet 10.121.2.64
```

Nếu bạn không thấy 4 và 64 từ đâu ra trong ví dụ trước, hãy thử viết
các byte ra dạng nhị phân!

## Ôn lại Subnet Mask

_Subnet mask_ là gì? Đây là một chuỗi bit `1` trong nhị phân chỉ ra
phần nào của địa chỉ IP là phần network. Nó được theo sau bởi một chuỗi
`0` trong nhị phân chỉ ra phần nào là số host.

Nó được dùng để xác định subnet mà một địa chỉ IP thuộc về, hoặc phần
nào của IP đại diện cho số host.

Hãy vẽ một cái trong nhị phân. Chúng ta sẽ dùng địa chỉ IP ví dụ này:

``` {.default}
198.51.100.10/24   Host 10 on subnet 198.51.100.0
```

Hãy chuyển sang nhị phân trước. (Có gợi ý ở đây rằng subnet mask là
AND mask nhị phân!)

``` {.default}
11000110.00110011.01100100.00001010   198.51.100.10
```

Và bây giờ, bên trên nó, hãy vẽ một chuỗi 24 số `1` (vì đây là subnet
`/24`) tiếp theo là 8 số `0` (vì địa chỉ IP tổng cộng 32 bit).


``` {.default}
11111111.11111111.11111111.00000000   255.255.255.0  subnet mask!
   
11000110.00110011.01100100.00001010   198.51.100.10
```

Đó là subnet mask tương ứng với subnet `/24`! `255.255.255.0`!

## Tính Subnet Mask từ Slash Notation

Nếu tôi cho bạn biết một subnet là `/24`, làm sao bạn có thể xác định
subnet mask là `255.255.255.0`? Hoặc nếu tôi nói nó là `/28` thì mask
là `255.255.255.240`?

Với subnet `/24`, chúng ta cần một chuỗi 24 số `1`, tiếp theo là 8 số
`0`.

Xem [Phụ lục: Bitwise](#appendix-bitwise) để biết cách tạo ra các chuỗi
số `1` trong nhị phân và dịch chúng.

Khi bạn có số nhị phân lớn đó, vấn đề là chuyển nó trở lại dạng
dots-and-numbers, dùng kỹ thuật chúng ta đã phác thảo ở trên.

Nhớ rằng subnet có thể kết thúc trên bất kỳ ranh giới bit nào. `/17`
là subnet bình thường. Không nhất thiết phải là bội số của 8!

## Tìm Subnet cho một địa chỉ IP

Nếu bạn được cho một địa chỉ IP với slash notation như thế này:

``` {.default}
198.51.100.10/24   Host 10 on subnet 198.51.100.0
```

Làm sao bạn có thể trích xuất chỉ subnet (198.51.100.0) và chỉ host?

Bạn có thể làm bằng bitwise-AND!

Chúng ta có thể tính subnet mask cho `/24` và được `255.255.255.0`, như
trên.

Sau đó, hãy xem trong nhị phân và AND chúng với nhau:

``` {.default}
  11111111.11111111.11111111.00000000   255.255.255.0  subnet mask
& 11000110.00110011.01100100.00001010   198.51.100.10  IP address
-------------------------------------
  11000110.00110011.01100100.00000000   198.51.100.0  network number!
```

Chúng ta cũng có thể thao tác trên toàn bộ cùng một lúc thay vì từng
byte... chỉ cần nhồi các số đó vào một giá trị duy nhất, như chúng ta đã
làm trong mục trên:

``` {.default}
  11111111111111111111111100000000   255.255.255.0  subnet mask
& 11000110001100110110010000001010   198.51.100.10  IP address
-------------------------------------
  11000110001100110110010000000000   198.51.100.0  network number
```

AND hoạt động trên toàn bộ cùng một lúc! Sau đó chúng ta có thể chuyển
đổi trở lại dạng dots-and-numbers như chúng ta đã làm trong các mục
trước.

Bây giờ nếu bạn có địa chỉ IP (trong một số 32-bit duy nhất) và subnet
mask (trong một số 32-bit duy nhất) và muốn lấy các bit _host_ ra từ địa
chỉ IP, không phải các bit network thì sao? Bạn có thấy cách làm không?
(Gợi ý: bitwise NOT!)

Router dùng điều này mọi lúc --- họ được cho một địa chỉ IP và cần biết
nó có khớp với bất kỳ subnet nào mà router đang kết nối không. Vậy nên
nó mask ra số network của địa chỉ IP và so sánh nó với tất cả các subnet
mà router biết. Rồi chuyển tiếp về phía subnet đúng.

## Reflect (Suy ngẫm)

* Biểu diễn 32-bit (4-byte) của địa chỉ IP `10.100.30.90` theo hex là
  gì? Theo thập phân? Theo nhị phân?
  <!-- 0x0a641e5a, 174333530, 0b1010011001000001111001011010 -->
 
* Địa chỉ IP dạng dots-and-numbers được đại diện bởi số 32-bit
  `0xc0a88225` là gì?
  <!-- 192.168.130.37 -->

* Địa chỉ IP dạng dots-and-numbers được đại diện bởi số thập phân 32-bit
  `180229186` là gì?
  <!-- 10.190.20.66 -->

* Cần những phép toán bitwise nào để trích xuất byte thứ hai từ bên trái
  (`0xff`) của số `0x12ff5678`?
  <!--
  shift, AND
  (n >> 16) & 0xff  or  (n & 0xff0000) >> 16
  -->

* Slash notation cho subnet mask `255.255.0.0` là gì?
  <!-- /16 -->

* Subnet mask cho network `192.168.1.12/24` là gì?
  <!-- 255.255.255.0 -->

* Những phép toán số học cần thiết để chuyển đổi slash subnet mask sang
  giá trị nhị phân là gì?
  <!--
  shift, subtract 1
  ((1 << m) - 1) << (32 - m)
  -->

* Cho địa chỉ IP (trong một số 32-bit duy nhất) và giá trị subnet mask
  (trong một số 32-bit duy nhất), cần thực hiện phép toán bitwise nào để
  lấy số subnet từ địa chỉ IP?
  <!-- AND the two together -->


192.168.1.0 là số network, nhưng nó không phải subnet mask. Subnet mask
là giá trị dots-and-numbers thu được từ slash notation. Trong trường hợp
này là `/24`, cho chúng ta `255.255.255.0`.


