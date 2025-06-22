# Hướng dẫn Test SOAP Web Service với Postman

## 1. Chuẩn bị WSDL URL
Trước tiên, bạn cần có URL WSDL của service. Thường có dạng:
```
http://localhost:8080/services/ImageService?wsdl
```

## 2. Cấu hình Postman

### Bước 1: Tạo New Request
- Mở Postman
- Click "New" → "Request"
- Chọn method: **POST**
- Nhập URL endpoint (không phải WSDL URL):
  ```
  http://localhost:8080/services/ImageService
  ```

### Bước 2: Cấu hình Headers
Trong tab **Headers**, thêm:
```
Content-Type: text/xml; charset=utf-8
SOAPAction: ""
```

## 3. Tạo SOAP Request cho từng method

### 3.1. getImages()
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:getImages/>
   </soap:Body>
</soap:Envelope>
```

### 3.2. getImage(int id)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:getImage>
         <arg0>1</arg0>
      </ser:getImage>
   </soap:Body>
</soap:Envelope>
```

### 3.3. uploadImage(int locationId, String base64ImageData, String filename, String caption)

**Cách convert ảnh thật thành base64:**

**Phương pháp 1: Sử dụng Online Tool**
1. Truy cập: https://base64.guru/converter/encode/image
2. Upload ảnh của bạn
3. Copy đoạn base64 (bỏ phần `data:image/png;base64,`)

**Phương pháp 2: Sử dụng lệnh Linux/Mac**
```bash
base64 -i your-image.jpg
```

**Phương pháp 3: Sử dụng PowerShell (Windows)**
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("C:\path\to\your-image.jpg"))
```

**SOAP Request với ảnh thật:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:uploadImage>
         <arg0>1</arg0>
         <arg1>/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAABAAEDASIAAhEBAxEB/8QAFQABAQAAAAAAAAAAAAAAAAAAAAv/xAAUEAEAAAAAAAAAAAAAAAAAAAAA/8QAFQEBAQAAAAAAAAAAAAAAAAAAAAX/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwCdABmX/9k=</arg1>
         <arg2>my-photo.jpg</arg2>
         <arg3>My real photo caption</arg3>
      </ser:uploadImage>
   </soap:Body>
</soap:Envelope>
```

**Lưu ý quan trọng:**
- Base64 string có thể rất dài (hàng nghìn ký tự)
- Chỉ copy phần base64, bỏ prefix `data:image/...;base64,`
- Đảm bảo không có line breaks trong base64 string

### 3.4. updateImage(int imageId, String base64ImageData, String filename, String caption)

**SOAP Request với ảnh thật:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:updateImage>
         <arg0>1</arg0>
         <arg1>[PASTE_YOUR_REAL_BASE64_IMAGE_HERE]</arg1>
         <arg2>updated-real-photo.jpg</arg2>
         <arg3>Updated real photo caption</arg3>
      </ser:updateImage>
   </soap:Body>
</soap:Envelope>
```

### 3.5. deleteImage(int id)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:deleteImage>
         <arg0>1</arg0>
      </ser:deleteImage>
   </soap:Body>
</soap:Envelope>
```

### 3.6. getImagesByLocation(int locationId)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:getImagesByLocation>
         <arg0>1</arg0>
      </ser:getImagesByLocation>
   </soap:Body>
</soap:Envelope>
```

### 3.7. getImageAsBase64(int imageId)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
               xmlns:ser="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <ser:getImageAsBase64>
         <arg0>1</arg0>
      </ser:getImageAsBase64>
   </soap:Body>
</soap:Envelope>
```

## 4. Cách sử dụng arguments (arg0, arg1, arg2...)

**Quan trọng**: Trong SOAP, các parameters được map theo thứ tự:
- `arg0` = tham số đầu tiên
- `arg1` = tham số thứ hai
- `arg2` = tham số thứ ba
- ...và cứ thế tiếp tục

**Ví dụ với uploadImage:**
```java
uploadImage(int locationId, String base64ImageData, String filename, String caption)
```
Sẽ được map như sau:
- `arg0` = locationId (int)
- `arg1` = base64ImageData (String)
- `arg2` = filename (String)
- `arg3` = caption (String)

## 5. Các bước thực hiện trong Postman

1. **Chọn method POST**
2. **Nhập URL endpoint** (không phải WSDL)
3. **Vào tab Headers**, thêm Content-Type và SOAPAction
4. **Vào tab Body**, chọn "raw" và "XML"
5. **Paste SOAP request** tương ứng
6. **Thay đổi giá trị** trong các tag `<arg0>`, `<arg1>`, etc.
7. **Click Send**

## 6. Xử lý Response

Response sẽ có dạng:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <ns2:getImagesResponse xmlns:ns2="http://service.backend.example.com/">
         <return>
            <!-- Dữ liệu trả về -->
         </return>
      </ns2:getImagesResponse>
   </soap:Body>
</soap:Envelope>
```

## 7. Tips quan trọng

- **Kiểm tra namespace**: Thay `http://service.backend.example.com/` bằng namespace thực tế trong WSDL
- **Kiểm tra endpoint URL**: Có thể khác với WSDL URL
- **Base64 Image**: Sử dụng base64 encoder online để convert image
- **Test từng method riêng lẻ**: Tạo separate request cho mỗi method
- **Save requests**: Tạo Collection trong Postman để lưu tất cả requests

## 9. Ví dụ thực tế với ảnh

**Bước 1: Chuẩn bị ảnh**
- Chọn 1 ảnh JPG hoặc PNG từ máy tính
- Convert thành base64 bằng một trong các cách trên

**Bước 2: Test upload**
```xml
<ser:uploadImage>
   <arg0>1</arg0>
   <arg1>[Base64 string dài khoảng 1000-5000 ký tự]</arg1>
   <arg2>vacation-photo.jpg</arg2>
   <arg3>My vacation photo in Da Nang</arg3>
</ser:uploadImage>
```

**Bước 3: Verify**
- Sau khi upload thành công, dùng `getImageAsBase64` để lấy lại
- Convert base64 về ảnh để kiểm tra

**Tool convert base64 về ảnh:**
- https://base64.guru/converter/decode/image
- Paste base64 string và download ảnh để verify

Nếu gặp lỗi:
1. Kiểm tra server có chạy không
2. Kiểm tra WSDL URL có accessible không
3. Xem log server để debug
4. Kiểm tra namespace trong SOAP request
5. Verify data types (int, String) có đúng không