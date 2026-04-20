# Hệ Thống Tên Miền (DNS)

Chúng ta đã biết IP chịu trách nhiệm định tuyến lưu lượng (routing traffic) trên
Internet. Chúng ta cũng biết nó làm điều đó với _địa chỉ IP_ (IP addresses), mà ta
thường biểu diễn dạng chấm-số (dots-and-numbers) cho IPv4, ví dụ `10.1.2.3`.

Nhưng là con người, chúng ta hiếm khi dùng địa chỉ IP. Khi bạn dùng trình duyệt
web, bạn thường không nhập địa chỉ IP vào thanh địa chỉ.

Ngay trong các dự án của chúng ta, ta cũng thường gõ `localhost` thay vì địa chỉ
localhost `127.0.0.1`.

Quá trình chung để chuyển đổi một tên như `www.example.com` mà con người dùng thành
địa chỉ IP mà máy tính dùng được gọi là _phân giải tên miền_ (domain name
resolution), và được cung cấp bởi một nhóm server phân tán tạo thành _Hệ Thống Tên
Miền_ (Domain Name System), hay DNS.

## Sử Dụng Thông Thường

Từ góc nhìn người dùng, chúng ta cấu hình thiết bị của mình có một "name server"
(máy chủ tên miền) để liên hệ khi cần chuyển đổi tên thành địa chỉ IP. (Có lẽ điều
này được cấu hình qua DHCP, nhưng sẽ nói thêm về sau.)

Khi bạn cố kết nối đến `example.com`, máy tính của bạn liên hệ name server đó để
lấy địa chỉ IP.

Nếu name server đó biết câu trả lời, nó cung cấp ngay. Nhưng nếu không, thì một
loạt guồng máy bắt đầu chuyển động.

Hãy bắt đầu đào sâu vào quá trình đó.

## Tên Miền và Địa Chỉ IP

Nếu bạn chưa bao giờ đăng ký tên miền (như `example.com` hay `oregonstate.edu` hay
`google.com` hay `army.mil`), quy trình đại khái như sau:

1. Liên hệ một _nhà đăng ký tên miền_ (domain registrar) --- tức là công ty có thẩm
   quyền bán tên miền.
2. Chọn tên miền chưa ai đăng ký.
3. Trả tiền hàng năm để dùng tên miền đó.
4. ...
5. Kiếm tiền!

Nhưng việc này hoàn toàn tách biệt khỏi khái niệm địa chỉ IP. Thật vậy, tên miền
có thể tồn tại mà không cần địa chỉ IP --- chỉ là không dùng được thôi.

Khi đã có tên miền, bạn có thể liên hệ công ty hosting để họ cung cấp địa chỉ IP
trên một server mà bạn có thể dùng.

Vậy là bạn có hai mảnh: tên miền và địa chỉ IP.

Nhưng bạn vẫn phải kết nối chúng lại để người khác có thể tra cứu IP của bạn khi
họ có tên miền.

Để làm điều này, bạn thêm một bản ghi cơ sở dữ liệu với thông tin liên quan vào một
server thuộc hệ sinh thái DNS: một _domain name server_ (máy chủ tên miền).

## Máy Chủ Tên (Name Servers)

Thường được gọi tắt là _name servers_, các server này chứa bản ghi IP cho tên miền
mà chúng có _thẩm quyền_ (authority). Tức là, một name server không có bản ghi cho
cả thế giới; nó chỉ có cho một tên miền hoặc subdomain cụ thể.

> Một _subdomain_ (tên miền con) là tên miền do chủ sở hữu của một tên miền quản lý.
> Ví dụ, chủ của `example.com` có thể tạo subdomain `sub1.example.com` và
> `sub2.example.com`. Chúng không phải là host trong trường hợp này --- nhưng chúng
> có thể có host riêng, ví dụ `host1.sub1.example.com`, `host2.sub1.example.com`,
> `somecompy.sub2.example.com`.
>
> Chủ tên miền có thể tạo bao nhiêu subdomain tùy thích. Chỉ cần đảm bảo có name
> server được thiết lập để xử lý chúng.

