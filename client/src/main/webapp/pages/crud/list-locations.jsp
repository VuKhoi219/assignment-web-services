<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
<div class="container mx-auto px-4 py-8">
  <div class="bg-white rounded-xl shadow-md overflow-hidden animate-fade-in">
    <!-- Header -->
    <div class="px-6 py-4 bg-gradient-to-r from-blue-500 to-blue-600 text-white">
      <div class="flex flex-col md:flex-row md:items-center md:justify-between">
        <h1 class="text-2xl font-bold">Danh sách dữ liệu</h1>
        <div class="mt-2 md:mt-0">
          <a href="${pageContext.request.contextPath}/crud?action=create"
             class="bg-white text-blue-600 px-4 py-2 rounded-lg font-medium hover:bg-blue-50 btn-transition">
            <i class="fas fa-plus mr-2"></i>Thêm mới
          </a>
        </div>
      </div>
    </div>

    <!-- Filter section -->
    <div class="px-6 py-4 border-b">
      <div class="flex flex-col md:flex-row md:items-center md:space-x-4 space-y-2 md:space-y-0">
        <div class="flex-1">
          <label for="search" class="block text-sm font-medium text-gray-700 mb-1">Tìm kiếm</label>
          <div class="relative">
            <input type="text" id="search" placeholder="Nhập từ khoá..."
                   class="w-full pl-10 pr-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
          </div>
        </div>
<%--        <div>--%>
<%--          <label for="filter" class="block text-sm font-medium text-gray-700 mb-1"></label>--%>
<%--          <select id="filter" class="w-full md:w-40 px-4 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500">--%>
<%--          </select>--%>
<%--        </div>--%>
<%--        <div class="self-end">--%>
<%--          <button id="filterBtn" class="bg-blue-500 text-white px-4 py-2 rounded-lg font-medium hover:bg-blue-600 btn-transition">--%>
<%--            <i class="fas fa-filter mr-2"></i>Lọc--%>
<%--          </button>--%>
<%--        </div>--%>
      </div>
    </div>

    <!-- Table -->
    <div class="overflow-x-auto custom-scrollbar">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
        <tr>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">STT</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tiêu đề</th>
          <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Mô tả</th>
          <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Thao tác</th>
        </tr>
        </thead>
        <tbody id="tableBody" class="bg-white divide-y divide-gray-200">
        <c:forEach items="${locations}" var="item" varStatus="loop">
          <tr class="${loop.index % 2 == 0 ? 'bg-white' : 'bg-gray-50'}">
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${loop.index + 1}</td>
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="text-sm font-medium text-gray-900">${item.title}</div>
            </td>
            <td class="px-6 py-4">
              <div class="text-sm text-gray-500 max-w-xs truncate">${item.description}</div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
              <a href="${pageContext.request.contextPath}/crud/${item.id}?action=detail"
                 class="view-btn text-blue-600 hover:text-blue-900 mr-3 btn-transition" title="Xem chi tiết">
                <i class="fas fa-eye"></i>
              </a>
              <button data-id="${item.id}" class="delete-btn text-red-600 hover:text-red-900 btn-transition" title="Xoá">
                <i class="fas fa-trash"></i>
              </button>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div class="px-6 py-4 border-t flex flex-col md:flex-row items-center justify-between">
      <div class="mb-4 md:mb-0">
        <p class="text-sm text-gray-700">
          Hiển thị <span id="startItem">1</span> đến <span id="endItem">5</span>
          trong <span id="totalItems">${locations.size()}</span> kết quả
        </p>
      </div>
      <div class="flex items-center space-x-2">
        <button id="prevPage" class="px-3 py-1 border rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 btn-transition">
          <i class="fas fa-chevron-left"></i>
        </button>
        <div id="pageNumbers" class="flex space-x-1">
          <!-- Page numbers will be inserted here by JavaScript -->
        </div>
        <button id="nextPage" class="px-3 py-1 border rounded-md text-gray-700 bg-white hover:bg-gray-50 disabled:opacity-50 btn-transition">
          <i class="fas fa-chevron-right"></i>
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Modal (hidden by default) -->
<div id="itemModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
  <div class="bg-white rounded-lg shadow-xl w-full max-w-md mx-4 animate-fade-in">
    <div class="px-6 py-4 border-b flex justify-between items-center">
      <h3 id="modalTitle" class="text-lg font-semibold text-gray-900">Chi tiết mục</h3>
      <button id="closeModal" class="text-gray-400 hover:text-gray-500">
        <i class="fas fa-times"></i>
      </button>
    </div>
    <div class="px-6 py-4">
      <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2">Tiêu đề</label>
        <p id="modalTitleContent" class="text-gray-700">...</p>
      </div>
      <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2">Mô tả</label>
        <p id="modalDescContent" class="text-gray-700">...</p>
      </div>

    </div>
    <div class="px-6 py-4 border-t flex justify-end space-x-3">
      <button id="modalCloseBtn" class="px-4 py-2 border rounded-md text-gray-700 hover:bg-gray-50 btn-transition">
        Đóng
      </button>
    </div>
  </div>
