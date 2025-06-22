<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Add null checks -->
<c:if test="${empty location}">
  <div class="container mx-auto px-4 py-8">
    <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
      Không tìm thấy thông tin địa điểm.
    </div>
  </div>
</c:if>

<c:if test="${not empty location}">
  <div class="container mx-auto px-4 py-8">
    <div class="bg-white rounded-lg shadow-lg overflow-hidden">
      <!-- Main Image with null check -->
      <div class="relative h-96 overflow-hidden">
        <c:choose>
          <c:when test="${not empty location.mainImage}">
            <img id="mainImage" src="${location.mainImage}" alt="${location.title}"
                 class="w-full h-full object-cover"
                 onerror="this.src='/images/placeholder.jpg';">
          </c:when>
          <c:otherwise>
            <div class="w-full h-full bg-gray-300 flex items-center justify-center">
              <i class="fas fa-image text-gray-500 text-4xl"></i>
            </div>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Location Info -->
      <div class="p-6">
        <div class="flex justify-between items-start mb-4">
          <div class="flex-1">
            <!-- Title Display/Edit -->
            <div id="titleDisplay">
              <h1 id="locationTitle" class="text-3xl font-bold text-gray-800">
                  ${not empty location.title ? location.title : 'Chưa có tiêu đề'}
              </h1>
            </div>
            <div id="titleEdit" class="hidden">
              <input type="text" id="titleInput" value="${location.title}"
                     class="text-3xl font-bold text-gray-800 bg-transparent border-b-2 border-blue-500 focus:outline-none focus:border-blue-700 w-full mb-2">
              <p id="locationId" class="text-gray-500 text-sm mt-1">ID địa điểm: ${location.id}</p>
            </div>
          </div>
          <div class="flex items-center gap-2 ml-4">
            <!-- Edit/Save Buttons -->
            <button id="editButton" class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded-lg transition duration-200">
              <i class="fas fa-edit mr-1"></i> Cập nhật
            </button>
            <button id="saveButton" class="hidden bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-lg transition duration-200">
              <i class="fas fa-save mr-1"></i> Lưu
            </button>
            <button id="cancelButton" class="hidden bg-gray-600 hover:bg-gray-700 text-white font-semibold py-2 px-4 rounded-lg transition duration-200">
              <i class="fas fa-times mr-1"></i> Hủy
            </button>
          </div>
        </div>

        <!-- Description Display/Edit -->
        <div id="descriptionDisplay">
          <p id="locationDescription" class="text-gray-700 mb-6">
              ${not empty location.description ? location.description : 'Chưa có mô tả'}
          </p>
        </div>
        <div id="descriptionEdit" class="hidden mb-6">
        <textarea id="descriptionInput" rows="4"
                  class="w-full text-gray-700 bg-gray-50 border border-gray-300 rounded-lg p-3 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500">${location.description}</textarea>
        </div>

        <!-- Guide Info with null checks -->
        <div class="mb-8">
          <h2 class="text-xl font-semibold text-gray-800 mb-4">Hướng dẫn viên</h2>
          <div id="guideInfo" class="bg-gray-50 p-4 rounded-lg">
            <c:choose>
              <c:when test="${not empty location.guide}">
                <div class="flex items-center">
                  <div class="w-12 h-12 rounded-full bg-gray-300 flex items-center justify-center mr-4">
                    <i class="fas fa-user text-gray-500"></i>
                  </div>
                  <div>
                    <h3 class="font-medium text-gray-800">
                        ${not empty location.guide.username ? location.guide.username : 'Chưa có tên'}
                    </h3>
                    <p class="text-sm text-gray-600">
                        ${not empty location.guide.email ? location.guide.email : 'Chưa có email'}
                    </p>
                    <p class="text-sm text-gray-600">
                        ${not empty location.guide.role ? location.guide.role : 'Chưa có vai trò'}
                    </p>
                  </div>
                </div>
              </c:when>
              <c:otherwise>
                <p class="text-gray-500">Chưa có thông tin hướng dẫn viên</p>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <!-- Add Image Button -->
        <div class="mb-4">
          <button id="addImageButton"
                  class="bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded-lg transition duration-200">
            <i class="fas fa-plus mr-2"></i> Thêm ảnh
          </button>
        </div>

        <!-- Upload Form -->
        <div id="uploadForm" class="hidden border border-gray-200 rounded-lg p-6 mb-6 bg-gray-50">
          <h3 class="text-lg font-semibold text-gray-800 mb-4">
            <i class="fas fa-upload mr-2"></i>Tải lên hình ảnh mới
          </h3>
          <form id="imageUploadForm" enctype="multipart/form-data">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <!-- File Input -->
              <div class="col-span-1 md:col-span-2">
                <label for="imageFile" class="block text-sm font-medium text-gray-700 mb-2">
                  Chọn hình ảnh *
                </label>
                <div class="flex items-center justify-center w-full">
                  <label for="imageFile" class="flex flex-col items-center justify-center w-full h-32 border-2 border-gray-300 border-dashed rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100">
                    <div class="flex flex-col items-center justify-center pt-5 pb-6">
                      <i class="fas fa-cloud-upload-alt text-gray-400 text-2xl mb-2"></i>
                      <p class="mb-2 text-sm text-gray-500">
                        <span class="font-semibold">Nhấp để tải lên</span> hoặc kéo thả
                      </p>
                      <p class="text-xs text-gray-500">PNG, JPG, JPEG (MAX. 5MB)</p>
                    </div>
                    <input id="imageFile" name="imageFile" type="file" class="hidden" accept="image/*" required>
                  </label>
                </div>
                <div id="selectedFileName" class="mt-2 text-sm text-gray-600 hidden"></div>
              </div>

              <!-- Caption Input -->
              <div>
                <label for="caption" class="block text-sm font-medium text-gray-700 mb-2">
                  Chú thích
                </label>
                <input type="text" id="caption" name="caption"
                       class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                       placeholder="Nhập chú thích cho hình ảnh...">
              </div>

              <!-- Location ID Input (hidden/readonly) -->
              <div>
                <label for="locationId" class="block text-sm font-medium text-gray-700 mb-2">
                  ID Địa điểm
                </label>
                <input type="text" id="locationIdInput" name="locationId"
                       value="${location.id}" readonly
                       class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-gray-100 text-gray-600">
              </div>
            </div>

            <!-- Form Buttons -->
            <div class="flex justify-end gap-3 mt-6">
              <button type="button" id="cancelUploadButton"
                      class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition duration-200">
                <i class="fas fa-times mr-1"></i> Hủy
              </button>
              <button type="submit" id="submitUploadButton"
                      class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition duration-200">
                <i class="fas fa-upload mr-1"></i> Tải lên
              </button>
            </div>
          </form>
        </div>

        <!-- Image Gallery with null checks -->
        <div class="mb-8">
          <h2 class="text-xl font-semibold text-gray-800 mb-4">Hình ảnh</h2>
          <div class="relative">
            <div id="imageGallery" class="flex overflow-x-auto scroll-smooth gap-4 pb-4">
              <c:choose>
                <c:when test="${not empty location.images}">
                  <c:forEach var="image" items="${location.images}">
                    <div class="relative group flex-shrink-0 w-48" data-image-id="${image.id}">
                      <img src="${not empty image.imageData ? image.imageData : '/images/placeholder.jpg'}"
                           alt="${not empty image.caption ? image.caption : 'Hình ảnh'}"
                           class="w-full h-32 object-cover rounded-lg cursor-pointer"
                           onclick="openImageModal(this.src, '${image.caption}')"
                           onerror="this.src='/images/placeholder.jpg';">
                      <div class="absolute inset-0 bg-black bg-opacity-50 opacity-0 group-hover:opacity-100 transition flex items-center justify-center rounded-lg">
                        <p class="text-white text-sm px-2 text-center">
                            ${not empty image.caption ? image.caption : 'Không có chú thích'}
                        </p>
                      </div>
                      <!-- Delete button -->
                      <button class="delete-image-btn absolute top-2 right-2 bg-red-500 hover:bg-red-600 text-white rounded-full w-8 h-8 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-200 z-10"
                              data-image-id="${image.id}"
                              title="Xóa ảnh">
                        <i class="fas fa-trash text-xs"></i>
                      </button>
                    </div>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <p class="text-gray-500">Chưa có hình ảnh nào.</p>
                </c:otherwise>
              </c:choose>
            </div>
            <!-- Navigation Buttons -->
            <c:if test="${not empty location.images and fn:length(location.images) > 1}">
              <button id="prevButton" class="absolute left-0 top-1/2 transform -translate-y-1/2 bg-gray-800 text-white p-2 rounded-full opacity-75 hover:opacity-100">
                <i class="fas fa-chevron-left"></i>
              </button>
              <button id="nextButton" class="absolute right-0 top-1/2 transform -translate-y-1/2 bg-gray-800 text-white p-2 rounded-full opacity-75 hover:opacity-100">
                <i class="fas fa-chevron-right"></i>
              </button>
            </c:if>
          </div>
        </div>

        <!-- Comments Section with pagination fix -->
        <div>
          <h2 class="text-xl font-semibold text-gray-800 mb-4">Bình luận</h2>
          <div id="commentsList" class="space-y-4">
            <c:choose>
              <c:when test="${not empty location.comments}">
                <!-- Calculate pagination bounds safely -->
                <c:set var="startIndex" value="${(page - 1) * 5}" />
                <c:set var="endIndex" value="${page * 5 - 1}" />
                <c:set var="totalComments" value="${fn:length(location.comments)}" />

                <c:if test="${startIndex < totalComments}">
                  <c:forEach var="comment" items="${location.comments}"
                             begin="${startIndex >= 0 ? startIndex : 0}"
                             end="${endIndex < totalComments ? endIndex : totalComments - 1}">
                    <div class="bg-gray-50 p-4 rounded-lg">
                      <div class="flex justify-between items-start mb-2">
                        <div class="flex items-center">
                          <div class="w-10 h-10 rounded-full bg-gray-300 flex items-center justify-center mr-3">
                            <i class="fas fa-user text-gray-500"></i>
                          </div>
                          <div>
                            <h4 class="font-medium text-gray-800">
                                ${not empty comment.user.username ? comment.user.username : 'Người dùng ẩn danh'}
                            </h4>
                            <p class="text-xs text-gray-500">
                                ${not empty comment.user.role ? comment.user.role : 'Người dùng'}
                            </p>
                          </div>
                        </div>
                        <div class="comment-rating">
                          <c:forEach begin="1" end="5" var="i">
                            <i class="fas fa-star${i <= comment.rating ? '' : ' opacity-30'}"></i>
                          </c:forEach>
                        </div>
                      </div>
                      <p class="text-gray-700 mb-2">
                          ${not empty comment.comment ? comment.comment : 'Không có nội dung bình luận'}
                      </p>
                    </div>
                  </c:forEach>
                </c:if>
              </c:when>
              <c:otherwise>
                <p class="text-gray-500">Chưa có bình luận nào.</p>
              </c:otherwise>
            </c:choose>
          </div>

          <!-- Pagination -->
          <c:if test="${totalPages > 1}">
            <div id="pagination" class="flex justify-center mt-4">
              <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="?page=${i}&action=detail"
                   class="mx-1 px-3 py-1 rounded ${i == page ? 'bg-gray-800 text-white' : 'bg-gray-200 text-gray-800'}">${i}</a>
              </c:forEach>
            </div>
          </c:if>
        </div>
      </div>
    </div>
  </div>