Name server có thẩm quyền cho một tên miền cụ thể có thể được hỏi về bất kỳ host
nào trên tên miền đó.

Host thường là "từ" đầu tiên của tên miền, mặc dù không nhất thiết phải vậy.

Ví dụ với `www.example.com`, host là máy tính tên `www` trên tên miền `example.com`.

Một name server có thể có thẩm quyền cho nhiều tên miền.

Nhưng ngay cả khi name server không biết địa chỉ IP của tên miền được hỏi, nó có
thể liên hệ các name server khác để tìm ra. Từ góc nhìn người dùng, quá trình này
hoàn toàn trong suốt (transparent).

Vậy là đơn giản. Nếu mình không biết tên miền đó, mình chỉ cần liên hệ name server
của tên miền đó và lấy câu trả lời từ họ, phải không?

## Máy Chủ Tên Gốc (Root Name Servers)

Chúng ta có một vấn đề ở đây. Làm sao tôi có thể kết nối với name server của một
tên miền nếu tôi không biết name server đó là cái nào?

Để giải quyết điều này, chúng ta có một số _root name servers_ (máy chủ tên gốc)
có thể giúp chúng ta. Khi không biết IP, ta có thể bắt đầu từ chúng và yêu cầu họ
cho biết IP, hoặc chỉ cho ta hỏi server nào khác. Sẽ nói thêm về quá trình đó sau.

Máy tính được cấu hình sẵn với địa chỉ IP của 13 root name server. Các IP này hiếm
khi thay đổi, và chỉ cần một trong số chúng là đủ. Máy tính thực hiện DNS thường
xuyên truy xuất danh sách này để cập nhật.

Các root name server được đặt tên từ `a` đến `m`:

``` {.default}
a.root-servers.net
b.root-servers.net
c.root-servers.net
...
k.root-servers.net
l.root-servers.net
m.root-servers.net
```

## Ví Dụ Chạy

Hãy bắt đầu bằng cách tra cứu một máy tính tên `www.example.com`. Ta cần biết địa
chỉ IP của nó. Ta không biết name server nào chịu trách nhiệm cho tên miền
`example.com`. Tất cả những gì ta biết là danh sách root name server của mình.

1. Hãy chọn một root server ngẫu nhiên, ví dụ `c.root-servers.net`. Ta liên hệ nó
   và nói: "Này, chúng tôi đang tìm `www.example.com`. Bạn có thể giúp không?"

   Nhưng root name server không biết điều đó. Nó nói: "Tôi không biết điều đó, nhưng
   tôi có thể cho bạn biết rằng nếu bạn đang tìm tên miền `.com` nào đó, bạn có thể
   liên hệ bất kỳ name server nào trong số này." Nó đính kèm danh sách các name
   server biết về tên miền `.com`:

   ``` {.default}
   a.gtld-servers.net
   b.gtld-servers.net
   c.gtld-servers.net
   d.gtld-servers.net
   e.gtld-servers.net
   f.gtld-servers.net
   g.gtld-servers.net
   h.gtld-servers.net
   i.gtld-servers.net
   j.gtld-servers.net
   k.gtld-servers.net
   l.gtld-servers.net
   m.gtld-servers.net
   ```

2. Vậy ta chọn một trong các name server `.com`.

   "Này `h.gtld-servers.net`, chúng tôi đang tìm `www.example.com`. Bạn có thể giúp
   không?"

   Và nó trả lời: "Tôi không biết tên đó, nhưng tôi biết các name server cho
   `example.com`. Bạn có thể nói chuyện với một trong số đó." Nó đính kèm danh sách
   các name server biết về tên miền `example.com`:

   ``` {.default}
   a.iana-servers.net
   b.iana-servers.net
   ```

3. Vậy ta chọn một trong các server đó.

   "Này `a.iana-servers.net`, chúng tôi đang tìm `www.example.com`. Bạn có thể giúp
   không?"

   Và name server đó trả lời: "Có, tôi có thể! Tôi biết tên đó! Địa chỉ IP của nó
   là `93.184.216.34`!"

