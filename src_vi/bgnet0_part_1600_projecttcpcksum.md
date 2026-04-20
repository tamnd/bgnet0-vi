# Project: Validating a TCP Packet

Trong project này bạn sẽ viết code để xác thực một TCP packet, đảm bảo
nó không bị hỏng trong quá trình truyền.

**Đầu vào (Inputs)**: Một chuỗi cặp file:

* Một file chứa địa chỉ IPv4 nguồn và đích dưới dạng ký hiệu
  dots-and-numbers (chấm và số).

* File kia chứa TCP packet thô (raw), bao gồm cả TCP header và payload.

Bạn có thể [fls[tải các file đầu vào từ thư mục exercises|tcpcksum/tcp_data.zip]].

**Đầu ra (Outputs)**:

* Với mỗi cặp file, in `PASS` nếu TCP checksum chính xác. Ngược lại in
  `FAIL`.

Project này có nhiều phần, vậy nên hãy viết và test từng bước một.

**Bạn phải hiểu 100% đặc tả này trước khi bắt đầu lên kế hoạch! Hãy
làm rõ trước khi tiến đến giai đoạn lập kế hoạch!**

**PHẦN KHÓ NHẤT TUYỆT ĐỐI của project này là hiểu nó! Code của bạn sẽ
không bao giờ chạy được trước khi bạn hiểu nó!**

**Model solution chỉ có 37 dòng code!** (Không tính dòng trống và
comment.) Đây không phải là con số để đập lại, mà là dấu hiệu cho thấy
bạn cần dành bao nhiêu công sức để hiểu đặc tả này so với việc gõ code!

## Hàm bị cấm (Banned Functions)

Bạn không được dùng bất cứ thứ gì trong thư viện `socket`.

## Cách code

Bạn có thể làm theo cách nào bạn thích, nhưng tôi khuyến nghị thứ tự
sau. Chi tiết cho từng bước được bao gồm trong các mục tiếp theo.

1. Đọc file `tcp_addrs_0.txt`.
1. Tách dòng thành hai phần, địa chỉ nguồn và địa chỉ đích.
1. Viết một hàm chuyển đổi địa chỉ IP dạng dots-and-numbers thành
   bytestring.
1. Đọc file `tcp_data_0.dat`.
1. Viết một hàm tạo ra các byte IP pseudo header từ địa chỉ IP trong
   `tcp_addrs_0.txt` và TCP length từ file `tcp_data_0.dat`.
1. Xây dựng phiên bản mới của TCP data với checksum được đặt về zero.
1. Nối pseudo header và TCP data với checksum bằng zero.
1. Tính checksum của chuỗi nối đó.
1. Trích xuất checksum từ dữ liệu gốc trong `tcp_data_0.dat`.
1. So sánh hai checksum. Nếu chúng giống nhau, là đúng!
1. Chỉnh sửa code để chạy trên tất cả 10 file dữ liệu. **5 file đầu
   phải có checksum khớp! 5 file sau không khớp!** Tức là 5 file sau
   mô phỏng bị hỏng trong quá trình truyền.

## Checksum nói chung

Checksum trong TCP là giá trị 16-bit đại diện cho "tổng" của tất cả
các byte trong packet. (Cộng thêm một chút nữa. Và không phải chỉ là
tổng cộng các byte --- đừng cộng thẳng vào!!! Chi tiết bên dưới.)

Bản thân TCP header chứa checksum từ host gửi.

Host nhận (đó là bạn đang giả vờ làm ở đây) tính checksum của riêng mình
từ dữ liệu đến và đảm bảo nó khớp với giá trị trong packet.

Nếu khớp, packet tốt. Nếu không khớp, nghĩa là có gì đó bị hỏng. Địa
chỉ IP nguồn hoặc đích sai, hoặc TCP header bị hỏng, hoặc dữ liệu sai.
Hay chính checksum bị hỏng.

Trong bất kỳ trường hợp nào, phần mềm TCP trong hệ điều hành sẽ yêu cầu
gửi lại nếu các checksum không khớp.

