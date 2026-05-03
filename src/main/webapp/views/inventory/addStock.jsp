<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activePage" value="addStock" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Stock — InvenTrack</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
    <h2 class="fw-bold mb-1">Add Stock</h2>
    <p class="text-muted mb-4">Component 01 — New items are pushed onto the LIFO Stack.</p>

    <%-- Stack Status Card --%>
    <div class="card border-0 shadow-sm mb-4 border-start border-4 border-primary">
      <div class="card-body">
        <h6 class="fw-semibold text-primary"><i class="bi bi-stack me-2"></i>Stack Status (LIFO)</h6>
        <p class="mb-1">Items in stack: <strong>${stackSize}</strong></p>
        <c:choose>
          <c:when test="${not empty stackTop}">
            <p class="mb-0">Top of stack (next to be deleted):
              <span class="badge bg-danger fs-6">${stackTop.name}</span>
              <code class="ms-2">${stackTop.id}</code>
            </p>
          </c:when>
          <c:otherwise>
            <p class="mb-0 text-muted">Stack is empty.</p>
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <%-- Error Alert --%>
    <c:if test="${not empty error}">
      <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
    </c:if>

    <%-- Add Item Form --%>
    <div class="card border-0 shadow-sm">
      <div class="card-header bg-white fw-semibold">
        <i class="bi bi-plus-circle me-2 text-primary"></i>New Inventory Item
      </div>
      <div class="card-body">
        <form action="${pageContext.request.contextPath}/addStock" method="post">
          <div class="row g-3">
            <div class="col-md-6">
              <label for="name" class="form-label fw-semibold">Item Name <span class="text-danger">*</span></label>
              <input type="text" class="form-control" id="name" name="name"
                     placeholder="e.g. Paracetamol 500mg" required>
            </div>
            <div class="col-md-6">
              <label for="category" class="form-label fw-semibold">Category <span class="text-danger">*</span></label>
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
              <label for="quantity" class="form-label fw-semibold">Quantity <span class="text-danger">*</span></label>
              <input type="number" class="form-control" id="quantity" name="quantity"
                     min="1" placeholder="e.g. 100" required>
            </div>
            <div class="col-md-4">
              <label for="price" class="form-label fw-semibold">Unit Price ($) <span class="text-danger">*</span></label>
              <input type="number" class="form-control" id="price" name="price"
                     step="0.01" min="0" placeholder="e.g. 9.99" required>
            </div>
            <div class="col-md-4">
              <label for="expiryDate" class="form-label fw-semibold">Expiry Date <span class="text-danger">*</span></label>
              <input type="date" class="form-control" id="expiryDate" name="expiryDate" required>
            </div>
            <div class="col-12 mt-3">
              <button type="submit" class="btn btn-primary px-4">
                <i class="bi bi-plus-circle me-2"></i>Add Item (Push to Stack)
              </button>
              <a href="${pageContext.request.contextPath}/viewInventory"
                 class="btn btn-outline-secondary ms-2">Cancel</a>
            </div>
          </div>
        </form>
      </div>
    </div>

    <%-- OOP Info Box --%>
    <div class="alert alert-info mt-4">
      <h6 class="fw-bold"><i class="bi bi-info-circle me-2"></i>OOP Concepts in Action</h6>
      <ul class="mb-0 small">
        <li><strong>Encapsulation:</strong> Item fields are private; accessed via getters/setters.</li>
        <li><strong>Abstraction:</strong> AddStockServlet delegates to InventoryService which hides Stack &amp; FileHandler details.</li>
        <li><strong>Stack (LIFO):</strong> Each submission calls <code>stack.push(item)</code> — the item is placed on top of the stack.</li>
      </ul>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
