# Dự án: Tính toán và Tìm kiếm Subnet (Computing and Finding Subnets)

Để chuẩn bị cho dự án tiếp theo là tìm đường định tuyến trong mạng, ta cần
làm một số việc để hiểu cách địa chỉ IP, subnet mask và subnet hoạt động
cùng nhau.

Trong dự án này ta sẽ đưa vào thực hành một số nội dung từ các chương trước.
Ta sẽ:

* Viết hàm chuyển đổi địa chỉ IP dạng chấm-số (dots-and-numbers) thành giá
  trị 32-bit đơn --- và ngược lại.

* Viết hàm chuyển đổi subnet mask ở dạng slash notation thành một giá trị
  32-bit đơn đại diện cho mask đó.

* Viết hàm kiểm tra xem hai địa chỉ IP có nằm trên cùng subnet hay không.

## Restrictions (Giới hạn)

Bạn **không** được dùng:

* Bất kỳ chức năng nào từ module `socket`.
* Bất kỳ chức năng nào từ module `struct`.
* Bất kỳ chức năng nào từ module `netaddr`.
* Các phương thức `.to_bytes()` hoặc `.from_bytes()`.

Hãy giữ nó trong phạm vi các phép toán bitwise tự viết.

## What To Do (Phải làm gì)

[fls[Tải skeleton code và các file trong archive ZIP này|netfuncs/netfuncs.zip]].
Đây là những gì bạn cần điền vào cho dự án này.

Cài đặt các hàm sau trong `netfuncs.py`:

* `ipv4_to_value(ipv4_addr)`
* `value_to_ipv4(addr)`
* `get_subnet_mask_value(slash)`
* `ips_same_subnet(ip1, ip2, slash)`
* `get_network(ip_value, netmask)`
* `find_router_for_ip(routers, ip)`

Mô tả các hàm nằm trong file ở docstring tương ứng. Hãy chú ý đặc biệt đến
_kiểu_ (types) đầu vào và đầu ra trong các ví dụ ở đó.

Lưu ý rằng không hàm nào cần dài hơn 5--15 dòng. Nếu bạn đang viết hàm dài
hơn thế, có thể bạn đang đi lạc hướng rồi.

## Testing as you Go (Kiểm tra theo từng bước)

Mình khuyến khích bạn _viết từng hàm một_ và kiểm tra bằng dữ liệu mẫu của
riêng bạn trước khi chuyển sang hàm tiếp theo.

Bạn có thể thêm các lệnh gọi hàm của riêng mình để kiểm tra xem chúng có
hoạt động đúng không. Dùng các đầu vào và đầu ra từ phần ví dụ trong comment
làm test case.

Có một hàm tên `my_tests()` trong `netfuncs.py` sẽ chạy thay cho hàm main
mặc định nếu bạn bỏ comment.

Nếu bạn bỏ comment `my_tests()`, bạn có thể chạy chương trình với:

``` {.sh}
python netfuncs.py
```

và xem kết quả từ hàm đó.

Nhớ comment lại `my_tests()` và chạy với code main đi kèm trước khi nộp,
như phần tiếp theo mô tả.

## Running the Program (Chạy chương trình)

Bạn chạy như sau:

``` {.sh}
python netfuncs.py example1.json
```

Chương trình sẽ đọc dữ liệu JSON từ `example1.json` đi kèm và chạy các hàm
của bạn trên nhiều phần của nó.

Đầu ra, nằm trong `example1_output.txt`, phải trông chính xác như thế này
nếu mọi thứ hoạt động đúng:

``` {.default}
Routers:
     10.34.166.1: netmask 255.255.255.0: network 10.34.166.0
     10.34.194.1: netmask 255.255.255.0: network 10.34.194.0
     10.34.209.1: netmask 255.255.255.0: network 10.34.209.0
     10.34.250.1: netmask 255.255.255.0: network 10.34.250.0
      10.34.46.1: netmask 255.255.255.0: network 10.34.46.0
      10.34.52.1: netmask 255.255.255.0: network 10.34.52.0
      10.34.53.1: netmask 255.255.255.0: network 10.34.53.0
      10.34.79.1: netmask 255.255.255.0: network 10.34.79.0
      10.34.91.1: netmask 255.255.255.0: network 10.34.91.0
      10.34.98.1: netmask 255.255.255.0: network 10.34.98.0

IP Pairs:
   10.34.194.188    10.34.91.252: different subnets
   10.34.209.189    10.34.91.120: different subnets
   10.34.209.229    10.34.166.26: different subnets
   10.34.250.213    10.34.91.184: different subnets
   10.34.250.228    10.34.52.119: different subnets
   10.34.250.234     10.34.46.73: different subnets
     10.34.46.25   10.34.166.228: different subnets
    10.34.52.118     10.34.91.55: different subnets
    10.34.52.158     10.34.166.1: different subnets
    10.34.52.187    10.34.52.244: same subnet
     10.34.52.23    10.34.46.130: different subnets
     10.34.52.60    10.34.46.125: different subnets
    10.34.79.218     10.34.79.58: same subnet
     10.34.79.81    10.34.46.142: different subnets
     10.34.79.99    10.34.46.205: different subnets
    10.34.91.205    10.34.53.190: different subnets
     10.34.91.68    10.34.79.122: different subnets
     10.34.91.97    10.34.46.255: different subnets
    10.34.98.184     10.34.209.6: different subnets
     10.34.98.33   10.34.166.170: different subnets

Routers and corresponding IPs:
     10.34.166.1: ['10.34.166.1', '10.34.166.170', '10.34.166.228', '10.34.166.26']
     10.34.194.1: ['10.34.194.188']
     10.34.209.1: ['10.34.209.189', '10.34.209.229', '10.34.209.6']
     10.34.250.1: ['10.34.250.213', '10.34.250.228', '10.34.250.234']
      10.34.46.1: ['10.34.46.125', '10.34.46.130', '10.34.46.142', '10.34.46.205', '10.34.46.25', '10.34.46.255', '10.34.46.73']
      10.34.52.1: ['10.34.52.118', '10.34.52.119', '10.34.52.158', '10.34.52.187', '10.34.52.23', '10.34.52.244', '10.34.52.60']
      10.34.53.1: ['10.34.53.190']
      10.34.79.1: ['10.34.79.122', '10.34.79.218', '10.34.79.58', '10.34.79.81', '10.34.79.99']
      10.34.91.1: ['10.34.91.120', '10.34.91.184', '10.34.91.205', '10.34.91.252', '10.34.91.55', '10.34.91.68', '10.34.91.97']
      10.34.98.1: ['10.34.98.184', '10.34.98.33']
```

