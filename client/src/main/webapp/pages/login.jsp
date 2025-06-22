<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
  <div class="max-w-md w-full space-y-8">
    <!-- Header -->
    <div class="text-center">
      <div class="mx-auto h-16 w-16 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full flex items-center justify-center mb-6">
        <svg class="h-8 w-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"></path>
        </svg>
      </div>
      <h2 class="text-3xl font-bold text-gray-900 mb-2">Chào mừng trở lại</h2>
      <p class="text-gray-600">Đăng nhập để tiếp tục hành trình của bạn</p>
    </div>

    <!-- Form -->
    <form action="auth?action=login" method="post" id="loginForm" class="bg-white shadow-2xl rounded-2xl px-8 py-8 space-y-6">

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
                 class="w-full px-4 py-3 pl-12 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-300 placeholder-gray-400"
                 placeholder="Nhập tên đăng nhập của bạn">
          <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
            </svg>
          </div>
        </div>
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
                 class="w-full px-4 py-3 pl-12 pr-12 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all duration-300 placeholder-gray-400"
                 placeholder="Nhập mật khẩu của bạn">
          <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
            </svg>
          </div>
          <button type="button"
                  id="togglePassword"
                  class="absolute inset-y-0 right-0 pr-3 flex items-center">
            <svg class="h-5 w-5 text-gray-400 hover:text-gray-600 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24" id="eye-open">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
            </svg>
            <svg class="h-5 w-5 text-gray-400 hover:text-gray-600 transition-colors hidden" fill="none" stroke="currentColor" viewBox="0 0 24 24" id="eye-closed">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.878 9.878L3 3m6.878 6.878L21 21"></path>
            </svg>
          </button>
        </div>
      </div>

      <!-- Remember & Forgot Password -->
      <div class="flex items-center justify-between">
        <div class="flex items-center">
          <input id="remember-me"
                 name="remember-me"
                 type="checkbox"
                 class="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded transition-colors">
          <label for="remember-me" class="ml-2 block text-sm text-gray-700">
            Ghi nhớ đăng nhập
          </label>
        </div>
        <div class="text-sm">
          <a href="#" class="font-medium text-blue-600 hover:text-blue-500 transition-colors duration-300">
            Quên mật khẩu?
          </a>
        </div>
      </div>

      <!-- Submit Button -->
      <div class="form-group">
        <button type="submit"
                id="submitBtn"
                class="group relative w-full bg-gradient-to-r from-blue-600 to-purple-600 text-white py-3 px-4 rounded-lg font-semibold text-lg hover:from-blue-700 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all duration-300 transform hover:scale-[1.02] disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none">
                    <span class="flex items-center justify-center">
                        <span id="btn-text">Đăng nhập</span>
                        <svg class="animate-spin -mr-1 ml-3 h-5 w-5 text-white hidden" id="loading-spinner" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                    </span>
          <div class="absolute inset-0 bg-gradient-to-r from-blue-700 to-purple-700 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300 -z-10"></div>
        </button>
      </div>

      <!-- Error Messages -->
      <% if (request.getParameter("error") != null) { %>
      <div class="bg-red-50 border border-red-200 rounded-lg p-4">
        <div class="flex">
          <svg class="h-5 w-5 text-red-400 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
          <div class="ml-3">
            <h3 class="text-sm font-medium text-red-800">
              Đăng nhập thất bại
            </h3>
            <div class="mt-1 text-sm text-red-700">
              <p>📧 Tên đăng nhập hoặc mật khẩu không đúng!</p>
            </div>
          </div>
        </div>
      </div>
      <% } %>

      <!-- Social Login (Optional) -->
      <div class="mt-6">
        <div class="relative">
          <div class="absolute inset-0 flex items-center">
            <div class="w-full border-t border-gray-300"></div>
          </div>
          <div class="relative flex justify-center text-sm">
            <span class="px-2 bg-white text-gray-500">Hoặc</span>
          </div>
        </div>

        <div class="mt-6 grid grid-cols-2 gap-3">
          <button type="button" class="w-full inline-flex justify-center py-2 px-4 border border-gray-300 rounded-lg shadow-sm bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 transition-colors duration-300">
            <svg class="h-5 w-5 text-red-500" viewBox="0 0 24 24">
              <path fill="currentColor" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
              <path fill="currentColor" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
              <path fill="currentColor" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
              <path fill="currentColor" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
            </svg>
            <span class="ml-2">Google</span>
          </button>

          <button type="button" class="w-full inline-flex justify-center py-2 px-4 border border-gray-300 rounded-lg shadow-sm bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 transition-colors duration-300">
            <svg class="h-5 w-5 text-blue-600" fill="currentColor" viewBox="0 0 24 24">
              <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
            </svg>
            <span class="ml-2">Facebook</span>
          </button>
        </div>
      </div>

      <!-- Register Link -->
      <div class="text-center pt-4 border-t border-gray-200">
        <p class="text-gray-600">
          Chưa có tài khoản?
          <a href="auth?action=register" class="font-medium text-blue-600 hover:text-blue-500 transition-colors duration-300">
            Đăng ký ngay
          </a>
        </p>
      </div>
    </form>
  </div>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('loginForm');
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

    // Input focus effects
    const inputs = document.querySelectorAll('input[type="text"], input[type="password"]');

    inputs.forEach(input => {
      input.addEventListener('focus', function() {
        this.parentElement.classList.add('focused');
        this.classList.add('ring-2', 'ring-blue-500', 'border-transparent');
      });

      input.addEventListener('blur', function() {
        if (this.value === '') {
          this.parentElement.classList.remove('focused');
        }
        this.classList.remove('ring-2', 'ring-blue-500', 'border-transparent');
      });

      // Add some basic validation styling
      input.addEventListener('input', function() {
        if (this.value.length > 0) {
          this.classList.add('border-green-300');
          this.classList.remove('border-red-300');
        }
      });
    });

    // Form submission with loading state
    form.addEventListener('submit', function(e) {
      const username = document.getElementById('username').value.trim();
      const password = document.getElementById('password').value.trim();

      if (username && password) {
        // Show loading state
        submitBtn.disabled = true;
        btnText.textContent = 'Đang đăng nhập...';
        loadingSpinner.classList.remove('hidden');
      } else {
        e.preventDefault();

        // Highlight empty fields
        if (!username) {
          document.getElementById('username').classList.add('border-red-300', 'focus:ring-red-500');
        }
        if (!password) {
          document.getElementById('password').classList.add('border-red-300', 'focus:ring-red-500');
        }
      }
    });

    // Enter key handling
    inputs.forEach(input => {
      input.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
          form.submit();
        }
      });
    });

    // Auto-focus first empty field
    const firstEmptyField = Array.from(inputs).find(input => !input.value);
    if (firstEmptyField) {
      firstEmptyField.focus();
    }

  });
</script>