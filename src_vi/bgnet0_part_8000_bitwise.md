# Phụ lục: Phép Toán Bitwise {#appendix-bitwise}

Trong phần này, ta sẽ ôn lại _phép toán bitwise_ (bitwise operations).

Các toán tử bitwise trong một ngôn ngữ thao tác trên các bit của số.
Các toán tử này hoạt động như thể một số được biểu diễn dưới dạng nhị phân, dù thực
tế không phải vậy. Chúng có thể làm việc với số ở bất kỳ cơ số nào trong Python,
nhưng với con người, nhìn dưới dạng nhị phân sẽ dễ hiểu nhất.

> Mẹo: nhớ rằng các cơ số khác nhau như hex, nhị phân, và thập phân chỉ là những
> cách khác nhau để viết xuống một giá trị. Giống như các ngôn ngữ khác nhau để
> biểu diễn cùng một giá trị số vậy.
>
> Khi một giá trị được lưu trong một biến, tốt nhất hãy nghĩ nó tồn tại thuần túy
> dưới dạng số --- không có cơ số. Chỉ khi bạn viết xuống (trong code hoặc in ra)
> thì cơ số mới quan trọng.
>
> Ví dụ, Python in mọi thứ theo thập phân (cơ số 10) theo mặc định. Nó có nhiều
> phương thức để ghi đè điều đó và xuất ra theo cơ số khác.

Ta sẽ xem xét:

* Viết code các cơ số khác nhau trong Python
* In các cơ số khác nhau trong Python
* Bitwise-AND
* Bitwise-OR
* Bitwise-NOT
* Dịch bit (Bitwise shift)
* Thiết lập một số bit `1` nhất định

## Viết Code Các Cơ Số Khác Nhau trong Python

`110101` có giá trị là bao nhiêu?

Não bạn có thể nghĩ tôi đang hỏi "Số nhị phân này là bao nhiêu trong thập phân?"
Nhưng bạn nhầm rồi!

Tôi không chỉ định cơ số cùng với số đó, nên bạn không biết nó là nhị phân, thập
phân hay hex!

Để rõ ràng, ý tôi là thập phân, vậy nó là một trăm mười nghìn một trăm lẻ một.

Python và hầu hết các ngôn ngữ khác giả định các số trong code của bạn là thập phân
trừ khi bạn chỉ định khác.

Nếu bạn muốn nó ở cơ số khác, bạn phải thêm tiền tố (prefix) để chỉ định cơ số.

Các tiền tố là:

<!-- CAPTION: Python Number Base Prefixes -->
|Cơ số|Tên cơ số|Tiền tố|
|-|-|-|
|2|Nhị phân (Binary)|`0b`|
|8|Bát phân (Octal)|`0o`|
|10|Thập phân (Decimal)|Không có|
|16|Thập lục phân (Hexadecimal)|`0x`|

Vậy hãy viết một số theo các cơ số khác nhau:

``` {.default}
  110101 decimal!
0b110101 binary!
0x110101 hex!
```

Nhìn vào giá trị thập phân `3490`. Tôi có thể chuyển nó sang hex và ra `0xda2`.

Điều quan trọng cần nhớ là hai giá trị này giống hệt nhau:

``` {.py}
>>> 3490 == 0xda2
True
```

Chỉ là "ngôn ngữ" khác nhau để biểu diễn cùng một giá trị mà thôi.

## In và Chuyển Đổi

Nhớ rằng không có khái niệm giá trị "được lưu dưới dạng hex" hay "được lưu dưới dạng
thập phân" trong một biến. Biến chỉ lưu một giá trị số thuần túy và ta không nên nghĩ
nó có cơ số.

Nó chỉ có cơ số khi ta viết trong code hoặc in ra. Khi đó ta phải chỉ định cơ số.
(Mặc dù Python dùng thập phân theo mặc định trong mọi trường hợp.)

Bạn có thể chuyển một giá trị sang chuỗi hex bằng hàm `hex()`. Tất cả các giá trị
"được chuyển đổi" đều trở thành chuỗi. Thì phải là gì khác nào?

``` {.py}
>>> print(hex(3490))
0xda2
```

Bạn có thể chuyển một giá trị sang chuỗi nhị phân bằng hàm `bin()`.

``` {.py}
>>> print(bin(3490))
0b110110100010
```

Bạn cũng có thể dùng f-string để làm điều đó:

``` {.py}
>>> print(f"3490 is {3490:x} in hex and {3490:b} in binary")
3490 is da2 in hex and 110110100010 in binary
```

F-string có tính năng hay là có thể đệm đến độ rộng trường bằng số không. Giả sử
bạn muốn biểu diễn số hex 8 chữ số, bạn có thể làm như sau:

``` {.py}
>>> print(f"3490 is {3490:08x} in hex")
3490 is 00000da2 in hex
```

## Bitwise-AND

Bitwise-AND kết hợp hai số với nhau bằng phép AND. Kết quả của phép AND là `1`
nếu cả hai bit đầu vào đều là `1`. Ngược lại là `0`.

