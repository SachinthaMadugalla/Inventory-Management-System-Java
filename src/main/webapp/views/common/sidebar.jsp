<%--
    sidebar.jsp — Reusable navigation sidebar included in every page.
    Uses Bootstrap 5 for styling.
    The 'activePage' request attribute is used to highlight the current nav item.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="activePage" type="java.lang.String"--%>
<div class="d-flex flex-column flex-shrink-0 sidebar-fixed">
    <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-brand">
        <span class="sidebar-brand-icon"><i class="bi bi-box-seam-fill"></i></span>
        <span class="sidebar-brand-text">Lumenara</span>
    </a>

    <div class="sidebar-section-label mt-1">Menu</div>

    <ul class="nav nav-pills flex-column mb-auto">

        <%-- Dashboard (admin only) --%>
        <c:if test="${sessionScope.role == 'admin'}">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/dashboard"
                   class="nav-link ${activePage == 'dashboard' ? 'active' : ''}">
                    <i class="bi bi-speedometer2"></i>Dashboard
                </a>
            </li>
        </c:if>

        <%-- Inventory --%>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/viewInventory"
               class="nav-link ${activePage == 'inventory' ? 'active' : ''}">
                <i class="bi bi-boxes"></i>Inventory
            </a>
        </li>

        <%-- Add Stock (admin only) --%>
        <c:if test="${sessionScope.role == 'admin'}">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/addStock"
                   class="nav-link ${activePage == 'addStock' ? 'active' : ''}">
                    <i class="bi bi-plus-circle"></i>Add Stock
                </a>
            </li>
        </c:if>

        <%-- Expiry Management --%>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/expiryManagement"
               class="nav-link ${activePage == 'expiry' ? 'active' : ''}">
                <i class="bi bi-calendar-x"></i>Expiry Mgmt
            </a>
        </li>

        <%-- Sales --%>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/processSale"
               class="nav-link ${activePage == 'addSale' ? 'active' : ''}">
                <i class="bi bi-cart-plus"></i>New Sale
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/viewSales"
               class="nav-link ${activePage == 'viewSales' ? 'active' : ''}">
                <i class="bi bi-receipt"></i>Sales History
            </a>
        </li>

        <%-- Reports (admin only) --%>
        <c:if test="${sessionScope.role == 'admin'}">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/reports"
                   class="nav-link ${activePage == 'reports' ? 'active' : ''}">
                    <i class="bi bi-bar-chart-line"></i>Reports
                </a>
            </li>
        </c:if>
    </ul>

    <div class="sidebar-section-label">System</div>
    <a href="${pageContext.request.contextPath}/logout"
       class="btn btn-outline-danger btn-sm w-100">
        <i class="bi bi-box-arrow-right me-1"></i>Logout
    </a>
</div>