Vậy là với bất kỳ tra cứu nào, ta bắt đầu từ root name server và nó chỉ đường đến
nơi tìm thêm thông tin. (Trừ khi thông tin đã được cache ở đâu đó, nhưng sẽ nói thêm
về điều đó sau.)

## Zones (Vùng)

Hệ Thống Tên Miền được chia thành các _zone_ (vùng) quản trị logic. Một zone, đại
khái, là tập hợp các tên miền dưới thẩm quyền của một name server cụ thể.

Nhưng đó là cách đơn giản hóa. Có thể có một hoặc nhiều tên miền trong cùng một
zone. Và có thể có nhiều name server hoạt động trong cùng zone đó.

Hãy nghĩ zone như tất cả tên miền và subdomain mà một đơn vị quản trị nào đó chịu
trách nhiệm.

Ví dụ, trong root zone, ta thấy có nhiều name server chịu trách nhiệm cho tra cứu
đó. Và trong zone `.com`, cũng có một số name server khác nhau có thẩm quyền.

## Thư Viện Resolver

Khi bạn viết phần mềm dùng tên miền, nó gọi một thư viện để thực hiện tra cứu DNS.
Bạn có thể đã nhận thấy rằng trong Python khi bạn gọi:

``` {.py}
s.connect(("example.com", 80))
```

bạn không cần lo lắng về DNS chút nào. Phía sau, Python đã làm tất cả công việc tra
cứu tên miền đó trong DNS.

Trong C, có một hàm gọi là `getaddrinfo()` làm điều tương tự.

Tóm lại là có một thư viện mà ta có thể dùng và không cần tự viết tất cả code đó.

Hệ điều hành cũng có một bản ghi chứa name server mặc định để dùng cho các tra cứu.
(Đôi khi được cấu hình thủ công, nhưng thường được cấu hình qua
[DHCP](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol).)
Vậy khi bạn yêu cầu tra cứu, máy tính của bạn trước tiên sẽ đến server này.

Nhưng khoan --- điều đó liên quan như thế nào đến toàn bộ hệ thống phân cấp root
server?

Câu trả lời: caching (bộ nhớ đệm)!

## Máy Chủ Cache (Caching Servers)

Hãy tưởng tượng tất cả các tra cứu DNS đang diễn ra trên toàn cầu. Nếu ta phải đến
root server cho _mỗi_ yêu cầu, không chỉ mất nhiều thời gian cho các yêu cầu lặp
lại, mà các root server còn bị quá tải hoàn toàn.

Để tránh điều này, tất cả thư viện resolver DNS và server DNS đều _cache_ (lưu đệm)
kết quả của chúng.

> Thực tế, các root server xử lý hàng nghìn tỷ yêu cầu mỗi ngày.

Bằng cách này ta có thể tránh làm quá tải các root server với các yêu cầu lặp lại.

Vậy ta phải sửa lại sơ đồ đã trình bày.

1. Hỏi thư viện resolver của ta về địa chỉ IP. Nếu nó có trong cache, nó sẽ trả về
   ngay.

2. Nếu không có, hỏi name server cục bộ của ta về địa chỉ IP. Nếu nó có trong cache,
   nó sẽ trả về.

3. Nếu không có trong cache **và** nếu name server này có một name server upstream
   khác (tức là một name server khác nó có thể nhờ để tìm câu trả lời), nó hỏi name
   server đó.

4. Nếu không có trong cache **và** nếu name server này không có name server upstream
   nào, nó đến các root server và quá trình tiếp tục như trước.

Với tất cả các cơ hội có thể lấy kết quả từ cache này, nó thực sự giúp giảm tải cho
các root name server.

Nhiều router WiFi bạn mua cũng chạy caching name server. Vậy khi DHCP cấu hình máy
tính của bạn, máy tính dùng router của bạn làm DNS server cho các máy trên LAN. Điều
này cho bạn phản hồi nhanh cho các tra cứu DNS vì ping time đến router rất ngắn.

### Time To Live (Thời Gian Sống)

Vì địa chỉ IP của tên miền hay host có thể thay đổi, ta phải có cách để các mục
cache hết hạn.

