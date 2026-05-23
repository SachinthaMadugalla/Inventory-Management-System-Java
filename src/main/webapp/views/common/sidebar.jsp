<%--
    sidebar.jsp — Reusable navigation sidebar included in every page.
    Uses Bootstrap 5 for styling.
    The 'activePage' request attribute is used to highlight the current nav item.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="activePage" type="java.lang.String"--%>
<div class="offcanvas-lg offcanvas-start sidebar-fixed" tabindex="-1" id="sidebar" aria-labelledby="sidebarLabel">
    <div class="offcanvas-header d-flex justify-content-between align-items-start mb-3">
        <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-brand text-decoration-none d-flex flex-column">
            <div class="d-flex align-items-center mb-1">
                <span class="sidebar-brand-icon me-2"><i class="bi bi-box-seam-fill"></i></span>
                <span class="sidebar-brand-text">Lumenara</span>
            </div>
            <span class="text-muted small" style="font-size: 0.75rem; letter-spacing: 0.5px;">Inventory &amp; Stock<br>Management System</span>
        </a>
        <button type="button" class="btn-close d-lg-none mt-2" data-bs-dismiss="offcanvas" data-bs-target="#sidebar" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body d-flex flex-column h-100">
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

        <div class="mt-auto">
            <div class="sidebar-section-label">System</div>
            <a href="${pageContext.request.contextPath}/logout"
               class="btn btn-outline-danger btn-sm w-100">
                <i class="bi bi-box-arrow-right me-1"></i>Logout
            </a>
        </div>
    </div>
</div>