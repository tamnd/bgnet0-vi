# Dự án 6: Định tuyến với Thuật toán Dijkstra (Routing with Dijkstra's)

Các Interior Gateway Protocol chia sẻ thông tin với nhau sao cho mỗi router
có bản đồ đầy đủ của mạng mà nó thuộc về. Bằng cách này, mỗi router có thể
đưa ra quyết định định tuyến tự chủ khi được cho một địa chỉ IP. Bất kể gói
tin đi đâu, router luôn có thể chuyển tiếp nó theo đúng hướng.

Các IGP như Open Shortest Path First (OSPF) dùng Thuật toán Dijkstra để tìm
đường ngắn nhất trên đồ thị có trọng số (weighted graph).

Trong dự án này, ta sẽ mô phỏng việc định tuyến đó. Ta sẽ cài đặt Thuật toán
Dijkstra để in ra đường ngắn nhất từ một IP đến một IP khác, hiển thị IP của
tất cả router ở giữa.

Ta sẽ không dùng mạng thật cho điều này. Thay vào đó, chương trình của bạn
sẽ đọc một file JSON chứa mô tả mạng rồi tính toán route từ đó.

## Banned Functions (Hàm bị cấm)

Bạn phải tự cài đặt Dijkstra. Không có điểm nào nếu dùng thư viện có sẵn!

## Graphs Refresher (Ôn lại về Đồ thị)

Đồ thị (graph) được tạo thành từ _vertices_ (đỉnh) và _edges_ (cạnh). Đôi
khi vertex được gọi là "vertexes" hay "verts" hay "nodes" (nút). Edge là
kết nối từ một nút đến một nút khác.

Bất kỳ nút nào trên đồ thị đều có thể kết nối với bất kỳ số lượng nút khác
nào, kể cả không nút nào. Một nút có thể kết nối với mọi nút khác. Thậm chí
có thể kết nối với chính nó.

Một cạnh có thể có _weight_ (trọng số) thường có nghĩa là chi phí để đi qua
cạnh đó khi bạn đang đi theo một đường trong đồ thị.

Ví dụ, hãy tưởng tượng một bản đồ đường cao tốc hiển thị các thành phố và
đường cao tốc giữa các thành phố. Và mỗi đường cao tốc được ghi nhãn với độ
dài của nó. Trong ví dụ này, các thành phố sẽ là vertices, các đường cao tốc
sẽ là edges, và độ dài đường cao tốc sẽ là trọng số cạnh.

Khi đi qua đồ thị, mục tiêu là giảm thiểu tổng tất cả trọng số cạnh mà bạn
gặp trên đường đi. Trên bản đồ của ta, mục tiêu sẽ là chọn các cạnh từ thành
phố xuất phát qua tất cả thành phố trung gian đến thành phố đích sao cho tổng
khoảng cách đi là ít nhất.

## Dijkstra's Algorithm Overview (Tổng quan Thuật toán Dijkstra)

Edsger Dijkstra (_DIKE-struh_) là một nhà khoa học máy tính nổi tiếng đã nghĩ
ra nhiều thứ, nhưng một trong số đó có ảnh hưởng đến mức chỉ được biết đến
bằng tên của ông: Thuật toán Dijkstra.

> Mẹo: Bí quyết để đánh vần "Dijkstra" là nhớ rằng "ijk" xuất hiện theo thứ
> tự.

Nếu bạn muốn tìm đường ngắn nhất giữa các nút trong đồ thị không trọng số
(unweighted graph), bạn chỉ cần thực hiện duyệt theo chiều rộng (BFS) cho đến
khi tìm thấy thứ bạn đang tìm. Khoảng cách chỉ được đo bằng "hop" (bước nhảy).

Nhưng nếu bạn thêm trọng số vào các cạnh giữa các nút, BFS không thể giúp
bạn phân biệt chúng. Có thể một số đường rất đáng mơ ước, còn một số lại
rất không đáng.

Dijkstra _có thể_ phân biệt. Nó là BFS có kèm một nét thay đổi.

Ý chính của thuật toán là: khám phá ra từ điểm xuất phát, chỉ theo đuổi con
đường có tổng độ dài ngắn nhất cho đến nay.

Tổng trọng số của mỗi đường là tổng trọng số tất cả các cạnh của nó.

Trong đồ thị kết nối tốt, sẽ có _rất nhiều_ đường tiềm năng từ điểm bắt đầu
đến đích. Nhưng vì ta chỉ theo đuổi đường ngắn nhất đã biết cho đến nay, ta
sẽ không bao giờ theo đuổi một đường đưa ta đi một triệu dặm ngoài đường, giả
sử ta biết có một đường ngắn hơn một triệu dặm.

## Dijkstra's Implementation (Cài đặt Dijkstra)

