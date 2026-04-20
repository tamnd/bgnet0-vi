# Dự án: Packet Tracer: Dùng Switch

Thông thường không ai nối dây hai PC trực tiếp với nhau. Thường chúng
được kết nối qua một _switch_ (công tắc mạng).

Hãy cài đặt điều đó trong lab.

## Thêm Một Số PC

Chọn "End Devices" ở góc dưới bên trái, và kéo ba PC ra workspace
(không gian làm việc).

Click vào từng cái, vào tab "Config" cho thiết bị `FastEthernet0` của
chúng và gán địa chỉ IP:

* PC0: `192.168.0.2`
* PC1: `192.168.0.3`
* PC2: `192.168.0.4`

Tất cả đều dùng subnet mask `255.255.255.0`.

## Thêm Switch

Click vào "Network Devices" ở góc dưới bên trái. Hàng icon dưới bên
trái sẽ thay đổi.

Chọn "Switches", thứ hai từ trái trong hàng dưới. Panel giữa sẽ thay
đổi.

Kéo switch `2960` ra workspace.

Nếu bạn click vào switch và xem tab "Physical", bạn sẽ thấy switch là
thiết bị có _rất nhiều_ cổng Ethernet. (Đây là switch khá cao cấp.
Switch gia đình thường có 4 hoặc 8 cổng. Mặt sau router WiFi ở nhà
bạn có thể có 4 cổng như vậy --- đó là switch tích hợp trong đó!)

Ta có thể kết nối các PC vào các cổng này và chúng sẽ có thể nói
chuyện với nhau.

## Nối Dây

Không có PC nào kết nối trực tiếp với nhau. Tất cả đều kết nối trực
tiếp vào switch.

Không dùng crossover cable ở đây; switch tự biết phải làm gì.

> Lưu ý khi bạn lần đầu nối dây LAN, có thể không thấy hai mũi tên
> xanh lên trên kết nối. Một hoặc cả hai có thể là vòng tròn cam
> cho thấy link đang trong quá trình kết nối. Bạn có thể nhấn nút
> `>>` tua nhanh ở góc dưới bên trái để nhảy thời gian cho đến khi
> thấy hai mũi tên xanh lên.

Chọn selector "Connections" ở góc dưới bên trái.

Chọn cáp "Copper Straight-Through". (Icon sẽ đổi thành ký hiệu "anti".)

Click vào PC0, rồi chọn `FastEthernet0`.

Click vào switch, rồi chọn bất kỳ cổng `FastEthernet0` nào.

Làm tương tự cho 2 PC còn lại.

## Kiểm Tra Ping!

Click vào một trong các PC và vào tab "Desktop" rồi chạy Command
Prompt. Đảm bảo bạn có thể `ping` hai PC còn lại.

<!-- Rubric

5
Straight-through cable used

5
Three PCs used

5
Switch used

10
Can ping from any PC to any other PC

-->
