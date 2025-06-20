<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="container">
    <div class="header-section">
        <h1>Danh Sách Địa Điểm Du Lịch</h1>
        <p class="subtitle">Khám phá những điểm đến tuyệt vời</p>
        
        <!-- Filter Form -->
        <div class="filter-section">
            <form method="GET" action="${pageContext.request.contextPath}/locations" class="filter-form">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="filterQuery">Tìm theo tên:</label>
                        <input type="text" 
                               id="filterQuery" 
                               name="filterQuery" 
                               value="${param.filterQuery}" 
                               placeholder="Nhập tên địa điểm...">
                    </div>
                    
                    <div class="filter-group">
                        <label for="filterRating">Đánh giá tối thiểu:</label>
                        <select id="filterRating" name="filterRating">
                            <option value="">Tất cả</option>
                            <option value="1" ${param.filterRating == '1' ? 'selected' : ''}>1 sao</option>
                            <option value="2" ${param.filterRating == '2' ? 'selected' : ''}>2 sao</option>
                            <option value="3" ${param.filterRating == '3' ? 'selected' : ''}>3 sao</option>
                            <option value="4" ${param.filterRating == '4' ? 'selected' : ''}>4 sao</option>
                            <option value="5" ${param.filterRating == '5' ? 'selected' : ''}>5 sao</option>
                        </select>
                    </div>
                    
                    <div class="filter-actions">
                        <button type="submit">Tìm kiếm</button>
                        <c:if test="${not empty param.filterQuery or not empty param.filterRating}">
                            <a href="${pageContext.request.contextPath}/locations">Xóa bộ lọc</a>
                        </c:if>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Error Message -->
    <c:if test="${not empty error}">
        <div class="alert alert-error">
            ${error}
        </div>
    </c:if>

    <!-- Filter Results -->
    <c:if test="${hasFilter and not empty filteredResults}">
        <div class="filter-results">
            <h3>Kết quả lọc (${filteredResults.size()} địa điểm)</h3>
            <div class="locations-grid">
                <c:forEach var="result" items="${filteredResults}">
                    <div class="location-card">
                        <div class="location-image">
                            <c:choose>
                                <c:when test="${not empty result.previewImage}">
                                    <img src="${result.previewImage}" alt="${result.location.title}">
                                </c:when>
                                <c:otherwise>
                                    <div class="no-image">
                                        <span>Không có ảnh</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="location-info">
                            <h3>${result.location.title}</h3>
                            <p>${result.location.description}</p>
                            <div class="rating">
                                Đánh giá: <fmt:formatNumber value="${result.averageRating}" maxFractionDigits="1"/> / 5
                            </div>
                            <a href="${pageContext.request.contextPath}/location-details?id=${result.location.id}" 
                               class="btn-view">Xem chi tiết</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- All Locations (when no filter or no filter results) -->
    <c:if test="${not hasFilter or (hasFilter and empty filteredResults)}">
        <div class="all-locations">
            <c:choose>
                <c:when test="${hasFilter and empty filteredResults}">
                    <h3>Không tìm thấy kết quả phù hợp</h3>
                    <p>Hiển thị tất cả địa điểm:</p>
                </c:when>
                <c:otherwise>
                    <h3>Tất cả địa điểm (${locationsCount} địa điểm)</h3>
                </c:otherwise>
            </c:choose>
            
            <c:if test="${not empty locations}">
                <div class="locations-grid">
                    <c:forEach var="location" items="${locations}">
                        <div class="location-card">
                            <div class="location-image">
                                <div class="no-image">
                                    <span>Không có ảnh</span>
                                </div>
                            </div>
                            
                            <div class="location-info">
                                <h3>${location.title}</h3>
                                <p>${location.description}</p>
                                <a href="${pageContext.request.contextPath}/location-details?id=${location.id}" 
                                   class="btn-view">Xem chi tiết</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </c:if>
    
    <!-- Empty State -->
    <c:if test="${empty locations}">
        <div class="empty-state">
            <h3>Chưa có địa điểm nào</h3>
            <p>Hiện tại chưa có địa điểm nào trong hệ thống.</p>
        </div>
    </c:if>
</div>

<style>
.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

.header-section {
    text-align: center;
    margin-bottom: 30px;
}

.header-section h1 {
    color: #333;
    margin-bottom: 10px;
}

.subtitle {
    color: #666;
    margin-bottom: 30px;
}

.filter-section {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 30px;
}

.filter-form {
    max-width: 800px;
    margin: 0 auto;
}

.filter-row {
    display: grid;
    grid-template-columns: 1fr 1fr auto;
    gap: 15px;
    align-items: end;
}

.filter-group {
    display: flex;
    flex-direction: column;
}

.filter-group label {
    margin-bottom: 5px;
    font-weight: 600;
    color: #555;
}

.filter-group input,
.filter-group select {
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 14px;
}

.filter-actions {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.filter-actions button,
.filter-actions a {
    padding: 10px 15px;
    text-align: center;
    text-decoration: none;
    border-radius: 4px;
    font-size: 14px;
    font-weight: 600;
}

.filter-actions button {
    background: #007bff;
    color: white;
    border: none;
    cursor: pointer;
}

.filter-actions button:hover {
    background: #0056b3;
}

.filter-actions a {
    background: #6c757d;
    color: white;
}

.filter-actions a:hover {
    background: #545b62;
    color: white;
}

.alert {
    padding: 15px;
    margin-bottom: 20px;
    border-radius: 4px;
}

.alert-error {
    background: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}

.filter-results h3,
.all-locations h3 {
    color: #333;
    margin-bottom: 20px;
}

.locations-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
}

.location-card {
    background: white;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    overflow: hidden;
    transition: transform 0.3s ease;
}

.location-card:hover {
    transform: translateY(-5px);
}

.location-image {
    height: 200px;
    overflow: hidden;
}

.location-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.no-image {
    width: 100%;
    height: 100%;
    background: #f8f9fa;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #6c757d;
}

.location-info {
    padding: 20px;
}

.location-info h3 {
    margin: 0 0 10px 0;
    color: #333;
}

.location-info p {
    color: #666;
    margin: 0 0 15px 0;
    line-height: 1.5;
}

.rating {
    color: #ffc107;
    font-weight: 600;
    margin-bottom: 15px;
}

.btn-view {
    background: #007bff;
    color: white;
    padding: 10px 20px;
    text-decoration: none;
    border-radius: 4px;
    font-weight: 600;
    display: inline-block;
}

.btn-view:hover {
    background: #0056b3;
    color: white;
}

.empty-state {
    text-align: center;
    padding: 60px 20px;
    color: #666;
}

@media (max-width: 768px) {
    .filter-row {
        grid-template-columns: 1fr;
        gap: 15px;
    }
    
    .filter-actions {
        flex-direction: row;
    }
    
    .locations-grid {
        grid-template-columns: 1fr;
    }
}
</style>
