<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="viewSales" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales History — InvenTrack</title>
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
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-0">Sales History</h2>
                <p class="text-muted">All recorded transactions</p>
            </div>
            <a href="${pageContext.request.contextPath}/processSale" class="btn btn-success">
                <i class="bi bi-cart-plus me-2"></i>New Sale
            </a>
        </div>

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <%-- Revenue Summary --%>
        <div class="card border-0 shadow-sm mb-4 bg-success text-white">
            <div class="card-body d-flex justify-content-between align-items-center">
                <div>
                    <div class="fs-4 fw-bold">$<fmt:formatNumber value="${totalRevenue}" maxFractionDigits="2"/></div>
                    <div class="small">Total Revenue from ${sales.size()} sale(s)</div>
                </div>
                <i class="bi bi-currency-dollar" style="font-size:3rem; opacity:0.6;"></i>
            </div>
        </div>

        <%-- Sales Table --%>
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-receipt me-2"></i>Transaction Records
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>Sale ID</th>
                            <th>Item ID</th>
                            <th>Item Name</th>
                            <th>Qty Sold</th>
                            <th>Total Price</th>
                            <th>Date</th>
                            <c:if test="${sessionScope.role == 'admin'}">
                            <th class="text-center">Actions</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sale" items="${sales}">
                        <tr>
                            <td><code class="small">${sale.saleId}</code></td>
                            <td><code class="small">${sale.itemId}</code></td>
                            <td class="fw-semibold">${sale.itemName}</td>
                            <td>${sale.quantitySold}</td>
                            <td class="text-success fw-semibold">
                                $<fmt:formatNumber value="${sale.totalPrice}" maxFractionDigits="2"/>
                            </td>
                            <td>${sale.saleDate}</td>
                            <c:if test="${sessionScope.role == 'admin'}">
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/editTransaction?id=${sale.saleId}"
                                   class="btn btn-sm btn-outline-primary me-1">
                                    <i class="bi bi-pencil"></i>
                                </a>
                                <form action="${pageContext.request.contextPath}/deleteSale"
                                      method="post" class="d-inline"
                                      onsubmit="return confirm('Delete transaction ${sale.saleId}?');">
                                    <input type="hidden" name="saleId" value="${sale.saleId}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </td>
                            </c:if>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty sales}">
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">
                                <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                No sales recorded yet. <a href="${pageContext.request.contextPath}/processSale">Make a sale</a>.
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
