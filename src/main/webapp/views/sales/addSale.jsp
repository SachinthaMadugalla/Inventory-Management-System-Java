<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--@elvariable id="error" type="java.lang.String"--%>
<%--@elvariable id="items" type="java.util.List"--%>
<c:set var="activePage" value="addSale" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Sale — InvenTrack</title>
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
        .form-control:focus, .form-select:focus { box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1); border-color: #10b981; background-color: #ffffff; }
        .btn-success { background-color: #10b981; border-color: #10b981; border-radius: 10px; font-weight: 500; padding: 0.75rem 1.5rem; }
        .btn-success:hover { background-color: #059669; border-color: #059669; }
        .btn-outline-secondary { border-radius: 10px; font-weight: 500; padding: 0.75rem 1.5rem; }
        #totalPreview  { font-size: 2rem; font-weight: 700; color: #10b981; letter-spacing: -0.05em; }
        .preview-box { background: linear-gradient(135deg, #f0fdf4 0%, #dcfce7 100%); border-radius: 12px; border: 1px solid #bbf7d0; }
    </style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="/views/common/sidebar.jsp"/>

    <div class="main-content flex-grow-1">
        <h2 class="fw-bold mb-1" style="color: #0f172a;">New Sale</h2>
        <p class="text-muted mb-4">Select an item and quantity to process a sale transaction.</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger border-0 rounded-3 shadow-sm"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
        </c:if>

        <div class="card card-custom" style="max-width: 650px;">
            <div class="card-header bg-transparent border-0 pt-4 pb-0 px-4">
                <h5 class="fw-bold mb-0" style="color: #0f172a;"><i class="bi bi-cart-plus me-2" style="color: #10b981;"></i>Process Sale</h5>
            </div>
            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/processSale" method="post" id="saleForm">
                    <div class="mb-4">
                        <label for="itemId" class="form-label fw-semibold text-dark">Select Item <span class="text-danger">*</span></label>
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
                    <div class="mb-4">
                        <label for="quantity" class="form-label fw-semibold text-dark">Quantity <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-123"></i></span>
                            <input type="number" class="form-control border-start-0 ps-0" id="quantity" name="quantity"
                                   min="1" placeholder="Enter quantity" required oninput="updatePreview()">
                        </div>
                        <div class="form-text mt-2" id="stockHint"><i class="bi bi-info-circle me-1"></i>Select an item to see available stock.</div>
                    </div>

                    <%-- Live total preview --%>
                    <div class="mb-4 p-4 preview-box d-flex justify-content-between align-items-center">
                        <div class="text-success fw-medium text-uppercase" style="letter-spacing: 1px; font-size: 0.85rem;">Estimated Total</div>
                        <div id="totalPreview">$0.00</div>
                    </div>

                    <div class="d-flex gap-2 pt-2 border-top mt-4">
                        <button type="submit" class="btn btn-success flex-grow-1">
                            <i class="bi bi-check-circle me-2"></i>Confirm Sale
                        </button>
                        <a href="${pageContext.request.contextPath}/viewSales"
                           class="btn btn-outline-secondary px-4">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!--suppress HtmlUnknownTarget -->
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
            hintEl.innerHTML = '<i class="bi bi-info-circle me-1"></i>Select an item to see available stock.';
            return;
        }

        const price = parseFloat(selected.dataset.price) || 0;
        const stock = parseInt(selected.dataset.stock) || 0;
        const qty   = parseInt(qtyInput.value) || 0;

        hintEl.innerHTML = '<i class="bi bi-box-seam me-1"></i>Available stock: <strong class="' + (stock < 10 ? 'text-danger' : 'text-success') + '">' + stock + '</strong>';

        const total = price * qty;
        // Animate the update
        totalEl.style.transform = 'scale(1.05)';
        setTimeout(() => { totalEl.style.transform = 'scale(1)'; }, 150);

        totalEl.textContent = '$' + total.toFixed(2);
    }
</script>
</body>
</html>