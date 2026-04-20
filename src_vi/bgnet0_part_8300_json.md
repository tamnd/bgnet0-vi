# Phụ lục: JSON {#appendix-json}

Với dự án cuối, ta cần có khả năng encode và decode dữ liệu JSON.

Nếu bạn chưa quen với định dạng đó, [hãy xem phần giới thiệu nhanh trên
Wikipedia](https://en.wikipedia.org/wiki/JSON).

Trong phần này, ta sẽ xem xét ý nghĩa của việc encode và decode dữ liệu JSON.

## JSON Versus Native

Đây là một JSON object mẫu:

``` {.json}
{
    "name": "Ada Lovelace",
    "country": "England",
    "years": [ 1815, 1852 ]
}
```

Trong Python, bạn có thể tạo một đối tượng `dict` trông giống y như vậy:

``` {.json}
d = {
    "name": "Ada Lovelace",
    "country": "England",
    "years": [ 1815, 1852 ]
}
```

Nhưng đây là sự khác biệt chính: _tất cả dữ liệu JSON là chuỗi_ (strings).
JSON là biểu diễn dạng chuỗi của dữ liệu được đề cập.

## Chuyển Đổi Qua Lại

Nếu bạn có một chuỗi JSON, bạn có thể chuyển nó thành dữ liệu native Python bằng
hàm `json.loads()`.

``` {.py}
import json

data = json.loads('{ "name": "Ada" }')

print(data["name"])   # Prints Ada
```

Tương tự, nếu bạn có dữ liệu Python, bạn có thể chuyển nó sang định dạng chuỗi JSON
bằng `json.dumps()`:

``` {.py}
import json

data = { "name": "Ada" }

json_data = json.dumps(data)

print(json_data)  # Prints {"name": "Ada"}
```

## In Đẹp (Pretty Printing)

Nếu bạn có một đối tượng phức tạp, `json.dumps()` sẽ gộp tất cả lại trên một dòng.

Code này:

``` {.py}
d = {
    "name": "Ada Lovelace",
    "country": "England",
    "years": [ 1815, 1852 ]
}

json.dumps(d)
```

xuất ra:

``` {.default}
'{"name": "Ada Lovelace", "country": "England", "years": [1815, 1852]}'
```

Bạn có thể làm nó gọn hơn một chút bằng cách truyền đối số `indent` vào `json.dumps()`,
cho nó mức độ thụt đầu dòng.

``` {.py}
json.dumps(d, indent=4)
```

xuất ra:

``` {.default}
{
    "name": "Ada Lovelace",
    "country": "England",
    "years": [
        1815,
        1852
    ]
}
```

Gọn hơn nhiều.

## Dấu Nháy Kép Rất Quan Trọng

JSON yêu cầu chuỗi và tên key phải ở trong dấu nháy kép (double quotes). Dấu nháy
đơn không chấp nhận được. Thiếu dấu nháy thì _chắc chắn_ không được.

## Suy Ngẫm

* Sự khác biệt giữa một JSON object và một Python dictionary là gì?

* Nhìn vào bài viết Wikipedia, những loại dữ liệu nào có thể được biểu diễn trong JSON?
