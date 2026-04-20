# Lời nói đầu
<!-- Beej's guide to Network Concepts
# vim: ts=4:sw=4:nosi:et:tw=72
-->

<!-- No hyphenation -->
<!-- [nh[scalbn]] -->

<!-- Index see alsos -->
<!--
[is[String==>see `char *`]]
[is[New line==>see `\n` newline]]
[is[Ternary operator==>see `?:` ternary operator]]
[is[Addition operator==>see `+` addition operator]]
[is[Subtraction operator==>see `-` subtraction operator]]
[is[Multiplication operator==>see `*` multiplication operator]]
[is[Division operator==>see `/` division operator]]
[is[Modulus operator==>see `%` modulus operator]]
[is[Boolean NOT==>see `!` operator]]
[is[Boolean AND==>see `&&` operator]]
[is[Boolean OR==>see `||` operator]]
[is[Bell==>see `\a` operator]]
[is[Tab (is better)==>see `\t` operator]]
[is[Carriage return==>see `\r` operator]]
[is[Hexadecimal==>see `0x` hexadecimal]]
-->

Đây là gì vậy? À, đây là hướng dẫn về một mớ khái niệm mà bạn có thể
gặp trong mạng máy tính. Không phải sách về lập trình mạng bằng
C---xem [flbg[_Beej's Guide to Network Programming_|bgnet]] cho việc
đó. Cuốn này ở đây để giúp bạn hiểu các thuật ngữ, và cũng để làm
một chút lập trình mạng bằng Python.

Phải chăng đây là _Beej's Guide to Network Programming in Python_?
Ừ thì, thật ra cũng gần vậy. Cuốn C thiên về cách network API của C
(thực ra là của Unix) hoạt động. Còn cuốn này thiên về các khái niệm
nền tảng phía dưới, dùng Python làm phương tiện.

Tôi tin là điều đó nghe cực kỳ rối rắm. Có lẽ cứ nhảy thẳng xuống
phần _Đối tượng đọc_ ở dưới cho nhanh.

## Đối tượng đọc

Bạn hoàn toàn mới với mạng và bị ngợp bởi đủ thứ thuật ngữ như
ISO-OSI, TCP/IP, port (cổng), Ethernet, LAN, và những thứ tương tự?
Và có lẽ bạn muốn viết code mạng bằng Python? Chúc mừng! Bạn chính
là đối tượng mà sách này nhắm đến!

Nhưng cần cảnh báo trước: sách này giả định bạn đã có một số kiến
thức lập trình Python trong tay.

## Trang chủ chính thức

Địa chỉ chính thức của tài liệu này (hiện tại) là
[fl[https://beej.us/guide/bgnet0/|https://beej.us/guide/bgnet0/]].

## Chính sách Email

Tôi thường sẵn sàng giúp đỡ qua email nên cứ thoải mái viết, nhưng
tôi không đảm bảo sẽ trả lời. Cuộc sống khá bận và có những lúc tôi
không thể trả lời câu hỏi của bạn. Trong trường hợp đó, tôi thường
chỉ xóa email đi. Không có gì cá nhân cả; tôi chỉ không bao giờ có
đủ thời gian để đưa ra câu trả lời chi tiết mà bạn cần.

Về nguyên tắc, câu hỏi càng phức tạp thì tôi càng ít có khả năng
trả lời. Nếu bạn có thể thu hẹp câu hỏi trước khi gửi và đảm bảo
đính kèm mọi thông tin liên quan (như nền tảng, trình biên dịch, các
thông báo lỗi bạn gặp, và bất cứ thứ gì bạn nghĩ có thể giúp tôi
debug), thì bạn sẽ có khả năng nhận được phản hồi cao hơn nhiều.

Nếu không nhận được phản hồi, hãy tiếp tục mày mò, cố tự tìm câu
trả lời, và nếu vẫn chịu thua thì viết lại cho tôi với những thông
tin bạn đã tìm được, hi vọng là đủ để tôi giúp được.

Sau khi đã cằn nhằn về chuyện viết thế nào cho đúng, tôi chỉ muốn
nói thêm là tôi _thực sự_ đánh giá cao mọi lời khen mà cuốn sách đã
nhận được qua nhiều năm. Đó là nguồn động lực thực sự, và tôi rất
vui khi biết nó đang được dùng vào việc tốt! `:-)` Cảm ơn bạn!

## Nhân bản

Bạn hoàn toàn được chào đón khi mirror trang này, dù công khai hay
riêng tư. Nếu bạn mirror công khai và muốn tôi đặt link tới nó từ
trang chính, nhắn cho tôi tại
[`beej@beej.us`](mailto:beej@beej.us).

## Ghi chú cho Người dịch

Nếu bạn muốn dịch sách này sang ngôn ngữ khác, viết cho tôi tại
[`beej@beej.us`](beej@beej.us) và tôi sẽ đặt link đến bản dịch của
bạn từ trang chính. Thoải mái thêm tên và thông tin liên lạc của bạn
vào bản dịch.

Lưu ý các hạn chế về giấy phép trong phần Bản quyền và Phân phối bên
dưới.

## Bản quyền và Phân phối

Beej's Guide to Networking Concepts là Copyright © 2023 Brian "Beej Jorgensen" Hall.

Với các ngoại lệ cụ thể cho source code và bản dịch ở dưới, tác phẩm
này được cấp phép theo Giấy phép Creative Commons
Attribution-Noncommercial-No Derivative Works 3.0. Để xem bản sao
của giấy phép này, truy cập
[`https://creativecommons.org/licenses/by-nc-nd/3.0/`](https://creativecommons.org/licenses/by-nc-nd/3.0/)
hoặc gửi thư đến Creative Commons, 171 Second Street, Suite 300, San
Francisco, California, 94105, USA.

Một ngoại lệ cụ thể cho phần "No Derivative Works" của giấy phép như
sau: hướng dẫn này có thể được dịch tự do sang bất kỳ ngôn ngữ nào,
với điều kiện bản dịch chính xác và hướng dẫn được in lại đầy đủ. Các
hạn chế giấy phép tương tự áp dụng cho bản dịch như đối với bản gốc.
Bản dịch cũng có thể bao gồm tên và thông tin liên lạc của người dịch.

Source code lập trình được trình bày trong tài liệu này được trao vào
public domain và hoàn toàn không có hạn chế giấy phép nào.

Các nhà giáo dục được khuyến khích tự do giới thiệu hoặc cung cấp
bản sao của hướng dẫn này cho học sinh của mình.

Liên hệ [`beej@beej.us`](beej@beej.us) để biết thêm thông tin.

## Lời tri ân

Những điều khó nhất khi viết mấy cuốn hướng dẫn này là:

* Học tài liệu đủ sâu để có thể giải thích nó
* Tìm ra cách tốt nhất để giải thích rõ ràng, một quá trình lặp đi
  lặp lại dường như bất tận
* Tự đặt mình vào vị trí một cái gọi là _chuyên gia_, trong khi thực
  ra tôi chỉ là một người bình thường đang cố hiểu mọi thứ, giống như
  mọi người
* Kiên trì tiếp tục khi có quá nhiều thứ khác thu hút sự chú ý của tôi

Nhiều người đã giúp tôi vượt qua quá trình này, và tôi muốn ghi nhận
những người đã làm cho cuốn sách này thành hiện thực.

* Tất cả mọi người trên Internet đã quyết định chia sẻ kiến thức của
  mình dưới hình thức này hay hình thức khác. Việc chia sẻ tự do
  thông tin hướng dẫn là thứ làm cho Internet trở thành nơi tuyệt
  vời như vậy.
* Tất cả mọi người đã gửi bản sửa lỗi và pull request cho mọi thứ
  từ hướng dẫn sai đến typo.

Cảm ơn! ♥
