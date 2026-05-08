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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
        }
        .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto; z-index: 100; }
        .main-content  { margin-left: 260px; padding: 2.5rem; }
        .stat-card     { border-radius: 16px; border: none; overflow: hidden; position: relative; }
        .stat-card::after {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(45deg, rgba(255,255,255,0.1), rgba(255,255,255,0));
            pointer-events: none;
        }
        .stat-icon     { font-size: 3.5rem; opacity: 0.2; position: absolute; right: -10px; bottom: -15px; transform: rotate(-10deg); }
        .bg-gradient-primary { background: linear-gradient(135deg, #4f46e5 0%, #3730a3 100%); }
        .bg-gradient-success { background: linear-gradient(135deg, #10b981 0%, #047857 100%); }
        .bg-gradient-info { background: linear-gradient(135deg, #0ea5e9 0%, #0369a1 100%); }
        .bg-gradient-warning { background: linear-gradient(135deg, #f59e0b 0%, #b45309 100%); }
        .card-custom { border-radius: 16px; border: none; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03); }
        .table-custom th { text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; color: #64748b; background-color: #f1f5f9; border-bottom: none; padding: 1rem; }
        .table-custom td { padding: 1rem; vertical-align: middle; border-bottom: 1px solid #e2e8f0; color: #334155; }
        .btn-custom { border-radius: 10px; font-weight: 500; padding: 0.75rem 1rem; transition: all 0.2s; }
        .btn-custom:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .page-header { background: #ffffff; padding: 2rem; border-radius: 16px; margin-bottom: 2rem; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
    </style>
</head>
<body>
<div class="d-flex">
    <%-- Sidebar --%>
    <jsp:include page="/views/common/sidebar.jsp"/>

    <%-- Main Content --%>
    <div class="main-content flex-grow-1">
        <div class="page-header d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-1" style="color: #0f172a;">Dashboard Overview</h2>
                <p class="text-muted mb-0">Track your inventory, sales, and revenue in real-time.</p>
            </div>
            <div>
                <span class="badge px-3 py-2 rounded-pill" style="background-color: #e0e7ff; color: #3730a3;">
                    <i class="bi bi-clock me-1"></i> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE, MMM d, yyyy"/>
                </span>
            </div>
        </div>

        <%-- Stats Row --%>
        <div class="row g-4 mb-5">
            <div class="col-md-3">
                <div class="card stat-card bg-gradient-primary text-white shadow-sm">
                    <div class="card-body p-4 position-relative">
                        <div class="fs-1 fw-bold mb-1">${totalItems}</div>
                        <div class="fw-medium" style="color: #c7d2fe;">Total Items</div>
                        <i class="bi bi-box-seam stat-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card bg-gradient-success text-white shadow-sm">
                    <div class="card-body p-4 position-relative">
                        <div class="fs-1 fw-bold mb-1">${totalSales}</div>
                        <div class="fw-medium" style="color: #d1fae5;">Total Sales</div>
                        <i class="bi bi-cart-check stat-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card bg-gradient-info text-white shadow-sm">
                    <div class="card-body p-4 position-relative">
                        <div class="fs-1 fw-bold mb-1">$<fmt:formatNumber value="${totalRevenue}" maxFractionDigits="2"/></div>
                        <div class="fw-medium" style="color: #e0f2fe;">Total Revenue</div>
                        <i class="bi bi-currency-dollar stat-icon"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card bg-gradient-warning text-white shadow-sm">
                    <div class="card-body p-4 position-relative">
                        <div class="fs-1 fw-bold mb-1">${lowStockCount}</div>
                        <div class="fw-medium" style="color: #fef3c7;">Low Stock Items</div>
                        <i class="bi bi-exclamation-triangle stat-icon"></i>
                    </div>
                </div>
            </div>
        </div>

        <%-- Quick Actions & Recent Items --%>
        <div class="row g-4">
            <div class="col-lg-3 order-lg-2">
                <div class="card card-custom h-100">
                    <div class="card-header bg-transparent border-0 pt-4 pb-2 px-4">
                        <h6 class="fw-bold text-uppercase" style="color: #64748b; font-size: 0.8rem; letter-spacing: 1px;">Quick Actions</h6>
                    </div>
                    <div class="card-body px-4 pb-4">
                        <div class="d-grid gap-3">
                            <a href="${pageContext.request.contextPath}/addStock" class="btn btn-primary btn-custom text-start shadow-sm" style="background-color: #4f46e5; border:none;">
                                <i class="bi bi-plus-circle me-2 fs-5 align-middle"></i> <span class="align-middle">Add New Stock</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/processSale" class="btn btn-success btn-custom text-start shadow-sm" style="background-color: #10b981; border:none;">
                                <i class="bi bi-cart-plus me-2 fs-5 align-middle"></i> <span class="align-middle">Process Sale</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/expiryManagement" class="btn btn-warning btn-custom text-start text-dark shadow-sm" style="background-color: #f59e0b; border:none;">
                                <i class="bi bi-calendar-x me-2 fs-5 align-middle"></i> <span class="align-middle">Expiry Check</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/reports" class="btn btn-info btn-custom text-start text-white shadow-sm" style="background-color: #0ea5e9; border:none;">
                                <i class="bi bi-bar-chart-line me-2 fs-5 align-middle"></i> <span class="align-middle">View Reports</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-9 order-lg-1">
                <div class="card card-custom h-100">
                    <div class="card-header bg-transparent border-0 pt-4 pb-3 px-4 d-flex justify-content-between align-items-center">
                        <h5 class="fw-bold mb-0" style="color: #0f172a;"><i class="bi bi-clock-history me-2 text-primary"></i>Recently Added Items</h5>
                        <a href="${pageContext.request.contextPath}/viewInventory" class="text-decoration-none fw-medium small" style="color: #4f46e5;">View All &rarr;</a>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-custom mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-4">Item Details</th>
                                        <th>Category</th>
                                        <th>Quantity</th>
                                        <th>Price</th>
                                        <th>Expiry</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${recentItems}">
                                    <tr>
                                        <td class="ps-4">
                                            <div class="fw-bold text-dark">${item.name}</div>
                                            <div class="text-muted small">ID: <code>${item.id}</code></div>
                                        </td>
                                        <td><span class="badge rounded-pill" style="background-color: #f1f5f9; color: #475569;">${item.category}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.quantity < 10}">
                                                    <span class="badge rounded-pill bg-danger-subtle text-danger px-2 py-1"><i class="bi bi-arrow-down-circle me-1"></i>${item.quantity} Low</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge rounded-pill bg-success-subtle text-success px-2 py-1">${item.quantity} In Stock</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="fw-medium">$<fmt:formatNumber value="${item.price}" maxFractionDigits="2"/></td>
                                        <td><span class="text-secondary"><i class="bi bi-calendar3 me-1 small"></i>${item.expiryDate}</span></td>
                                    </tr>
                                    </c:forEach>
                                    <c:if test="${empty recentItems}">
                                    <tr>
                                        <td colspan="5" class="text-center text-muted py-5">
                                            <div class="mb-3"><i class="bi bi-inbox fs-1 text-black-50 opacity-25"></i></div>
                                            No items in inventory yet.
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
    </div>
</div>
<!--suppress HtmlUnknownTarget -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>