Dijkstra xây dựng cấu trúc cây trên đỉnh đồ thị. Khi bạn tìm thấy đường ngắn
nhất từ bất kỳ nút nào trở về điểm bắt đầu, nút đó ghi lại nút trước đó trong
đường của nó như _parent_ (cha) của nó.

Nếu sau đó tìm thấy một đường ngắn hơn khác, parent được chuyển sang nút của
đường ngắn hơn mới.

[flw[Wikipedia có một số sơ đồ hay hiển thị nó trong
thực tế|Dijkstra's_algorithm]].

Vậy làm cách nào để nó hoạt động?

Bản thân Dijkstra chỉ xây dựng cây đại diện cho các đường ngắn nhất trở về
điểm bắt đầu. Ta sẽ theo dõi cây đường ngắn nhất đó sau để tìm một đường cụ
thể.

* Thuật toán Dijkstra để tính tất cả đường ngắn nhất trên đồ thị từ điểm nguồn:
  * Khởi tạo:
    * Tạo một tập `to_visit` rỗng. Đây là tập tất cả các nút ta vẫn cần thăm.
    * Tạo một từ điển `distance`. Với bất kỳ nút nào (là key), nó sẽ chứa
      khoảng cách từ nút đó đến nút xuất phát
    * Tạo một từ điển `parent`. Với bất kỳ nút nào (là key), nó liệt kê key
      cho nút dẫn trở lại nút xuất phát (theo đường ngắn nhất).
    * Với mọi nút:
      * Đặt `parent` của nó thành `None`.
      * Đặt `distance` của nó thành vô cực. (Python có vô cực trong
        `math.inf`, nhưng bạn cũng có thể dùng một số rất lớn, ví dụ 4 tỷ.)
      * Thêm nút vào tập `to_visit`.
    * Đặt khoảng cách đến nút xuất phát thành `0`.

  * Chạy:
    * Trong khi `to_visit` không rỗng:
      * Tìm nút trong `to_visit` có `distance` nhỏ nhất. Gọi đây là "nút
        hiện tại".
      * Xóa nút hiện tại khỏi tập `to_visit`.
      * Với mỗi nút láng giềng của nút hiện tại còn trong `to_visit`:
        * Tính khoảng cách từ nút xuất phát đến láng giềng. Đây là khoảng
          cách của nút hiện tại cộng với trọng số cạnh đến láng giềng.
        * Nếu khoảng cách tính được nhỏ hơn giá trị hiện tại của láng giềng
          trong `distance`:
          * Đặt giá trị của láng giềng trong `distance` bằng khoảng cách tính được.
          * Đặt `parent` của láng giềng thành nút hiện tại.
        * [Quá trình này gọi là "relaxing" (thư giãn). Khoảng cách nút bắt
          đầu từ vô cực và "thư giãn" xuống khoảng cách ngắn nhất của chúng.]
 
Wikipedia cung cấp pseudocode này, nếu dễ tiêu hóa hơn:

``` {.py}
 1  function Dijkstra(Graph, source):
 2
 3      for each vertex v in Graph.Vertices:
 4          dist[v] ← INFINITY
 5          prev[v] ← UNDEFINED
 6          add v to Q
 7      dist[source] ← 0
 8
 9      while Q is not empty:
10          u ← vertex in Q with min dist[u]
11          remove u from Q
12
13          for each neighbor v of u still in Q:
14              alt ← dist[u] + Graph.Edges(u, v)
15              if alt < dist[v]:
16                  dist[v] ← alt
17                  prev[v] ← u
18
19      return dist[], prev[]
```

Đến đây, ta đã xây dựng được cây của mình gồm tất cả các con trỏ `parent`.

Để tìm đường ngắn nhất từ một điểm trở về điểm bắt đầu (ở gốc của cây), bạn
chỉ cần theo dõi các con trỏ `parent` từ điểm đó trở lên cây.

* Lấy Đường ngắn nhất từ nguồn đến đích:
  * Đặt nút hiện tại của ta thành nút **đích**.
  * Đặt `path` của ta thành mảng rỗng.
  * Trong khi nút hiện tại không phải nút xuất phát:
    * Thêm nút hiện tại vào `path`.
    * nút hiện tại = `parent` của nút hiện tại
  * Thêm nút xuất phát vào path.

Tất nhiên, điều này sẽ xây dựng đường theo thứ tự ngược. Nó phải như vậy vì
tất cả con trỏ parent đều trỏ về nút xuất phát ở gốc của cây. Hoặc là đảo
ngược nó ở cuối, hoặc chạy thuật toán Dijkstra chính bằng cách truyền đích
vào vị trí nguồn.

### Getting the Minimum Distance (Lấy khoảng cách nhỏ nhất)

Một phần của thuật toán là tìm nút với `distance` nhỏ nhất vẫn còn trong tập
`to_visit`.

Với dự án này, bạn có thể chỉ cần thực hiện tìm kiếm tuyến tính `O(n)` để
tìm nút có khoảng cách ngắn nhất cho đến nay.

Trong thực tế, điều này quá tốn kém --- hiệu suất `O(n²)` theo số vertices.
Vì vậy các cài đặt thực tế sẽ dùng [min
heap](https://en.wikipedia.org/wiki/Binary_heap) (đống tối thiểu) sẽ giúp
lấy giá trị nhỏ nhất hiệu quả hơn trong thời gian `O(log n)`. Điều này đưa
ta đến `O(n log n)` theo số verts.

Nếu bạn muốn thử thách thêm, hãy dùng min heap.

## What About Our Project? (Còn dự án của ta thì sao?)

[_Tất cả địa chỉ IP trong dự án này là địa chỉ IPv4._]

[fls[Tải skeleton code ZIP tại đây|dijkstra/dijkstra.zip]].

Được rồi, đó là nhiều nội dung tổng quát.

Vậy điều đó tương ứng với gì trong dự án?

### The Function, Inputs, and Outputs (Hàm, Đầu vào, và Đầu ra)

Bạn phải cài đặt hàm này:

``` {.py}
def dijkstras_shortest_path(routers, src_ip, dest_ip):
```

Đầu vào của hàm là:

* `routers`: Một từ điển đại diện cho đồ thị.
* `src_ip`: Địa chỉ IP nguồn dạng chuỗi chấm-số.
* `dest_ip`: Địa chỉ IP đích dạng chuỗi chấm-số.

Đầu ra của hàm là:

* Một mảng chuỗi hiển thị tất cả địa chỉ IP router dọc theo route.
  * **Lưu ý: Nếu IP nguồn và IP đích ở cùng subnet với nhau, trả về mảng
    rỗng.** Không có router nào tham gia trong trường hợp này.

Code để chạy hàm của bạn đã được bao gồm trong skeleton code ở trên. Nó sẽ
xuất ra console các dòng như thế này hiển thị nguồn, đích và tất cả router ở
giữa:

``` {.default}
10.34.46.25 -> 10.34.166.228    ['10.34.46.1', '10.34.98.1', '10.34.166.1']
```

### The Graph Representation (Biểu diễn Đồ thị)

Từ điển đồ thị trong `routers` trông như đoạn trích này:

``` {.json}
{
    "10.34.98.1": {
        "connections": {
            "10.34.166.1": {
                "netmask": "/24",
                "interface": "en0",
                "ad": 70
            },
            "10.34.194.1": {
                "netmask": "/24",
                "interface": "en1",
                "ad": 93
            },
            "10.34.46.1": {
                "netmask": "/24",
                "interface": "en2",
                "ad": 64
            }
        },
        "netmask": "/24",
        "if_count": 3,
        "if_prefix": "en"
    },
     
    # ... etc. ...
```

Các key cấp cao nhất (ví dụ `"10.34.98.1"`) là các IP router. Đây là các
vertices của đồ thị.

Với mỗi cái, bạn có một danh sách `"connections"` là các edges của đồ thị.

Trong mỗi connection, bạn có một trường `"ad"` là trọng số cạnh.

> "AD" là viết tắt của _Administrative Distance_ (Khoảng cách quản trị). Đây
> là trọng số được đặt thủ công hoặc tự động (hoặc hỗn hợp cả hai) định nghĩa
> mức độ tốn kém của một đoạn route cụ thể.
> Giá trị mặc định là 110. Số cao hơn thì tốn kém hơn.
>
> Chỉ số này bao gồm nhiều ý tưởng về route, bao gồm băng thông nó cung cấp,
> mức độ tắc nghẽn, mức độ các admin muốn nó được dùng (hay không), v.v.

Netmask cho IP router nằm trong trường `"netmask"`, và có thêm các trường
`"netmask"` cho tất cả router connection.

Trường `"interface"` cho biết thiết bị mạng nào trên router được dùng để
đến router láng giềng. Nó không được dùng trong dự án này.

`"if_count"` và `"if_prefix"` cũng không được dùng trong dự án này.

## Input File and Example Output (File đầu vào và Đầu ra mẫu)

Archive skeleton bao gồm file đầu vào mẫu (`example1.json`) và đầu ra kỳ vọng
cho file đó (`example1_output.json`).

## Hints (Gợi ý)

* Dựa nhiều vào các hàm mạng bạn đã viết trong dự án trước!
* Hiểu đầy đủ mô tả dự án này trước khi đưa ra kế hoạch!
* Đưa ra kế hoạch càng nhiều càng tốt trước khi viết bất kỳ code nào!

<!--
Rubric:

12
Starting router IP is correctly determined from source IP address.

12
Ending router IP is correctly determined from destination IP address.

8
Shortest path array does not include start IP

8
Shortest path array does not include end IP

20
Shortest path array includes all router IPs from source to destination in order source-to-destination.

20
Shortest path array contains the actual shortest path.

12
Empty shortest path is returned when source and destination are on the same subnet.

5
Code requested to be unmodified is unmodified
-->
