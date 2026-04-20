# Endianness và Số Nguyên

Chúng ta đã làm một số công việc truyền text qua mạng. Nhưng bây giờ chúng ta muốn làm điều khác: muốn truyền dữ liệu số nguyên nhị phân (binary integer data).

Dĩ nhiên chúng ta _có thể_ chỉ chuyển đổi các số thành chuỗi, nhưng điều này lãng phí hơn mức cần thiết. Biểu diễn nhị phân gọn hơn và tiết kiệm băng thông.

Nhưng mạng chỉ có thể gửi và nhận byte! Làm thế nào chúng ta có thể chuyển đổi các số tùy ý thành từng byte?

Đó là điều chương này nói về.

Chúng ta muốn:

* Chuyển đổi số nguyên thành chuỗi byte
* Chuyển đổi chuỗi byte trở lại thành số nguyên

Và trong chương này chúng ta sẽ xem xét:

* Các số được biểu diễn bởi chuỗi byte như thế nào
* Thứ tự các byte đó được sắp xếp
* Cách chuyển đổi một số thành chuỗi byte trong Python
* Cách chuyển đổi một chuỗi byte thành số trong Python

Những điểm chính cần chú ý:

* Số nguyên có thể được biểu diễn bởi chuỗi byte.
* Chúng ta sẽ chuyển đổi số nguyên thành chuỗi byte trước khi truyền chúng
  qua mạng.
* Chúng ta sẽ chuyển đổi chuỗi byte trở lại thành số nguyên khi nhận
  chúng qua mạng.
* _Big-Endian_ và _Little-Endian_ là hai cách khác nhau để sắp xếp
  các chuỗi byte đó.
* Python cung cấp chức năng tích hợp sẵn để chuyển đổi số nguyên thành
  chuỗi byte và ngược lại.

## Biểu Diễn Số Nguyên

Trong phần này chúng ta sẽ tìm hiểu sâu về cách một số nguyên có thể được biểu diễn
bởi một chuỗi byte riêng lẻ.

### Biểu Diễn Byte Thập Phân

Hãy xem cách các số nguyên được biểu diễn dưới dạng chuỗi byte. Những chuỗi byte này là thứ chúng ta sẽ gửi qua mạng để truyền giá trị số nguyên đến các hệ thống khác.

Một byte đơn (trong ngữ cảnh này chúng ta định nghĩa byte là 8 bit thông thường) có thể mã hóa các giá trị nhị phân từ `00000000` đến `11111111`. Theo thập phân, các con số này đi từ 0 đến 255.

Vậy điều gì xảy ra nếu bạn muốn lưu trữ số lớn hơn 255? Như 256? Trong trường hợp đó, bạn cần dùng byte thứ hai để lưu trữ giá trị bổ sung.

Càng dùng nhiều byte để biểu diễn một số nguyên, phạm vi số nguyên bạn có thể biểu diễn càng lớn. Một byte có thể lưu từ 0 đến 255. Hai byte có thể lưu từ 0 đến 65535.

Nhìn theo một cách khác, 65536 là số tổ hợp của các số 1 và 0 bạn có thể có trong một số 16-bit.

