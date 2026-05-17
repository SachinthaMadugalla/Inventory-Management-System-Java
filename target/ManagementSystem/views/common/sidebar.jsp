<%--
    sidebar.jsp — Reusable navigation sidebar included in every page.
    Uses Bootstrap 5 for styling.
    The 'activePage' request attribute is used to highlight the current nav item.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="activePage" type="java.lang.String"--%>
<div class="d-flex flex-column flex-shrink-0 p-3 bg-dark text-white sidebar-fixed" style="width:250px; min-height:100vh;">
    <a href="${pageContext.request.contextPath}/dashboard"
       class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none">
        <i class="bi bi-box-seam-fill fs-4 me-2"></i>
        <span class="fs-5 fw-bold">InvenTrack</span>
    </a>
    <hr>

    <%-- Logged-in user info --%>
    <div class="mb-3 small text-secondary">
        <i class="bi bi-person-circle me-1"></i>
        Logged in as: <strong class="text-white">${sessionScope.username}</strong>
        <span class="badge bg-primary ms-1">${sessionScope.role}</span>
    </div>
    <hr>

    <ul class="nav nav-pills flex-column mb-auto">

        <%-- Dashboard (admin only) --%>
        <c:if test="${sessionScope.role == 'admin'}">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/dashboard"
               class="nav-link text-white ${activePage == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-speedometer2 me-2"></i>Dashboard
            </a>
        </li>
        </c:if>

        <%-- Inventory --%>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/viewInventory"
               class="nav-link text-white ${activePage == 'inventory' ? 'active' : ''}">
                <i class="bi bi-boxes me-2"></i>Inventory
            </a>
        </li>

        <%-- Add Stock (admin only) --%>
        <c:if test="${sessionScope.role == 'admin'}">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/addStock"
               class="nav-link text-white ${activePage == 'addStock' ? 'active' : ''}">
                <i class="bi bi-plus-circle me-2"></i>Add Stock
            </a>
        </li>
        </c:if>

        <%-- Expiry Management --%>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/expiryManagement"
               class="nav-link text-white ${activePage == 'expiry' ? 'active' : ''}">
                <i class="bi bi-calendar-x me-2"></i>Expiry Mgmt
            </a>
        </li>

        <%-- Sales --%>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/processSale"
               class="nav-link text-white ${activePage == 'addSale' ? 'active' : ''}">
                <i class="bi bi-cart-plus me-2"></i>New Sale
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/viewSales"
               class="nav-link text-white ${activePage == 'viewSales' ? 'active' : ''}">
                <i class="bi bi-receipt me-2"></i>Sales History
            </a>
        </li>

        <%-- Reports (admin only) --%>
        <c:if test="${sessionScope.role == 'admin'}">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/reports"
               class="nav-link text-white ${activePage == 'reports' ? 'active' : ''}">
                <i class="bi bi-bar-chart-line me-2"></i>Reports
            </a>
        </li>
        </c:if>
    </ul>

    <hr>
    <a href="${pageContext.request.contextPath}/logout"
       class="btn btn-outline-danger btn-sm w-100">
        <i class="bi bi-box-arrow-right me-1"></i>Logout
    </a>
</div>