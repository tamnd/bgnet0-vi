# Giao thức Internet phiên bản 6 (IPv6)

Đây là điều lớn lao mới! Vì chỉ có quá ít địa chỉ biểu diễn được trong 32 bit (chỉ 4.294.967.296 địa chỉ, chưa tính các địa chỉ dành riêng), những người có quyền lực đã quyết định chúng ta cần một sơ đồ đánh địa chỉ mới. Một sơ đồ có nhiều bit hơn. Một sơ đồ có thể tồn tại, theo mọi nghĩa thực tế, mãi mãi.

Vấn đề là: chúng ta đang cạn kiệt địa chỉ IP. Vào những năm 1970, một thế giới với hàng tỷ máy tính là điều ngoài sức tưởng tượng. Nhưng ngày nay, chúng ta đã vượt quá con số đó nhiều bậc độ lớn.

Vì vậy họ quyết định tăng kích thước địa chỉ IP từ 32 bit lên 128 bit, cho chúng ta nhiều hơn 79.228.162.514.264.337.593.543.950.336 lần không gian địa chỉ. Cái này chắc chắn sẽ tồn tại được một thời gian rất, rất dài.

> Nhiều không gian địa chỉ trong số này được dành riêng, nên thực ra không có đến
> nhiều địa chỉ như vậy. Nhưng vẫn còn **RẤT NHIỀU**, dù đo theo hệ thống nào.

Đó là sự khác biệt chính giữa IPv4 và IPv6.

Để minh họa, chúng ta sẽ tiếp tục dùng IPv4 vì nó vẫn phổ biến và dễ viết hơn một chút. Nhưng đây là thông tin nền tảng tốt cần biết, vì một ngày nào đó IPv6 sẽ là thứ duy nhất còn lại.

Một ngày nào đó.

## Biểu diễn

Với không gian địa chỉ lớn như vậy, cách viết dấu chấm-và-thập phân (dots-and-decimal) không còn phù hợp nữa. Vì vậy họ nghĩ ra một cách mới để hiển thị địa chỉ IPv6: dấu hai chấm-và-hex (colons-and-hex). Mỗi số hex là 16 bit (4 chữ số hex), nên chúng ta cần 8 số đó để đạt 128 bit.

Ví dụ:

``` {.default}
2001:0db8:6ffa:8939:163b:4cab:98bf:070a
```

Ký hiệu slash (dấu gạch chéo) được dùng để chia subnet (mạng con) giống như IPv4. Đây là ví dụ với 64 bit cho phần network (được chỉ định bởi `/64`) và 64 bit cho phần host (vì `128-64=64`):

``` {.default}
2001:0db8:6ffa:8939:163b:4cab:98bf:070a/64
```

64 bit cho host! Điều đó có nghĩa là subnet này có thể có 18.446.744.073.709.551.616 host!

Có rất nhiều không gian trong một địa chỉ IPv6!

> Khi nói về địa chỉ IPv6 tiêu chuẩn cho các host cụ thể,
> `/64` là quy tắc được khuyến nghị mạnh mẽ cho kích thước subnet của bạn. Một số
> giao thức dựa vào điều này.
>
> Nhưng khi chỉ nói về các subnet, bạn có thể thấy các con số nhỏ hơn ở đó
> đại diện cho không gian địa chỉ lớn hơn. Nhưng kỳ vọng là cuối cùng không gian đó
> sẽ được phân chia thành các subnet `/64` để sử dụng bởi các host riêng lẻ.

Bây giờ, viết hết tất cả những số hex đó rất cồng kềnh, đặc biệt nếu có nhiều chuỗi số không trong đó. Vì vậy có một vài quy tắc rút gọn.

1. Các số 0 đứng đầu của bất kỳ số 16-bit nào có thể được bỏ đi.
2. Các chuỗi nhiều số không sau khi áp dụng quy tắc 1 có thể được thay thế
   bằng hai dấu hai chấm liên tiếp.

Ví dụ, chúng ta có thể có địa chỉ:

``` {.default}
2001:0db8:6ffa:0000:0000:00ab:98bf:070a
```

