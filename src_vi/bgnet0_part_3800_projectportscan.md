# Dự án: Quét Cổng (Port Scanning)

Giờ thì mình sẽ làm chút quét cổng (port scanning)!

**LƯU Ý: Chúng ta chỉ chạy lệnh này trên `localhost` để tránh rắc rối pháp lý.**

Để thực hiện, ta cần cài công cụ `nmap`.

MacOS:

``` {.sh}
brew install nmap
```

Windows WSL:

``` {.sh}
sudo apt-get update
sudo apt-get install nmap
```

1. **Quét Tất Cả Các Cổng Phổ Biến**

   Lệnh này sẽ quét 1000 cổng phổ biến nhất:

   ``` {.sh}
   nmap localhost
   ```

   Kết quả đầu ra là gì?

2. **Quét Toàn Bộ Cổng**

   Lệnh này sẽ quét tất cả cổng --- bắt đầu từ `0`:

   ``` {.sh}
   nmap -p0- localhost
   ```

   Kết quả đầu ra là gì?

3. **Chạy Server rồi Quét Cổng**

   Chạy bất kỳ chương trình TCP server nào bạn đã viết trong học kỳ này trên một cổng nào đó.

   Chạy lại lệnh quét toàn bộ cổng ở trên.

   * Để ý cổng của server bạn xuất hiện trong kết quả nhé!

   * Server của bạn có bị crash với lỗi "Connection reset" không? Nếu có, tại sao?
     Nếu không, hãy đoán xem tại sao điều này có thể xảy ra dù bạn không thấy lỗi
     từ phía server. (Xem chương [Port Scanning](#port-scanning) nhé!)

<!-- Rubric

20 points

5
Appropriate output from `nmap localhost`

5
Appropriate output from `nmap -p0- localhost`

5
Appropriate output from `nmap -p0- localhost` that shows your server's open port

5
Explanation of the possible "Connection reset" error

-->