<!-- CAPTION: Bitwise-AND Truth Table -->
|A|B|A AND B|
|:-:|:-:|:-:|
|0|0|0|
|0|1|0|
|1|0|0|
|1|1|1|

Hãy làm một ví dụ và AND hai số nhị phân với nhau. Bitwise-AND dùng toán tử
ampersand (`&`) trong Python và nhiều ngôn ngữ khác.

``` {.default}
  0     0     1     1
& 0   & 1   & 0   & 1
---   ---   ---   ---
  0     0     0     1
```

Bạn thấy kết quả là `1` chỉ khi cả hai bit đầu vào đều là `1`.

Các đầu vào lớn hơn được AND theo từng cặp bit riêng lẻ, chính là những gì xuất
hiện ở mỗi cột của các số lớn bên dưới. (Để hoàn chỉnh, kết quả thập phân được
hiển thị ở bên phải, nhưng nó được suy ra từ biểu diễn nhị phân. Không dễ để
nhìn hai số thập phân và suy ra bitwise-AND của chúng.)

``` {.default}
  0100011111000101010      146986
& 1001111001001111000    & 324216
---------------------    --------
  0000011001000101000       12840
```

Thấy cách mỗi bit đầu ra là `1` chỉ khi cả hai bit trong cột phía trên nó đều là `1`.

## Bitwise-OR

Bitwise-OR kết hợp hai số với nhau bằng phép OR. Kết quả của phép OR là `1`
nếu một trong hai hoặc cả hai bit đầu vào là `1`. Ngược lại là `0`.

<!-- CAPTION: Bitwise-OR Truth Table -->
|A|B|A OR B|
|:-:|:-:|:-:|
|0|0|0|
|0|1|1|
|1|0|1|
|1|1|1|

Hãy làm một ví dụ và OR hai số nhị phân với nhau. Bitwise-OR dùng toán tử
pipe (`|`) trong Python và nhiều ngôn ngữ khác.

``` {.default}
  0     0     1     1
| 0   | 1   | 0   | 1
---   ---   ---   ---
  0     1     1     1
```

Bạn thấy kết quả là `1` nếu một trong hai bit đầu vào là `1`.

Các đầu vào lớn hơn được OR theo từng cặp bit riêng lẻ, chính là những gì xuất
hiện ở mỗi cột của các số lớn bên dưới. (Để hoàn chỉnh, kết quả thập phân được
hiển thị ở bên phải, nhưng nó được suy ra từ biểu diễn nhị phân. Không dễ để
nhìn hai số thập phân và suy ra bitwise-OR của chúng.)

``` {.default}
  0100011111000101010      146986
| 1001111001001111000    | 324216
---------------------    --------
  1101111111001111010      458362
```

Thấy cách mỗi bit đầu ra là `1` nếu một trong hai hoặc cả hai bit trong cột phía
trên nó là `1`.

## Bitwise-NOT

Bitwise-NOT _đảo ngược_ một giá trị bằng cách đổi tất cả bit `1` thành `0` và
tất cả bit `0` thành `1`. Đây là toán tử đơn nguyên (unary) --- chỉ hoạt động
trên một số duy nhất.

<!-- CAPTION: Bitwise-NOT Truth Table -->
|A|NOT A|
|:-:|:-:|
|0|1|
|1|0|

Hãy làm một ví dụ và NOT một số bit đơn. Bitwise-NOT dùng toán tử
tilde (`~`) trong Python và nhiều ngôn ngữ khác.

``` {.default}
~ 0   ~ 1
---   ---
  1     0
```

Bạn thấy kết quả đơn giản là lật sang giá trị bit kia.

Các đầu vào lớn hơn được NOT theo từng bit riêng lẻ, chính là những gì xuất
hiện ở mỗi cột của các số lớn bên dưới. (Để hoàn chỉnh, kết quả thập phân được
hiển thị ở bên phải, nhưng nó được suy ra từ biểu diễn nhị phân. Không dễ để
nhìn hai số thập phân và suy ra bitwise-NOT của chúng.)

``` {.default}
~ 0100011111000101010    ~ 146986
---------------------    --------
  1011100000111010101      377301
```

Thấy cách mỗi bit đầu ra là `1` chỉ khi cả hai bit trong cột phía trên nó đều là `1`.

Lưu ý Python: bitwise-NOT của một số thường âm vì Python dùng số học độ chính xác
tùy ý. Nếu bạn cần nó là dương, hãy bitwise-AND kết quả với số bit `1` bạn cần
để biểu diễn giá trị cuối cùng. Ví dụ, để lấy một byte với `37` bị đảo ngược,
bạn có thể làm bất kỳ cách nào trong số này:

``` {.py}
(~37) & 255
(~37) & 0xff
(~37) & 0b11111111
```

(Vì tất nhiên, đó đều là cùng một số ở các cơ số khác nhau!)

## Dịch Bit (Bitwise Shift)

Đây là cái thú vị. Dùng thứ này, bạn có thể di chuyển một số qua lại một số bit nhất định.

Xem cách ta di chuyển tất cả bit sang trái 2 trong ví dụ này:

