<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="item" type="com.inventory.model.Item"--%>
<%--@elvariable id="error" type="java.lang.String"--%>
<c:set var="activePage" value="inventory" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Item — InvenTrack</title>
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
        <h2 class="fw-bold mb-1">Edit Item</h2>
        <p class="text-muted mb-4">Modifying: <strong>${item.name}</strong> — uses Read-Modify-Overwrite pattern.</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
        </c:if>

        <div class="card border-0 shadow-sm" style="max-width: 700px;">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-pencil-square me-2 text-primary"></i>Update Item Details
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/editStock" method="post">
                    <input type="hidden" name="id" value="${item.id}">

                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="name" class="form-label fw-semibold">Item Name</label>
                            <input type="text" class="form-control" id="name" name="name"
                                   value="${item.name}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="category" class="form-label fw-semibold">Category</label>
                            <select class="form-select" id="category" name="category" required>
                                <c:forEach var="cat" items="${['Medicine','Food','Electronics','Clothing','Beverages','Other']}">
                                    <option value="${cat}" ${item.category == cat ? 'selected' : ''}>${cat}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="quantity" class="form-label fw-semibold">Quantity</label>
                            <input type="number" class="form-control" id="quantity" name="quantity"
                                   value="${item.quantity}" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label for="price" class="form-label fw-semibold">Unit Price ($)</label>
                            <input type="number" class="form-control" id="price" name="price"
                                   value="${item.price}" step="0.01" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label for="expiryDate" class="form-label fw-semibold">Expiry Date</label>
                            <input type="date" class="form-control" id="expiryDate" name="expiryDate"
                                   value="${item.expiryDate}" required>
                        </div>
                        <div class="col-12 mt-3">
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="bi bi-save me-2"></i>Save Changes
                            </button>
                            <a href="${pageContext.request.contextPath}/viewInventory"
                               class="btn btn-outline-secondary ms-2">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="alert alert-info mt-4" style="max-width: 700px;">
            <strong><i class="bi bi-info-circle me-2"></i>File Integrity:</strong>
            The update reads the entire <code>items.txt</code> into memory, replaces this item's record,
            then overwrites the file — ensuring no data corruption (Read-Modify-Overwrite pattern).
        </div>
    </div>
</div>
<!--suppress HtmlUnknownTarget -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>