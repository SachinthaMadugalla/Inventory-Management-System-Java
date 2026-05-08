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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto; z-index: 100; }
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
        <h2 class="fw-bold mb-1" style="color: #0f172a;">Edit Item</h2>
        <p class="text-muted mb-4">Modifying: <strong class="text-dark">${item.name}</strong> — uses Read-Modify-Overwrite pattern.</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger border-0 rounded-3 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
        </c:if>

        <div class="card card-custom" style="max-width: 700px;">
            <div class="card-header bg-transparent border-0 pt-4 pb-0 px-4">
                <h5 class="fw-bold mb-0" style="color: #0f172a;"><i class="bi bi-pencil-square me-2" style="color: #4f46e5;"></i>Update Item Details</h5>
            </div>
            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/editStock" method="post">
                    <input type="hidden" name="id" value="${item.id}">

                    <div class="row g-4">
                        <div class="col-md-6">
                            <label for="name" class="form-label fw-semibold text-dark">Item Name</label>
                            <input type="text" class="form-control" id="name" name="name"
                                   value="${item.name}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="category" class="form-label fw-semibold text-dark">Category</label>
                            <select class="form-select" id="category" name="category" required>
                                <c:forEach var="cat" items="${['Medicine','Food','Electronics','Clothing','Beverages','Other']}">
                                    <option value="${cat}" ${item.category == cat ? 'selected' : ''}>${cat}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="quantity" class="form-label fw-semibold text-dark">Quantity</label>
                            <input type="number" class="form-control" id="quantity" name="quantity"
                                   value="${item.quantity}" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label for="price" class="form-label fw-semibold text-dark">Unit Price ($)</label>
                            <input type="number" class="form-control" id="price" name="price"
                                   value="${item.price}" step="0.01" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label for="expiryDate" class="form-label fw-semibold text-dark">Expiry Date</label>
                            <input type="date" class="form-control" id="expiryDate" name="expiryDate"
                                   value="${item.expiryDate}" required>
                        </div>
                        <div class="col-12 mt-4 pt-3 border-top">
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary flex-grow-1">
                                    <i class="bi bi-save me-2"></i>Save Changes
                                </button>
                                <a href="${pageContext.request.contextPath}/viewInventory"
                                   class="btn btn-outline-secondary px-4">Cancel</a>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="alert alert-info border-0 rounded-3 shadow-sm mt-4 d-flex align-items-start" style="max-width: 700px; background-color: #eff6ff; color: #1e3a8a;">
            <i class="bi bi-shield-check fs-4 me-3 mt-1" style="color: #3b82f6;"></i>
            <div>
                <h6 class="fw-bold mb-1">File Integrity</h6>
                <p class="mb-0 small">The update reads the entire <code>items.txt</code> into memory, replaces this item's record, then overwrites the file — ensuring no data corruption (Read-Modify-Overwrite pattern).</p>
            </div>
        </div>
    </div>
</div>
<!--suppress HtmlUnknownTarget -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>