``` {.default}
000111000111  left shifted by 2 is:
011100011100
```

Hoặc ta có thể dịch phải:

``` {.default}
000111000111  right shifted by 2 is:
000001110001  
```

Các bit mới ở trái hoặc phải được đặt thành không, và các bit rơi ra ngoài sẽ biến
mất mãi mãi.

> Tôi đang nói dối một chút vì cách nhiều ngôn ngữ xử lý dịch phải của số âm. Nếu
> bạn dịch phải một số âm, các bit mới có thể là `1` thay vì `0` tùy thuộc vào
> ngôn ngữ. Python dùng số học nguyên độ chính xác tùy ý, vì vậy thực ra có vô số
> bit `1` ở bên trái của bất kỳ số âm nào trong Python, làm mọi thứ còn kỳ lạ hơn.
>
> Bây giờ, tốt nhất chỉ nghĩ về số dương thôi.

Toán tử là `<<` cho dịch trái và `>>` cho dịch phải trong hầu hết các ngôn ngữ
(xin lỗi Ruby!). Hãy làm một ví dụ:

``` {.py}
>>> v = 0b00000101
>>> print(f"{v << 2:08b}")
00010100
```

Ở đây ta có một byte ở dạng nhị phân và ta dịch trái nó 2 bit với `v << 2`.
Và bạn có thể thấy `101` đã di chuyển sang trái 2 bit!

## Thiết Lập Một Số Bit `1` Nhất Định

Đây là một thủ thuật bit nhỏ ta có thể dùng nếu muốn lấy một số với một số bit
liên tiếp được thiết lập thành `1`.

Ví dụ, nếu tôi muốn một số với 12 bit được thiết lập thành một, cụ thể là:

``` {.py}
0b111111111111
```

Tôi phải làm gì?

Ta có thể tận dụng một vài thủ thuật ở đây. Bắt đầu với thủ thuật #1.

Nếu bạn muốn thiết lập bit thứ n thành `1` (trong đó bit ngoài cùng bên phải
là bit số 0), bạn có thể nâng 2 lên lũy thừa đó và đến đích.

Hãy thiết lập bit #5 thành 1. Ta lấy `2**5` ra `32`. Và `32` ở dạng nhị phân
là `100000`. Đây rồi.

Tùy chọn khác là dịch trái `1` đi 5 bit: `1 << 5` là `100000` ở nhị phân,
tức là `32` thập phân.

Cách đó hoạt động được.

Nhưng làm thế nào để đến được chuỗi bit `1` của chúng ta từ đó?

Xem cái này: 32 trừ 1 bằng bao nhiêu? 31. Không phải câu hỏi đánh lừa. Nhưng
hãy nhìn chúng ở dạng nhị phân:

``` {.default}
32   100000
31   011111
```

Ồ! Là một chuỗi `1`! Không những thế, còn là chuỗi 5 bit `1`, đúng như ta
muốn! (Điều này tương tự như phép trừ trong thập phân. 10,000 - 1 = 9,999.
Chỉ là trong nhị phân ta tràn sang tất cả `1`, không phải `9`.)

``` {.py}
run_of_ones = (1 << count) - 1
```

Đây là chuỗi 12 bit `1` của ta:

``` {.py}
>>> bin((1 << 12) - 1)
'0b111111111111'
```

Nếu bạn thích những _thủ thuật bit_ (bit-twiddling hacks) kiểu này, bạn có thể
thích cuốn sách [Hacker's
Delight](https://en.wikipedia.org/wiki/Hacker%27s_Delight). Chương 2, bao gồm
nhiều kỹ thuật như vậy đã từng được phân phối miễn phí; bạn có thể tìm thấy
PDF trôi nổi đâu đó.

## Suy Ngẫm

* `2342 & 2332` bằng bao nhiêu?

* `0b110101 | 112` bằng bao nhiêu?

* `~0b101010010101` ở dạng nhị phân là bao nhiêu? (Python sẽ hiển thị kết quả
  là một số âm, nhưng bạn có thể đưa nó về dương bằng cách AND với
  `0b111111111111`. Và đừng quên Python bỏ qua các số không đứng đầu khi in!)

* `16 << 1` bằng bao nhiêu?

* `64 << 1` bằng bao nhiêu?

* `4200 << 1` bằng bao nhiêu? Thấy quy luật không?

* `16 >> 2` bằng bao nhiêu?

* `0b11100111 << 3` bằng bao nhiêu?

* `(1 << 8) - 1` bằng bao nhiêu?

* `0x01020304 & ((1 << 16) - 1)` bằng bao nhiêu?

<!--

Answers:

2342 & 2332
2308	0x904	0b100100000100

0b110101 | 112
117	0x75	0b1110101

(~0b101010010101)&0b111111111111
1386	0x56a	0b10101101010

16 << 1
32

64 << 1
128

4200 << 1
8400   Doubles

16 >> 2
4

0b11100111 << 3
1848	0x738	0b11100111000

 ~ %  (1 << 8) - 1
255	0xff	0b11111111

0x01020304 & ((1 << 16) - 1)
772	0x304	0b1100000100

-->
