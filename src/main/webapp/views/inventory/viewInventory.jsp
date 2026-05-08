<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--@elvariable id="successMsg" type="java.lang.String"--%>
<%--@elvariable id="stackSize" type="java.lang.Integer"--%>
<%--@elvariable id="stackTop" type="com.inventory.model.Item"--%>
<%--@elvariable id="items" type="java.util.List"--%>
<c:set var="activePage" value="inventory" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inventory — InvenTrack</title>
  <!--suppress HtmlUnknownTarget -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!--suppress HtmlUnknownTarget -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
    .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto; z-index: 100; }
    .main-content  { margin-left: 260px; padding: 2.5rem; }
    .card-custom { border-radius: 16px; border: none; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03); }
    .table-custom th { text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; color: #64748b; background-color: #f1f5f9; border-bottom: none; padding: 1rem; }
    .table-custom td { padding: 1rem; vertical-align: middle; border-bottom: 1px solid #e2e8f0; color: #334155; }
    .btn-action { width: 32px; height: 32px; padding: 0; display: inline-flex; align-items: center; justify-content: center; border-radius: 8px; transition: all 0.2s; }
    .btn-action:hover { transform: translateY(-2px); }
  </style>
</head>
<body>
<div class="d-flex">
  <jsp:include page="/views/common/sidebar.jsp"/>

  <div class="main-content flex-grow-1">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="fw-bold mb-1" style="color: #0f172a;">Inventory Management</h2>
        <p class="text-muted mb-0">Component 01 — View and manage all stock items</p>
      </div>
      <c:if test="${sessionScope.role == 'admin'}">
        <a href="${pageContext.request.contextPath}/addStock" class="btn btn-primary px-4 py-2" style="background-color: #4f46e5; border-color: #4f46e5; border-radius: 10px; font-weight: 500;">
          <i class="bi bi-plus-lg me-2"></i>Add Stock
        </a>
      </c:if>
    </div>

    <%-- Flash messages --%>
    <c:if test="${not empty successMsg}">
      <div class="alert alert-success alert-dismissible fade show border-0 rounded-3 shadow-sm">
        <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <%-- Stack Status (admin only) --%>
    <c:if test="${sessionScope.role == 'admin'}">
      <div class="card card-custom mb-4 border-start border-4" style="border-left-color: #f59e0b !important;">
        <div class="card-body p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
          <div>
            <h6 class="fw-bold text-uppercase mb-2" style="color: #b45309; font-size: 0.8rem; letter-spacing: 0.05em;">
              <i class="bi bi-stack me-2"></i>Stack (LIFO) Status
            </h6>
            <div class="d-flex align-items-center">
              <span class="text-secondary me-3">Items in stack: <strong class="text-dark fs-5">${stackSize}</strong></span>
              <c:choose>
                <c:when test="${not empty stackTop}">
                  <span class="text-secondary">Top item: </span>
                  <span class="badge ms-2 px-2 py-1" style="background-color: #fee2e2; color: #b91c1c;">${stackTop.name}</span>
                  <code class="ms-2 px-2 py-1 rounded" style="background-color: #f1f5f9; color: #475569;">${stackTop.id}</code>
                </c:when>
                <c:otherwise><span class="text-muted fst-italic">Stack is empty</span></c:otherwise>
              </c:choose>
            </div>
          </div>
            <%-- LIFO Delete button --%>
          <form action="${pageContext.request.contextPath}/deleteStock" method="post"
                onsubmit="return confirm('Delete the most recently added item (LIFO pop)?');">
            <input type="hidden" name="mode" value="last">
            <button type="submit" class="btn btn-danger px-4" style="border-radius: 10px; font-weight: 500;"
              ${empty stackTop ? 'disabled' : ''}>
              <i class="bi bi-backspace-reverse me-2"></i>Delete Last Added (Pop)
            </button>
          </form>
        </div>
      </div>
    </c:if>

    <%-- Inventory Table --%>
    <div class="card card-custom">
      <div class="card-header bg-transparent border-0 pt-4 pb-3 px-4 d-flex justify-content-between align-items-center">
        <h5 class="fw-bold mb-0" style="color: #0f172a;">
          <i class="bi bi-box-seam me-2 text-primary"></i>Stock Items <span class="badge rounded-pill ms-2" style="background-color: #e2e8f0; color: #475569;">${items.size()} total</span>
        </h5>
        <a href="${pageContext.request.contextPath}/expiryManagement" class="btn btn-sm" style="background-color: #fff7ed; color: #ea580c; border: 1px solid #ffedd5; font-weight: 500;">
          <i class="bi bi-sort-numeric-down me-1"></i>Sort by Expiry
        </a>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-custom align-middle mb-0">
            <thead>
            <tr>
              <th class="ps-4">Item ID</th>
              <th>Name</th>
              <th>Category</th>
              <th>Quantity</th>
              <th>Unit Price</th>
              <th>Expiry Date</th>
              <c:if test="${sessionScope.role == 'admin'}">
                <th class="text-center pe-4">Actions</th>
              </c:if>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${items}">
              <tr>
                <td class="ps-4"><code class="px-2 py-1 rounded" style="background-color: #f1f5f9; color: #64748b;">${item.id}</code></td>
                <td class="fw-bold text-dark">${item.name}</td>
                <td><span class="badge rounded-pill" style="background-color: #f1f5f9; color: #475569;">${item.category}</span></td>
                <td>
                  <c:choose>
                    <c:when test="${item.quantity < 10}">
                      <span class="badge rounded-pill bg-danger-subtle text-danger px-3 py-2"><i class="bi bi-exclamation-circle me-1"></i>${item.quantity}</span>
                    </c:when>
                    <c:when test="${item.quantity < 30}">
                      <span class="badge rounded-pill bg-warning-subtle text-warning-emphasis px-3 py-2">${item.quantity}</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge rounded-pill bg-success-subtle text-success px-3 py-2">${item.quantity}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="fw-medium text-dark">$<fmt:formatNumber value="${item.price}" maxFractionDigits="2"/></td>
                <td>
                  <span class="text-secondary"><i class="bi bi-calendar3 me-2 small text-muted"></i>${item.expiryDate}</span>
                </td>
                <c:if test="${sessionScope.role == 'admin'}">
                  <td class="text-center pe-4">
                    <div class="d-flex justify-content-center gap-2">
                      <a href="${pageContext.request.contextPath}/editStock?id=${item.id}"
                         class="btn btn-action btn-outline-primary" title="Edit">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <form action="${pageContext.request.contextPath}/deleteStock"
                            method="post" class="d-inline"
                            onsubmit="return confirm('Delete ${item.name}?');">
                        <input type="hidden" name="mode"   value="byId">
                        <input type="hidden" name="itemId" value="${item.id}">
                        <button type="submit" class="btn btn-action btn-outline-danger" title="Delete">
                          <i class="bi bi-trash3"></i>
                        </button>
                      </form>
                    </div>
                  </td>
                </c:if>
              </tr>
            </c:forEach>
            <c:if test="${empty items}">
              <tr>
                <td colspan="7" class="text-center text-muted py-5">
                  <div class="mb-3"><i class="bi bi-inbox fs-1 text-black-50 opacity-25"></i></div>
                  <h6 class="fw-medium text-dark mb-1">No items found</h6>
                  <p class="small mb-0">Your inventory is currently empty. <a href="${pageContext.request.contextPath}/addStock" class="text-primary text-decoration-none fw-medium">Add some stock</a> to get started.</p>
                </td>
              </tr>
            </c:if>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
<!--suppress HtmlUnknownTarget -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>