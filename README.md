# Hướng dẫn Khái niệm Mạng của Beej (Bản tiếng Việt)

> Tiếng Việt &middot; [English](README.en.md)

Bản dịch tiếng Việt của [Beej's Guide to Network Concepts][bgnet0],
tác giả Brian "Beej Jorgensen" Hall. Cuốn sách giải thích các khái niệm
mạng máy tính từ gốc rễ: từ mô hình phân tầng, IP, TCP, UDP, đến
subnetting, routing, DNS, DHCP, firewall, và cả socket programming thực
chiến. Đọc miễn phí, chia sẻ thoải mái.

> Khác với [Beej's Guide to Network Programming][bgnet], quyển này tập
> trung vào **khái niệm** mạng, không phải API C. Bạn sẽ học TCP/IP từ
> trong ra ngoài, chứ không phải chỉ biết gọi `connect()`.

[bgnet0]: https://beej.us/guide/bgnet0/
[bgnet]: https://beej.us/guide/bgnet/

## Có hợp với tôi không?

Hợp nếu bạn đang học mạng máy tính hoặc muốn hiểu chắc những gì xảy
ra bên dưới khi code network. Không yêu cầu biết C sâu---mỗi chương
đi kèm project Python thực hành.

Nếu bạn đọc tiếng Anh thoải mái, cứ [đọc bản gốc][bgnet0], nó ở ngay
đó thôi.

## Bố cục repo

```
bgnet0-vi/
├── src/         # Bản gốc tiếng Anh (lấy từ upstream, không sửa)
├── src_vi/      # Bản dịch tiếng Việt (phần hay ho ở đây)
├── source/      # Chương trình mẫu (giữ nguyên từ upstream)
├── translations/# Các bản dịch ngôn ngữ khác có sẵn từ upstream
├── website/     # Tài nguyên website của upstream
├── scripts/     # Build helper, release helper
├── bgbspd/      # Submodule build system dùng chung của Beej
├── ROADMAP.md   # Kế hoạch và tiến độ dịch
├── UPSTREAM.md  # Đang bám upstream ở commit nào
├── LICENSE.md   # CC BY-NC-ND 3.0, giống upstream
└── README.md    # Bạn đang ở đây
```

## Tình trạng

CI/CD tạm tắt trong lúc marathon dịch diễn ra. Sau khi 43 chương
dịch xong, CI/CD bật lại và bản release đầu tiên được cắt.
Theo dõi tiến độ ở [ROADMAP.md](ROADMAP.md).

## Giấy phép

Nội dung gốc tiếng Anh thuộc bản quyền của Brian "Beej Jorgensen" Hall,
phát hành theo [CC BY-NC-ND 3.0][license]. Bản dịch tiếng Việt cũng theo
giấy phép đó.

[license]: https://creativecommons.org/licenses/by-nc-nd/3.0/