Nhiệm vụ của bạn trong project này là tính lại checksum của dữ liệu đã
cho và đảm bảo nó khớp (hoặc không khớp) với checksum đã có trong dữ
liệu đó.

## Chi tiết File đầu vào

**Tải [fls[ZIP này|tcpcksum/tcp_data.zip]] với các file đầu vào**.

Có 10 bộ file. 5 bộ đầu có checksum hợp lệ. 5 bộ sau bị hỏng.

Phòng khi bạn không để ý, dòng trên cho bạn biết phải làm gì để đạt
100% ở project này!

Các file được đặt tên như sau:

``` {.default}
tcp_addrs_0.txt
tcp_addrs_0.dat

tcp addrs_1.txt
tcp addrs_1.dat
```

và tương tự, đến chỉ số 9. Mỗi cặp file có liên quan đến nhau.

### File `.txt`

Bạn có thể mở file `tcp_addrs_n.txt` trong editor và thấy nó chứa một
cặp địa chỉ IP ngẫu nhiên, tương tự như:

``` {.default}
192.0.2.207 192.0.2.244
```

Đây là _địa chỉ IP nguồn_ và _địa chỉ IP đích_ cho TCP packet này.

Tại sao cần biết thông tin IP nếu đây là TCP checksum? Hẹn ngay!

### File `.dat`

Đây là file nhị phân chứa TCP header thô tiếp theo là dữ liệu payload.
Nó sẽ trông như rác trong editor. Nếu bạn có chương trình hexdump, bạn
có thể xem các byte với nó. Ví dụ, đây là output từ `hexdump`:

``` {.sh}
hexdump -C tcp_data_0.dat
```

``` {.default}
00000000  3f d7 c9 c5 ed d8 23 52  6a 15 32 96 50 d9 78 d8  |?.....#Rj.2.P.x.|
00000010  67 be ba aa 2a 63 25 2d  7c 4f 2a 39 52 69 4b 75  |g...*c%-|O*9RiKu|
00000020  42 39 53                                          |B9S|
00000023
```

Nhưng cho project này, những thứ duy nhất trong file đó bạn thực sự cần
quan tâm là:

* Độ dài (tính bằng bytes) của dữ liệu
* Checksum big-endian 16-bit được lưu tại offset 16-17

Chi tiết hơn sau!

Lưu ý: các file này chứa TCP header "gần đúng". Tất cả các phần đều có
mặt, nhưng các giá trị khác nhau (đặc biệt trong các trường flags và
options) có thể không có nghĩa gì.

## Làm thế nào để tính TCP Checksum?

Không dễ đâu.

TCP checksum ở đó để xác minh tính toàn vẹn của nhiều thứ:

* TCP header
* TCP payload
* Địa chỉ IP nguồn và đích (để bảo vệ chống lại dữ liệu bị định tuyến
  sai vào TCP stream).

Phần cuối rất thú vị, vì địa chỉ IP hoàn toàn không có trong TCP header
hay data, vậy làm sao ta đưa chúng vào checksum?

TCP checksum là một số 2-byte được tính như sau, cho TCP header data,
payload và địa chỉ IP nguồn và đích:

* Xây dựng một chuỗi byte đại diện cho IP Pseudo header (xem bên dưới).

* Đặt checksum TCP header hiện tại về zero.

* Nối IP pseudo header + TCP header và payload.

* Tính checksum của chuỗi nối đó.

Đó là cách tính TCP checksum.

Nhưng có rất nhiều chi tiết.

## IP Pseudo Header

Vì chúng ta muốn đảm bảo rằng các địa chỉ IP cũng đúng cho dữ liệu này,
chúng ta cần đưa IP header vào checksum.

Ngoại trừ chúng ta không đưa IP header thật vào. Chúng ta tạo một cái
giả. Và nó trông như thế này (lấy thẳng từ TCP RFC):

