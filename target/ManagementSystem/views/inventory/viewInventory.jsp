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
  <style>
    body { background-color: #f0f2f5; }
    .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto; z-index: 100; }
    .main-content  { margin-left: 250px; padding: 2rem; }
  </style>
</head>
<body>
<div class="d-flex">
  <jsp:include page="/views/common/sidebar.jsp"/>

  <div class="main-content flex-grow-1">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <div>
        <h2 class="fw-bold mb-0">Inventory</h2>
        <p class="text-muted">Component 01 — All stock items</p>
      </div>
      <c:if test="${sessionScope.role == 'admin'}">
        <a href="${pageContext.request.contextPath}/addStock" class="btn btn-primary">
          <i class="bi bi-plus-circle me-2"></i>Add Stock
        </a>
      </c:if>
    </div>

    <%-- Flash messages --%>
    <c:if test="${not empty successMsg}">
      <div class="alert alert-success alert-dismissible fade show">
        <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    </c:if>

    <%-- Stack Status (admin only) --%>
    <c:if test="${sessionScope.role == 'admin'}">
      <div class="card border-0 shadow-sm mb-4 border-start border-4 border-warning">
        <div class="card-body d-flex justify-content-between align-items-center flex-wrap gap-3">
          <div>
            <h6 class="fw-semibold text-warning mb-1"><i class="bi bi-stack me-2"></i>Stack (LIFO) Status</h6>
            <p class="mb-0 small">
              Items in stack: <strong>${stackSize}</strong> &nbsp;|&nbsp;
              <c:choose>
                <c:when test="${not empty stackTop}">
                  Top: <span class="badge bg-danger">${stackTop.name}</span>
                  <code class="ms-1">${stackTop.id}</code>
                </c:when>
                <c:otherwise><span class="text-muted">Stack is empty</span></c:otherwise>
              </c:choose>
            </p>
          </div>
            <%-- LIFO Delete button — calls stack.pop() --%>
          <form action="${pageContext.request.contextPath}/deleteStock" method="post"
                onsubmit="return confirm('Delete the most recently added item (LIFO pop)?');">
            <input type="hidden" name="mode" value="last">
            <button type="submit" class="btn btn-danger btn-sm"
              ${empty stackTop ? 'disabled' : ''}>
              <i class="bi bi-stack-overflow me-1"></i>Delete Last Added (Stack Pop)
            </button>
          </form>
        </div>
      </div>
    </c:if>

    <%-- Inventory Table --%>
    <div class="card border-0 shadow-sm">
      <div class="card-header bg-white d-flex justify-content-between align-items-center">
        <span class="fw-semibold"><i class="bi bi-table me-2"></i>Stock Items (${items.size()} total)</span>
        <a href="${pageContext.request.contextPath}/expiryManagement" class="btn btn-sm btn-outline-warning">
          <i class="bi bi-sort-numeric-up me-1"></i>Sort by Expiry (MergeSort)
        </a>
      </div>
      <div class="card-body p-0">
        <div class="table-responsive">
          <table class="table table-hover align-middle mb-0">
            <thead class="table-dark">
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Category</th>
              <th>Quantity</th>
              <th>Unit Price</th>
              <th>Expiry Date</th>
              <c:if test="${sessionScope.role == 'admin'}">
                <th class="text-center">Actions</th>
              </c:if>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${items}">
              <tr>
                <td><code class="small">${item.id}</code></td>
                <td class="fw-semibold">${item.name}</td>
                <td><span class="badge bg-secondary">${item.category}</span></td>
                <td>
                  <c:choose>
                    <c:when test="${item.quantity < 10}">
                      <span class="badge bg-danger">${item.quantity} ⚠ Low</span>
                    </c:when>
                    <c:when test="${item.quantity < 30}">
                      <span class="badge bg-warning text-dark">${item.quantity}</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge bg-success">${item.quantity}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>$<fmt:formatNumber value="${item.price}" maxFractionDigits="2"/></td>
                <td>${item.expiryDate}</td>
                <c:if test="${sessionScope.role == 'admin'}">
                  <td class="text-center">
                    <a href="${pageContext.request.contextPath}/editStock?id=${item.id}"
                       class="btn btn-sm btn-outline-primary me-1">
                      <i class="bi bi-pencil"></i>
                    </a>
                    <form action="${pageContext.request.contextPath}/deleteStock"
                          method="post" class="d-inline"
                          onsubmit="return confirm('Delete ${item.name}?');">
                      <input type="hidden" name="mode"   value="byId">
                      <input type="hidden" name="itemId" value="${item.id}">
                      <button type="submit" class="btn btn-sm btn-outline-danger">
                        <i class="bi bi-trash"></i>
                      </button>
                    </form>
                  </td>
                </c:if>
              </tr>
            </c:forEach>
            <c:if test="${empty items}">
              <tr>
                <td colspan="7" class="text-center text-muted py-4">
                  <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                  No items in inventory. <a href="${pageContext.request.contextPath}/addStock">Add some stock</a>.
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