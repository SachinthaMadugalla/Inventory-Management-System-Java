<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--@elvariable id="totalRevenue" type="java.lang.Double"--%>
<%--@elvariable id="sales" type="java.util.List"--%>
<%--@elvariable id="successMsg" type="java.lang.String"--%>
<c:set var="activePage" value="viewSales" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales History — InvenTrack</title>
    <!--suppress HtmlUnknownTarget -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!--suppress HtmlUnknownTarget -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .main-content  { margin-left: 260px; padding: 2.5rem; }
        .card-custom { border-radius: 16px; border: none; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03); }
        .revenue-card { background: linear-gradient(135deg, #10b981 0%, #047857 100%); color: white; border-radius: 16px; border: none; box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.3); overflow: hidden; position: relative; }
        .revenue-card::after { content: ''; position: absolute; top: 0; right: 0; bottom: 0; left: 0; background: url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PGNpcmNsZSBjeD0iMiIgY3k9IjIiIHI9IjIiIGZpbGw9IiNmZmYiIGZpbGwtb3BhY2l0eT0iMC4xIi8+PC9zdmc+') repeat; opacity: 0.5; }
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
                <h2 class="fw-bold mb-1" style="color: #0f172a;">Sales History</h2>
                <p class="text-muted mb-0">All recorded transactions</p>
            </div>
            <a href="${pageContext.request.contextPath}/processSale" class="btn btn-success px-4 py-2 shadow-sm" style="background-color: #10b981; border-color: #10b981; border-radius: 10px; font-weight: 500;">
                <i class="bi bi-cart-plus me-2"></i>New Sale
            </a>
        </div>

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success alert-dismissible fade show border-0 rounded-3 shadow-sm">
                <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <%-- Revenue Summary --%>
        <div class="card revenue-card mb-5">
            <div class="card-body p-4 p-md-5 d-flex justify-content-between align-items-center z-index-1 position-relative" style="z-index: 2;">
                <div>
                    <div class="text-uppercase fw-bold mb-2" style="color: #d1fae5; letter-spacing: 1px; font-size: 0.85rem;">Total Revenue</div>
                    <div class="display-4 fw-bold mb-1" style="letter-spacing: -0.02em;">$<fmt:formatNumber value="${totalRevenue}" maxFractionDigits="2"/></div>
                    <div class="fw-medium" style="color: #a7f3d0;">From ${sales.size()} recorded sale(s)</div>
                </div>
                <i class="bi bi-currency-dollar position-absolute" style="font-size:8rem; opacity:0.15; right: 2rem; top: 50%; transform: translateY(-50%);"></i>
            </div>
        </div>

        <%-- Sales Table --%>
        <div class="card card-custom">
            <div class="card-header bg-transparent border-0 pt-4 pb-3 px-4">
                <h5 class="fw-bold mb-0" style="color: #0f172a;"><i class="bi bi-receipt me-2 text-success"></i>Transaction Records</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">Sale ID</th>
                            <th>Item ID</th>
                            <th>Item Name</th>
                            <th>Qty Sold</th>
                            <th>Total Price</th>
                            <th>Date</th>
                            <c:if test="${sessionScope.role == 'admin'}">
                            <th class="text-center pe-4">Actions</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sale" items="${sales}">
                        <tr>
                            <td class="ps-4"><code class="px-2 py-1 rounded" style="background-color: #f8fafc; color: #64748b; border: 1px solid #e2e8f0;">${sale.saleId}</code></td>
                            <td><code class="px-2 py-1 rounded" style="background-color: #f1f5f9; color: #475569;">${sale.itemId}</code></td>
                            <td class="fw-bold text-dark">${sale.itemName}</td>
                            <td><span class="badge rounded-pill px-3 py-2" style="background-color: #f1f5f9; color: #334155;">${sale.quantitySold} units</span></td>
                            <td class="text-success fw-bold">
                                $<fmt:formatNumber value="${sale.totalPrice}" maxFractionDigits="2"/>
                            </td>
                            <td><span class="text-secondary"><i class="bi bi-clock me-1 small"></i>${sale.saleDate}</span></td>
                            <c:if test="${sessionScope.role == 'admin'}">
                            <td class="text-center pe-4">
                                <div class="d-flex justify-content-center gap-2">
                                    <a href="${pageContext.request.contextPath}/editTransaction?id=${sale.saleId}"
                                       class="btn btn-action btn-outline-primary" title="Edit">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/deleteSale"
                                          method="post" class="d-inline"
                                          onsubmit="return confirm('Delete transaction ${sale.saleId}?');">
                                        <input type="hidden" name="saleId" value="${sale.saleId}">
                                        <button type="submit" class="btn btn-action btn-outline-danger" title="Delete">
                                            <i class="bi bi-trash3"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                            </c:if>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty sales}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-5">
                                <div class="mb-3"><i class="bi bi-receipt fs-1 text-black-50 opacity-25"></i></div>
                                <h6 class="fw-medium text-dark mb-1">No sales recorded yet</h6>
                                <p class="small mb-0"><a href="${pageContext.request.contextPath}/processSale" class="text-success text-decoration-none fw-medium">Process a sale</a> to see it here.</p>
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