``` {.default}
+--------+--------+--------+--------+
|           Source Address          |
+--------+--------+--------+--------+
|         Destination Address       |
+--------+--------+--------+--------+
|  Zero  |  PTCL  |    TCP Length   |
+--------+--------+--------+--------+
```

Đừng để bố cục lưới đánh lừa bạn: IP pseudo header là một chuỗi bytes.
Nó chỉ ở bố cục này để con người đọc dễ hơn thôi.

Mỗi dấu `+` trong sơ đồ đại diện cho ranh giới byte.

Vậy Source Address (địa chỉ nguồn) là 4 bytes. (Này! Địa chỉ IPv4 là 4
bytes!) **Bạn lấy cái này từ các file `tcp_addrs_n.txt`**.

Destination Address (địa chỉ đích) là 4 bytes. **Bạn cũng lấy cái này
từ các file `tcp_addrs_n.txt`**.

Zero là một byte, chỉ đặt bằng giá trị byte `0x00`.

PTCL là giao thức, và nó luôn được đặt bằng giá trị byte `0x06`. (IP có
một số số ma thuật đại diện cho giao thức cấp cao hơn trên nó. Số của
TCP là 6. Đó là nguồn gốc của nó.)

TCP Length là tổng chiều dài, tính bằng bytes của TCP packet và data,
big-endian. **Đây là chiều dài của dữ liệu bạn sẽ đọc từ các file
`tcp_data_n.dat`**.

Vậy trước khi tính TCP checksum, bạn phải tự tạo một IP pseudo header!

### Pseudo Header ví dụ

Nếu IP nguồn là `255.0.255.1` và IP đích là `127.255.0.1`, và TCP length
là 3490 (hex 0x0da2), pseudo header sẽ là chuỗi bytes này:

``` {.default}
 Source IP |  Dest IP  |Z |P |TCP length
           |           |  |  |  
ff 00 ff 01 7f ff 00 01 00 06 0d a2
```

`Z` là phần zero. Và `P` là giao thức (luôn là 6).

Thấy cách các byte tương ứng với các đầu vào không? (255 là hex 0xff,
127 là hex 0x7f, v.v.)

### Lấy bytes địa chỉ IP

Nếu để ý, địa chỉ IP trong các file `tcp_addrs_n.txt` ở dạng dots-and-
numbers, không phải nhị phân.

**Bạn sẽ cần viết một hàm chuyển chuỗi dots-and-numbers thành chuỗi 4
bytes.**

Thuật toán:

* Tách dots and numbers thành mảng 4 số nguyên.
* Chuyển mỗi cái thành byte bằng `.to_bytes()`
* Nối tất cả lại thành một bytestring duy nhất.

Hàm này sẽ nhận địa chỉ IPv4 dạng dots-and-numbers và trả về bytestring
bốn byte với kết quả.

Đây là bài test:

* Input: `"1.2.3.4"`
* Output: `b'\x01\x02\x03\x04'`

Sau đó bạn có thể chạy hàm này trên mỗi địa chỉ IP trong file đầu vào
và append chúng vào pseudoheader.

### Lấy chiều dài TCP Data

Cái này dễ: một khi bạn đọc một trong các file `tcp_data_n.dat`, chỉ
cần lấy chiều dài của dữ liệu.

``` {.py}
with open("tcp_data_0.dat", "rb") as fp:
    tcp_data = fp.read()
    tcp_length = len(tcp_data)  # <-- right here
```

**Nhớ dùng `"rb"` khi đọc dữ liệu nhị phân! Đó là ý nghĩa của `b`! Nếu
không làm vậy, có thể phá vỡ mọi thứ!**

## TCP Header Checksum

Khi tính checksum, chúng ta cần TCP header với trường checksum được đặt
về zero.

Và chúng ta cũng cần trích xuất checksum hiện có từ TCP header đã nhận
để có thể so sánh với checksum chúng ta tính được!

Sơ đồ này rất lớn, nhưng thực ra chúng ta chỉ quan tâm đến một phần.
Vậy nên lướt qua và chuyển đến đoạn tiếp theo:

