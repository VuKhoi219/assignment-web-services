<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- pages/home.jsp -->
<div class="home-container">
    <div class="hero-section">
        <h1>Chào mừng đến với Hệ thống Du lịch</h1>
        <p class="hero-subtitle">Khám phá những điểm đến tuyệt vời trên khắp đất nước</p>        <div class="hero-actions">
            <a href="${pageContext.request.contextPath}/locations" class="btn btn-primary btn-large">
                <i class="icon-location"></i>
                Xem Danh Sách Địa Điểm
            </a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-large">
                <i class="icon-user"></i>
                Đăng Nhập
            </a>
        </div>
    </div>
    
    <div class="features-section">
        <div class="feature-card">
            <div class="feature-icon">📍</div>
            <h3>Địa Điểm Du Lịch</h3>
            <p>Khám phá hàng trăm điểm đến hấp dẫn với thông tin chi tiết và hình ảnh đẹp mắt</p>
        </div>
        
        <div class="feature-card">
            <div class="feature-icon">📸</div>
            <h3>Hình Ảnh Chất Lượng</h3>
            <p>Xem những hình ảnh chất lượng cao về các địa điểm để có cái nhìn trực quan nhất</p>
        </div>
        
        <div class="feature-card">
            <div class="feature-icon">💬</div>
            <h3>Đánh Giá & Bình Luận</h3>
            <p>Đọc và chia sẻ những trải nghiệm thực tế từ cộng đồng du lịch</p>
        </div>
    </div>
</div>

<style>
.home-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

.hero-section {
    text-align: center;
    padding: 60px 0;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-radius: 20px;
    margin-bottom: 60px;
}

.hero-section h1 {
    font-size: 3em;
    margin: 0 0 20px 0;
    font-weight: 700;
}

.hero-subtitle {
    font-size: 1.3em;
    margin: 0 0 40px 0;
    opacity: 0.9;
    max-width: 600px;
    margin-left: auto;
    margin-right: auto;
}

.hero-actions {
    display: flex;
    gap: 20px;
    justify-content: center;
    flex-wrap: wrap;
}

.features-section {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 30px;
    margin-top: 40px;
}

.feature-card {
    background: white;
    padding: 40px 30px;
    border-radius: 15px;
    text-align: center;
    box-shadow: 0 8px 25px rgba(0,0,0,0.1);
    transition: all 0.3s ease;
}

.feature-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 15px 35px rgba(0,0,0,0.15);
}

.feature-icon {
    font-size: 4em;
    margin-bottom: 20px;
}

.feature-card h3 {
    font-size: 1.5em;
    margin: 0 0 15px 0;
    color: #333;
}

.feature-card p {
    color: #666;
    line-height: 1.6;
    margin: 0;
}

.btn {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 15px 30px;
    border-radius: 10px;
    text-decoration: none;
    font-weight: 600;
    transition: all 0.3s ease;
    border: none;
    cursor: pointer;
    font-size: 1.1em;
}

.btn-large {
    padding: 18px 35px;
    font-size: 1.2em;
}

.btn-primary {
    background: #fff;
    color: #667eea;
}

.btn-primary:hover {
    background: #f8f9ff;
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
}

.btn-secondary {
    background: transparent;
    color: white;
    border: 2px solid white;
}

.btn-secondary:hover {
    background: white;
    color: #667eea;
    transform: translateY(-2px);
}

.icon-location::before { content: "📍"; }
.icon-user::before { content: "👤"; }

@media (max-width: 768px) {
    .hero-section h1 {
        font-size: 2.2em;
    }
    
    .hero-subtitle {
        font-size: 1.1em;
    }
    
    .hero-actions {
        flex-direction: column;
        align-items: center;
    }
    
    .hero-actions .btn {
        width: 280px;
        justify-content: center;
    }
    
    .features-section {
        grid-template-columns: 1fr;
    }
    
    .home-container {
        padding: 15px;
    }
}
</style>