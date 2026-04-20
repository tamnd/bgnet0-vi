# Phụ lục: Đa Luồng (Multithreading) {#appendix-threading}

_Đa luồng_ (multithreading) là ý tưởng rằng một tiến trình (process) có thể có
nhiều _luồng_ (threads) thực thi. Tức là, nó có thể chạy một số hàm cùng một lúc,
theo nghĩa nào đó.

Điều này thực sự hữu ích nếu bạn có một hàm đang chờ điều gì đó xảy ra, và bạn
cần một hàm khác tiếp tục chạy cùng lúc.

Điều này sẽ hữu ích trong một multiuser chat client vì nó phải làm hai việc cùng lúc,
cả hai đều block (chặn):

* Chờ người dùng gõ tin nhắn chat của họ.
* Chờ server gửi thêm tin nhắn.

Nếu không dùng đa luồng, ta sẽ không thể nhận tin nhắn từ server trong khi đang
chờ input người dùng và ngược lại.

> Ghi chú bên lề: `select()` thực ra có khả năng thêm các file descriptor thông
> thường vào tập hợp để lắng nghe. Vì vậy về mặt kỹ thuật nó _có thể_ lắng nghe
> dữ liệu trên các socket **và** bàn phím. Điều này không hoạt động trên Windows.
> Và thiết kế của client đơn giản hơn khi dùng đa luồng.

Hãy xem cách nó hoạt động trong Python.

## Các Khái Niệm

Có một vài thuật ngữ ta cần làm rõ trước.

* **Thread** (luồng): biểu diễn một "luồng thực thi", tức là, một phần của chương
  trình đang thực thi tại thời điểm cụ thể này. Nếu bạn muốn nhiều phần của chương
  trình thực thi cùng lúc, bạn có thể đặt chúng trong các thread riêng biệt.

* **Main Thread** (luồng chính): đây là luồng đang chạy theo mặc định. Ta chưa
  bao giờ đặt tên cho nó trước đây. Nhưng code bạn chạy mà không nghĩ đến thread
  thực ra đang chạy trong main thread.

* **Spawning** (tạo): Ta nói ta "spawn" (tạo) một thread mới để chạy một hàm cụ thể.
  Nếu ta làm vậy, hàm đó sẽ thực thi _cùng lúc_ với main thread. Cả hai sẽ chạy
  song song!

* **Join** (ghép): Một thread có thể chờ thread khác kết thúc bằng cách gọi phương
  thức `join()` của thread đó. Về mặt khái niệm, điều này ghép thread kia trở lại
  với thread đang gọi. Thường đây là main thread `join()` các thread nó đã spawn
  trở lại với nó.

* **Target** (đích): Thread target là hàm mà thread sẽ chạy. Khi hàm này return,
  thread kết thúc.

Điều quan trọng cần lưu ý là _các đối tượng global được chia sẻ giữa các thread_!
Điều này có nghĩa là một thread có thể đặt giá trị trong một đối tượng global và
các thread khác sẽ thấy những thay đổi đó. Bạn không cần lo lắng về điều này nếu
dữ liệu chia sẻ là read-only, nhưng phải cân nhắc nếu nó có thể ghi.

Chúng ta sắp đi sâu vào concurrency (đồng thời) và synchronization (đồng bộ hóa)
ở đây, vì vậy với dự án này, hãy đơn giản là không dùng bất kỳ đối tượng global
chia sẻ nào. Nhớ câu châm ngôn cũ:

> Shared Nothing Is Happy Everybody
> (Không Chia Sẻ Gì Là Mọi Người Vui Vẻ)

Đó không phải là câu châm ngôn cũ thật sự. Tôi vừa bịa ra. Và nó nghe có vẻ ích
kỷ khi đọc lại.

Quay lại với một khái niệm liên quan: các đối tượng cục bộ (local) _không_ được
chia sẻ giữa các thread. Điều này có nghĩa là thread có các biến cục bộ và giá
trị tham số riêng. Chúng có thể thay đổi chúng và những thay đổi đó sẽ không hiển
thị với các thread khác.