</c:if>

<!-- Image Modal -->
<div id="imageModal" class="fixed inset-0 bg-black bg-opacity-75 hidden z-50 flex items-center justify-center">
  <div class="relative max-w-4xl max-h-full p-4">
    <button id="closeModal" class="absolute top-2 right-2 text-white text-2xl hover:text-gray-300">
      <i class="fas fa-times"></i>
    </button>
    <img id="modalImage" src="" alt="" class="max-w-full max-h-full object-contain">
    <p id="modalCaption" class="text-white text-center mt-4"></p>
  </div>
</div>

<!-- Loading Overlay -->
<div id="loadingOverlay" class="fixed inset-0 bg-black bg-opacity-50 hidden z-40 flex items-center justify-center">
  <div class="bg-white rounded-lg p-6 flex items-center">
    <i class="fas fa-spinner fa-spin text-blue-600 text-2xl mr-3"></i>
    <span class="text-gray-700">Đang xử lý...</span>
  </div>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Image upload functionality - Fixed version
    const addImageButton = document.getElementById('addImageButton');
    const uploadForm = document.getElementById('uploadForm');
    const cancelUploadButton = document.getElementById('cancelUploadButton');
    const imageUploadForm = document.getElementById('imageUploadForm');
    const imageFile = document.getElementById('imageFile');
    const selectedFileName = document.getElementById('selectedFileName');

    addImageButton.addEventListener('click', function() {
      uploadForm.classList.remove('hidden');
      addImageButton.classList.add('hidden');
    });

    cancelUploadButton.addEventListener('click', function() {
      resetUploadForm();
    });

    imageFile.addEventListener('change', function() {
      const file = this.files[0];
      const selectedFileName = document.getElementById('selectedFileName');

      // Xóa preview cũ (nếu có)
      const existingPreview = selectedFileName.nextElementSibling;
      if (existingPreview && existingPreview.className.includes('preview-img')) {
        existingPreview.remove();
      }

      if (file) {
        // Hiển thị tên và kích thước file
        const fileName = file.name;
        const fileSize = (file.size / 1024 / 1024).toFixed(2);
        selectedFileName.textContent = `Đã chọn: ${fileName} (${fileSize} MB)`;
        selectedFileName.classList.remove('hidden');
        selectedFileName.classList.remove('text-red-600');

        // Kiểm tra định dạng file
        if (!file.type.match('image.*')) {
          selectedFileName.textContent = `Lỗi: Vui lòng chọn file ảnh (PNG, JPG, JPEG)`;
          selectedFileName.classList.add('text-red-600');
          return;
        }

        // Kiểm tra kích thước file
        if (file.size > 5 * 1024 * 1024) {
          selectedFileName.textContent = `Lỗi: File quá lớn (${fileSize} MB). Vui lòng chọn file nhỏ hơn 5MB`;
          selectedFileName.classList.add('text-red-600');
          return;
        }

        // Tạo preview ảnh
        const reader = new FileReader();
        reader.onload = function(e) {
          const previewImg = document.createElement('img');
          previewImg.src = e.target.result;
          previewImg.className = 'preview-img mt-2 max-w-xs max-h-32 rounded shadow object-cover';
          previewImg.alt = 'Ảnh xem trước';
          selectedFileName.parentNode.appendChild(previewImg);
        };
        reader.readAsDataURL(file);
      } else {
        selectedFileName.classList.add('hidden');
        selectedFileName.textContent = '';
      }
    });

    imageUploadForm.addEventListener('submit', function(e) {
      e.preventDefault();

      const file = imageFile.files[0];
      if (!file) {
        alert('Vui lòng chọn hình ảnh!');
        return;
      }

      if (file.size > 5 * 1024 * 1024) {
        alert('Kích thước file không được vượt quá 5MB!');
        return;
      }

      // Kiểm tra định dạng file
      if (!file.type.match('image.*')) {
        alert('Vui lòng chọn file ảnh (PNG, JPG, JPEG)!');
        return;
      }

      const caption = document.getElementById('caption').value.trim();
      const locationId = document.getElementById('locationIdInput').value;

      // Validate locationId
      if (!locationId) {
        alert('Không tìm thấy ID địa điểm!');
        return;
      }

      // Show loading
      document.getElementById('loadingOverlay').classList.remove('hidden');

      // Tạo FormData và log để debug
      const formData = new FormData();
      formData.append('file', file);
      formData.append('caption', caption);
      formData.append('filename', file.name);
      formData.append('locationId', locationId);

      // Debug log
      console.log('=== UPLOAD DEBUG ===');
      console.log('File:', file);
      console.log('File name:', file.name);
      console.log('File size:', file.size);
      console.log('File type:', file.type);
      console.log('Caption:', caption);
      console.log('Location ID:', locationId);

      // Upload image API call
      fetch('/image', {
        method: 'POST',
        body: formData
        // Không set Content-Type header, để browser tự động set với boundary
      })
              .then(data => {
                console.log('Response data:', data);
                document.getElementById('loadingOverlay').classList.add('hidden');

                if (data.success) {
                  showMessage('Tải lên hình ảnh thành công!', 'success');
                  resetUploadForm();
                  // Reload page to show new image
                  setTimeout(() => {
                    window.location.reload();
                  }, 1500);
                } else {
                  showMessage(data.message || 'Có lỗi xảy ra khi tải lên!', 'error');
                }
              })
              .catch(error => {
                document.getElementById('loadingOverlay').classList.add('hidden');
                console.error('Upload error:', error);
                showMessage('Có lỗi xảy ra khi tải lên hình ảnh: ' + error.message, 'error');
              });
    });

    function resetUploadForm() {
      uploadForm.classList.add('hidden');
      addImageButton.classList.remove('hidden');
      imageUploadForm.reset();
      selectedFileName.classList.add('hidden');
      selectedFileName.classList.remove('text-red-600');

      // Remove preview image
      const existingPreview = selectedFileName.nextElementSibling;
      if (existingPreview && existingPreview.className.includes('preview-img')) {
        existingPreview.remove();
      }
    }