Áp dụng quy tắc đầu tiên và loại bỏ các số 0 đứng đầu:

``` {.default}
2001:db8:6ffa:0:0:ab:98bf:70a
```

Và chúng ta thấy có một chuỗi hai `0` ở giữa, có thể thay thế bằng hai dấu hai chấm:

``` {.default}
2001:db8:6ffa::ab:98bf:70a
```

Theo cách này chúng ta có thể có được biểu diễn gọn hơn.

## Địa chỉ Link-Local

[Đây là thông tin "nên biết", nhưng chỉ cần ghi nhớ dưới dạng "IPv6 tự động cấp địa chỉ IP cho tất cả các interface".]

Có các địa chỉ trong IPv6 và IPv4 được dành riêng cho các host trên LAN (mạng cục bộ) cụ thể này. Chúng không được dùng phổ biến trong IPv4, nhưng bắt buộc phải có trong IPv6. Tất cả các địa chỉ này thuộc subnet `fe80::/10`.

> Khai triển đầy đủ, đây là:
> ``` {.default}
> fe80:0000:0000:0000:0000:0000:0000:0000
> ```

10 bit đầu là phần mạng. Trong một địa chỉ link-local IPv6, 54 bit tiếp theo được dành riêng (`0`) và sau đó còn lại 64 bit để xác định host.

Khi một interface IPv6 được khởi động, nó tự động tính toán địa chỉ link-local của mình dựa trên địa chỉ Ethernet và các thông tin khác.

Địa chỉ link-local là duy nhất trên LAN, nhưng có thể không là duy nhất toàn cầu. Router không chuyển tiếp bất kỳ gói tin link-local nào ra khỏi LAN để tránh các vấn đề với IP trùng lặp.

Một interface có thể nhận được IP khác sau đó nếu một máy chủ DHCP cấp phát, ví dụ như vậy, lúc đó nó sẽ có hai IP.

## Các Địa Chỉ và Subnet IPv6 Đặc Biệt

Giống như IPv4, có nhiều địa chỉ mang ý nghĩa đặc biệt.

* **`::1`** - localhost, máy tính này, phiên bản IPv6 của `127.0.0.1`
* **`2001:db8::/32`** - dùng trong tài liệu hướng dẫn
* **`fe80::/10`** - địa chỉ link local

Có các dải IPv6 khác với ý nghĩa đặc biệt, nhưng đó là những dải phổ biến bạn sẽ thấy.

## IPv6 và DNS

DNS cũng ánh xạ các tên mà con người có thể đọc sang địa chỉ IPv6. Bạn có thể tra cứu chúng bằng `dig` bằng cách yêu cầu nó tìm bản ghi `AAAA` (đó là tên DNS đặt cho bản ghi địa chỉ IPv6).

``` {.default}
$ dig example.com AAAA
```

``` {.default}
; <<>> DiG 9.10.6 <<>> example.com AAAA
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 13491
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;example.com.			IN	AAAA

;; ANSWER SECTION:
example.com.		81016	IN	AAAA	2606:2800:220:1:248:1893:25c8:1946

;; Query time: 14 msec
;; SERVER: 1.1.1.1#53(1.1.1.1)
;; WHEN: Wed Sep 28 16:05:16 PDT 2022
;; MSG SIZE  rcvd: 68
```

Bạn có thể thấy địa chỉ IPv6 của `example.com` trong phần `ANSWER SECTION` ở trên.

## IPv6 và URL

Vì URL dùng ký tự `:` để phân tách số cổng, nghĩa đó xung đột với các ký tự `:` được dùng trong địa chỉ IPv6.

Nếu bạn chạy máy chủ trên cổng 33490, bạn có thể kết nối đến nó trong trình duyệt web bằng cách đặt địa chỉ IPv6 trong dấu ngoặc vuông. Ví dụ, để kết nối đến localhost tại địa chỉ `::1`, bạn có thể:

``` {.default}
http://[::1]:33490/
```

## Suy Ngẫm

* IPv6 có những ưu điểm gì so với IPv4?

* Địa chỉ `2001:0db8:004a:0000:0000:00ab:ab4d:000a` có thể được viết đơn giản hơn như thế nào?