Ngoài ra, nếu bạn có nhiều thread chạy cùng lúc, thứ tự thực thi là không thể đoán
trước. Điều này chỉ thực sự trở thành vấn đề nếu có một số phụ thuộc về thời gian
hay dữ liệu giữa các thread, và một lần nữa chúng ta đang đi ra ngoài vùng an toàn.
Hãy chỉ cần biết rằng thứ tự thực thi là không thể đoán trước và điều đó sẽ ổn
với dự án này.

Thế là đủ để bắt đầu rồi.

## Đa Luồng trong Python

Hãy viết một chương trình spawn ba thread.

Mỗi thread sẽ chạy một hàm gọi là `runner()` (bạn có thể đặt tên hàm tùy ý).
Hàm này nhận hai đối số: `name` (tên) và `count` (số lần). Nó lặp và in `name`
ra `count` lần.

Thread kết thúc khi hàm `runner()` return.

Bạn có thể tạo thread mới bằng cách gọi constructor `threading.Thread()`.

Bạn có thể chạy thread bằng phương thức `.start()` của nó.

Và bạn có thể chờ thread hoàn thành bằng phương thức `.join()` của nó.

Hãy xem thử!

<!-- read in the projects/threaddemo.py file here -->
``` {.py}
import threading
import time

def runner(name, count):
    """ Thread running function. """

    for i in range(count):
        print(f"Running: {name} {i}")
        time.sleep(0.2)  # seconds

# Launch this many threads
THREAD_COUNT = 3

# We need to keep track of them so that we can join() them later. We'll
# put all the thread references into this array
threads = []

# Launch all threads!!
for i in range(THREAD_COUNT):

    # Give them a name
    name = f"Thread{i}"

    # Set up the thread object. We're going to run the function called
    # "runner" and pass it two arguments: the thread's name and count:
    t = threading.Thread(target=runner, args=(name, i+3))

    # The thread won't start executing until we call `start()`:
    t.start()

    # Keep track of this thread so we can join() it later.
    threads.append(t)

# Join all the threads back up to this, the main thread. The main thread
# will block on the join() call until the thread is complete. If the
# thread is already complete, the join() returns immediately.

for t in threads:
    t.join()

print("All child threads complete!")
```

Và đây là output:

``` {.default}
Running: Thread0 0
Running: Thread1 0
Running: Thread2 0
Running: Thread1 1
Running: Thread0 1
Running: Thread2 1
Running: Thread1 2
Running: Thread0 2
Running: Thread2 2
Running: Thread1 3
Running: Thread2 3
Running: Thread2 4
All child threads complete!
```

Tất cả chúng đang chạy cùng lúc!

Chú ý thứ tự thực thi không nhất quán. Nó có thể thay đổi từ lần chạy này sang
lần chạy khác. Và điều đó ổn vì các thread không phụ thuộc vào nhau.

## Daemon Thread

Python phân loại thread theo hai cách khác nhau:

* Thread thông thường, bình thường
* Daemon thread (phát âm là "DEE-mun" hoặc "DAY-mun")

Ý tưởng chung là một daemon thread sẽ tiếp tục chạy mãi mãi và không bao giờ
return từ hàm của nó. Không giống như các thread thông thường, những thread này
sẽ tự động bị Python kill khi tất cả các thread không phải daemon đã chết.

### Điều Này Liên Quan Đến `CTRL-C`

Nếu bạn kill main thread bằng `CTRL-C` và không có thread thông thường nào khác
đang chạy, tất cả daemon thread cũng sẽ bị kill.

Nhưng nếu bạn có một số thread thông thường, bạn phải `CTRL-C` qua tất cả chúng
trước khi quay lại dấu nhắc lệnh.

Trong dự án cuối, ta sẽ chạy một thread mãi mãi để lắng nghe tin nhắn đến từ
server. Vì vậy đó nên là daemon thread.

Bạn có thể tạo daemon thread như sau:

``` {.py}
t = threading.Thread(target=runner, daemon=True)
```

Khi đó ít nhất `CTRL-C` sẽ dễ dàng thoát ra khỏi client.

## Suy Ngẫm

* Mô tả loại vấn đề mà việc dùng thread có thể giải quyết.

* Sự khác biệt giữa daemon thread và non-daemon thread trong Python là gì?

* Bạn phải làm gì để tạo main thread trong Python, nếu có?

## Dự Án Threading

Nếu bạn muốn thử sức, đây là một dự án nhỏ để làm.

