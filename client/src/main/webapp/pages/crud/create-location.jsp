<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Kiểm tra session để xác định user đã đăng nhập hay chưa
    String userToken = (String) session.getAttribute("token");
    String username = (String) session.getAttribute("username");
    String userRole = (String) session.getAttribute("role");
    Integer userId = (Integer) session.getAttribute("userId");

    boolean isLoggedIn = (userToken != null && !userToken.trim().isEmpty());

    // Kiểm tra authorization - chỉ cho phép role "guide"
    if (!isLoggedIn) {
        // Chưa đăng nhập - chuyển hướng về trang login
        response.sendRedirect(request.getContextPath() + "auth?action=login");
        return;
    }

    if (!"guide".equals(userRole)) {
        // Không có quyền truy cập - hiển thị thông báo lỗi
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
%>
<div class="container mx-auto px-4 py-8 max-w-3xl">
    <div class="bg-red-50 border border-red-200 rounded-xl p-6 md:p-8 text-center">
        <div class="mb-4">
            <i class="fas fa-exclamation-triangle text-red-500 text-4xl"></i>
        </div>
        <h1 class="text-2xl font-bold text-red-800 mb-2">Không có quyền truy cập</h1>
        <p class="text-red-600 mb-4">Bạn không có quyền tạo địa điểm mới. Chỉ hướng dẫn viên (guide) mới có thể thực hiện chức năng này.</p>
        <div class="flex justify-center gap-3">
            <a href="<%= request.getContextPath() %>/dashboard"
               class="px-6 py-3 bg-blue-600 hover:bg-blue-700 rounded-lg font-medium text-white transition duration-200">
                <i class="fas fa-home mr-2"></i>Về trang chủ
            </a>
            <a href="<%= request.getContextPath() %>/locations"
               class="px-6 py-3 border border-gray-300 rounded-lg font-medium text-gray-700 hover:bg-gray-50 transition duration-200">
                <i class="fas fa-map-marked-alt mr-2"></i>Xem địa điểm
            </a>
        </div>
    </div>
</div>
<%
        return; // Dừng xử lý tiếp
    }

    // Set attributes để sử dụng trong JSTL
    request.setAttribute("isLoggedIn", isLoggedIn);
    request.setAttribute("currentUsername", username);
    request.setAttribute("currentUserRole", userRole);
    request.setAttribute("currentUserId", userId);