``` {.default}
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          Source Port          |       Destination Port        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                        Sequence Number                        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Acknowledgment Number                      |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Data |           |U|A|P|R|S|F|                               |
| Offset| Reserved  |R|C|S|S|Y|I|            Window             |
|       |           |G|K|H|T|N|N|                               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|           Checksum            |         Urgent Pointer        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Options                    |    Padding    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                             data                              |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

(Một lần nữa, giống như IP pseudo header, cái này được mã hóa như một
luồng bytes và lưới chỉ ở đây để làm cho cuộc sống của chúng ta dễ hơn.
Lưới này rộng 32-bit, được đánh số dọc theo trên cùng.)

Bạn thấy chỗ viết `Checksum` không? Đó là phần chúng ta quan tâm cho
project này. Và nó là số 2-byte (big-endian) tại byte offset 16 và 17
bên trong TCP header.

Nó cũng sẽ nằm tại byte offset 16-17 trong các file `tcp_data_n.dat` vì
các file đó bắt đầu bằng TCP header. (Tiếp theo là TCP payload.)

**Bạn sẽ cần checksum từ file đó. Dùng slice để lấy hai bytes đó rồi
dùng `.from_bytes()` để chuyển thành số. Đây là checksum gốc bạn sẽ so
sánh ở cuối cùng!**

**Bạn cũng sẽ cần tạo một phiên bản của TCP header và data đó với
checksum được đặt về zero. Bạn có thể làm như thế này:**

``` {.py}
tcp_zero_cksum = tcp_data[:16] + b'\x00\x00' + tcp_data[18:]
```

Thấy cách chúng ta tạo phiên bản mới của TCP data chưa? Chúng ta slice
mọi thứ trước và sau checksum hiện có, và đặt hai byte zero vào giữa.

## Thực sự tính Checksum

Chúng ta gần đến rồi. Cho đến nay chúng ta đã làm các bước sau:

* Xây dựng IP pseudo header
* Trích xuất checksum từ TCP header hiện có
* Xây dựng phiên bản TCP header với checksum bằng zero

Và bây giờ chúng ta đến phần toán học. Đây là những gì đặc tả nói:

> The checksum field is the 16 bit one's complement of the one's
> complement sum of all 16 bit words in the header and text.

Ờ thôi, chúng ta đã gặp vấn đề rồi. Cái gì của cái gì?

One's complement (bù một) là cách biểu diễn số nguyên dương và âm trong
nhị phân. Chúng ta không cần biết chi tiết cho việc này, may mắn thay.

Nhưng một điều chúng ta cần chú ý là chúng ta đang nói về tất cả "các
từ 16 bit"... cái đó là gì?

Nó có nghĩa là thay vì coi tất cả dữ liệu này là một loạt bytes, chúng
ta coi nó là một loạt các giá trị 16-bit được đóng gói cùng nhau.

Vậy nếu bạn có các bytes:

``` {.default}
01 02 03 04 05 06
```

chúng ta sẽ coi đó là 3 giá trị 16-bit:

``` {.default}
0102 0304 0506
```

Và chúng ta sẽ cộng những cái đó lại. Với phép cộng one's complement.
Dù sao đi nữa.

Này --- nhưng nếu có số lẻ bytes thì sao?

> If a segment contains an odd number of header and text octets to be
> checksummed, the last octet is padded on the right with zeros to form
> a 16 bit word for checksum purposes.

Vậy nên chúng ta sẽ phải xem xét `tcp_length` mà chúng ta lấy được
bằng cách lấy độ dài của dữ liệu từ file `tcp_data_0.dat`. Nếu nó lẻ,
chỉ cần thêm một byte zero vào cuối toàn bộ dữ liệu.

Thuận tiện là, chúng ta đã có một bản sao của TCP data có thể dùng: phiên
bản chúng ta tạo ra với checksum bằng zero. Vì chúng ta sẽ iterate qua
cái này dù sao, cũng tiện để append byte zero vào đó:

``` {.py}
if len(tcp_zero_cksum) % 2 == 1:
    tcp_zero_cksum += b'\x00'
