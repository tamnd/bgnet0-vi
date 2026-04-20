# Dự án: Đào thông tin DNS

Tiện ích `dig` là một công cụ dòng lệnh tuyệt vời để lấy thông tin
DNS từ name server mặc định của bạn, hoặc từ bất kỳ name server nào.

## Cài đặt (Installation)

Trên Mac:

``` {.sh}
brew install bind
```

Trên WSL:

``` {.sh}
sudo apt install dnsutils
```

## Thử ngay thôi (Try it Out)

Gõ:

``` {.sh}
dig example.com
```

và xem kết quả trả về.

``` {.default}
; <<>> DiG 9.10.6 <<>> example.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 60465
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;example.com.                   IN      A

;; ANSWER SECTION:
example.com.            79753   IN      A       93.184.216.34

;; Query time: 23 msec
;; SERVER: 1.1.1.1#53(1.1.1.1)
;; WHEN: Fri Nov 18 18:37:13 PST 2022
;; MSG SIZE  rcvd: 56
```

Nhiều thứ lắm nhỉ. Nhưng hãy nhìn vào những dòng này:

``` {.default}
;; ANSWER SECTION:
example.com.            79753   IN      A       93.184.216.34
```

Đó là địa chỉ IP của `example.com`! Thấy chữ `A` không? Nghĩa là đây
là một bản ghi địa chỉ (address record).

Bạn cũng có thể lấy các loại bản ghi khác. Muốn xem mail exchange
server của `oregonstate.edu` không? Thêm vào dòng lệnh thôi:

``` {.sh}
dig mx oregonstate.edu
```

Kết quả:

``` {.default}
;; ANSWER SECTION:
oregonstate.edu. 600 IN MX 5 oregonstate-edu.mail.protection.outlook.com.
```

Hoặc muốn xem name servers của `example.com`:

``` {.sh}
dig ns example.com
```

## Time To Live (TTL)

Nếu bạn `dig` một bản ghi `A`, bạn sẽ thấy một con số trên dòng đó:

``` {.default}
;; ANSWER SECTION:
example.com.            78236   IN      A       93.184.216.34
```

Ở đây là `78236`. Đây là TTL (thời gian tồn tại) của một mục trong
cache. Con số này cho biết name server bạn dùng đã cache địa chỉ IP
đó, và cache này sẽ không hết hạn cho đến khi còn 78.236 giây nữa.
(Để tham khảo: một ngày có 86.400 giây.)

## Authoritative Servers (Máy chủ có thẩm quyền)

Nếu bạn nhận được một mục đã được cache trong name server của mình,
bạn sẽ thấy `AUTHORITY: 0` trong output của `dig`:

``` {.default}
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
                                            ^^^^^^^^^^^^
```

Nhưng nếu mục đó đến trực tiếp từ name server chịu trách nhiệm cho
tên miền đó, bạn sẽ thấy `AUTHORITY: 1` (hoặc một số dương nào đó).

## Lấy Root Name Servers

Chỉ cần gõ `dig` và nhấn Enter, bạn sẽ thấy tất cả các root DNS
server, gồm cả địa chỉ IPv4 (loại bản ghi `A`) lẫn IPv6 (loại bản
ghi `AAAA`).

## Đào tại một Name Server cụ thể

Nếu biết name server mà bạn muốn truy vấn, dùng dấu `@` để chỉ định
server đó.

Hai name server miễn phí phổ biến là `1.1.1.1` và `8.8.8.8`.

Hãy hỏi một trong số đó về IP của `example.com`:

``` {.sh}
dig @8.8.8.8 example.com
```

Và ta nhận được câu trả lời như mong đợi. (Tuy TTL có thể khác ---
đây là các server khác nhau, cache của chúng có tuổi khác nhau mà.)

## Đào tại một Root Name Server

Có khá nhiều root name server, vậy hãy `dig` `example.com` tại một
trong số đó:

``` {.sh}
dig @l.root-servers.net example.com
```

Ta nhận được kết quả thú vị:

``` {.default}
com.                    172800  IN      NS      a.gtld-servers.net.
com.                    172800  IN      NS      b.gtld-servers.net.
com.                    172800  IN      NS      c.gtld-servers.net.
com.                    172800  IN      NS      d.gtld-servers.net.
```

và còn nhiều nữa.

Không thấy `example.com` đâu cả... và nhìn kìa --- đó là các bản ghi
`NS`, tức name servers.

Root server đang nói với ta rằng: "Tao không biết `example.com` là
ai, nhưng đây là mấy name server biết `.com` là cái gì."

Vậy ta chọn một trong số đó và `dig` tiếp:

``` {.sh}
dig @c.gtld-servers.net example.com
```

Và ta nhận được:

``` {.default}
example.com.            172800  IN      NS      a.iana-servers.net.
example.com.            172800  IN      NS      b.iana-servers.net.
```

Lại cùng kiểu đó, thêm các bản ghi `NS`. Name server `c.gtld-servers.net`
đang nói: "Tao không biết IP của `example.com`, nhưng đây là mấy name
server có thể biết!"

Vậy ta thử lại:

``` {.sh}
dig @a.iana-servers.net example.com
```

Và cuối cùng ta nhận được bản ghi `A` với địa chỉ IP!

``` {.default}
example.com.            86400   IN      A       93.184.216.34
```

Bạn cũng có thể dùng `+trace` trên dòng lệnh để theo dõi toàn bộ
quá trình truy vấn từ đầu đến cuối:

``` {.sh}
dig +trace example.com
```

## Việc cần làm (What to Do)

Thử trả lời các câu hỏi sau:

* Địa chỉ IP của `microsoft.com` là gì?
* Mail exchange của `google.com` là gì?
* Các name server của `duckduckgo.com` là gì?
* Theo quy trình ở phần Đào tại Root Name Server ở trên, bắt đầu từ
  một root name server và đào dần xuống đến `www.yahoo.com` (**KHÔNG**
  phải `yahoo.com`).

  Lưu ý rằng quá trình này kết thúc bằng một bản ghi `CNAME`! Bạn sẽ
  phải lặp lại quy trình với alias được đặt tên trong bản ghi `CNAME`
  đó, bắt đầu lại từ root server.

  Thêm vào tài liệu của bạn các lệnh `dig` bạn đã dùng để lấy địa chỉ
  IP. Mỗi lệnh `dig` phải có `@` một name server khác nhau, bắt đầu
  từ root.

<!-- Rubric

5
Submission properly shows IP of www.oregonstate.edu

5
Submission properly shows MX for google.com

5
Submission properly shows name servers for oregonstate.edu

15
Submission properly shows all dig queries to get the IP address of www.yahoo.com

-->