</div>

<!-- Delete confirmation modal -->
<div id="deleteModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
  <div class="bg-white rounded-lg shadow-xl w-full max-w-md mx-4 animate-fade-in">
    <div class="px-6 py-4 border-b flex justify-between items-center">
      <h3 class="text-lg font-semibold text-gray-900">Xác nhận xoá</h3>
      <button id="closeDeleteModal" class="text-gray-400 hover:text-gray-500">
        <i class="fas fa-times"></i>
      </button>
    </div>
    <div class="px-6 py-4">
      <p class="text-gray-700">Bạn có chắc chắn muốn xoá mục này không?</p>
      <p id="deleteItemTitle" class="font-medium mt-2"></p>
    </div>
    <div class="px-6 py-4 border-t flex justify-end space-x-3">
      <button id="cancelDeleteBtn" class="px-4 py-2 border rounded-md text-gray-700 hover:bg-gray-50 btn-transition">
        Huỷ
      </button>
      <button id="confirmDeleteBtn" class="px-4 py-2 bg-red-500 text-white rounded-md hover:bg-red-600 btn-transition">
        Xoá
      </button>
    </div>
  </div>
</div>

<script>
  console.log('sampleData initialization start');
  // Data from JSP
  const sampleData = [
    <c:forEach items="${locations}" var="item" varStatus="loop">
    {
      id: ${item.id},
      title: "${fn:escapeXml(item.title)}",
      description: "${fn:escapeXml(item.description)}",
    }<c:if test="${!loop.last}">,</c:if>
    </c:forEach>
  ] || [];
  console.log('sampleData:', sampleData);

  // DOM elements
  const tableBody = document.getElementById('tableBody');
  const searchInput = document.getElementById('search');
  // const filterBtn = document.getElementById('filterBtn');
  const prevPageBtn = document.getElementById('prevPage');
  const nextPageBtn = document.getElementById('nextPage');
  const pageNumbers = document.getElementById('pageNumbers');
  const startItem = document.getElementById('startItem');
  const endItem = document.getElementById('endItem');
  const totalItems = document.getElementById('totalItems');
  const itemModal = document.getElementById('itemModal');
  const modalTitle = document.getElementById('modalTitle');
  const modalTitleContent = document.getElementById('modalTitleContent');
  const modalDescContent = document.getElementById('modalDescContent');
  const closeModalBtn = document.getElementById('closeModal');
  const modalCloseBtn = document.getElementById('modalCloseBtn');
  const deleteModal = document.getElementById('deleteModal');
  const closeDeleteModal = document.getElementById('closeDeleteModal');
  const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
  const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
  const deleteItemTitle = document.getElementById('deleteItemTitle');

  // Pagination variables
  let currentPage = 1;
  const itemsPerPage = 5;
  let filteredData = [...sampleData];
  let totalPages = Math.ceil(filteredData.length / itemsPerPage);

  // Initialize the table
  function initTable() {
    renderPagination();
    updatePaginationInfo();
  }


  // Render pagination buttons
  function renderPagination() {
    pageNumbers.innerHTML = '';

    if (currentPage > 3) {
      const firstPage = createPageButton(1);
      pageNumbers.appendChild(firstPage);
      if (currentPage > 4) {
        const dots = document.createElement('span');
        dots.className = 'px-3 py-1';
        dots.textContent = '...';
        pageNumbers.appendChild(dots);
      }
    }

    const startPage = Math.max(1, currentPage - 2);
    const endPage = Math.min(totalPages, currentPage + 2);

    for (let i = startPage; i <= endPage; i++) {
      const pageBtn = createPageButton(i);
      if (i === currentPage) {
        pageBtn.classList.add('bg-blue-500', 'text-white');
        pageBtn.classList.remove('hover:bg-gray-50');
      }
      pageNumbers.appendChild(pageBtn);
    }

    if (currentPage < totalPages - 2) {
      if (currentPage < totalPages - 3) {
        const dots = document.createElement('span');
        dots.className = 'px-3 py-1';
        dots.textContent = '...';
        pageNumbers.appendChild(dots);
      }
      const lastPage = createPageButton(totalPages);
      pageNumbers.appendChild(lastPage);
    }

    prevPageBtn.disabled = currentPage === 1;
    nextPageBtn.disabled = currentPage === totalPages;
  }

  function createPageButton(pageNumber) {
    const btn = document.createElement('button');
    btn.className = 'px-3 py-1 border rounded-md text-gray-700 bg-white hover:bg-gray-50 btn-transition';
    btn.textContent = pageNumber;
    btn.addEventListener('click', () => {
      currentPage = pageNumber;
      renderPagination();
      updatePaginationInfo();
    });
    return btn;
  }

  function updatePaginationInfo() {
    const start = (currentPage - 1) * itemsPerPage + 1;
    const end = Math.min(currentPage * itemsPerPage, filteredData.length);
    startItem.textContent = start;
    endItem.textContent = end;
    totalItems.textContent = filteredData.length;
  }

  function filterData() {
    const searchTerm = searchInput.value.toLowerCase();

    filteredData = sampleData.filter(item => {
      const matchesSearch = item.title.toLowerCase().includes(searchTerm) ||
              item.description.toLowerCase().includes(searchTerm);
      return matchesSearch ;
    });

    currentPage = 1;
    totalPages = Math.ceil(filteredData.length / itemsPerPage);
    renderPagination();
    updatePaginationInfo();
  }

  function showDeleteModal(id) {
    const item = sampleData.find(item => item.id === parseInt(id));
    if (item) {
      deleteItemTitle.textContent = item.title;
      deleteModal.classList.remove('hidden');
      confirmDeleteBtn.setAttribute('data-id', id);
    }
  }

  function deleteItem(id) {
    // Send AJAX request to delete
    fetch(`${pageContext.request.contextPath}/location/` + id, {
      method: 'DELETE'
    }).then(response => {
      if (response.ok) {
        sampleData.splice(sampleData.findIndex(item => item.id === parseInt(id)), 1);
        filterData();
        deleteModal.classList.add('hidden');
      } else {
        alert('Có lỗi xảy ra khi xóa item');
      }
    }).catch(error => {
      console.error('Error deleting item:', error);
      alert('Có lỗi xảy ra khi xóa item');
    });
  }

  // // Event listeners
  // filterBtn.addEventListener('click', filterData);
  // searchInput.addEventListener('keyup', (e) => {
  //   if (e.key === 'Enter') {
  //     filterData();
  //   }
  // });

  prevPageBtn.addEventListener('click', () => {
    if (currentPage > 1) {
      currentPage--;
      renderPagination();
      updatePaginationInfo();
    }
  });

  nextPageBtn.addEventListener('click', () => {
    if (currentPage < totalPages) {
      currentPage++;
      renderPagination();
      updatePaginationInfo();
    }
  });

  closeModalBtn.addEventListener('click', () => {
    itemModal.classList.add('hidden');
  });

  modalCloseBtn.addEventListener('click', () => {
    itemModal.classList.add('hidden');
  });

  closeDeleteModal.addEventListener('click', () => {
    deleteModal.classList.add('hidden');
  });

  cancelDeleteBtn.addEventListener('click', () => {
    deleteModal.classList.add('hidden');
  });

  confirmDeleteBtn.addEventListener('click', () => {
    const id = confirmDeleteBtn.getAttribute('data-id');
    console.log(id)
    deleteItem(id);
  });

  window.addEventListener('click', (e) => {
    if (e.target === itemModal) {
      itemModal.classList.add('hidden');
    }
    if (e.target === deleteModal) {
      deleteModal.classList.add('hidden');
    }
  });
  // Thêm vào cuối script
  document.querySelectorAll('.delete-btn').forEach(btn => {
    btn.addEventListener('click', function(e) {
      e.preventDefault();
      const id = this.getAttribute('data-id');
      showDeleteModal(id);
    });
  });
  // Initialize the table on load
  document.addEventListener('DOMContentLoaded', initTable);
</script>