<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="expiry" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expired Items — InvenTrack</title>
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
        <h2 class="fw-bold mb-1">Expired Items</h2>
        <p class="text-muted mb-4">Component 02 — Items past their expiry date requiring immediate action</p>

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <%-- Summary Banner --%>
        <div class="card border-0 shadow-sm mb-4 bg-danger text-white">
            <div class="card-body d-flex justify-content-between align-items-center">
                <div>
                    <div class="fs-4 fw-bold">${expired.size()} Expired Item(s)</div>
                    <div class="small">These items are past their expiry date and should be removed</div>
                </div>
                <i class="bi bi-exclamation-triangle-fill" style="font-size:3rem; opacity:0.6;"></i>
            </div>
        </div>

        <%-- Expired Items Table --%>
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white fw-semibold d-flex justify-content-between align-items-center">
                <span><i class="bi bi-calendar-x me-2 text-danger"></i>Expired Stock</span>
                <a href="${pageContext.request.contextPath}/expiryManagement"
                   class="btn btn-sm btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i>Back to Expiry Management
                </a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Quantity</th>
                            <th>Unit Price</th>
                            <th>Expiry Date</th>
                            <c:if test="${sessionScope.role == 'admin'}">
                            <th class="text-center">Action</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${expired}">
                        <tr class="table-danger">
                            <td><code class="small">${item.id}</code></td>
                            <td class="fw-semibold">${item.name}</td>
                            <td><span class="badge bg-secondary">${item.category}</span></td>
                            <td>${item.quantity}</td>
                            <td>$<fmt:formatNumber value="${item.price}" maxFractionDigits="2"/></td>
                            <td>
                                <span class="badge bg-danger">
                                    <i class="bi bi-calendar-x me-1"></i>${item.expiryDate}
                                </span>
                            </td>
                            <c:if test="${sessionScope.role == 'admin'}">
                            <td class="text-center">
                                <form action="${pageContext.request.contextPath}/deleteStock"
                                      method="post" class="d-inline"
                                      onsubmit="return confirm('Permanently remove expired item: ${item.name}?');">
                                    <input type="hidden" name="mode"   value="byId">
                                    <input type="hidden" name="itemId" value="${item.id}">
                                    <button type="submit" class="btn btn-sm btn-danger">
                                        <i class="bi bi-trash me-1"></i>Remove
                                    </button>
                                </form>
                            </td>
                            </c:if>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty expired}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                <i class="bi bi-check-circle fs-3 d-block mb-2 text-success"></i>
                                No expired items found. All stock is within expiry date.
                            </td>
                        </tr>
                        </c:if>
                    </tbody>
                </table>
                </div>
            </div>
        </div>

        <div class="alert alert-info mt-4">
            <h6 class="fw-bold"><i class="bi bi-info-circle me-2"></i>OOP Concepts in Action</h6>
            <ul class="mb-0 small">
                <li><strong>Encapsulation:</strong> Expiry date is private inside Item class; accessed via getExpiryDate().</li>
                <li><strong>Abstraction:</strong> ExpiryServlet uses MergeSort via InventoryService to sort and filter items.</li>
            </ul>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