Nếu đầu ra khác, hãy xem qua code và kiểm tra hàm nào cho đầu ra sai. Sau
đó kiểm tra chi tiết hơn trong hàm `my_tests()`.

<!--
New Rubric

5 points each, 100 points

ipv4_to_value(): returns single numeric integer type
value_to_ipv4(): returns correct string
get_subnet_mask_value(): uses bitwise operations to make mask
ipv4_to_value(): Successfully converts any IP address in dots-and-numbers format into a single value representing that IP packed into a 4-byte 32-bit integer.
value_to_ipv4(): Successfully converts a single value representing an IP packed into a 4-byte 32-bit integer into a string in dots-and-numbers format.
value_to_ipv4(): No leading zeros on any of the numbers in the string.
value_to_ipv4(): No padding--only digits and periods in the string.
get_subnet_mask_value(): Returns a single integer representing the subnet mask defined by the slash notation.
get_subnet_mask_value(): Handles both plain slash notation like "/16" and IP/slash notation like "198.51.100.12/22".
ips_same_subnet(): Returns True if both numbers are on the same subnet.
ips_same_subnet(): Uses get_subnet_mask_value() to get the subnet mask.
ips_same_subnet(): Uses ipv4_to_value() to get the values of the IP addresses.
ips_same_subnet(): Does the proper bitwise arithmetic to determine if the IP addresses are on the same subnet.
get_network(): Returns the network portion of the IP address as an integer.
get_network(): Uses the correct bitwise arithmetic to perform this computation.
find_router_for_ip(): Correctly finds the router that's on the same subnet as the given IP.
find_router_for_ip(): Returns the router IP as a dots-and-numbers strings
find_router_for_ip(): Returns None if no router is found on the same subnet as the given IP.
find_router_for_ip(): Calls ips_same_subnet() to make the determination.
No code below the do-not-modify line was modified.
-->

<!--
Fall 2022 Rubric

* `ipv4_to_value(ipv4_addr)`

10
ipv4_to_value(): Successfully converts any IP address in dots-and-numbers format into a single value representing that IP packed into a 4-byte 32-bit integer.

* `value_to_ipv4(addr)`

10
value_to_ipv4(): Successfully converts a single value representing an IP packed into a 4-byte 32-bit integer into a string in dots-and-numbers format.

1
value_to_ipv4(): No leading zeros on any of the numbers in the string.

1
value_to_ipv4(): No padding--only digits and periods in the string.

* `get_subnet_mask_value(slash)`

10
get_subnet_mask_value(): Returns a single integer representing the subnet mask defined by the slash notation.

5
get_subnet_mask_value(): Handles both plain slash notation like "/16" and IP/slash notation like "198.51.100.12/22".

* `ips_same_subnet(ip1, ip2, slash)`

10
ips_same_subnet(): Returns True if both numbers are on the same subnet.

5
ips_same_subnet(): Uses get_subnet_mask_value() to get the subnet mask.

5
ips_same_subnet(): Uses ipv4_to_value() to get the values of the IP addresses.

10
ips_same_subnet(): Does the proper bitwise arithmetic to determine if the IP addresses are on the same subnet.

* `get_network(ip_value, netmask)`

5
get_network(): Returns the network portion of the IP address as an integer.

5
get_network(): Uses the correct bitwise arithmetic to perform this computation.

* `find_router_for_ip(routers, ip)`

10
find_router_for_ip(): Correctly finds the router that's on the same subnet as the given IP.

3
find_router_for_ip(): Returns the router IP as a dots-and-numbers strings

3
find_router_for_ip(): Returns None if no router is found on the same subnet as the given IP.

5
find_router_for_ip(): Calls ips_same_subnet() to make the determination.

* Additional:

5
No code below the do-not-modify line was modified.

-->
