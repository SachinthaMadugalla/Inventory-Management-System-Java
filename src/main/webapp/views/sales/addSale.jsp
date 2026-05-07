<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="addSale" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Sale — InvenTrack</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; }
        .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto; z-index: 100; }
        .main-content  { margin-left: 250px; padding: 2rem; }
        #totalPreview  { font-size: 1.5rem; font-weight: bold; color: #198754; }
    </style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="/views/common/sidebar.jsp"/>

    <div class="main-content flex-grow-1">
        <h2 class="fw-bold mb-1">New Sale</h2>
        <p class="text-muted mb-4">Select an item and quantity to process a sale transaction.</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
        </c:if>

        <div class="card border-0 shadow-sm" style="max-width: 650px;">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-cart-plus me-2 text-success"></i>Process Sale
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/processSale" method="post" id="saleForm">
                    <div class="mb-3">
                        <label for="itemId" class="form-label fw-semibold">Select Item <span class="text-danger">*</span></label>
                        <select class="form-select" id="itemId" name="itemId" required onchange="updatePreview()">
                            <option value="" disabled selected>-- Choose an item --</option>
                            <c:forEach var="item" items="${items}">
                                <option value="${item.id}"
                                        data-price="${item.price}"
                                        data-stock="${item.quantity}">
                                    ${item.name} (Stock: ${item.quantity}) — $<fmt:formatNumber value="${item.price}" maxFractionDigits="2"/>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="quantity" class="form-label fw-semibold">Quantity <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" id="quantity" name="quantity"
                               min="1" placeholder="Enter quantity" required oninput="updatePreview()">
                        <div class="form-text" id="stockHint"></div>
                    </div>

                    <%-- Live total preview --%>
                    <div class="mb-4 p-3 bg-light rounded">
                        <span class="text-muted">Estimated Total: </span>
                        <span id="totalPreview">$0.00</span>
                    </div>

                    <button type="submit" class="btn btn-success px-4">
                        <i class="bi bi-check-circle me-2"></i>Confirm Sale
                    </button>
                    <a href="${pageContext.request.contextPath}/viewSales"
                       class="btn btn-outline-secondary ms-2">Cancel</a>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function updatePreview() {
        const select = document.getElementById('itemId');
        const qtyInput = document.getElementById('quantity');
        const totalEl = document.getElementById('totalPreview');
        const hintEl  = document.getElementById('stockHint');

        const selected = select.options[select.selectedIndex];
        if (!selected || !selected.dataset.price) {
            totalEl.textContent = '$0.00';
            return;
        }

        const price = parseFloat(selected.dataset.price) || 0;
        const stock = parseInt(selected.dataset.stock) || 0;
        const qty   = parseInt(qtyInput.value) || 0;

        hintEl.textContent = 'Available stock: ' + stock;
        totalEl.textContent = '$' + (price * qty).toFixed(2);
    }
</script>
</body>
</html>
