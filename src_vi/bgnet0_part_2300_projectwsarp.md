
# Dự án: Bắt gói tin ARP bằng WireShark

Chúng ta sẽ xem xét một chút lưu lượng mạng thực tế bằng
[fl[WireShark|https://www.wireshark.org/]] và thử bắt
một số ARP request (yêu cầu ARP) và ARP reply (phản hồi ARP).

WireShark là công cụ tuyệt vời để _sniff_ (nghe lén) các gói tin mạng. Nó cho
phép bạn theo dõi các gói tin di chuyển qua LAN (mạng cục bộ).

Ta sẽ cài filter (bộ lọc) trong WireShark để chỉ nhìn vào các gói ARP
đến và đi từ máy của mình thôi --- khỏi phải mò kim đáy bể.

## Cần Tạo Ra Gì

Một tài liệu chứa 4 thứ:

1. Địa chỉ MAC của kết nối đang hoạt động trên máy bạn.

2. Địa chỉ IP của kết nối đang hoạt động trên máy bạn.

3. Bản ghi gói tin WireShark dạng đọc được của một ARP request.

4. Bản ghi gói tin WireShark dạng đọc được của một ARP reply.

Chi tiết bên dưới!

## Từng Bước Một

Đây là những gì ta sẽ làm:

1. **Tra Địa Chỉ Ethernet (MAC) Của Bạn**

   Máy tính có thể có nhiều interface (giao diện) Ethernet --- ví dụ
   một cái cho WiFi và một cái cho dây --- cái jack Ethernet ở cạnh máy.

   Vì bạn gần như chắc chắn đang dùng wireless, hãy tra địa chỉ MAC
   của interface wireless. (Bạn có thể cần Google để biết cách làm điều này.)
   
   Cho cả bước này lẫn bước 2 bên dưới, thông tin có thể tìm thấy
   bằng lệnh này trên Unix-like:

   ``` {.sh}
   ifconfig
   ```

   và lệnh này trên Windows:

   ``` {.sh}
   ipconfig
   ```

2. **Tra Địa Chỉ IP Của Bạn**

   Lại nữa, ta cần địa chỉ IP của interface mạng đang hoạt động,
   thường là thiết bị WiFi.

3. **Mở WireShark**

   Lần đầu mở, cài WireShark để theo dõi thiết bị Ethernet đang hoạt động.
   Trên Linux, có thể là `wlan0`. Trên Mac, có thể là `en0`.
   Trên Windows, khả năng cao là `Wi-Fi`.

   Cài display filter (bộ lọc hiển thị) trong WireShark để lọc các gói ARP
   chỉ đến hoặc đi từ máy của bạn. Gõ dòng này vào thanh gần
   đỉnh cửa sổ, ngay dưới nút cá mập xanh.

   ``` {.default}
   arp and eth.addr==[địa chỉ MAC của bạn]
   ```

   Đừng quên nhấn `RETURN` sau khi gõ filter.

   Bắt đầu capture (bắt gói tin) bằng cách nhấn nút cá mập xanh.

4. **Tìm Thêm IP Trên Subnet Của Bạn**

   Phần này không cần có máy tính thực sự ở IP đó cũng được --- nhưng nếu có
   thì tốt hơn. Quan sát log WireShark một lúc để xem IP nào đang hoạt động
   trên LAN.

   > IP của bạn AND với subnet mask sẽ cho ra subnet number. Thử
   > nhập các số khác nhau cho phần host. Thử default gateway của bạn
   > (Google xem cách tìm default gateway trên hệ điều hành của bạn.)

   Trên command line, `ping` một IP khác trên LAN của bạn:

   ``` {.sh}
   ping [địa chỉ IP]
   ```

   (Nhấn `CONTROL-C` để thoát khỏi ping.)

   Lần ping đầu tiên, bạn có thấy gói ARP nào đi qua WireShark không?
   Nếu không, thử các địa chỉ IP khác trên subnet như đã nói ở trên.

   Dù bạn gửi bao nhiêu ping, bạn chỉ thấy một ARP reply thôi.
   (Bạn sẽ thấy một request cho mỗi ping nếu không có reply!)
   Vì sau reply đầu tiên, máy tính cache (lưu bộ nhớ đệm) kết quả ARP và không
   cần gửi thêm nữa!

   Sau một đến năm phút, máy tính sẽ hết hạn cache entry đó và bạn sẽ
   thấy thêm một lần trao đổi ARP nếu ping lại IP đó.

5. **Chép Lại Request và Reply**

   Trong timeline (dòng thời gian), ARP request trông đại loại thế này
   (với địa chỉ IP khác, rõ ràng rồi):

   ``` {.default}
   ARP 60 Who has 192.168.1.230? Tell 192.168.1.1
   ```

   Và nếu mọi thứ suôn sẻ, bạn sẽ có reply trông như thế này:

   ``` {.default}
   ARP 42 192.168.1.230 is at ac:d1:b8:df:20:85
   ```

   [Nếu không thấy gì, thử đổi display filter thành chỉ "arp". Quan sát
   một lúc xem có thấy cặp request/reply nào đi qua không.]

   Click vào request và xem chi tiết ở panel dưới bên trái.
   Mở rộng panel "Address Resolution Protocol (request)".

   Nhấp chuột phải vào bất kỳ dòng nào trong panel đó và chọn "Copy->All Visible
   Items".

   Đây là ví dụ một request (rút ngắn cho vừa chiều dài dòng):

   ``` {.default}
   Frame 221567: 42 bytes on wire (336 bits), 42 bytes captured  [...]
   Ethernet II, Src: HonHaiPr_df:20:85 (ac:d1:b8:df:20:85), Dst: [...]
   Address Resolution Protocol (request)
       Hardware type: Ethernet (1)
       Protocol type: IPv4 (0x0800)
       Hardware size: 6
       Protocol size: 4
       Opcode: request (1)
       Sender MAC address: HonHaiPr_df:20:85 (ac:d1:b8:df:20:85)
       Sender IP address: 192.168.1.230
       Target MAC address: 00:00:00_00:00:00 (00:00:00:00:00:00)
       Target IP address: 192.168.1.148
   ```

   Click vào reply trong timeline. Chép thông tin reply theo cách tương tự.

   Đây là ví dụ một reply (rút ngắn cho vừa chiều dài dòng):
   
   ``` {.default}
   Frame 221572: 42 bytes on wire (336 bits), 42 bytes captured  [...]
   Ethernet II, Src: Apple_63:3c:ef (8c:85:90:63:3c:ef), Dst:    [...]
   Address Resolution Protocol (reply)
       Hardware type: Ethernet (1)
       Protocol type: IPv4 (0x0800)
       Hardware size: 6
       Protocol size: 4
       Opcode: reply (2)
       Sender MAC address: Apple_63:3c:ef (8c:85:90:63:3c:ef)
       Sender IP address: 192.168.1.148
       Target MAC address: HonHaiPr_df:20:85 (ac:d1:b8:df:20:85)
       Target IP address: 192.168.1.230
   ```

<!--

Rubric

10
Submission includes your MAC address of your currently active connection.

10
Submission includes your IP address of your currently active connection.

20
Submission includes a human-readable WireShark packet capture of an ARP request.

20
Submission includes a human-readable WireShark packet capture of an ARP reply.

-->