> Phần này đang nói về **số nguyên không âm** chỉ. Số dấu phẩy động dùng
> [encoding khác](https://en.wikipedia.org/wiki/IEEE_754#Basic_and_interchange_formats).
> Số nguyên âm dùng kỹ thuật tương tự với số dương, nhưng chúng ta sẽ giữ
> đơn giản lúc này và bỏ qua chúng.

Hãy xem điều gì xảy ra khi chúng ta đếm từ 253 đến 259 trong một số 16-bit. Vì 259 lớn hơn một byte đơn có thể chứa, chúng ta sẽ dùng hai byte (chứa số từ 0 đến 255), với giá trị thập phân tương ứng được biểu diễn ở bên phải:

``` {.default}
  0 253   represents 253
  0 254   represents 254
  0 255   represents 255
  1   0   represents 256
  1   1   represents 257
  1   2   represents 258
  1   3   represents 259
```

Chú ý byte bên phải "cuộn lại" từ `255` về `0` như đồng hồ xe. Gần như là byte đó là "hàng đơn vị" và byte bên trái là "hàng 256"... gần giống như nhìn vào một hệ thống đánh số cơ số 256.

Chúng ta có thể tính giá trị thập phân của số bằng cách lấy byte đầu tiên nhân với 256, rồi cộng thêm giá trị của byte thứ hai:

``` {.default}
1  * 256 +   3 = 259
```

Hoặc trong ví dụ này, nơi hai byte với giá trị `17` và `178` biểu diễn giá trị `4530`:

``` {.default}
17 * 256 + 178 = 4530
```

Cả `17` và `178` đều không lớn hơn `255`, vì vậy chúng đều vừa trong một byte đơn.

Vì vậy mọi số nguyên đều có thể được biểu diễn hoàn toàn bằng một chuỗi byte. Bạn chỉ cần nhiều byte hơn trong chuỗi để biểu diễn các số lớn hơn.

### Biểu Diễn Byte Nhị Phân

Nhị phân, thập lục phân và thập phân chỉ là các "ngôn ngữ" khác nhau để viết ra các giá trị.

Vì vậy chúng ta có thể viết lại toàn bộ phần trước của tài liệu chỉ bằng cách dịch tất cả các số thập phân sang nhị phân, và nó vẫn đúng như vậy.

Thực ra, hãy làm điều đó cho ví dụ từ phần trước. Nhớ: điều này tương đương về mặt số --- chúng ta chỉ thay đổi các số từ thập phân sang nhị phân. Tất cả các khái niệm khác đều giống hệt.

``` {.default}
00000000 11111101    represents  11111101 (253 decimal)
00000000 11111110    represents  11111110 (254 decimal)
00000000 11111111    represents  11111111 (255 decimal)
00000001 00000000    represents 100000000 (256 decimal)
00000001 00000001    represents 100000001 (257 decimal)
00000001 00000010    represents 100000010 (258 decimal)
00000001 00000011    represents 100000011 (259 decimal)
```

Nhưng khoan đã --- thấy mẫu không? Nếu bạn chỉ ghép hai byte lại với nhau bạn sẽ có chính xác cùng số với biểu diễn nhị phân! (Bỏ qua các số 0 đứng đầu.)

Thực ra tất cả những gì chúng ta đã làm là lấy biểu diễn nhị phân của một số và chia nó thành từng đoạn 8 bit. Chúng ta có thể lấy bất kỳ số tùy ý nào như 1.256.616.290.962 thập phân và chuyển đổi sang nhị phân:

``` {.default}
10010010010010100001010101110101010010010
```

và làm điều tương tự, chia thành từng đoạn 8 bit:

``` {.default}
1 00100100 10010100 00101010 11101010 10010010
```

Vì chúng ta đang đóng gói vào byte, chúng ta nên đệm `1` đứng đầu đó thành 8 bit như sau:

``` {.default}
00000001 00100100 10010100 00101010 11101010 10010010
```

Và đó là biểu diễn byte-theo-byte của số 1.256.616.290.962.

### Biểu Diễn Byte Thập Lục Phân

Một lần nữa, không quan trọng chúng ta dùng hệ số nào --- chúng chỉ là các "ngôn ngữ" khác nhau để biểu diễn một giá trị số.

Lập trình viên thích hex vì nó rất tương thích với byte (mỗi byte là 2 chữ số hex). Hãy làm lại bảng tương tự, lần này bằng hex:

``` {.default}
00 fd    represents 00fd (253 decimal)
00 fe    represents 00fe (254 decimal)
00 ff    represents 00ff (255 decimal)
01 00    represents 0100 (256 decimal)
01 01    represents 0101 (257 decimal)
01 02    represents 0102 (258 decimal)
01 03    represents 0103 (259 decimal)
```

Nhìn lại lần nữa! Biểu diễn hex của số giống hệt hai byte ghép lại với nhau! Cực kỳ tiện lợi.

## Endianness

Sẵn sàng chứng kiến một điều bất ngờ chưa?

Tôi vừa nói với bạn rằng một số như (bằng hex):

``` {.default}
45f2
```

có thể được biểu diễn bởi hai byte này:

``` {.default}
45 f2
```

Nhưng đoán xem! Một số hệ thống sẽ biểu diễn `0x45f2` là:

``` {.default}
f2 45
```

Bị đảo ngược! Điều này giống như tôi nói "Tôi muốn 123 miếng bánh mì nướng" trong khi thực ra tôi muốn 321!

Có một tên cho việc đặt byte ngược như thế này. Chúng ta gọi những biểu diễn như vậy là _little endian_ (đầu nhỏ trước).

Điều này có nghĩa là "đầu nhỏ" của số (byte "đơn vị", nếu tôi có thể gọi như vậy) nằm ở phía trước.

Cách viết bình thường hơn, thuận chiều hơn (như chúng ta đã làm lúc đầu, nơi số `0x45f2` được biểu diễn hợp lý theo thứ tự `45 f2`) được gọi là _big endian_ (đầu lớn trước). Byte ở slot giá trị lớn nhất (cũng gọi là _byte có nghĩa nhất_) nằm ở phía trước.

Tin xấu là hầu như tất cả các mẫu CPU Intel đều là little-endian, cũng như Apple M-series. Vì vậy, hiệu quả là, tất cả mọi người.

Tin tốt là **tất cả các số mạng được truyền dưới dạng big-endian**, cách hợp lý. Vì vậy chúng ta được suy nghĩ về byte của mình theo thứ tự hợp lý.

> Và khi tôi nói "tất cả các số mạng", ý tôi là "một lượng nhất định trong số
> đó"[^---Monty Python]. Nếu cả hai bên đồng ý truyền bằng little endian, không có
> luật nào chống lại điều đó. Điều này sẽ có ý nghĩa nếu sender và receiver đều là
> kiến trúc little-endian --- tại sao lãng phí thời gian đảo ngược byte chỉ để đảo
> ngược lại? Nhưng đa số giao thức chỉ định big-endian. Và nói chung không phải là
> vấn đề thực tiễn vì hầu hết CPU có thể đảo ngược byte trong một word rất nhanh.

Thứ tự byte big-endian được gọi là _network byte order_ (thứ tự byte mạng) trong các ngữ cảnh mạng vì lý do này.

## Python và Endianness

Nếu bạn có một số trong Python, làm thế nào để chuyển đổi nó thành chuỗi byte?

May mắn thay, có một hàm tích hợp để giúp với điều đó: `.to_bytes()`.

Và có một hàm đi theo hướng ngược lại: `.from_bytes()`

Nó thậm chí cho phép bạn chỉ định endianness! Vì chúng ta sẽ dùng cái này để truyền byte qua mạng, chúng ta sẽ luôn dùng `"big"` endian.

### Chuyển Đổi Số Thành Byte

Đây là một demo trong đó chúng ta lấy số 3490 và lưu trữ nó dưới dạng bytestring 2 byte theo thứ tự big-endian.

Lưu ý rằng chúng ta truyền hai thứ vào phương thức `.to_bytes()`: số byte cho kết quả, và `"big"` nếu là big-endian, hoặc `"little"` nếu là little endian.

> Các phiên bản Python mới hơn mặc định là `"big"`. Trong các phiên bản cũ hơn,
> bạn vẫn phải rõ ràng.

``` {.default}
n = 3490

bytes = n.to_bytes(2, "big")
```

Nếu chúng ta in chúng ra chúng ta sẽ thấy các giá trị byte:

``` {.default}
for b in bytes:
    print(b)
```

``` {.default}
13
162
```

Đó là các giá trị byte big-endian tạo nên số 3490. Chúng ta có thể xác minh rằng `13 * 256 + 162 == 3490` dễ dàng.

Nếu bạn thử lưu trữ số 70.000 trong hai byte, bạn sẽ gặp `OverflowError`. Hai byte không đủ lớn để lưu trữ các giá trị trên 65535 --- bạn sẽ cần thêm một byte.

Hãy làm thêm một ví dụ nữa bằng hex:

``` {.py}
n = 0xABCD
bytes = n.to_bytes(2, "big")

for b in bytes:
    print(f"{b:02X}")  # Print in hex
```

in ra:

``` {.default}
AB
CD
```

Đó là các chữ số giống hệt giá trị gốc được lưu trong `n`!

### Chuyển Đổi Byte Trở Lại Thành Số

Hãy xem đầy đủ. Chúng ta sẽ tạo một số hex và chuyển đổi nó thành byte, như chúng ta đã làm trong phần trước. Sau đó chúng ta thậm chí sẽ in ra bytestring để xem nó trông như thế nào.

Sau đó chúng ta sẽ chuyển đổi bytestring đó trở lại thành số và in nó ra để đảm bảo nó khớp với bản gốc.

``` {.py}
n = 0x0102
bytes = n.to_bytes(2, "big")

print(bytes)
```

cho kết quả đầu ra:

``` {.py}
b'\x01\x02'
```

Chữ `b` ở phía trước có nghĩa là đây là bytestring (trái ngược với string thông thường) và `\x` là escape sequence xuất hiện trước một số hex 2 chữ số.

Vì số gốc của chúng ta là `0x0102`, nên điều hợp lý là hai byte trong bytestring có giá trị `\x01` và `\x02`.

Bây giờ hãy chuyển đổi chuỗi đó trở lại và in bằng hex:

``` {.py}
v = int.from_bytes(bytes, "big")

print(f"{v:04x}")
```

Và cái đó in ra:

``` {.default}
0102
```

giống hệt giá trị gốc của chúng ta!

## Suy Ngẫm

* Chỉ dùng các phương thức `.to_bytes()` và `.from_bytes()`, làm thế nào bạn có thể
  đổi chỗ thứ tự byte trong một số 2-byte? (Tức là đảo ngược các byte.)
  Làm thế nào bạn có thể làm điều đó mà không dùng bất kỳ vòng lặp hay phương thức nào khác? (Gợi ý:
  `"big"` và `"little"`!)

* Mô tả theo cách hiểu của bạn sự khác biệt giữa Big-Endian và
  Little-Endian.

* Network Byte Order là gì?

* Tại sao không chỉ gửi toàn bộ số cùng một lúc thay vì chia nó thành
  byte?

* Little-endian có vẻ ngược chiều. Tại sao nó tồn tại? Hãy tìm kiếm
  một chút trên Internet để trả lời câu hỏi này.
