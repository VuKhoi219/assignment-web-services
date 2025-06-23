<%--
  Created by IntelliJ IDEA.
  User: DELL G15
  Date: 6/21/2025
  Time: 11:25 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div  class="bg-gradient-to-br from-gray-900 to-indigo-900 min-h-screen flex items-center justify-center text-white bg-pattern overflow-hidden">
  <div class="absolute inset-0 overflow-hidden">
    <div class="absolute top-1/4 left-1/4 w-32 h-32 rounded-full bg-purple-500 opacity-20 blur-3xl"></div>
    <div class="absolute bottom-1/4 right-1/4 w-40 h-40 rounded-full bg-blue-500 opacity-20 blur-3xl"></div>
    <div class="absolute top-1/3 right-1/3 w-24 h-24 rounded-full bg-indigo-500 opacity-20 blur-3xl"></div>
  </div>

  <div class="relative z-10 max-w-2xl mx-4 p-8 bg-white/10 backdrop-blur-lg rounded-2xl shadow-2xl border border-white/10 text-center">
    <div class="floating mb-8">
      <div class="w-32 h-32 mx-auto bg-gradient-to-br from-red-500 to-pink-600 rounded-full flex items-center justify-center shadow-lg">
        <i class="fas fa-lock text-6xl text-white"></i>
      </div>
    </div>

    <h1 class="text-4xl md:text-5xl font-bold mb-4 glow">Truy cập bị từ chối</h1>
    <p class="text-xl text-white/80 mb-8">Bạn không có quyền truy cập trang này.</p>

    <div class="bg-white/5 p-6 rounded-xl mb-8">
      <div class="flex items-center justify-center space-x-4">
        <i class="fas fa-exclamation-triangle text-yellow-400 text-2xl"></i>
        <p class="text-left">Điều này có thể do tài khoản của bạn không có quyền phù hợp hoặc trang này bị giới hạn truy cập.</p>
      </div>
    </div>

    <div class="mt-10 text-sm text-white/60">
      <p>Mã lỗi: 403 Cấm truy cập</p>
      <p class="mt-2">Nếu bạn cho rằng đây là lỗi, vui lòng liên hệ với quản trị viên.</p>
    </div>
  </div>

  <div class="absolute bottom-6 left-0 right-0 text-center text-white/50 text-sm">
    <p>© 2023 Công ty của bạn. Bảo lưu mọi quyền.</p>
  </div>
</div>
<script>
  // Thêm một số yếu tố tương tác
  document.addEventListener('DOMContentLoaded', function() {
    const buttons = document.querySelectorAll('a');

    buttons.forEach(button => {
      button.addEventListener('mouseenter', () => {
        button.querySelector('i').classList.add('animate-bounce');
      });

      button.addEventListener('mouseleave', () => {
        button.querySelector('i').classList.remove('animate-bounce');
      });
    });

    // Thêm các hạt nổi
    const container = document.querySelector('body');
    for (let i = 0; i < 20; i++) {
      const particle = document.createElement('div');
      particle.className = 'absolute rounded-full bg-white/10';
      particle.style.width = `${Math.random() * 5 + 2}px`;
      particle.style.height = particle.style.width;
      particle.style.left = `${Math.random() * 100}%`;
      particle.style.top = `${Math.random() * 100}%`;
      particle.style.animation = `float ${Math.random() * 10 + 5}s ease-in-out infinite ${Math.random() * 5}s`;
      container.appendChild(particle);
    }
  });
</script>
