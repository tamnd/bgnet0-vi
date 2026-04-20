# Select

Trong chương này ta sẽ xem xét hàm `select()`. Đây là
một hàm nhìn vào cả một tập hợp socket và cho bạn biết socket nào đã
gửi dữ liệu cho bạn. Tức là, socket nào đang sẵn sàng để gọi `recv()`.

Điều này cho phép chúng ta chờ dữ liệu trên một số lượng lớn socket cùng một lúc.

## Vấn Đề Ta Đang Giải Quyết

Giả sử server đang kết nối với ba client. Nó muốn `recv()` dữ liệu từ
bất kỳ client nào gửi đến tiếp theo.

Nhưng server không có cách nào biết client nào sẽ gửi dữ liệu tiếp theo.

Thêm vào đó, khi server gọi `recv()` trên một socket chưa có dữ liệu
sẵn sàng để đọc, lệnh gọi `recv()` sẽ _block_ (chặn lại), ngăn mọi thứ
khác tiếp tục chạy.

> _Block_ (chặn) có nghĩa là tiến trình sẽ dừng thực thi tại đây và đi
> vào trạng thái ngủ cho đến khi một điều kiện nào đó được thỏa mãn.
> Với `recv()`, tiến trình ngủ cho đến khi có dữ liệu để nhận.

Vậy chúng ta có vấn đề này: nếu làm như thế này:

``` {.py}
data1 = s1.recv(4096)
data2 = s2.recv(4096)
data3 = s3.recv(4096)
```

nhưng `s1` chưa có dữ liệu sẵn sàng, tiến trình sẽ block ở đó và không
gọi `recv()` trên `s2` hay `s3` dù hai socket kia có thể đang có dữ liệu
cần nhận.

Chúng ta cần một cách để theo dõi `s1`, `s2`, và `s3` cùng lúc, xác định
cái nào đang có dữ liệu sẵn sàng, rồi chỉ gọi `recv()` trên những socket đó.

Hàm `select()` làm đúng điều này. Gọi `select()` trên một tập hợp socket
sẽ block cho đến khi một hoặc nhiều socket trong đó sẵn sàng đọc. Sau đó
nó trả về cho bạn danh sách những socket đó và bạn có thể gọi `recv()` chỉ
trên chúng.

## Dùng `select()`

Trước tiên, bạn cần module `select`.

``` {.py}
import select
```

Nếu bạn có một loạt socket đã kết nối muốn kiểm tra xem cái nào sẵn sàng
để `recv()`, bạn có thể thêm chúng vào một `set()` và truyền tập hợp đó vào
`select()`. Nó sẽ block cho đến khi một cái sẵn sàng đọc.

Tập hợp này có thể dùng làm danh sách chính tắc (canonical list) các socket
đang kết nối. Bạn cần theo dõi tất cả chúng ở đâu đó, và đây là nơi tốt.
Khi có kết nối mới, bạn thêm vào tập hợp; khi kết nối ngắt, bạn xóa ra. Như
vậy nó luôn chứa socket của tất cả các kết nối hiện tại.

Đây là ví dụ. `select()` nhận ba đối số và trả về ba giá trị. Ta chỉ xem
cái đầu tiên của mỗi bên thôi, bỏ qua phần còn lại.

``` {.py}
read_set = {s1, s2, s3}

ready_to_read, _, _ = select.select(read_set, {}, {})
```

Tại đây, ta có thể duyệt qua các socket đã sẵn sàng và nhận dữ liệu.

``` {.py}
for s in ready_to_read:
    data = s.recv(4096)
```

## Dùng `select()` với Socket Lắng Nghe

Nếu bạn quan sát kỹ, có thể bạn đang tự hỏi: nếu server đang block
trong lệnh gọi `select()` chờ dữ liệu đến, làm sao nó có thể gọi `accept()`
để chấp nhận kết nối mới? Chẳng phải kết nối mới sẽ phải chờ sao? Hơn nữa,
`accept()` cũng block... làm sao ta quay lại `select()` nếu đang bị block ở đó?

May mắn thay, `select()` cho chúng ta câu trả lời: _bạn có thể thêm socket
lắng nghe (listening socket) vào tập hợp!_ Khi socket lắng nghe xuất hiện
là "sẵn sàng đọc" (ready-to-read), điều đó có nghĩa là có một kết nối mới
đến cần `accept()`.

## Thuật Toán Chính

Kết hợp lại, ta có lõi của bất kỳ vòng lặp chính nào dùng `select()`:

``` {.default}
add the listener socket to the set

main loop:

    call select() and get the sockets that are ready to read

    for all sockets that are ready to read:

        if the socket is the listener socket:
            accept() a new connection
            add the new socket to our set!

        else the socket is a regular socket:
            recv() the data from the socket

            if you receive zero bytes
                the client hung up
                remove the socket from tbe set!
```

## Còn Các Đối Số Kia Của `select()` Thì Sao?

`select()` thực ra nhận ba đối số. (Tuy nhiên với dự án này ta chỉ cần dùng
đối số đầu tiên, nên phần này chỉ mang tính thông tin.)

Chúng tương ứng với:

* Những socket nào bạn muốn theo dõi để biết khi nào sẵn sàng đọc (ready-to-read)
* Những socket nào bạn muốn theo dõi để biết khi nào sẵn sàng ghi (ready-to-write)
* Những socket nào bạn muốn theo dõi về điều kiện ngoại lệ (exception conditions)

Và các giá trị trả về cũng ánh xạ tương ứng.

``` {.py}
read, write, exc = select.select(read_set, write_set, exc_set)
```

Nhưng một lần nữa, với dự án này ta chỉ dùng cái đầu và bỏ qua phần còn lại.

``` {.py}
read, _, _ = select.select(read_set, {}, {})
```

### Timeout (Hết Thời Gian)

Mình hơi nói lươn một chút. Có một đối số thứ tư tùy chọn là `timeout`. Đây là
số giây (dạng số thực) để chờ một sự kiện xảy ra; nếu không có gì xảy ra trong
khoảng thời gian đó, `select()` trả về và không có socket nào trong kết quả được
đánh dấu là sẵn sàng.

Bạn cũng có thể đặt timeout là `0` nếu muốn chỉ thăm dò (poll) các socket.

## Dùng `select()` với `send()`

Nếu máy tính của bạn cố gửi quá nhiều quá nhanh, lệnh gọi `send()` có thể block.
Tức là, hệ điều hành sẽ cho nó ngủ trong khi xử lý tồn đọng dữ liệu cần gửi.

Nhưng giả sử bạn thực sự không muốn lệnh gọi bị block và muốn tiếp tục xử lý.

Bạn có thể dùng `select()` để kiểm tra xem socket có block khi `send()` hay không,
bằng cách truyền một tập hợp chứa socket descriptor đó làm đối số thứ hai.

Nó sẽ hoạt động tương tự như tập hợp "sẵn sàng đọc" ở trên.

## Suy Ngẫm

* Tại sao không thể chỉ gọi `recv()` trên tất cả socket đã kết nối? `select()` mang
  lại lợi ích gì?

* Khi `select()` hiển thị một socket "sẵn sàng đọc" (ready-to-read), điều đó có
  nghĩa gì nếu socket đó là listening socket so với socket thông thường?

* Tại sao ta phải thêm listening socket vào tập hợp? Tại sao không gọi `accept()`
  rồi mới gọi `select()`?

