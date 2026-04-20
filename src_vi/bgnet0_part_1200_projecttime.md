# Dự Án: Giờ Nguyên Tử

Bạn sẽ kết nối đến đồng hồ nguyên tử tại NIST (Viện Tiêu Chuẩn và Công Nghệ Quốc Gia Hoa Kỳ) và lấy số giây kể từ ngày 1 tháng 1 năm 1900 từ đồng hồ của họ. (Đó là rất nhiều giây.)

Và bạn sẽ in nó ra.

Sau đó bạn sẽ in ra thời gian hệ thống từ đồng hồ trên máy tính của bạn.

Nếu đồng hồ máy tính của bạn chính xác, các con số sẽ rất gần nhau trong kết quả đầu ra:

``` {.default}
NIST time  : 3874089043
System time: 3874089043
```

Chúng ta chỉ viết một client trong trường hợp này. Server đã tồn tại và đang chạy rồi.

## Lưu Ý Về Tính Hợp Pháp

NIST vận hành server này để sử dụng công khai. Nói chung, bạn không muốn kết nối đến các server mà chủ sở hữu không muốn bạn làm. Đó là cách nhanh chóng để vi phạm pháp luật.

Nhưng trong trường hợp này, công chúng nói chung được chào đón sử dụng nó.

## Lưu Ý Về Sử Dụng Được Phép

**Server NIST không bao giờ được truy vấn nhiều hơn một lần mỗi bốn giây**. Họ có thể bắt đầu từ chối dịch vụ nếu bạn vượt quá tốc độ này.

Nếu bạn chạy code thường xuyên và muốn chắc chắn rằng bạn đã chờ 4 giây, bạn có thể đệm thời gian chạy bằng lệnh `sleep` trên dòng lệnh:

``` {.sh}
sleep 4; python3 timeclient.py
```

## Epoch (Điểm Gốc Thời Gian)

Trong ngôn ngữ máy tính, chúng ta gọi "epoch" (kỷ nguyên) là "điểm bắt đầu của thời gian" từ góc độ máy tính.

Nhiều thư viện đo thời gian bằng "số giây kể từ epoch", tức là kể từ buổi bình minh của thời gian.

Chúng ta có nghĩa là gì với buổi bình minh của thời gian? Chà, điều đó tùy thuộc.

Nhưng trong thế giới Unix, buổi bình minh của thời gian rất cụ thể là ngày 1 tháng 1 năm 1970 lúc 00:00 UTC (còn gọi là Greenwich Mean Time --- Giờ Trung Bình Greenwich).

Trong các epoch khác, buổi bình minh của thời gian có thể là ngày khác. Ví dụ, Time Protocol (Giao thức Thời gian) mà chúng ta sẽ nói đến sử dụng ngày 1 tháng 1 năm 1900 lúc 00:00 UTC, trước Unix 70 năm.

Điều này có nghĩa là chúng ta sẽ phải thực hiện một số chuyển đổi. Nhưng may mắn cho bạn, chúng ta sẽ chỉ cung cấp cho bạn code sẽ trả về giá trị cho bạn và bạn không phải lo lắng về nó.

## Cảnh Báo Nghiêm Trọng Về Số Không

Vì những lý do tôi không hiểu, đôi khi server NIST sẽ trả về 4 byte toàn số không. Và đôi khi nó sẽ chỉ gửi không byte và đóng kết nối.

Nếu điều này xảy ra, bạn có thể sẽ thấy `0` xuất hiện làm thời gian NIST.

Chỉ cần thử chạy lại client để xem bạn có kết quả tốt sau một hoặc hai lần thử nữa không, lưu ý giới hạn một truy vấn mỗi 4 giây.

Họ có một IP xoay vòng cho `time.nist.gov` và có vẻ như một hoặc hai server có thể không hoạt động đúng.

Nếu nó tiếp tục ra số không, có thể có sự cố khác.

## Kế Hoạch

Đây là những gì chúng ta sẽ làm:

