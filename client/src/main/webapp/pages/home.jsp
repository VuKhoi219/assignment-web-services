<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold text-center text-blue-800 mb-8">Khám phá địa điểm du lịch</h1>

    <!-- Search Box -->
    <div class="max-w-2xl mx-auto mb-10 relative">
        <form method="GET" action="${pageContext.request.contextPath}/" class="relative">
            <input
                    type="text"
                    name="search"
                    id="searchInput"
                    placeholder="Tìm kiếm địa điểm..."
                    value="${searchTerm}"
                    class="w-full px-4 py-3 pl-12 rounded-lg border border-gray-300 focus:border-blue-500 search-box"
            >
            <i class="fas fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            <input type="hidden" name="page" value="1">
        </form>
    </div>

    <!-- Search Results Info -->
    <c:if test="${not empty searchTerm}">
        <div class="text-center mb-6">
            <p class="text-gray-600">
                Tìm thấy <span class="font-semibold text-blue-600">${totalItems}</span>
                kết quả cho "<span class="font-semibold">${searchTerm}</span>"
            </p>
        </div>
    </c:if>

    <!-- Place Cards Grid -->
    <div id="placesContainer" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 mb-8">
        <c:choose>
            <c:when test="${empty places}">
                <div class="col-span-full text-center py-10">
                    <i class="fas fa-map-marker-alt text-4xl text-gray-300 mb-4"></i>
                    <p class="text-xl text-gray-500">Không tìm thấy địa điểm phù hợp</p>
                    <c:if test="${not empty searchTerm}">
                        <a href="${pageContext.request.contextPath}/" class="inline-block mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition">
                            Xem tất cả địa điểm
                        </a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="place" items="${places}">
                    <div class="card bg-white rounded-lg overflow-hidden shadow-md hover:shadow-lg transition-shadow duration-300">
                        <div class="relative h-40 overflow-hidden">
                            <img src="${place.image}" alt="${place.title}" class="w-full h-full object-cover hover:scale-105 transition-transform duration-300">
                        </div>
                        <div class="p-4">
                            <h3 class="font-bold text-lg text-gray-800 mb-2">${place.title}</h3>
                            <p class="text-gray-600 text-sm mb-3">${place.description}</p>
                            <div class="flex justify-between items-center">
                                <a href="${pageContext.request.contextPath}/location?id=${place.id}">
                                    <button class="text-blue-600 text-sm font-medium hover:text-blue-800 transition">
                                        Xem chi tiết
                                    </button>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <div class="flex justify-center mt-8">
            <nav class="inline-flex rounded-md shadow-sm">
                <!-- Previous Button -->
                <c:choose>
                    <c:when test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}<c:if test='${not empty searchTerm}'>&search=${searchTerm}</c:if>"
                           class="px-3 py-1 rounded-l-md border border-gray-300 bg-white text-gray-700 hover:bg-gray-50 transition">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="px-3 py-1 rounded-l-md border border-gray-300 bg-gray-100 text-gray-400 cursor-not-allowed">
                            <i class="fas fa-chevron-left"></i>
                        </span>
                    </c:otherwise>
                </c:choose>

                <!-- Page Numbers -->
                <div class="flex">
                    <!-- First page -->
                    <c:if test="${currentPage == 1}">
                        <span class="px-3 py-1 border-t border-b border-gray-300 bg-blue-500 text-white">1</span>
                    </c:if>
                    <c:if test="${currentPage != 1}">
                        <a href="?page=1<c:if test='${not empty searchTerm}'>&search=${searchTerm}</c:if>"
                           class="px-3 py-1 border-t border-b border-gray-300 bg-white text-gray-700 hover:bg-gray-50 transition">1</a>
                    </c:if>

                    <!-- Ellipsis before current page range -->
                    <c:if test="${currentPage > 3}">
                        <span class="px-3 py-1 border-t border-b border-gray-300 bg-white text-gray-500">...</span>
                    </c:if>

                    <!-- Current page and neighbors -->
                    <c:set var="startPage" value="${currentPage > 2 ? currentPage - 1 : 2}" />
                    <c:set var="endPage" value="${currentPage < totalPages - 1 ? currentPage + 1 : totalPages - 1}" />

                    <c:forEach var="i" begin="${startPage}" end="${endPage}">
                        <c:if test="${i > 1 && i < totalPages}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="px-3 py-1 border-t border-b border-gray-300 bg-blue-500 text-white">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="?page=${i}<c:if test='${not empty searchTerm}'>&search=${searchTerm}</c:if>"
                                       class="px-3 py-1 border-t border-b border-gray-300 bg-white text-gray-700 hover:bg-gray-50 transition">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </c:forEach>

                    <!-- Ellipsis after current page range -->
                    <c:if test="${currentPage < totalPages - 2}">
                        <span class="px-3 py-1 border-t border-b border-gray-300 bg-white text-gray-500">...</span>
                    </c:if>

                    <!-- Last page -->
                    <c:if test="${totalPages > 1}">
                        <c:choose>
                            <c:when test="${currentPage == totalPages}">
                                <span class="px-3 py-1 border-t border-b border-gray-300 bg-blue-500 text-white">${totalPages}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="?page=${totalPages}<c:if test='${not empty searchTerm}'>&search=${searchTerm}</c:if>"
                                   class="px-3 py-1 border-t border-b border-gray-300 bg-white text-gray-700 hover:bg-gray-50 transition">${totalPages}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </div>

                <!-- Next Button -->
                <c:choose>
                    <c:when test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}<c:if test='${not empty searchTerm}'>&search=${searchTerm}</c:if>"
                           class="px-3 py-1 rounded-r-md border border-gray-300 bg-white text-gray-700 hover:bg-gray-50 transition">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span class="px-3 py-1 rounded-r-md border border-gray-300 bg-gray-100 text-gray-400 cursor-not-allowed">
                            <i class="fas fa-chevron-right"></i>
                        </span>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>

        <!-- Pagination Info -->
        <div class="text-center mt-4 text-sm text-gray-600">
            Trang ${currentPage} / ${totalPages} - Hiển thị ${places.size()} / ${totalItems} địa điểm
        </div>
    </c:if>
</div>
