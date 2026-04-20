# Tường lửa (Firewalls)

Thành phần yêu thích trong mọi bộ phim hacker dở tệ đó là _tường lửa_
(firewall). Qua những bộ phim tệ đó, rõ ràng nó liên quan đến bảo mật,
nhưng vai trò cụ thể thì mơ hồ --- chỉ thấy rằng kẻ xấu vượt qua được
tường lửa là điều tệ hại.

Nhưng trở lại thực tế: tường lửa là một máy tính (thường là router)
hạn chế một số loại lưu lượng nhất định giữa một giao diện mạng và
giao diện khác. Thay vì chuyển tiếp mọi gói tin thuộc mọi loại từ mọi
cổng, nó có thể quyết định hủy các gói đó.

Hệ quả là nếu ai đó cố kết nối đến một cổng ở phía bên kia của tường
lửa, tường lửa có thể ngăn chặn kết nối đó tùy theo cách cấu hình.

Trong chương này, ta sẽ nói về tường lửa theo nghĩa khái niệm, không
đi sâu vào cấu hình thực tế cụ thể. Có nhiều triển khai tường lửa
khác nhau, và chúng đều có phương pháp cấu hình khác nhau.

## Hoạt động của Tường lửa (Firewall Operation)

Hãy nghĩ về một gói tin đến router --- router đó có khả năng kiểm tra
gói tin tùy ý. Nó có thể xem IP nguồn và đích, hoặc cổng, thậm chí
dữ liệu ở tầng ứng dụng.

Điều đó cho nó cơ hội quyết định có tiếp tục chuyển tiếp gói tin hay
không, dựa trên bất kỳ dữ liệu nào trong đó.

Ví dụ, tường lửa có thể được cấu hình để cho phép mọi lưu lượng cổng
80 (HTTP) đến từ bên ngoài vào bên trong, nhưng chặn lưu lượng đến
trên tất cả các cổng đích khác.

Hoặc có thể chỉ cho phép một số địa chỉ IP nhất định kết nối.

Vậy khi nhận được một gói tin, tường lửa xem qua các quy tắc đã cấu
hình và quyết định có hủy gói đó (nếu bị lọc) hay chuyển tiếp bình
thường.

Khi quyết định hủy gói, nó có thêm một vài lựa chọn. Có thể hủy thầm
lặng, hoặc trả lời bằng thông báo
[ICMP](https://en.wikipedia.org/wiki/Internet_Control_Message_Protocol)
"destination unreachable" (đích không thể tiếp cận).

Lọc cơ bản như vậy cho phép kiểm soát một phần, nhưng vẫn có những
thứ bạn muốn làm mà nó không xử lý được.

Ví dụ, nếu ai đó phía sau tường lửa thiết lập kết nối TCP qua Internet
từ một cổng ngẫu nhiên, ta muốn lưu lượng có thể quay lại đến host đó
qua cổng ngẫu nhiên đó.

Với lọc đơn thuần, ta phải cho phép lưu lượng trên tất cả các cổng
đó.

Nhưng với _lọc trạng thái_ (stateful filtering), tường lửa theo dõi
trạng thái các kết nối TCP đã được khởi tạo từ phía sau tường lửa.
Tường lửa thấy bắt tay ba bước TCP và biết rằng đây là kết nối hợp lệ.
Sau đó nó có thể an toàn cho phép lưu lượng quay vào cổng ngẫu nhiên
của máy bên trong.

Lọc trạng thái cũng được dùng với lưu lượng UDP, dù UDP là connectionless
(không kết nối). Tường lửa thấy gói UDP đi ra, và sẽ cho phép các gói
UDP đến cổng đó quay vào. (Trong một thời gian. Vì không có kết nối,
không có cách nào biết khi nào server và client xong việc. Nên tường
lửa sẽ timeout quy tắc UDP sau một thời gian không dùng.)

> Để tránh tường lửa timeout các quy tắc của mình, các chương trình
> có thể gửi tin nhắn _keepalive_ (giữ kết nối sống). TCP thực ra có
> một loại thông điệp cụ thể cho việc này, và hệ điều hành sẽ định kỳ
> gửi các gói `ACK` rỗng ra để không ai timeout. (Khi lập trình với
> socket, bạn sẽ cần đặt tùy chọn `SO_KEEPALIVE`.)
>
> Keepalive cũng có thể được triển khai hiệu quả bởi chương trình dùng
> UDP. Nó có thể được cấu hình để gửi gói keepalive tùy chỉnh đến phía
> nhận (phía nhận sẽ trả lời bằng ACK nào đó) theo chu kỳ.
>
> Keepalive chỉ là vấn đề với các chương trình có khoảng thời gian dài
> không có lưu lượng mạng.

Cuối cùng, lọc cũng có thể được thực hiện ở tầng ứng dụng. Nếu tường
lửa đào sâu đủ vào gói tin, nó có thể thấy đó là dữ liệu HTTP hay FTP
chẳng hạn. Với thông tin đó, nó có thể cho phép hoặc từ chối toàn bộ
lưu lượng HTTP, kể cả khi nó đến trên cổng không chuẩn.

## Tường lửa và NAT (Firewalls and NAT)

Trong mạng gia đình, thường thấy tường lửa cũng kiêm luôn vai trò
router, switch và NAT.

Tất cả gộp vào một.

Nhưng không có gì ngăn ta có một máy tính tường lửa riêng trên mạng,
chỉ làm nhiệm vụ quyết định có cho phép lưu lượng đi qua hay không.

Và cũng không có quy tắc nào bắt buộc một phía của tường lửa phải là
mạng riêng (private) và phía kia là mạng công (public). Cả hai phía
đều có thể là private, đều public, hoặc một private một public.

Vai trò cốt lõi của tường lửa không phải để phân tách mạng public và
private --- đó là vai trò của NAT --- mà là kiểm soát lưu lượng nào
được phép đi qua.

## Tường lửa cục bộ (Local Firewalls)

Bạn cũng có thể cài tường lửa ngay trên máy tính của mình (và điều
này thường được làm). Thường được thiết lập để cho phép tất cả kết nối
đi ra từ máy, nhưng hạn chế kết nối đến từ các máy khác.

Trên MacOS và Windows, tường lửa có thể được bật đơn giản và sau đó
bắt đầu chặn lưu lượng theo một số quy tắc phổ biến.

Nếu bạn cần mở một số cổng cụ thể, phải thêm thủ công.

Linux có hỗ trợ tường lửa thông qua cơ chế gọi là
[iptables](https://en.wikipedia.org/wiki/Iptables). Đây không phải thứ
dễ cấu hình nhất, nhưng đủ mạnh để xây dựng một NAT router/firewall
từ đầu.

## Reflect

* Sự khác biệt/mối quan hệ giữa tường lửa và router là gì?

* Sự khác biệt/mối quan hệ giữa tường lửa và NAT là gì?

* Điều buồn cười nhất hoặc đau đớn nhất trong [đoạn clip NCIS
  này](https://www.youtube.com/watch?v=u8qgehH3kEQ) là gì?
