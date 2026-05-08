<%--
    sidebar.jsp — Reusable navigation sidebar included in every page.
    Uses Bootstrap 5 for styling.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="activePage" type="java.lang.String"--%>
<style>
    .sidebar-custom {
        background: linear-gradient(180deg, #1e1b4b 0%, #312e81 100%);
        box-shadow: 4px 0 15px rgba(0,0,0,0.1);
        border-right: 1px solid rgba(255,255,255,0.05);
    }
    .sidebar-custom .nav-link {
        color: #c7d2fe;
        border-radius: 10px;
        margin-bottom: 4px;
        transition: all 0.3s ease;
        padding: 0.75rem 1rem;
    }
    .sidebar-custom .nav-link:hover {
        background-color: rgba(255,255,255,0.1);
        color: #ffffff;
        transform: translateX(4px);
    }
    .sidebar-custom .nav-link.active {
        background-color: #4f46e5;
        color: #ffffff;
        box-shadow: 0 4px 6px -1px rgba(79, 70, 229, 0.4);
    }
    .brand-logo {
        color: #818cf8;
        filter: drop-shadow(0 0 8px rgba(129, 140, 248, 0.5));
    }
    .menu-heading {
        font-size: 0.7rem;
        letter-spacing: 1px;
        color: #818cf8 !important;
    }
</style>
<div class="d-flex flex-column flex-shrink-0 p-3 sidebar-custom sidebar-fixed" style="width:260px; min-height:100vh; z-index: 1000;">
    <a href="${pageContext.request.contextPath}/dashboard"
       class="d-flex align-items-center mb-4 mt-2 me-md-auto text-white text-decoration-none px-2">
        <i class="bi bi-hexagon-fill fs-3 me-3 brand-logo"></i>
        <span class="fs-4 fw-bold tracking-tight">InvenTrack</span>
    </a>

    <%-- Logged-in user info --%>
    <div class="mb-4 px-3 py-3 rounded-3" style="background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.05);">
        <div class="d-flex align-items-center">
            <div class="bg-primary rounded-circle d-flex align-items-center justify-content-center me-3 shadow" style="width:40px; height:40px;">
                <i class="bi bi-person text-white fs-5"></i>
            </div>
            <div>
                <div class="small" style="color:#a5b4fc; font-size: 0.75rem;">Welcome back,</div>
                <strong class="text-white d-block">${sessionScope.username}</strong>
                <span class="badge mt-1" style="background-color: #4338ca;">${sessionScope.role}</span>
            </div>
        </div>
    </div>

    <ul class="nav nav-pills flex-column mb-auto px-1">
        <li class="nav-item">
            <div class="text-uppercase fw-bold text-secondary mb-2 ms-2 menu-heading">Main Menu</div>
        </li>

        <%-- Dashboard (admin only) --%>
        <c:if test="${sessionScope.role == 'admin'}">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/dashboard"
               class="nav-link ${activePage == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-grid-1x2-fill me-3"></i>Dashboard
            </a>
        </li>
        </c:if>

        <%-- Inventory --%>
        <li class="nav-item mt-3">
            <div class="text-uppercase fw-bold text-secondary mb-2 ms-2 menu-heading">Inventory</div>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/viewInventory"
               class="nav-link ${activePage == 'inventory' ? 'active' : ''}">
                <i class="bi bi-boxes me-3"></i>All Items
            </a>
        </li>

        <%-- Add Stock (admin only) --%>
        <c:if test="${sessionScope.role == 'admin'}">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/addStock"
               class="nav-link ${activePage == 'addStock' ? 'active' : ''}">
                <i class="bi bi-plus-square-fill me-3"></i>Add Stock
            </a>
        </li>
        </c:if>

        <%-- Expiry Management --%>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/expiryManagement"
               class="nav-link ${activePage == 'expiry' ? 'active' : ''}">
                <i class="bi bi-calendar-x-fill me-3"></i>Expiry Mgmt
            </a>
        </li>

        <li class="nav-item mt-3">
            <div class="text-uppercase fw-bold text-secondary mb-2 ms-2 menu-heading">Sales &amp; Reports</div>
        </li>
        <%-- Sales --%>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/processSale"
               class="nav-link ${activePage == 'addSale' ? 'active' : ''}">
                <i class="bi bi-cart-plus-fill me-3"></i>New Sale
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/viewSales"
               class="nav-link ${activePage == 'viewSales' ? 'active' : ''}">
                <i class="bi bi-receipt-cutoff me-3"></i>Sales History
            </a>
        </li>

        <%-- Reports (admin only) --%>
        <c:if test="${sessionScope.role == 'admin'}">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/reports"
               class="nav-link ${activePage == 'reports' ? 'active' : ''}">
                <i class="bi bi-bar-chart-fill me-3"></i>Reports
            </a>
        </li>
        </c:if>
    </ul>

    <div class="mt-auto px-1 pt-3 border-top" style="border-color: rgba(255,255,255,0.1) !important;">
        <a href="${pageContext.request.contextPath}/logout"
           class="btn btn-outline-light w-100 rounded-3 d-flex align-items-center justify-content-center" style="border-color: rgba(255,255,255,0.2); color: #e2e8f0;">
            <i class="bi bi-box-arrow-right me-2"></i>Sign Out
        </a>
    </div>
</div>