Điều này được thực hiện qua một trường trong bản ghi DNS gọi là _time to live_ (TTL,
thời gian sống). Đây là số giây một server nên cache kết quả. Thường được đặt là
86400 giây (1 ngày), nhưng có thể hơn hoặc ít hơn tùy thuộc vào mức độ thay đổi địa
chỉ IP mà quản trị viên zone nghĩ đến.

Khi một mục cache hết hạn, name server sẽ phải hỏi lại upstream hoặc root server nếu
có ai yêu cầu nó.

## Loại Bản Ghi (Record Types)

Cho đến nay, ta đã nói về việc dùng DNS để ánh xạ tên host hoặc tên miền thành địa
chỉ IP. Đây là một trong các loại bản ghi được lưu trữ cho tên miền trên DNS server.

Các loại bản ghi phổ biến là:

* `A`: Bản ghi địa chỉ cho IPv4. Đây là loại bản ghi ta đã nói đến suốt lúc nãy.
  Trả lời câu hỏi: "Địa chỉ IPv4 của host hoặc tên miền này là gì?"

* `AAAA`: Bản ghi địa chỉ cho IPv6. Trả lời câu hỏi: "Địa chỉ IPv6 của host hoặc
  tên miền này là gì?"

* `NS`: Bản ghi name server cho một tên miền cụ thể. Trả lời câu hỏi: "Những name
  server nào đang trả lời cho host hoặc tên miền này?"

* `MX`: Bản ghi mail exchange (trao đổi thư). Trả lời câu hỏi: "Máy tính nào chịu
  trách nhiệm xử lý thư trên tên miền này?"

* `TXT`: Bản ghi văn bản. Chứa thông tin văn bản tự do. Đôi khi được dùng cho mục
  đích chống spam và chứng minh quyền sở hữu tên miền.

* `CNAME`: Bản ghi tên kinh điển (canonical name). Hãy nghĩ đây như một bí danh
  (alias). Phát biểu: "Tên miền xyz.example.com là bí danh của abc.example.com."

* `SOA`: Bản ghi đầu thẩm quyền (start of authority). Chứa thông tin về tên miền,
  bao gồm name server chính và thông tin liên lạc.

Có [rất nhiều loại bản ghi DNS](https://en.wikipedia.org/wiki/List_of_DNS_record_types).

## DNS Động (Dynamic DNS)

Người dùng Internet thông thường không có _địa chỉ IP tĩnh_ (static IP address ---
tức là chuyên dùng hoặc không thay đổi) tại nhà. Nếu họ khởi động lại modem, ISP có
thể cấp cho họ địa chỉ IP khác.

Điều này gây rắc rối với DNS vì bất kỳ bản ghi DNS nào trỏ đến IP công khai của họ
sẽ bị lỗi thời.

DNS Động (DDNS) nhằm giải quyết vấn đề này.

Tóm lại, có hai cơ chế đang hoạt động:

1. Một cách để client báo cho DDNS server biết địa chỉ IP của họ là gì.

2. TTL rất ngắn trên DDNS server cho bản ghi đó.

Trong khi DNS định nghĩa một cách để gửi bản ghi cập nhật, một cách phổ biến khác
là có một máy tính trên LAN của bạn định kỳ (ví dụ mỗi 10 phút) liên hệ nhà cung
cấp DDNS với một yêu cầu HTTP được xác thực. DDNS server sẽ thấy địa chỉ IP yêu cầu
đến từ đó và dùng nó để cập nhật bản ghi.

## Reverse DNS (DNS Ngược)

Điều gì sẽ xảy ra nếu bạn có địa chỉ IP dạng chấm-số và muốn biết tên host của IP
đó? Bạn có thể thực hiện tra cứu _reverse DNS_ (DNS ngược).

Lưu ý rằng không phải tất cả địa chỉ IP đều có bản ghi như vậy, và thường một truy
vấn reverse DNS sẽ trả về rỗng.

## Suy Ngẫm

* Name server của máy tính bạn ngay lúc này là gì? Tìm trên mạng cách tra cứu trên
  hệ điều hành của bạn.

* Các root name server có biết mọi địa chỉ IP trên thế giới không?

* Tại sao ai đó lại dùng DNS động?

* TTL được dùng để làm gì?