```

Cái đó sẽ bắt buộc nó có độ dài chẵn.

Chúng ta có thể trích xuất tất cả các giá trị 16-bit đó bằng cách làm
gì đó như sau. Nhớ rằng dữ liệu cần được tính checksum bao gồm pseudo
header và TCP data (với trường checksum được đặt về zero):

``` {.py}
data = pseudoheader + tcp_zero_cksum

offset = 0   # byte offset into data

while offset < len(data):
    # Slice 2 bytes out and get their value:

    word = int.from_bytes(data[offset:offset + 2], "big")

    offset += 2   # Go to the next 2-byte value
```

Tuyệt. Cái đó iterate qua tất cả các từ trong toàn bộ đoạn dữ liệu.
Nhưng điều đó mua cho chúng ta điều gì?

Checksum là gì rồi?

Hãy lấy vòng lặp đó và thêm code checksum vào.

Ở đây chúng ta quay lại với cái one's-complement. Và một số thứ 16-bit,
khá khó chịu trong Python vì nó dùng số nguyên có độ chính xác tùy ý.

Nhưng đây là cách chúng ta muốn làm. Trong ví dụ sau, `tcp_data` là TCP
data được padding đến độ dài chẵn với zero cho checksum.

``` {.py}
# Pseudocode

function checksum(pseudo_header, tcp_data)
    data = pseudo_header + tcp_data

    total = 0

    for each 16-bit word of data:  # See code above

        total += word
        total = (total & 0xffff) + (total >> 16)  # carry around

    return (~total) & 0xffff  # one's complement
```

Cái "carry around" đó là một phần của toán one's complement. Các thứ
`&0xffff` khắp nơi là để buộc Python cho chúng ta số nguyên 16-bit.

Nhớ đặc tả nói gì không?

> The checksum field is the 16 bit one's complement of the one's
> complement sum of all 16 bit words in the header and text.

Vòng lặp đang cho chúng ta "one's complement sum" (tổng bù một). `~total`
ở cuối đang cho chúng ta "one's complement" của cái đó.

## So sánh cuối cùng (Final Comparison)

Bây giờ bạn đã tính được checksum cho TCP data và trích xuất checksum
hiện có từ TCP data, đã đến lúc so sánh hai cái.

Nếu chúng bằng nhau, dữ liệu nguyên vẹn và chính xác. Nếu không bằng,
dữ liệu bị hỏng.

Trong dữ liệu mẫu, 5 file đầu nguyên vẹn, và 5 file cuối bị hỏng.

## Đầu ra (Output)

Đầu ra của chương trình của bạn phải hiển thị TCP data nào pass và cái
nào fail. Tức là, đây phải là đầu ra của bạn:

``` {.default}
PASS
PASS
PASS
PASS
PASS
FAIL
FAIL
FAIL
FAIL
FAIL
```

## Thành công! (Success)

Đó không phải là chuyện dễ dàng. Hãy tự thưởng cho mình! Bạn xứng đáng
được vậy.

<!-- Rubric

100 points

10
Function converts dots-and-numbers to 4 big-endian bytes

5
Pseudo header contains source and destination IP addresses in binary format

5
Pseudo header contains zero in zero field

5
Psudeo header contains binary value 0x06 in the protocol field

5
Pseudo header contains proper TCP segment length as a 16-bit big-endian number

5
Checksum concatenates the pseudo header and TCP header and data

5
Checksum pads complete data to an even byte length

10
Checksum computation operates on 16-bit words

10
Checksum computation is correct one's complement math

5
Checksum is inverted before returning

5
Checksum results are masked correctly to 16 bits

10
All 10 file sets are read and processed

5
Original checksum is extracted correctly

5
A version of the TCP data with checksum zeroed is constructed correctly

10
"PASS"/"FAIL" output is correct.

-->
