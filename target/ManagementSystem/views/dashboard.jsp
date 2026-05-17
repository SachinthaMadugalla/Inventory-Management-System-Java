<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="activePage" value="dashboard" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — InvenTrack</title>
    <!--suppress HtmlUnknownTarget -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!--suppress HtmlUnknownTarget -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; }
        .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto; z-index: 100; }
        .main-content  { margin-left: 250px; padding: 2rem; }
        .stat-card     { border-radius: 12px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.08); }
        .stat-icon     { font-size: 2.5rem; opacity: 0.8; }
    </style>
</head>
<body>
<div class="d-flex">
    <%-- Sidebar --%>
    <jsp:include page="/views/common/sidebar.jsp"/>

    <%-- Main Content --%>
    <div class="main-content flex-grow-1">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-0">Dashboard</h2>
                <p class="text-muted">Welcome back, <strong>${sessionScope.username}</strong>!</p>
            </div>
        </div>

        <%-- Stats Row --%>
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card stat-card bg-primary text-white">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fs-2 fw-bold">${totalItems}</div>
                            <div class="small">Total Items</div>
                        </div>
                        <i class="bi bi-boxes stat-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card bg-success text-white">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fs-2 fw-bold">${totalSales}</div>
                            <div class="small">Total Sales</div>
                        </div>
                        <i class="bi bi-receipt stat-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card bg-info text-white">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fs-2 fw-bold">$<fmt:formatNumber value="${totalRevenue}" maxFractionDigits="2"/></div>
                            <div class="small">Total Revenue</div>
                        </div>
                        <i class="bi bi-currency-dollar stat-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card bg-warning text-dark">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fs-2 fw-bold">${lowStockCount}</div>
                            <div class="small">Low Stock Items</div>
                        </div>
                        <i class="bi bi-exclamation-triangle stat-icon"></i>
                    </div>
                </div>
            </div>
        </div>

        <%-- Quick Actions --%>
        <div class="row g-3 mb-4">
            <div class="col-12">
                <h5 class="fw-semibold">Quick Actions</h5>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/addStock" class="btn btn-primary">
                    <i class="bi bi-plus-circle me-2"></i>Add Stock
                </a>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/processSale" class="btn btn-success">
                    <i class="bi bi-cart-plus me-2"></i>New Sale
                </a>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/expiryManagement" class="btn btn-warning">
                    <i class="bi bi-calendar-x me-2"></i>Expiry Check
                </a>
            </div>
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/reports" class="btn btn-info text-white">
                    <i class="bi bi-bar-chart-line me-2"></i>Reports
                </a>
            </div>
        </div>

        <%-- Recent Items Table --%>
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-clock-history me-2"></i>Recently Added Items
            </div>
            <div class="card-body p-0">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th><th>Name</th><th>Category</th>
                            <th>Qty</th><th>Price</th><th>Expiry</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${recentItems}">
                        <tr>
                            <td><code>${item.id}</code></td>
                            <td>${item.name}</td>
                            <td><span class="badge bg-secondary">${item.category}</span></td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.quantity < 10}">
                                        <span class="badge bg-danger">${item.quantity}</span>
                                    </c:when>
                                    <c:otherwise>${item.quantity}</c:otherwise>
                                </c:choose>
                            </td>
                            <td>$<fmt:formatNumber value="${item.price}" maxFractionDigits="2"/></td>
                            <td>${item.expiryDate}</td>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty recentItems}">
                        <tr><td colspan="6" class="text-center text-muted py-3">No items in inventory yet.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<!--suppress HtmlUnknownTarget -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>