// Utility function to show messages
    function showMessage(message, type = 'info') {
      const messageDiv = document.createElement('div');
      messageDiv.className = `fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50 ${
    type == 'success' ? 'bg-green-500 text-white' :
    type == 'error' ? 'bg-red-500 text-white' :
    'bg-blue-500 text-white'
  }`;
      messageDiv.innerHTML = `
    <div class="flex items-center">
      <i class="fas fa-${type == 'success' ? 'check' : type == 'error' ? 'exclamation' : 'info'} mr-2"></i>
      ${message}
    </div>
  `;

      document.body.appendChild(messageDiv);

      setTimeout(() => {
        messageDiv.remove();
      }, 5000);
    }
  });

  // Thêm JavaScript này vào cuối thẻ <script> hiện tại trong file JSP của bạn

  // Edit/Update functionality for title and description
  const editButton = document.getElementById('editButton');
  const saveButton = document.getElementById('saveButton');
  const cancelButton = document.getElementById('cancelButton');
  const titleDisplay = document.getElementById('titleDisplay');
  const titleEdit = document.getElementById('titleEdit');
  const titleInput = document.getElementById('titleInput');
  const descriptionDisplay = document.getElementById('descriptionDisplay');
  const descriptionEdit = document.getElementById('descriptionEdit');
  const descriptionInput = document.getElementById('descriptionInput');
  const locationTitle = document.getElementById('locationTitle');
  const locationDescription = document.getElementById('locationDescription');

  // Store original values for cancel functionality
  let originalTitle = titleInput.value;
  let originalDescription = descriptionInput.value;

  // Edit button click handler
  editButton.addEventListener('click', function() {
    // Store current values as original
    originalTitle = titleInput.value;
    originalDescription = descriptionInput.value;

    // Switch to edit mode
    enterEditMode();
  });

  // Save button click handler
  saveButton.addEventListener('click', function() {
    const newTitle = titleInput.value.trim();
    const newDescription = descriptionInput.value.trim();
    const locationId = document.getElementById('locationIdInput').value;

    // Validation
    if (!newTitle) {
      showMessage('Tiêu đề không được để trống!', 'error');
      return;
    }

    if (!locationId) {
      showMessage('Không tìm thấy ID địa điểm!', 'error');
      return;
    }

    // Show loading
    document.getElementById('loadingOverlay').classList.remove('hidden');

    // Prepare data for API call as FormData
    const formData = new FormData();
    formData.append('title', newTitle);
    formData.append('description', newDescription);

    console.log('=== UPDATE DEBUG ===');
    console.log('Location ID:', locationId);
    console.log('Title:', newTitle);
    console.log('Description:', newDescription);

    // Call update API
    fetch('/location/' + locationId, {
      method: 'PUT',
      body: formData
    })
            .then(response => {
              if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
              }
              return response.json();
            })
            .then(data => {
              document.getElementById('loadingOverlay').classList.add('hidden');

              console.log('Update response:', data);

              if (data.success) {
                // Update displayed values
                locationTitle.textContent = newTitle;
                locationDescription.textContent = newDescription || 'Chưa có mô tả';

                // Update original values
                originalTitle = newTitle;
                originalDescription = newDescription;

                // Exit edit mode
                exitEditMode();

                showMessage('Cập nhật thông tin thành công!', 'success');
              } else {
                showMessage(data.message || 'Có lỗi xảy ra khi cập nhật!', 'error');
              }
            })
            .catch(error => {
              document.getElementById('loadingOverlay').classList.add('hidden');
              console.error('Update error:', error);
              showMessage('Có lỗi xảy ra khi cập nhật: ' + error.message, 'error');
            });
  });

  // Cancel button click handler
  cancelButton.addEventListener('click', function() {
    // Restore original values
    titleInput.value = originalTitle;
    descriptionInput.value = originalDescription;

    // Exit edit mode
    exitEditMode();

    showMessage('Đã hủy chỉnh sửa', 'info');
  });

  // Helper functions
  function enterEditMode() {
    // Hide display elements
    titleDisplay.classList.add('hidden');
    descriptionDisplay.classList.add('hidden');

    // Show edit elements
    titleEdit.classList.remove('hidden');
    descriptionEdit.classList.remove('hidden');

    // Hide edit button, show save/cancel buttons
    editButton.classList.add('hidden');
    saveButton.classList.remove('hidden');
    cancelButton.classList.remove('hidden');

    // Focus on title input
    titleInput.focus();
    titleInput.select();
  }

  function exitEditMode() {
    // Show display elements
    titleDisplay.classList.remove('hidden');
    descriptionDisplay.classList.remove('hidden');

    // Hide edit elements
    titleEdit.classList.add('hidden');
    descriptionEdit.classList.add('hidden');

    // Show edit button, hide save/cancel buttons
    editButton.classList.remove('hidden');
    saveButton.classList.add('hidden');
    cancelButton.classList.add('hidden');
  }

  // Keyboard shortcuts for edit mode
  document.addEventListener('keydown', function(e) {
    // Only handle shortcuts when in edit mode
    if (!titleEdit.classList.contains('hidden')) {
      if (e.key === 'Escape') {
        e.preventDefault();
        cancelButton.click();
      } else if (e.key === 'Enter' && e.ctrlKey) {
        e.preventDefault();
        saveButton.click();
      }
    }
  });

  // Auto-resize textarea
  descriptionInput.addEventListener('input', function() {
    this.style.height = 'auto';
    this.style.height = this.scrollHeight + 'px';
  });

  // Enhance the existing showMessage function if needed
  if (typeof showMessage === 'undefined') {
    function showMessage(message, type = 'info') {
      const messageDiv = document.createElement('div');
      messageDiv.className = `fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50 transition-all duration-300 ${
      type == 'success' ? 'bg-green-500 text-white' :
      type == 'error' ? 'bg-red-500 text-white' :
      type == 'warning' ? 'bg-yellow-500 text-white' :
      'bg-blue-500 text-white'
    }`;

      messageDiv.innerHTML = `
      <div class="flex items-center">
        <i class="fas fa-${
          type == 'success' ? 'check-circle' :
          type == 'error' ? 'exclamation-triangle' :
          type == 'warning' ? 'exclamation-circle' :
          'info-circle'
        } mr-2"></i>
        <span>${message}</span>
        <button onclick="this.parentElement.parentElement.remove()" class="ml-4 text-white hover:text-gray-200">
          <i class="fas fa-times"></i>
        </button>
      </div>
    `;

      document.body.appendChild(messageDiv);

      // Auto remove after 5 seconds
      setTimeout(() => {
        if (messageDiv.parentNode) {
          messageDiv.style.opacity = '0';
          messageDiv.style.transform = 'translateX(100%)';
          setTimeout(() => {
            messageDiv.remove();
          }, 300);
        }
      }, 5000);
    }
  }
  // Delete image functionality
  document.addEventListener('click', function(e) {
    if (e.target.closest('.delete-image-btn')) {
      const deleteBtn = e.target.closest('.delete-image-btn');
      const imageId = deleteBtn.getAttribute('data-image-id');

      if (!imageId) {
        showMessage('Không tìm thấy ID hình ảnh!', 'error');
        return;
      }

      // Confirm deletion
      if (confirm('Bạn có chắc chắn muốn xóa hình ảnh này không?')) {
        deleteImage(imageId);
      }
    }
  });

  // Delete image function
  function deleteImage(imageId) {
    console.log('=== DELETE IMAGE DEBUG ===');
    console.log('Image ID:', imageId);

    // Show loading
    document.getElementById('loadingOverlay').classList.remove('hidden');

    // Call delete API
    fetch(`/image/`+imageId, {
      method: 'DELETE',
    })
            .then(response => {
              console.log('Delete response status:', response.status);

              if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
              }

              // Check if response has content
              const contentType = response.headers.get('content-type');
              if (contentType && contentType.includes('application/json')) {
                return response.json();
              } else {
                // If no JSON response, assume success
                return { success: true, message: 'Xóa hình ảnh thành công!' };
              }
            })
            .then(data => {
              document.getElementById('loadingOverlay').classList.add('hidden');

              console.log('Delete response data:', data);

              if (data.success !== false) { // Treat as success if not explicitly false
                // Remove image from DOM
                const imageElement = document.querySelector(`[data-image-id="${imageId}"]`);
                if (imageElement) {
                  imageElement.style.opacity = '0';
                  imageElement.style.transform = 'scale(0.8)';

                  setTimeout(() => {
                    imageElement.remove();

                    // Check if gallery is now empty
                    const remainingImages = document.querySelectorAll('#imageGallery [data-image-id]');
                    if (remainingImages.length === 0) {
                      const gallery = document.getElementById('imageGallery');
                      gallery.innerHTML = '<p class="text-gray-500">Chưa có hình ảnh nào.</p>';

                      // Hide navigation buttons if they exist
                      const prevBtn = document.getElementById('prevButton');
                      const nextBtn = document.getElementById('nextButton');
                      if (prevBtn) prevBtn.style.display = 'none';
                      if (nextBtn) nextBtn.style.display = 'none';
                    }
                  }, 300);
                }

                showMessage(data.message || 'Xóa hình ảnh thành công!', 'success');
              } else {
                showMessage(data.message || 'Có lỗi xảy ra khi xóa hình ảnh!', 'error');
              }
            })
            .catch(error => {
              document.getElementById('loadingOverlay').classList.add('hidden');
              console.error('Delete error:', error);

              // Handle different types of errors
              let errorMessage = 'Có lỗi xảy ra khi xóa hình ảnh!';

              if (error.message.includes('404')) {
                errorMessage = 'Không tìm thấy hình ảnh cần xóa!';
              } else if (error.message.includes('403')) {
                errorMessage = 'Bạn không có quyền xóa hình ảnh này!';
              } else if (error.message.includes('500')) {
                errorMessage = 'Lỗi server khi xóa hình ảnh!';
              }

              showMessage(errorMessage, 'error');
            });
  }

  // Enhance delete button hover effects
  document.addEventListener('DOMContentLoaded', function() {
    // Add hover effects for delete buttons
    const style = document.createElement('style');
    style.textContent = `
    .delete-image-btn {
      transition: all 0.2s ease;
    }

    .delete-image-btn:hover {
      transform: scale(1.1);
      box-shadow: 0 2px 8px rgba(239, 68, 68, 0.4);
    }

    .delete-image-btn:active {
      transform: scale(0.95);
    }

    /* Animation for image removal */
    .image-removing {
      transition: opacity 0.3s ease, transform 0.3s ease;
    }
  `;
    document.head.appendChild(style);
  });

  // Optional: Add keyboard shortcut for deletion when image is focused
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Delete' || e.key === 'Backspace') {
      const focusedImage = document.activeElement;
      if (focusedImage && focusedImage.closest('[data-image-id]')) {
        e.preventDefault();
        const imageContainer = focusedImage.closest('[data-image-id]');
        const deleteBtn = imageContainer.querySelector('.delete-image-btn');
        if (deleteBtn) {
          deleteBtn.click();
        }
      }
    }
  });
</script>