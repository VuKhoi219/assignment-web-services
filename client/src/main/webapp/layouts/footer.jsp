<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="main-footer">
  <div class="footer-container">
    <div class="footer-content">
      <div class="footer-section">
        <h3>🏖️ Travel Hub</h3>
        <p>Khám phá những điểm đến tuyệt vời trên khắp đất nước cùng với chúng tôi.</p>
      </div>
        <div class="footer-section">
        <h4>Liên kết nhanh</h4>
        <ul>
          <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
          <li><a href="${pageContext.request.contextPath}/locations">Địa điểm</a></li>
        </ul>
      </div>
      
      <div class="footer-section">
        <h4>Liên hệ</h4>
        <p>📧 contact@travelhub.com</p>
        <p>📞 (+84) 123 456 789</p>
        <p>📍 Hà Nội, Việt Nam</p>
      </div>
    </div>
    
    <div class="footer-bottom">
      <p>&copy; 2025 Travel Hub. Tất cả quyền được bảo lưu.</p>
    </div>
  </div>
</footer>

<style>
.main-footer {
  background: #2d3748;
  color: white;
  margin-top: 60px;
}

.footer-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px 20px 20px;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 40px;
  margin-bottom: 30px;
}

.footer-section h3 {
  margin: 0 0 15px 0;
  font-size: 1.5em;
  color: #667eea;
}

.footer-section h4 {
  margin: 0 0 15px 0;
  font-size: 1.2em;
  color: #a0aec0;
}

.footer-section p {
  margin: 0 0 10px 0;
  color: #cbd5e0;
  line-height: 1.6;
}

.footer-section ul {
  list-style: none;
  padding: 0;
}

.footer-section ul li {
  margin-bottom: 8px;
}

.footer-section ul li a {
  color: #cbd5e0;
  text-decoration: none;
  transition: color 0.3s ease;
}

.footer-section ul li a:hover {
  color: #667eea;
}

.footer-bottom {
  border-top: 1px solid #4a5568;
  padding-top: 20px;
  text-align: center;
}

.footer-bottom p {
  margin: 0;
  color: #a0aec0;
}

@media (max-width: 768px) {
  .footer-content {
    grid-template-columns: 1fr;
    gap: 30px;
  }
  
  .footer-container {
    padding: 30px 15px 15px 15px;
  }
}
</style>