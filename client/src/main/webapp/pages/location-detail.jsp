<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  // Kiểm tra session để xác định user đã đăng nhập hay chưa
  String userToken = (String) session.getAttribute("token");
  String username = (String) session.getAttribute("username");
  String userRole = (String) session.getAttribute("role");
  Integer userId = (Integer) session.getAttribute("userId");

  boolean isLoggedIn = (userToken != null && !userToken.trim().isEmpty());

  // Set attributes để sử dụng trong JSTL
  request.setAttribute("isLoggedIn", isLoggedIn);
  request.setAttribute("currentUsername", username);
  request.setAttribute("currentUserRole", userRole);
  request.setAttribute("currentUserId", userId);
%>
<div class="container mx-auto px-4 py-8">
  <div class="bg-white rounded-lg shadow-lg overflow-hidden">
    <!-- Main Image -->
    <div class="relative h-96 overflow-hidden">
      <img id="mainImage" src="${location.mainImage}" alt="${location.title}" class="w-full h-full object-cover">
    </div>

    <!-- Location Info -->
    <div class="p-6">
      <div class="flex justify-between items-start mb-4">
        <div>
          <h1 id="locationTitle" class="text-3xl font-bold text-gray-800">${location.title}</h1>
          <p id="locationId" class="text-gray-500 text-sm mt-1">ID địa điểm: ${location.id}</p>
        </div>
      </div>

      <p id="locationDescription" class="text-gray-700 mb-6">${location.description}</p>

      <!-- Guide Info -->
      <div class="mb-8">
        <h2 class="text-xl font-semibold text-gray-800 mb-4">Hướng dẫn viên</h2>
        <div id="guideInfo" class="bg-gray-50 p-4 rounded-lg">
          <div class="flex items-center">
            <div class="w-12 h-12 rounded-full bg-gray-300 flex items-center justify-center mr-4">
              <i class="fas fa-user text-gray-500"></i>
            </div>
            <div>
              <h3 class="font-medium text-gray-800">${location.guide.username}</h3>
              <p class="text-sm text-gray-600">${location.guide.email}</p>
              <p class="text-sm text-gray-600">${location.guide.role}</p>
            </div>
          </div>
        </div>
      </div>

      <!-- Image Gallery -->
      <div class="mb-8">
        <h2 class="text-xl font-semibold text-gray-800 mb-4">Hình ảnh</h2>
        <div class="relative">
          <div id="imageGallery" class="flex overflow-x-auto scroll-smooth gap-4 pb-4">
            <c:forEach var="image" items="${location.images}">
              <div class="relative group flex-shrink-0 w-48">
                <img src="${image.imageData}" alt="${image.caption}" class="w-full h-32 object-cover rounded-lg">
                <div class="absolute inset-0 bg-black bg-opacity-50 opacity-0 group-hover:opacity-100 transition flex items-center justify-center rounded-lg">
                  <p class="text-white text-sm px-2 text-center">${image.caption}</p>
                </div>
              </div>
            </c:forEach>
          </div>
          <!-- Navigation Buttons -->
          <button id="prevButton" class="absolute left-0 top-1/2 transform -translate-y-1/2 bg-gray-800 text-white p-2 rounded-full opacity-75 hover:opacity-100">
            <i class="fas fa-chevron-left"></i>
          </button>
          <button id="nextButton" class="absolute right-0 top-1/2 transform -translate-y-1/2 bg-gray-800 text-white p-2 rounded-full opacity-75 hover:opacity-100">
            <i class="fas fa-chevron-right"></i>
          </button>
        </div>
      </div>

      <!-- Comments Section -->
      <div>
        <h2 class="text-xl font-semibold text-gray-800 mb-4">Bình luận</h2>
        <div id="commentsList" class="space-y-4">
          <c:if test="${not empty location.comments}">
            <c:forEach var="comment" items="${location.comments}" begin="${(page - 1) * 5 >= 0 ? (page - 1) * 5 : 0}" end="${page * 5 - 1}">
              <div class="bg-gray-50 p-4 rounded-lg">
                <div class="flex justify-between items-start mb-2">
                  <div class="flex items-center">
                    <div class="w-10 h-10 rounded-full bg-gray-300 flex items-center justify-center mr-3">
                      <i class="fas fa-user text-gray-500"></i>
                    </div>
                    <div>
                      <h4 class="font-medium text-gray-800">${comment.user.username}</h4>
                      <p class="text-xs text-gray-500">${comment.user.role}</p>
                    </div>
                  </div>
                  <div class="comment-rating">
                    <c:forEach begin="1" end="5" var="i">
                      <i class="fas fa-star${i <= comment.rating ? '' : ' opacity-30'}"></i>
                    </c:forEach>
                  </div>
                </div>
                <p class="text-gray-700 mb-2">${comment.comment}</p>
              </div>
            </c:forEach>
          </c:if>
          <c:if test="${empty location.comments}">
            <p class="text-gray-500">Chưa có bình luận nào.</p>
          </c:if>
        </div>
        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
          <div id="pagination" class="flex justify-center mt-4">
            <c:forEach begin="1" end="${totalPages}" var="i">
              <a href="?page=${i}" class="mx-1 px-3 py-1 rounded ${i == page ? 'bg-gray-800 text-white' : 'bg-gray-200 text-gray-800'}">${i}</a>
            </c:forEach>
          </div>
        </c:if>
      </div>
    </div>
  </div>

  <!-- Comment Form Section -->
  <div class="mb-6">

    <!-- Check if user is logged in using session -->
    <c:choose>
      <c:when test="${isLoggedIn && currentUserRole == 'consumer'}">
          <h3 class="text-lg font-semibold text-gray-800 mb-4">Thêm bình luận</h3>

          <form action="${pageContext.request.contextPath}/comment" method="post" class="bg-gray-50 p-6 rounded-lg">
          <!-- Hidden field for location ID -->
          <input type="hidden" name="locationId" value="${location.id}">

          <!-- Hidden field for user ID (from session) -->
          <input type="hidden" name="userId" value="${currentUserId}">

          <!-- User Info Display -->
          <div class="mb-4 flex items-center">
            <div class="w-10 h-10 rounded-full bg-blue-500 flex items-center justify-center mr-3">
              <i class="fas fa-user text-white"></i>
            </div>
          </div>

          <!-- Rating Selection -->
          <div class="mb-4">
            <label class="block text-sm font-medium text-gray-700 mb-2">Đánh giá *</label>
            <div class="flex items-center space-x-1" id="ratingStars">
              <input type="hidden" name="rating" id="ratingValue" value="5" required>
              <i class="fas fa-star cursor-pointer text-yellow-400 text-xl rating-star" data-rating="1"></i>
              <i class="fas fa-star cursor-pointer text-yellow-400 text-xl rating-star" data-rating="2"></i>
              <i class="fas fa-star cursor-pointer text-yellow-400 text-xl rating-star" data-rating="3"></i>
              <i class="fas fa-star cursor-pointer text-yellow-400 text-xl rating-star" data-rating="4"></i>
              <i class="fas fa-star cursor-pointer text-yellow-400 text-xl rating-star" data-rating="5"></i>
              <span class="ml-2 text-sm text-gray-600" id="ratingText">Tuyệt vời</span>
            </div>
          </div>

          <!-- Comment Text -->
          <div class="mb-4">
            <label for="commentText" class="block text-sm font-medium text-gray-700 mb-2">Bình luận *</label>
            <textarea
                    id="commentText"
                    name="comment"
                    rows="4"
                    required
                    maxlength="500"
                    placeholder="Chia sẻ trải nghiệm của bạn về địa điểm này..."
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
            ></textarea>
            <div class="flex justify-between mt-1">
              <span class="text-xs text-gray-500">Tối đa 500 ký tự</span>
              <span class="text-xs text-gray-500" id="charCount">0/500</span>
            </div>
          </div>

          <!-- Submit Button -->
          <div class="flex justify-end">
            <button
                    type="submit"
                    class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition duration-200"
            >
              <i class="fas fa-paper-plane mr-2"></i>
              Gửi bình luận
            </button>
          </div>
        </form>
      </c:when>
        <c:when test="${isLoggedIn && currentUserRole == 'guide'}"></c:when>
      <c:otherwise>
          <h3 class="text-lg font-semibold text-gray-800 mb-4">Thêm bình luận</h3>
          <!-- Login prompt for non-logged in users -->
        <div class="bg-gray-50 p-6 rounded-lg text-center">
          <i class="fas fa-sign-in-alt text-gray-400 text-3xl mb-3"></i>
          <p class="text-gray-600 mb-4">Vui lòng đăng nhập để có thể bình luận và đánh giá địa điểm</p>
          <div class="space-x-4">
            <a href="${pageContext.request.contextPath}/auth?action=login" class="bg-blue-600 text-white px-6 py-2 rounded-md hover:bg-blue-700 transition duration-200 inline-block">
              <i class="fas fa-sign-in-alt mr-2"></i>
              Đăng nhập
            </a>
            <a href="${pageContext.request.contextPath}/auth?action=register" class="bg-gray-600 text-white px-6 py-2 rounded-md hover:bg-gray-700 transition duration-200 inline-block">
              <i class="fas fa-user-plus mr-2"></i>
              Đăng ký
            </a>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<script>
  // Image Gallery Carousel
  const gallery = document.getElementById('imageGallery');
  const prevButton = document.getElementById('prevButton');
  const nextButton = document.getElementById('nextButton');

  if (prevButton && nextButton && gallery) {
    prevButton.addEventListener('click', () => {
      gallery.scrollBy({ left: -200, behavior: 'smooth' });
    });

    nextButton.addEventListener('click', () => {
      gallery.scrollBy({ left: 200, behavior: 'smooth' });
    });
  }

  // Rating Stars Functionality
  const ratingStars = document.querySelectorAll('.rating-star');
  const ratingValue = document.getElementById('ratingValue');
  const ratingText = document.getElementById('ratingText');

  const ratingTexts = {
    1: 'Rất tệ',
    2: 'Tệ',
    3: 'Bình thường',
    4: 'Tốt',
    5: 'Tuyệt vời'
  };

  ratingStars.forEach(star => {
    star.addEventListener('click', function() {
      const rating = parseInt(this.getAttribute('data-rating'));
      ratingValue.value = rating;
      ratingText.textContent = ratingTexts[rating];

      // Update star display
      ratingStars.forEach((s, index) => {
        if (index < rating) {
          s.classList.add('text-yellow-400');
          s.classList.remove('text-gray-300');
        } else {
          s.classList.add('text-gray-300');
          s.classList.remove('text-yellow-400');
        }
      });
    });

    // Hover effect
    star.addEventListener('mouseenter', function() {
      const rating = parseInt(this.getAttribute('data-rating'));
      ratingStars.forEach((s, index) => {
        if (index < rating) {
          s.classList.add('text-yellow-300');
        } else {
          s.classList.remove('text-yellow-300');
        }
      });
    });
  });

  // Character count for textarea
  const commentTextarea = document.getElementById('commentText');
  const charCount = document.getElementById('charCount');

  if (commentTextarea && charCount) {
    commentTextarea.addEventListener('input', function() {
      const count = this.value.length;
      charCount.textContent = count + '/500';

      if (count > 450) {
        charCount.classList.add('text-red-500');
      } else {
        charCount.classList.remove('text-red-500');
      }
    });
  }

  // Form validation
  const form = document.querySelector('form[action*="addComment"]');
  if (form) {
    form.addEventListener('submit', function(e) {
      const comment = commentTextarea.value.trim();
      const rating = ratingValue.value;

      if (!comment) {
        e.preventDefault();
        alert('Vui lòng nhập bình luận');
        commentTextarea.focus();
        return;
      }

      if (comment.length < 10) {
        e.preventDefault();
        alert('Bình luận phải có ít nhất 10 ký tự');
        commentTextarea.focus();
        return;
      }

      if (!rating || rating < 1 || rating > 5) {
        e.preventDefault();
        alert('Vui lòng chọn đánh giá từ 1 đến 5 sao');
        return;
      }
    });
  }
</script>