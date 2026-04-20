# Dự án: Dùng Select

Trong dự án này ta sẽ viết một server dùng `select()` để xử lý nhiều kết
nối đồng thời (simultaneous connections).

Client đã được cung cấp sẵn. Bạn chỉ cần điền vào phần server.

## Code Demo

Tải [fls[file ZIP này|select/select.zip]] với tất cả các file đầu vào.

File `select_client.py` đã hoàn chỉnh rồi.

Bạn cần điền vào file `select_server.py` để cho nó chạy.

## Các Tính Năng Cần Thêm

Server của bạn cần làm những việc sau:

* Khi client kết nối, server in ra thông tin kết nối của client theo
  dạng sau (IP và số port của client đứng trước):

  ``` {.default}
  ('127.0.0.1', 61457): connected
  ```

* Khi client ngắt kết nối, server in ra thông tin kết nối của client đó
  theo dạng:

  ``` {.default}
  ('127.0.0.1', 61457): disconnected
  ```

  **Gợi ý**: Bạn có thể dùng phương thức `.getpeername()` trên socket để
  lấy địa chỉ của đầu kia ngay cả sau khi nó đã ngắt kết nối. Nó trả về
  một tuple chứa `("host", port)`, giống như những gì bạn truyền vào
  `connect()`.

* Khi client gửi dữ liệu, server cần in ra độ dài dữ liệu và đối tượng
  bytestring thô nhận được:

  ``` {.default}
  ('127.0.0.1', 61457) 22 bytes: b'test1: xajrxttphhlwmjf'
  ```

## Ví Dụ Chạy

Chạy server:

``` {.sh}
python select_server.py 3490
```

Chạy các client:

``` {.sh}
python select_client.py alice localhost 3490
python select_client.py bob localhost 3490
python select_client.py chris localhost 3490
```

Đối số đầu tiên của client có thể là bất kỳ chuỗi nào --- server in nó ra
cùng với dữ liệu để giúp bạn nhận biết client nào gửi.

Ví dụ output:

``` {.default}
waiting for connections
('127.0.0.1', 61457): connected
('127.0.0.1', 61457) 22 bytes: b'test1: xajrxttphhlwmjf'
('127.0.0.1', 61457) 22 bytes: b'test1: geqtgopbayogenz'
('127.0.0.1', 61457) 23 bytes: b'test1: jquijcatyhvfpydn'
('127.0.0.1', 61457) 23 bytes: b'test1: qbavdzfihualuxzu'
('127.0.0.1', 61457) 24 bytes: b'test1: dyqmzawthxjpkgpcg'
('127.0.0.1', 61457) 23 bytes: b'test1: mhxebjpmsmjsycmj'
('127.0.0.1', 61458): connected
('127.0.0.1', 61458) 23 bytes: b'test2: bejnrwxftgzcgdyg'
('127.0.0.1', 61457) 24 bytes: b'test1: ptcavvhroihmgdfyw'
('127.0.0.1', 61458) 24 bytes: b'test2: qrumcrmqxauwtcuaj'
('127.0.0.1', 61457) 26 bytes: b'test1: tzoitpusjaxljkfxfvw'
('127.0.0.1', 61457) 17 bytes: b'test1: mtcwokwquc'
('127.0.0.1', 61458) 18 bytes: b'test2: whvqnzgtaem'
('127.0.0.1', 61457): disconnected
('127.0.0.1', 61458) 21 bytes: b'test2: raqlvexhimxfgl'
('127.0.0.1', 61458): disconnected
```

<!-- Rubric:

5
Server prints proper client connection message

5
Server prints proper client disconnection message

5
Server prints proper client data received message

5
Server uses select() to wait for incoming connections

5
Server uses select() to wait for incoming client data

-->