1. Kết nối đến server `time.nist.gov` trên cổng `37` (cổng Time Protocol).

2. Nhận dữ liệu. (Bạn không cần gửi bất cứ thứ gì.) Bạn nên nhận được 4 byte.

3. 4 byte đại diện cho một số big-endian 4 byte. Giải mã 4 byte đó với `.from_bytes()` vào một biến số.

4. In ra giá trị từ time server, đó sẽ là số giây kể từ ngày 1 tháng 1 năm 1900 lúc 00:00.

5. In ra thời gian hệ thống tính bằng số giây kể từ ngày 1 tháng 1 năm 1900 lúc 00:00.

Hai lần sẽ đại khái (hoặc chính xác) đồng ý nếu đồng hồ máy tính của bạn chính xác.

Con số nên hơn 3.870.000.000 một chút, để cho bạn ý tưởng sơ bộ. Và nó nên tăng thêm một lần mỗi giây.

### 1. Kết Nối Đến Server

Time Protocol nói chung hoạt động với cả UDP và TCP. Cho dự án này bạn phải dùng TCP sockets, giống như chúng ta đã làm cho các dự án khác.

Vì vậy hãy tạo một socket và kết nối đến `time.nist.gov` trên cổng `37`, cổng Time Protocol.

### 2. Nhận Dữ Liệu

Về mặt kỹ thuật bạn nên dùng một vòng lặp để làm điều này, nhưng rất khó xảy ra là một lượng dữ liệu nhỏ như vậy sẽ bị chia thành nhiều gói tin.

Bạn sẽ nhận được tối đa 4 byte, dù bạn yêu cầu bao nhiêu.

Bạn có thể đóng socket ngay sau khi nhận dữ liệu.

### 3. Giải Mã Dữ Liệu

Dữ liệu là một số nguyên được mã hóa dưới dạng 4 byte, big-endian.

Dùng phương thức `.from_bytes()` được đề cập trong các chương trước để chuyển đổi bytestream từ `recv()` thành một giá trị.

### 4. In Ra Thời Gian NIST

Nó nên ở định dạng này:

``` {.default}
NIST time  : 3874089043
```

### 5. In Ra Thời Gian Hệ Thống

Đây là một đoạn code Python lấy số giây kể từ ngày 1 tháng 1 năm 1900 lúc 00:00 từ đồng hồ hệ thống của bạn.

Bạn có thể dán cái này ngay vào code của mình và gọi nó để lấy thời gian hệ thống.

In thời gian hệ thống ngay sau thời gian NIST theo định dạng sau:

``` {.default}
System time: 3874089043
```

Đây là code:

``` {.py}
import time

def system_seconds_since_1900():
    """
    The time server returns the number of seconds since 1900, but Unix
    systems return the number of seconds since 1970. This function
    computes the number of seconds since 1900 on the system.
    """

    # Number of seconds between 1900-01-01 and 1970-01-01
    seconds_delta = 2208988800

    seconds_since_unix_epoch = int(time.time())
    seconds_since_1900_epoch = seconds_since_unix_epoch + seconds_delta

    return seconds_since_1900_epoch
```

Giả sử con số của NIST không phải là số không:

* Nếu con số này trong vòng 10 giây so với con số của NIST, thật tuyệt.

* Nếu nó trong vòng 86.400 giây, đó là OK. Và tôi muốn nghe về điều đó vì có thể là bug trong code trên.

* Nếu nó trong vòng một triệu giây, tôi thực sự muốn nghe về điều đó.

* Nếu nó ngoài phạm vi đó, có thể là bug trong code của bạn. Bạn có dùng `"big"` endian không? Bạn có đang nhận 4 byte không?

<!-- Rubric

55 points

-5 Program uses TCP sockets
-10 Program connects successfully to time.nist.gov port 37
-10 Program receives data from the server
-5 Program close()s the socket after receiving data
-10 Program properly decodes data from server
-5 Program properly prints out results
-10 Results are within 86,400 seconds of each other

 -->