%>
<div class="container mx-auto px-4 py-8 max-w-3xl">
    <div class="bg-white rounded-xl shadow-md overflow-hidden p-6 md:p-8">
        <div class="flex items-center mb-6">
            <div class="bg-blue-100 p-3 rounded-full mr-4">
                <i class="fas fa-map-marker-alt text-blue-600 text-xl"></i>
            </div>
            <h1 class="text-2xl font-bold text-gray-800">Tạo địa điểm mới</h1>
        </div>

        <form id="locationForm" class="space-y-6" action="/location" method="post" enctype="multipart/form-data">
            <!-- Title Field -->
            <div>
                <label for="title" class="block text-sm font-medium text-gray-700 mb-1">Tên địa điểm <span class="text-red-500">*</span></label>
                <div class="relative">
                    <input type="text" id="title" name="title" required
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200"
                           placeholder="Nhập tên địa điểm">
                    <div class="absolute inset-y-0 right-0 flex items-center pr-3 pointer-events-none">
                        <i class="fas fa-heading text-gray-400"></i>
                    </div>
                </div>
            </div>

            <!-- Description Field -->
            <div>
                <label for="description" class="block text-sm font-medium text-gray-700 mb-1">Mô tả</label>
                <textarea id="description" name="description" rows="4"
                          class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200"
                          placeholder="Nhập mô tả về địa điểm"></textarea>
            </div>

            <!-- File Upload Section -->
            <div class="border border-gray-200 rounded-lg p-4">
                <h3 class="text-lg font-medium text-gray-800 mb-4 flex items-center">
                    <i class="fas fa-image text-blue-500 mr-2"></i> Hình ảnh địa điểm
                </h3>

                <!-- File Input -->
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Chọn ảnh từ máy <span class="text-red-500">*</span></label>
                    <div class="file-input-wrapper">
                        <button type="button" id="fileButton" class="w-full bg-blue-50 hover:bg-blue-100 text-blue-600 font-medium py-3 px-4 rounded-lg border border-blue-200 transition duration-200 flex items-center justify-center">
                            <i class="fas fa-cloud-upload-alt mr-2"></i> Chọn tệp
                        </button>
                        <input type="file" id="file" name="file" accept="image/*" required class="hidden">
                    </div>
                    <p class="mt-1 text-sm text-gray-500" id="fileNameDisplay">Chưa có tệp nào được chọn</p>
                </div>

                <!-- Image Preview -->
                <div id="previewContainer" class="preview-container" style="display: none;">
                    <p class="text-sm font-medium text-gray-700 mb-2">Xem trước:</p>
                    <div class="flex items-center">
                        <img id="previewImage" src="#" alt="Preview" class="preview-image mr-4" style="max-width: 200px; max-height: 200px; object-fit: cover; border-radius: 8px;">
                        <div>
                            <p class="text-sm text-gray-600" id="fileSizeInfo"></p>
                            <p class="text-sm text-gray-600" id="fileDimensions"></p>
                        </div>
                    </div>
                </div>

                <!-- Filename Field -->
                <div class="mb-4">
                    <label for="filename" class="block text-sm font-medium text-gray-700 mb-1">Tên ảnh</label>
                    <input type="text" id="filename" name="filename"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200"
                           placeholder="Nhập tên cho ảnh">
                </div>

                <!-- Caption Field -->
                <div>
                    <label for="caption" class="block text-sm font-medium text-gray-700 mb-1">Chú thích</label>
                    <input type="text" id="caption" name="caption"
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition duration-200"
                           placeholder="Nhập chú thích cho ảnh">
                </div>
            </div>

            <!-- Form Actions -->
            <div class="flex flex-col sm:flex-row justify-end gap-3 pt-4">
                <button type="button" class="px-6 py-3 border border-gray-300 rounded-lg font-medium text-gray-700 hover:bg-gray-50 transition duration-200">
                    Hủy bỏ
                </button>
                <button type="submit" class="px-6 py-3 bg-blue-600 hover:bg-blue-700 rounded-lg font-medium text-white transition duration-200 flex items-center justify-center">
                    <i class="fas fa-save mr-2"></i> Lưu địa điểm
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const fileInput = document.getElementById('file');
        const fileButton = document.getElementById('fileButton');
        const fileNameDisplay = document.getElementById('fileNameDisplay');
        const previewContainer = document.getElementById('previewContainer');
        const previewImage = document.getElementById('previewImage');
        const filenameInput = document.getElementById('filename');
        const locationForm = document.getElementById('locationForm');

        // File input change handler
        fileInput.addEventListener('change', function(e) {
            if (this.files && this.files[0]) {
                const file = this.files[0];

                // Display file name
                fileNameDisplay.textContent = `Đã chọn: ${file.name}`;

                // Auto-fill filename field if empty
                if (!filenameInput.value) {
                    const fileNameWithoutExt = file.name.replace(/\.[^/.]+$/, "");
                    filenameInput.value = fileNameWithoutExt;
                }

                // Create preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    previewImage.src = e.target.result;
                    previewContainer.style.display = 'block';

                };
                reader.readAsDataURL(file);

                // Display file size
                const fileSize = file.size > 1024
                    ? file.size > 1048576
                        ? Math.round(file.size / 1048576) + 'MB'
                        : Math.round(file.size / 1024) + 'KB'
                    : file.size + ' bytes';
            }
        });

        // Trigger file input when button is clicked
        fileButton.addEventListener('click', function() {
            fileInput.click();
        });

        // Form submission - THAY ĐỔI: Cho phép submit thực sự
        locationForm.addEventListener('submit', function(e) {
            // Hiển thị loading state
            const submitButton = this.querySelector('button[type="submit"]');
            const originalContent = submitButton.innerHTML;
            submitButton.disabled = true;
            submitButton.innerHTML = '<i class="fas fa-circle-notch fa-spin mr-2"></i> Đang lưu...';

            console.log('Form đang được submit...');
        });
    });
</script>