### Chúng Ta Xây Dựng Gì

Khách hàng đã thuê chúng ta trong trường hợp này có một số dãy số. Họ muốn tổng
cộng của tất cả các tổng của tất cả các dãy.

Ví dụ, nếu các dãy là:

``` {.py}
[
    [1,5],
    [20,22]
]
```

Ta muốn:

* Đầu tiên cộng `1+2+3+4+5` để ra `15`.
* Sau đó cộng `20+21+22` để ra `63`.
* Sau đó cộng `15+63` để ra `78`, là đáp án cuối.

Họ muốn các tổng của dãy và tổng cuối được in ra. Với ví dụ trên, họ muốn in:

``` {.default}
[15, 63]
78
```

### Cấu Trúc Tổng Thể

Chương trình PHẢI dùng thread để giải quyết vấn đề vì khách hàng thực sự thích
tính song song (parallelism).

Bạn nên viết một hàm cộng một dãy số. Sau đó bạn sẽ spawn một thread cho mỗi
dãy và để thread đó xử lý dãy đó. Nếu có 10 dãy số, sẽ có 10 thread, mỗi cái
xử lý một dãy.

Main thread sẽ:

* Cấp phát một mảng cho kết quả. Độ dài mảng này phải bằng số dãy (cũng bằng
  số thread). Mỗi thread có slot riêng để lưu kết quả trong mảng.

  ``` {.py}
  result = [0] * n   # Create an array of `n` zeros
  ```

* Trong một vòng lặp, khởi động tất cả các thread. Đối số của thread là:

  * Số ID thread `0..(n-1)`, trong đó `n` là số thread.
    Đây là chỉ số thread sẽ dùng để lưu kết quả trong mảng kết quả.

  * Giá trị bắt đầu của dãy.

  * Giá trị kết thúc của dãy.

  * Mảng kết quả, nơi thread sẽ lưu kết quả.

* Main thread nên theo dõi tất cả các đối tượng thread trả về từ
  `threading.Thread()` trong một mảng. Nó sẽ cần chúng ở bước tiếp theo.

* Trong một vòng lặp khác sau đó, gọi `.join()` trên tất cả các thread.
  Điều này sẽ khiến main thread chờ cho đến khi tất cả các subthread hoàn thành.

* In kết quả. Sau tất cả các `join()`, mảng kết quả sẽ có tất cả các tổng trong đó.

### Các Hàm Hữu Ích

* `threading.Thread()`: tạo một thread.

* `range(a, b)`: tạo ra tất cả các số nguyên trong dãy `[a, b)` dưới dạng iterable.

* `sum()`: tính tổng của một iterable.

* `enumerate()`: tạo ra index và giá trị trên một iterable.

### Những Gì Hàm Chạy Thread Cần

Tất cả các thread sẽ ghi vào một mảng chia sẻ. Mảng này có thể được thiết lập trước
để có các số không trong tất cả các phần tử. Phải có một phần tử cho mỗi thread,
để mỗi thread có thể điền vào phần tử phù hợp.

Để làm điều này, bạn phải truyền số chỉ số (index) của thread vào hàm chạy của nó
để nó biết phần tử nào trong mảng chia sẻ để đặt kết quả vào!

### Ví Dụ Chạy

Đầu vào ví dụ (bạn có thể hardcode thẳng trong chương trình):

``` {.py}
ranges = [
    [10, 20],
    [1, 5],
    [70, 80],
    [27, 92],
    [0, 16]
]
```

Output tương ứng:

``` {.default}
[165, 15, 825, 3927, 136]
5068
```

### Mở Rộng

* Nếu bạn đang dùng `sum()` hoặc vòng lặp `for`, độ phức tạp thời gian (time complexity)
  của bạn là bao nhiêu?

* Công thức dạng đóng cho tổng các số nguyên từ 1 đến _n_ là `n*(n+1)//2`. Bạn có thể
  dùng nó để đạt độ phức tạp thời gian tốt hơn không? Tốt hơn bao nhiêu?


<!-- Rubric:

10
Threads spawned, one thread per range

5
Main thread join()s will all spawned threads

5
Each thread properly populates a results array

5
Correct array of sums is outputted 

5
Correct complete total is outputted

-->
