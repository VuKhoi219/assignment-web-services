# Comment Service API Documentation

## Tổng quan
Comment Service là một Web Service sử dụng SOAP/WSDL để quản lý các bình luận và đánh giá cho các địa điểm. Service này cung cấp các chức năng CRUD (Create, Read, Update, Delete) cho comments.

## Thông tin kết nối
- **Service Name**: CommentService
- **Implementation**: CommentServiceImpl
- **Database**: MySQL (wed_service)
- **Protocol**: SOAP Web Service

## Cấu trúc dữ liệu

### Comment Entity
```xml
<Comment>
    <id>int</id>
    <comment>string</comment>
    <rating>int (1-5)</rating>
    <user>User</user>
    <location>Location</location>
</Comment>
```

### User Entity
```xml
<User>
    <id>int</id>
    <username>string</username>
    <email>string</email>
</User>
```

### Location Entity
```xml
<Location>
    <id>int</id>
    <title>string</title>
    <description>string</description>
</Location>
```

## API Methods

### 1. getComments()
**Mô tả**: Lấy danh sách tất cả comments với thông tin user và location đầy đủ

**Request**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:getComments/>
   </soap:Body>
</soap:Envelope>
```

**Response**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <ns2:getCommentsResponse xmlns:ns2="http://service.backend.example.com/">
         <return>
            <id>1</id>
            <comment>Great place to visit!</comment>
            <rating>5</rating>
            <user>
               <id>1</id>
               <username>john_doe</username>
               <email>john@example.com</email>
            </user>
            <location>
               <id>1</id>
               <title>Hoan Kiem Lake</title>
               <description>Beautiful lake in Hanoi</description>
            </location>
         </return>
      </ns2:getCommentsResponse>
   </soap:Body>
</soap:Envelope>
```

### 2. getComment(int id)
**Mô tả**: Lấy thông tin chi tiết của một comment theo ID

**Parameters**:
- `id` (int): ID của comment cần lấy

**Request**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:getComment>
         <arg0>1</arg0>
      </ser:getComment>
   </soap:Body>
</soap:Envelope>
```

**Response**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <ns2:getCommentResponse xmlns:ns2="http://service.backend.example.com/">
         <return>
            <id>1</id>
            <comment>Great place to visit!</comment>
            <rating>5</rating>
            <user>
               <id>1</id>
               <username>john_doe</username>
               <email>john@example.com</email>
            </user>
            <location>
               <id>1</id>
               <title>Hoan Kiem Lake</title>
               <description>Beautiful lake in Hanoi</description>
            </location>
         </return>
      </ns2:getCommentResponse>
   </soap:Body>
</soap:Envelope>
```

### 3. createComment(int locationId, String comment, int userId, int rating)
**Mô tả**: Tạo comment mới

**Parameters**:
- `locationId` (int): ID của địa điểm
- `comment` (String): Nội dung bình luận
- `userId` (int): ID của người dùng
- `rating` (int): Điểm đánh giá (1-5)

**Request**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:createComment>
         <arg0>1</arg0>
         <arg1>This is a wonderful place!</arg1>
         <arg2>1</arg2>
         <arg3>5</arg3>
      </ser:createComment>
   </soap:Body>
</soap:Envelope>
```

**Response**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <ns2:createCommentResponse xmlns:ns2="http://service.backend.example.com/">
         <return>Comment created successfully with ID: 123</return>
      </ns2:createCommentResponse>
   </soap:Body>
</soap:Envelope>
```

**Validation Rules**:
- Rating phải từ 1-5
- Comment không được rỗng
- User ID và Location ID phải tồn tại trong database

**Error Messages**:
- "Rating must be between 1 and 5"
- "Comment comment cannot be empty"
- "Invalid user or location ID"

### 4. updateComment(String commentComment, int rating, int commentId)
**Mô tả**: Cập nhật comment đã có

**Parameters**:
- `commentComment` (String): Nội dung bình luận mới
- `rating` (int): Điểm đánh giá mới (1-5)
- `commentId` (int): ID của comment cần cập nhật

**Request**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:updateComment>
         <arg0>Updated comment content</arg0>
         <arg1>4</arg1>
         <arg2>1</arg2>
      </ser:updateComment>
   </soap:Body>
</soap:Envelope>
```

**Response**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <ns2:updateCommentResponse xmlns:ns2="http://service.backend.example.com/">
         <return>Comment updated successfully</return>
      </ns2:updateCommentResponse>
   </soap:Body>
</soap:Envelope>
```

**Error Messages**:
- "Comment with ID {id} not found"
- "Rating must be between 1 and 5"
- "Comment comment cannot be empty"

### 5. deleteComment(int id)
**Mô tả**: Xóa comment theo ID

**Parameters**:
- `id` (int): ID của comment cần xóa

**Request**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:deleteComment>
         <arg0>1</arg0>
      </ser:deleteComment>
   </soap:Body>
</soap:Envelope>
```

**Response**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <ns2:deleteCommentResponse xmlns:ns2="http://service.backend.example.com/">
         <return>Comment deleted successfully</return>
      </ns2:deleteCommentResponse>
   </soap:Body>
</soap:Envelope>
```

**Error Messages**:
- "Comment with ID {id} not found"

### 6. getAverageRatingByLocation(int locationId)
**Mô tả**: Lấy điểm đánh giá trung bình của một địa điểm

**Parameters**:
- `locationId` (int): ID của địa điểm

**Request**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:getAverageRatingByLocation>
         <arg0>1</arg0>
      </ser:getAverageRatingByLocation>
   </soap:Body>
</soap:Envelope>
```

**Response**:
```xml
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <ns2:getAverageRatingByLocationResponse xmlns:ns2="http://service.backend.example.com/">
         <return>4.5</return>
      </ns2:getAverageRatingByLocationResponse>
   </soap:Body>
</soap:Envelope>
```

## Cách sử dụng với WSDL

### 1. Truy cập WSDL
```
http://localhost:8080/CommentService?wsdl
```

### 2. Generate Client Code
Sử dụng công cụ như `wsimport` (Java) để generate client code:
```bash
wsimport -keep -p com.example.client http://localhost:8080/CommentService?wsdl

## Error Handling
- Tất cả SQLException sẽ được log và trả về message lỗi thân thiện
- Foreign key constraint violations sẽ trả về "Invalid user or location ID"
- Validation errors sẽ trả về message cụ thể về lỗi validation

## Testing với SoapUI
1. Import WSDL vào SoapUI: `http://localhost:8080/CommentService?wsdl`
2. Sử dụng các request templates được generate tự động
3. Modify các parameters theo yêu cầu test case