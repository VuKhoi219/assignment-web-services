# Postman SOAP Tests cho LocationService

## Cấu hình cơ bản

### 1. URL WSDL
```
http://localhost:8080/your-app-name/LocationService?wsdl
```

### 2. SOAP Endpoint
```
http://localhost:8080/your-app-name/LocationService
```

## Test Cases

### 1. Test getLocations()

**Method:** POST  
**URL:** `http://localhost:8080/your-app-name/LocationService`  
**Headers:**
```
Content-Type: text/xml; charset=utf-8
SOAPAction: ""
```

**Body (raw XML):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" 
               xmlns:loc="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <loc:getLocations/>
   </soap:Body>
</soap:Envelope>
```

---

### 2. Test getLocation(int id)

**Method:** POST  
**URL:** `http://localhost:8080/your-app-name/LocationService`  
**Headers:**
```
Content-Type: text/xml; charset=utf-8
SOAPAction: ""
```

**Body (raw XML):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" 
               xmlns:loc="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <loc:getLocation>
         <arg0>1</arg0>
      </loc:getLocation>
   </soap:Body>
</soap:Envelope>
```

---

### 3. Test createLocation(String title, String description, int guideId)

**Method:** POST  
**URL:** `http://localhost:8080/your-app-name/LocationService`  
**Headers:**
```
Content-Type: text/xml; charset=utf-8
SOAPAction: ""
```

**Body (raw XML):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" 
               xmlns:loc="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <loc:createLocation>
         <arg0>Hồ Gươm</arg0>
         <arg1>Hồ nước ngọt tự nhiên nằm ở trung tâm thành phố Hà Nội</arg1>
         <arg2>1</arg2>
      </loc:createLocation>
   </soap:Body>
</soap:Envelope>
```

---

### 4. Test updateLocation(String title, String description, int id)

**Method:** POST  
**URL:** `http://localhost:8080/your-app-name/LocationService`  
**Headers:**
```
Content-Type: text/xml; charset=utf-8
SOAPAction: ""
```

**Body (raw XML):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" 
               xmlns:loc="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <loc:updateLocation>
         <arg0>Hồ Hoàn Kiếm</arg0>
         <arg1>Hồ nước ngọt tự nhiên nằm ở trung tâm thành phố Hà Nội, còn gọi là Hồ Gươm</arg1>
         <arg2>1</arg2>
      </loc:updateLocation>
   </soap:Body>
</soap:Envelope>
```

---

### 5. Test deleteLocation(int id)

**Method:** POST  
**URL:** `http://localhost:8080/your-app-name/LocationService`  
**Headers:**
```
Content-Type: text/xml; charset=utf-8
SOAPAction: ""
```

**Body (raw XML):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" 
               xmlns:loc="http://service.backend.example.com/">
   <soap:Header/>
   <soap:Body>
      <loc:deleteLocation>
         <arg0>1</arg0>
      </loc:deleteLocation>
   </soap:Body>
</soap:Envelope>
```

## Cách sử dụng trong Postman

### Bước 1: Tạo Collection mới
1. Mở Postman
2. Click "New" → "Collection"
3. Đặt tên: "LocationService SOAP Tests"

### Bước 2: Thêm từng request
1. Click "Add request" trong collection
2. Đặt tên cho request (vd: "Get All Locations")
3. Chọn method POST
4. Nhập URL endpoint
5. Thêm Headers
6. Paste XML body tương ứng

### Bước 3: Test Parameters
- Thay đổi `your-app-name` thành tên ứng dụng thực tế của bạn
- Thay đổi port nếu Tomcat không chạy trên 8080
- Thay đổi các giá trị test data phù hợp với database

## Lưu ý quan trọng

### 1. Namespace
- Namespace `xmlns:loc="http://service.backend.example.com/"` có thể khác
- Kiểm tra WSDL để xác định namespace chính xác

### 2. Parameter names
- JAX-WS tự động tạo tên parameter là `arg0`, `arg1`, `arg2`...
- Hoặc có thể sử dụng annotation `@WebParam(name="title")` để đặt tên cụ thể

### 3. Database issues
- Trong code có vấn đề: table name không consistent
    - `getLocations()`: `FROM location`
    - `createLocation()`: `INSERT INTO locations`
    - Cần thống nhất tên table

### 4. Expected Responses

**Successful Response Example:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
   <S:Body>
      <ns2:getLocationsResponse xmlns:ns2="http://service.backend.example.com/">
         <return>
            <id>1</id>
            <title>Hồ Gươm</title>
            <description>Hồ nước ngọt tự nhiên...</description>
         </return>
      </ns2:getLocationsResponse>
   </S:Body>
</S:Envelope>
```

**Error Response Example:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/">
   <S:Body>
      <S:Fault>
         <faultcode>S:Server</faultcode>
         <faultstring>Database connection failed</faultstring>
      </S:Fault>
   </S:Body>
</S:Envelope>
```

## Tips để debug

1. **Kiểm tra WSDL trước:** Truy cập `http://localhost:8080/your-app-name/LocationService?wsdl`
2. **Check Tomcat logs:** Xem catalina.out để debug lỗi
3. **Test database connection:** Đảm bảo MySQL đang chạy và connection string đúng
4. **Verify deployment:** Đảm bảo ứng dụng đã deploy thành công trên Tomcat