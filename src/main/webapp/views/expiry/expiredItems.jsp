<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="activePage" value="expiry" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expired Items — InvenTrack</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto; z-index: 100; }
        .main-content  { margin-left: 260px; padding: 2.5rem; }
        .card-custom { border-radius: 16px; border: none; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03); }
        .table-custom th { text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; color: #64748b; background-color: #f1f5f9; border-bottom: none; padding: 1rem; }
        .table-custom td { padding: 1rem; vertical-align: middle; border-bottom: 1px solid #e2e8f0; }
        .btn-danger-custom { background-color: #ef4444; border-color: #ef4444; border-radius: 8px; font-weight: 500; transition: all 0.2s; }
        .btn-danger-custom:hover { background-color: #dc2626; border-color: #dc2626; transform: translateY(-2px); }
        .table-danger-custom { background-color: #fef2f2; color: #991b1b; }
        .table-danger-custom td { border-bottom-color: #fecaca; }
        .table-custom tbody tr:hover td { background-color: transparent; }
        .table-danger-custom:hover td { background-color: #fee2e2; }
    </style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="/views/common/sidebar.jsp"/>

    <div class="main-content flex-grow-1">
        <h2 class="fw-bold mb-1" style="color: #0f172a;">Expired Items</h2>
        <p class="text-muted mb-4">Component 02 — Items past their expiry date requiring immediate action</p>

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success alert-dismissible fade show border-0 rounded-3 shadow-sm">
                <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <%-- Summary Banner --%>
        <div class="card border-0 shadow-sm mb-4" style="background: linear-gradient(135deg, #ef4444 0%, #b91c1c 100%); color: white; border-radius: 16px;">
            <div class="card-body p-4 d-flex justify-content-between align-items-center position-relative overflow-hidden">
                <div style="z-index: 2;">
                    <div class="fs-4 fw-bold mb-1">${expired.size()} Expired Item(s)</div>
                    <div class="fw-medium" style="color: #fca5a5;">These items are past their expiry date and should be removed</div>
                </div>
                <i class="bi bi-exclamation-triangle-fill position-absolute" style="font-size: 8rem; opacity: 0.15; right: -10px; top: 50%; transform: translateY(-50%);"></i>
            </div>
        </div>

        <%-- Expired Items Table --%>
        <div class="card card-custom">
            <div class="card-header bg-transparent border-0 pt-4 pb-3 px-4 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0" style="color: #0f172a;"><i class="bi bi-calendar-x me-2 text-danger"></i>Expired Stock</h5>
                <a href="${pageContext.request.contextPath}/expiryManagement"
                   class="btn btn-sm btn-outline-secondary" style="border-radius: 8px; font-weight: 500;">
                    <i class="bi bi-arrow-left me-1"></i>Back to Expiry Management
                </a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                <table class="table table-custom align-middle mb-0">
                    <thead>
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Quantity</th>
                            <th>Unit Price</th>
                            <th>Expiry Date</th>
                            <c:if test="${sessionScope.role == 'admin'}">
                            <th class="text-center pe-4">Action</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${expired}">
                        <tr class="table-danger-custom">
                            <td class="ps-4"><code class="px-2 py-1 rounded" style="background-color: rgba(0,0,0,0.05); color: inherit;">${item.id}</code></td>
                            <td class="fw-bold">${item.name}</td>
                            <td><span class="badge rounded-pill" style="background-color: rgba(220,38,38,0.1); color: #b91c1c; border: 1px solid rgba(220,38,38,0.2);">${item.category}</span></td>
                            <td class="fw-medium">${item.quantity}</td>
                            <td class="fw-bold">$<fmt:formatNumber value="${item.price}" maxFractionDigits="2"/></td>
                            <td>
                                <span class="badge rounded-pill bg-danger px-3 py-2 shadow-sm">
                                    <i class="bi bi-calendar-x me-1"></i>${item.expiryDate}
                                </span>
                            </td>
                            <c:if test="${sessionScope.role == 'admin'}">
                            <td class="text-center pe-4">
                                <form action="${pageContext.request.contextPath}/deleteStock"
                                      method="post" class="d-inline"
                                      onsubmit="return confirm('Permanently remove expired item: ${item.name}?');">
                                    <input type="hidden" name="mode"   value="byId">
                                    <input type="hidden" name="itemId" value="${item.id}">
                                    <button type="submit" class="btn btn-sm btn-danger-custom shadow-sm px-3">
                                        <i class="bi bi-trash3 me-1"></i>Remove
                                    </button>
                                </form>
                            </td>
                            </c:if>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty expired}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-5">
                                <div class="mb-3"><i class="bi bi-check-circle fs-1 text-success opacity-50"></i></div>
                                <h6 class="fw-medium text-dark mb-1">No expired items found</h6>
                                <p class="small mb-0">All stock is within expiry date. Great job!</p>
                            </td>
                        </tr>
                        </c:if>
                    </tbody>
                </table>
                </div>
            </div>
        </div>

        <div class="alert alert-info border-0 rounded-3 shadow-sm mt-4 d-flex align-items-start" style="background-color: #eff6ff; color: #1e3a8a;">
            <i class="bi bi-lightbulb fs-4 me-3 mt-1" style="color: #3b82f6;"></i>
            <div>
                <h6 class="fw-bold mb-2">OOP Concepts in Action</h6>
                <ul class="mb-0 small ps-3">
                    <li class="mb-1"><strong>Encapsulation:</strong> Expiry date is private inside Item class; accessed via getExpiryDate().</li>
                    <li><strong>Abstraction:</strong> ExpiryServlet uses MergeSort via InventoryService to sort and filter items.</li>
                </ul>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>