<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="stackSize" type="java.lang.Integer"--%>
<%--@elvariable id="stackTop" type="com.inventory.model.Item"--%>
<%--@elvariable id="error" type="java.lang.String"--%>
<c:set var="activePage" value="addStock" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Stock — InvenTrack</title>
  <!--suppress HtmlUnknownTarget -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!--suppress HtmlUnknownTarget -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
    .main-content  { margin-left: 260px; padding: 2.5rem; }
    .card-custom { border-radius: 16px; border: none; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03); }
    .form-control, .form-select { border-radius: 10px; padding: 0.75rem 1rem; background-color: #f8fafc; border: 1px solid #e2e8f0; }
    .form-control:focus, .form-select:focus { box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1); border-color: #4f46e5; background-color: #ffffff; }
    .btn-primary { background-color: #4f46e5; border-color: #4f46e5; border-radius: 10px; font-weight: 500; padding: 0.75rem 1.5rem; }
    .btn-primary:hover { background-color: #4338ca; border-color: #4338ca; }
    .btn-outline-secondary { border-radius: 10px; font-weight: 500; padding: 0.75rem 1.5rem; }
  </style>
</head>
<body>
<div class="d-flex">
  <jsp:include page="/views/common/sidebar.jsp"/>

  <div class="main-content flex-grow-1">
    <h2 class="fw-bold mb-1" style="color: #0f172a;">Add Stock</h2>
    <p class="text-muted mb-4">Component 01 — New items are pushed onto the LIFO Stack.</p>

    <%-- Stack Status Card --%>
    <div class="card card-custom mb-4 border-start border-4" style="border-left-color: #4f46e5 !important;">
      <div class="card-body p-4">
        <h6 class="fw-bold text-uppercase mb-2" style="color: #3730a3; font-size: 0.8rem; letter-spacing: 0.05em;">
          <i class="bi bi-stack me-2"></i>Stack Status (LIFO)
        </h6>
        <div class="d-flex align-items-center">
          <span class="text-secondary me-3">Items in stack: <strong class="text-dark fs-5">${stackSize}</strong></span>
          <c:choose>
            <c:when test="${not empty stackTop}">
              <span class="text-secondary">Top item: </span>
              <span class="badge ms-2 px-2 py-1" style="background-color: #fee2e2; color: #b91c1c;">${stackTop.name}</span>
              <code class="ms-2 px-2 py-1 rounded" style="background-color: #f1f5f9; color: #475569;">${stackTop.id}</code>
            </c:when>
            <c:otherwise><span class="text-muted fst-italic">Stack is empty.</span></c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <%-- Error Alert --%>
    <c:if test="${not empty error}">
      <div class="alert alert-danger border-0 rounded-3 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
    </c:if>

    <%-- Add Item Form --%>
    <div class="card card-custom">
      <div class="card-header bg-transparent border-0 pt-4 pb-0 px-4">
        <h5 class="fw-bold mb-0" style="color: #0f172a;"><i class="bi bi-plus-square-fill me-2" style="color: #4f46e5;"></i>New Inventory Item</h5>
      </div>
      <div class="card-body p-4">
        <form action="${pageContext.request.contextPath}/addStock" method="post">
          <div class="row g-4">
            <div class="col-md-6">
              <label for="name" class="form-label fw-semibold text-dark">Item Name <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="name" name="name"
                     placeholder="e.g. Paracetamol 500mg" required>
            </div>
            <div class="col-md-6">
              <label for="category" class="form-label fw-semibold text-dark">Category <span class="text-danger">*</span></label>
              <select class="form-select" id="category" name="category" required>
                <option value="" disabled selected>Select category</option>
                <option value="Medicine">Medicine</option>
                <option value="Food">Food</option>
                <option value="Electronics">Electronics</option>
                <option value="Clothing">Clothing</option>
                <option value="Beverages">Beverages</option>
                <option value="Other">Other</option>
              </select>
            </div>
            <div class="col-md-4">
              <label for="quantity" class="form-label fw-semibold text-dark">Quantity <span class="text-danger">*</span></label>
              <input type="number" class="form-control" id="quantity" name="quantity"
                     min="1" placeholder="e.g. 100" required>
            </div>
            <div class="col-md-4">
              <label for="price" class="form-label fw-semibold text-dark">Unit Price ($) <span class="text-danger">*</span></label>
              <input type="number" class="form-control" id="price" name="price"
                     step="0.01" min="0" placeholder="e.g. 9.99" required>
            </div>
            <div class="col-md-4">
              <label for="expiryDate" class="form-label fw-semibold text-dark">Expiry Date <span class="text-danger">*</span></label>
              <input type="date" class="form-control" id="expiryDate" name="expiryDate" required>
            </div>
            <div class="col-12 mt-3 pt-3 border-top">
              <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1">
                  <i class="bi bi-plus-circle me-2"></i>Add Item (Push to Stack)
                </button>
                <a href="${pageContext.request.contextPath}/viewInventory"
                   class="btn btn-outline-secondary px-4">Cancel</a>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>

    <%-- OOP Info Box --%>
    <div class="alert alert-info border-0 rounded-3 shadow-sm mt-4 d-flex align-items-start" style="background-color: #eff6ff; color: #1e3a8a;">
      <i class="bi bi-lightbulb fs-4 me-3 mt-1" style="color: #3b82f6;"></i>
      <div>
        <h6 class="fw-bold mb-2">OOP Concepts in Action</h6>
        <ul class="mb-0 small ps-3">
          <li class="mb-1"><strong>Encapsulation:</strong> Item fields are private; accessed via getters/setters.</li>
          <li class="mb-1"><strong>Abstraction:</strong> AddStockServlet delegates to InventoryService which hides Stack &amp; FileHandler details.</li>
          <li><strong>Stack (LIFO):</strong> Each submission calls <code>stack.push(item)</code> — the item is placed on top of the stack.</li>
        </ul>
      </div>
    </div>
  </div>
</div>
<!--suppress HtmlUnknownTarget -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>