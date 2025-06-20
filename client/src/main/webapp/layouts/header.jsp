<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- layouts/header.jsp -->
<header class="main-header">
    <div class="header-container">        <div class="logo">
            <a href="${pageContext.request.contextPath}/">
                <h1>🏖️ Travel Hub</h1>
            </a>
        </div>          <nav class="main-nav">
            <ul class="nav-list">
                <li><a href="${pageContext.request.contextPath}/" class="nav-link">🏠 Trang chủ</a></li>
                <li><a href="${pageContext.request.contextPath}/locations" class="nav-link">📍 Địa điểm</a></li>
                <li><a href="${pageContext.request.contextPath}/login" class="nav-link">🔐 Đăng nhập</a></li>
                <li><a href="${pageContext.request.contextPath}/register" class="nav-link">📝 Đăng ký</a></li>
            </ul>
        </nav>
        
        <div class="mobile-menu-toggle">
            <span></span>
            <span></span>
            <span></span>
        </div>
    </div>
</header>

<style>
.main-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    position: sticky;
    top: 0;
    z-index: 1000;
}

.header-container {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20px;
    height: 70px;
}

.logo a {
    text-decoration: none;
    color: white;
}

.logo h1 {
    margin: 0;
    font-size: 1.8em;
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 10px;
}

.main-nav {
    flex: 1;
    display: flex;
    justify-content: center;
}

.nav-list {
    display: flex;
    list-style: none;
    margin: 0;
    padding: 0;
    gap: 30px;
}

.nav-link {
    color: white;
    text-decoration: none;
    font-weight: 500;
    padding: 8px 16px;
    border-radius: 8px;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    gap: 8px;
}

.nav-link:hover {
    background: rgba(255,255,255,0.2);
    transform: translateY(-2px);
}

.mobile-menu-toggle {
    display: none;
    flex-direction: column;
    cursor: pointer;
    gap: 4px;
}

.mobile-menu-toggle span {
    width: 25px;
    height: 3px;
    background: white;
    border-radius: 2px;
    transition: all 0.3s ease;
}

@media (max-width: 768px) {
    .main-nav {
        display: none;
    }
    
    .mobile-menu-toggle {
        display: flex;
    }
    
    .header-container {
        padding: 0 15px;
    }
    
    .logo h1 {
        font-size: 1.5em;
    }
}
</style>