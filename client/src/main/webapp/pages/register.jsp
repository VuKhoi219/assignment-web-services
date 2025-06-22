<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <div class="max-w-md w-full space-y-8">
        <!-- Header -->
        <div class="text-center">
            <div class="mx-auto h-16 w-16 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full flex items-center justify-center mb-6">
                <svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"></path>
                </svg>
            </div>
            <h2 class="text-3xl font-bold text-gray-900 mb-2">Tạo tài khoản mới</h2>
            <p class="text-gray-600">Gia nhập cộng đồng Travel Hub ngay hôm nay</p>
        </div>

        <!-- Form -->
        <form action="auth?action=register" method="post" id="registerForm" class="bg-white shadow-2xl rounded-2xl px-8 py-8 space-y-6">

            <!-- Username Field -->
            <div class="form-group">
                <label for="username" class="block text-sm font-medium text-gray-700 mb-2">
                    Tên đăng nhập
                </label>
                <div class="relative">
                    <input type="text"
                           id="username"
                           name="username"
                           required
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-300 placeholder-gray-400"
                           placeholder="Nhập tên đăng nhập của bạn">
                    <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                        <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                        </svg>
                    </div>
                </div>
                <p class="mt-1 text-sm text-red-600 hidden" id="username-error">Tên đăng nhập phải có ít nhất 3 ký tự</p>
            </div>

            <!-- Email Field -->
            <div class="form-group">
                <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                    Địa chỉ Email
                </label>
                <div class="relative">
                    <input type="email"
                           id="email"
                           name="email"
                           required
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-300 placeholder-gray-400"
                           placeholder="Nhập email của bạn">
                    <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                        <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"></path>
                        </svg>
                    </div>
                </div>
                <p class="mt-1 text-sm text-red-600 hidden" id="email-error">Vui lòng nhập email hợp lệ</p>
            </div>

            <!-- Password Field -->
            <div class="form-group">
                <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
                    Mật khẩu
                </label>
                <div class="relative">
                    <input type="password"
                           id="password"
                           name="password"
                           required
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-300 placeholder-gray-400"
                           placeholder="Nhập mật khẩu của bạn">
                    <button type="button"
                            id="togglePassword"
                            class="absolute inset-y-0 right-0 pr-3 flex items-center">
                        <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" id="eye-open">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                        </svg>
                        <svg class="h-5 w-5 text-gray-400 hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24" id="eye-closed">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.878 9.878L3 3m6.878 6.878L21 21"></path>
                        </svg>
                    </button>
                </div>
                <div class="mt-2">
                    <div class="flex items-center space-x-2">
                        <div class="flex-1 bg-gray-200 rounded-full h-2">
                            <div id="password-strength" class="h-2 rounded-full transition-all duration-300"></div>
                        </div>
                        <span id="password-strength-text" class="text-xs text-gray-500">Độ mạnh</span>
                    </div>
                </div>
                <p class="mt-1 text-sm text-red-600 hidden" id="password-error">Mật khẩu phải có ít nhất 6 ký tự</p>
            </div>

            <!-- Role Field -->
            <div class="form-group">
                <label for="role" class="block text-sm font-medium text-gray-700 mb-2">
                    Vai trò
                </label>
                <select id="role"
                        name="role"
                        required
                        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-300 bg-white">
                    <option value="">Chọn vai trò của bạn</option>
                    <option value="consumer">👤 Người dùng</option>
                    <option value="guide">🎯 Hướng dẫn viên</option>
                </select>
                <p class="mt-1 text-sm text-red-600 hidden" id="role-error">Vui lòng chọn vai trò</p>
            </div>

            <!-- Submit Button -->
            <div class="form-group">
                <button type="submit"
                        id="submitBtn"
                        class="w-full bg-gradient-to-r from-blue-600 to-purple-600 text-white py-3 px-4 rounded-lg font-semibold text-lg hover:from-blue-700 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all duration-300 transform hover:scale-[1.02] disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none">
                    <span class="flex items-center justify-center">
                        <span id="btn-text">Tạo tài khoản</span>
                        <svg class="animate-spin -mr-1 ml-3 h-5 w-5 text-white hidden" id="loading-spinner" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                    </span>
                </button>
            </div>

            <!-- Error Messages -->
            <% if (request.getParameter("error") != null) { %>
            <div class="bg-red-50 border border-red-200 rounded-lg p-4">
                <div class="flex">
                    <svg class="h-5 w-5 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                    </svg>
                    <div class="ml-3">
                        <p class="text-sm text-red-800">
                            <%
                                String error = request.getParameter("error");
                                if ("username_exists".equals(error)) {
                                    out.print("Tên đăng nhập đã tồn tại!");
                                } else if ("email_exists".equals(error)) {
                                    out.print("Email đã được sử dụng!");
                                } else {
                                    out.print("Đã có lỗi xảy ra, vui lòng thử lại!");
                                }
                            %>
                        </p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Login Link -->
            <div class="text-center pt-4 border-t border-gray-200">
                <p class="text-gray-600">
                    Đã có tài khoản?
                    <a href="auth?action=login" class="font-medium text-blue-600 hover:text-blue-500 transition-colors duration-300">
                        Đăng nhập ngay
                    </a>
                </p>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('registerForm');
        const submitBtn = document.getElementById('submitBtn');
        const btnText = document.getElementById('btn-text');
        const loadingSpinner = document.getElementById('loading-spinner');
        const togglePassword = document.getElementById('togglePassword');
        const passwordField = document.getElementById('password');
        const eyeOpen = document.getElementById('eye-open');
        const eyeClosed = document.getElementById('eye-closed');

        // Password toggle functionality
        togglePassword.addEventListener('click', function() {
            const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordField.setAttribute('type', type);

            eyeOpen.classList.toggle('hidden');
            eyeClosed.classList.toggle('hidden');
        });

        // Form validation functions
        function validateField(field) {
            const errorElement = document.getElementById(field.id + '-error');
            let isValid = true;
            let errorMessage = '';

            switch(field.type) {
                case 'email':
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    isValid = emailRegex.test(field.value);
                    errorMessage = 'Vui lòng nhập email hợp lệ';
                    break;
                case 'password':
                    isValid = field.value.length >= 6;
                    errorMessage = 'Mật khẩu phải có ít nhất 6 ký tự';
                    break;
                case 'text':
                    isValid = field.value.trim().length >= 3;
                    errorMessage = 'Tên đăng nhập phải có ít nhất 3 ký tự';
                    break;
            }

            // Update field styling
            if (field.value && isValid) {
                field.classList.remove('border-red-300', 'focus:ring-red-500');
                field.classList.add('border-green-300', 'focus:ring-green-500');
                errorElement.classList.add('hidden');
            } else if (field.value && !isValid) {
                field.classList.remove('border-green-300', 'focus:ring-green-500');
                field.classList.add('border-red-300', 'focus:ring-red-500');
                errorElement.textContent = errorMessage;
                errorElement.classList.remove('hidden');
            } else {
                field.classList.remove('border-red-300', 'border-green-300', 'focus:ring-red-500', 'focus:ring-green-500');
                errorElement.classList.add('hidden');
            }

            return isValid;
        }

        function validateSelect(select) {
            const errorElement = document.getElementById(select.id + '-error');
            const isValid = select.value !== '';

            if (isValid) {
                select.classList.remove('border-red-300', 'focus:ring-red-500');
                select.classList.add('border-green-300', 'focus:ring-green-500');
                errorElement.classList.add('hidden');
            } else {
                select.classList.remove('border-green-300', 'focus:ring-green-500');
                select.classList.add('border-red-300', 'focus:ring-red-500');
                errorElement.classList.remove('hidden');
            }

            return isValid;
        }

        // Password strength indicator
        function updatePasswordStrength(password) {
            const strengthBar = document.getElementById('password-strength');
            const strengthText = document.getElementById('password-strength-text');

            let strength = 0;
            let color = '';
            let text = '';

            if (password.length >= 6) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;

            const percentage = (strength / 5) * 100;

            switch(strength) {
                case 0:
                case 1:
                    color = 'bg-red-500';
                    text = 'Yếu';
                    break;
                case 2:
                    color = 'bg-orange-500';
                    text = 'Trung bình';
                    break;
                case 3:
                    color = 'bg-yellow-500';
                    text = 'Khá';
                    break;
                case 4:
                    color = 'bg-blue-500';
                    text = 'Mạnh';
                    break;
                case 5:
                    color = 'bg-green-500';
                    text = 'Rất mạnh';
                    break;
            }

            strengthBar.className = `h-2 rounded-full transition-all duration-300 ${color}`;
            strengthBar.style.width = percentage + '%';
            strengthText.textContent = text;
            strengthText.className = `text-xs ${color.replace('bg-', 'text-')}`;
        }

        // Event listeners
        const inputs = document.querySelectorAll('input[type="text"], input[type="email"], input[type="password"]');
        const roleSelect = document.getElementById('role');

        inputs.forEach(input => {
            input.addEventListener('blur', () => validateField(input));
            input.addEventListener('input', () => {
                if (input.classList.contains('border-red-300') || input.classList.contains('border-green-300')) {
                    validateField(input);
                }
                if (input.type === 'password') {
                    updatePasswordStrength(input.value);
                }
            });
        });

        roleSelect.addEventListener('change', () => validateSelect(roleSelect));

        // Form submission
        form.addEventListener('submit', function(e) {
            let isFormValid = true;

            // Validate all fields
            inputs.forEach(input => {
                if (!validateField(input)) {
                    isFormValid = false;
                }
            });

            if (!validateSelect(roleSelect)) {
                isFormValid = false;
            }

            if (isFormValid) {
                // Show loading state
                submitBtn.disabled = true;
                btnText.textContent = 'Đang tạo tài khoản...';
                loadingSpinner.classList.remove('hidden');
            } else {
                e.preventDefault();
            }
        });
    });
</script>