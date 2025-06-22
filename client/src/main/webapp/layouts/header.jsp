<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Lấy thông tin từ session
    String userToken = (String) session.getAttribute("token");
    String userRole = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    Integer userId = (Integer) session.getAttribute("userId");

    // Kiểm tra đã đăng nhập hay chưa
    boolean isLoggedIn = (userToken != null && !userToken.trim().isEmpty());
    boolean isGuide = isLoggedIn && "guide".equals(userRole);
%>
<!-- layouts/header.jsp -->
<header class="bg-gradient-to-r from-blue-600 via-purple-600 to-indigo-700 shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <!-- Logo -->
            <div class="flex-shrink-0">
                <a href="${pageContext.request.contextPath}/" class="flex items-center group">
                    <h1 class="text-2xl font-bold text-white group-hover:scale-105 transition-transform duration-300 drop-shadow-lg">
                        🏖️ Travel Hub
                    </h1>
                </a>
            </div>

            <!-- Navigation và Auth -->
            <div class="flex items-center space-x-8">
                <!-- Main Navigation -->
                <nav class="hidden md:block">
                    <ul class="flex space-x-6">
                        <li>
                            <a href="${pageContext.request.contextPath}/"
                               class="text-white hover:text-blue-200 px-4 py-2 rounded-full transition-all duration-300 hover:bg-white/10 hover:-translate-y-0.5 font-medium flex items-center space-x-2">
                                <span>🏠</span>
                                <span>Trang chủ</span>
                            </a>
                        </li>

                        <!-- Hiển thị "Quản lý địa điểm" chỉ khi đã đăng nhập và có role là guide -->
                        <% if (isGuide) { %>
                        <li>
                            <a href="${pageContext.request.contextPath}/crud"
                               class="text-white hover:text-blue-200 px-4 py-2 rounded-full transition-all duration-300 hover:bg-white/10 hover:-translate-y-0.5 font-medium flex items-center space-x-2">
                                <span>📍</span>
                                <span>Quản lý địa điểm</span>
                            </a>
                        </li>
                        <% } %>
                    </ul>
                </nav>

                <!-- Auth Section -->
                <div class="flex items-center space-x-4">
                    <% if (isLoggedIn) { %>
                    <!-- Hiển thị thông tin user và nút đăng xuất khi đã đăng nhập -->
                    <div class="flex items-center space-x-4">
                        <!-- Thông tin user -->
                        <div class="text-white flex items-center space-x-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                            </svg>
                            <span class="font-medium">Xin chào, <%= username %></span>
                            <% if (isGuide) { %>
                            <span class="bg-yellow-400 text-yellow-900 px-2 py-1 rounded-full text-xs font-semibold">Guide</span>
                            <% } %>
                        </div>

                        <!-- Logout Button -->
                        <a href="${pageContext.request.contextPath}/logout"
                           class="bg-red-500 hover:bg-red-600 text-white px-6 py-2 rounded-full font-semibold transition-all duration-300 hover:shadow-lg hover:scale-105 flex items-center space-x-2">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
                            </svg>
                            <span>Đăng xuất</span>
                        </a>
                    </div>
                    <% } else { %>
                    <!-- Hiển thị nút đăng nhập và đăng ký khi chưa đăng nhập -->
                    <!-- Login Button -->
                    <a href="auth?action=login"
                       class="bg-white text-purple-600 hover:bg-blue-50 px-6 py-2 rounded-full font-semibold transition-all duration-300 hover:shadow-lg hover:scale-105 flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"></path>
                        </svg>
                        <span>Đăng nhập</span>
                    </a>

                    <!-- Register Button -->
                    <a href="auth?action=register"
                       class="border-2 border-white text-white hover:bg-white hover:text-purple-600 px-6 py-2 rounded-full font-semibold transition-all duration-300 hover:shadow-lg flex items-center space-x-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path>
                        </svg>
                        <span>Đăng ký</span>
                    </a>
                    <% } %>
                </div>

                <!-- Mobile Menu Button -->
                <div class="md:hidden">
                    <button class="text-white hover:text-blue-200 p-2">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
                        </svg>
                    </button>
                </div>
            </div>
        </div>

        <!-- Mobile Navigation (Hidden by default) -->
        <div class="md:hidden hidden" id="mobile-menu">
            <div class="px-2 pt-2 pb-3 space-y-1 border-t border-white/20">
                <a href="${pageContext.request.contextPath}/"
                   class="text-white hover:bg-white/10 block px-3 py-2 rounded-md font-medium">
                    🏠 Trang chủ
                </a>

                <!-- Hiển thị "Quản lý địa điểm" trong mobile menu chỉ khi là guide -->
                <% if (isGuide) { %>
                <a href="${pageContext.request.contextPath}/crud"
                   class="text-white hover:bg-white/10 block px-3 py-2 rounded-md font-medium">
                    📍 Quản lý địa điểm
                </a>
                <% } %>

                <div class="pt-4 border-t border-white/20 mt-4">
                    <% if (isLoggedIn) { %>
                    <!-- Mobile user info và logout -->
                    <div class="text-white px-3 py-2 font-medium">
                        Xin chào, <%= username %>
                        <% if (isGuide) { %>
                        <span class="bg-yellow-400 text-yellow-900 px-2 py-1 rounded-full text-xs font-semibold ml-2">Guide</span>
                        <% } %>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout"
                       class="bg-red-500 text-white block px-3 py-2 rounded-md font-semibold text-center">
                        Đăng xuất
                    </a>
                    <% } else { %>
                    <!-- Mobile login/register buttons -->
                    <a href="auth?action=login"
                       class="bg-white text-purple-600 block px-3 py-2 rounded-md font-semibold mb-2 text-center">
                        Đăng nhập
                    </a>
                    <a href="auth?action=register"
                       class="border border-white text-white block px-3 py-2 rounded-md font-semibold text-center">
                        Đăng ký
                    </a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</header>

<script>
    // Toggle mobile menu
    document.addEventListener('DOMContentLoaded', function() {
        const mobileMenuButton = document.querySelector('.md\\:hidden button');
        const mobileMenu = document.getElementById('mobile-menu');

        if (mobileMenuButton && mobileMenu) {
            mobileMenuButton.addEventListener('click', function() {
                mobileMenu.classList.toggle('hidden');
            });
        }
    });
</script>