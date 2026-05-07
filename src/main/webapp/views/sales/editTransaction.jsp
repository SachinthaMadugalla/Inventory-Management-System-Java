<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="activePage" value="viewSales" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Transaction — InvenTrack</title>
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
        <h2 class="fw-bold mb-1">Edit Transaction</h2>
        <p class="text-muted mb-4">Component 03 — Correct an erroneous transaction record</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
            </div>
        </c:if>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-pencil-square me-2 text-primary"></i>
                Edit Sale Record — <code>${sale.saleId}</code>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/editTransaction" method="post">
                    <input type="hidden" name="saleId" value="${sale.saleId}">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="itemId" class="form-label fw-semibold">Item ID</label>
                            <input type="text" class="form-control" id="itemId" name="itemId"
                                   value="${sale.itemId}" required>
                        </div>
                        <div class="col-md-6">
                            <label for="itemName" class="form-label fw-semibold">Item Name</label>
                            <input type="text" class="form-control" id="itemName" name="itemName"
                                   value="${sale.itemName}" required>
                        </div>
                        <div class="col-md-4">
                            <label for="quantitySold" class="form-label fw-semibold">Quantity Sold</label>
                            <input type="number" class="form-control" id="quantitySold" name="quantitySold"
                                   value="${sale.quantitySold}" min="1" required>
                        </div>
                        <div class="col-md-4">
                            <label for="totalPrice" class="form-label fw-semibold">Total Price ($)</label>
                            <input type="number" class="form-control" id="totalPrice" name="totalPrice"
                                   value="${sale.totalPrice}" step="0.01" min="0" required>
                        </div>
                        <div class="col-md-4">
                            <label for="saleDate" class="form-label fw-semibold">Sale Date</label>
                            <input type="date" class="form-control" id="saleDate" name="saleDate"
                                   value="${sale.saleDate}" required>
                        </div>
                        <div class="col-12 mt-3">
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="bi bi-save me-2"></i>Save Changes
                            </button>
                            <a href="${pageContext.request.contextPath}/viewSales"
                               class="btn btn-outline-secondary ms-2">Cancel</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="alert alert-info mt-4">
            <h6 class="fw-bold"><i class="bi bi-info-circle me-2"></i>OOP Concepts in Action</h6>
            <ul class="mb-0 small">
                <li><strong>Encapsulation:</strong> Sale fields are private; modified only through setters.</li>
                <li><strong>Abstraction:</strong> File update uses Read-Modify-Overwrite pattern inside FileHandler.</li>
            </ul>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
