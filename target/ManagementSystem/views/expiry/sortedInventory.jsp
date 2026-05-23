<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="activePage" value="expiry" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sorted Inventory — InvenTrack</title>
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
        .status-expired { background-color: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .status-warning { background-color: #fffbeb; color: #b45309; border: 1px solid #fde68a; }
        .status-valid { background-color: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
    </style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="/views/common/sidebar.jsp"/>

    <div class="main-content flex-grow-1">
        <h2 class="fw-bold mb-1" style="color: #0f172a;">Sorted Inventory View</h2>
        <p class="text-muted mb-4">Component 02 — All items sorted by expiry date using Merge Sort (O(n log n))</p>

        <%-- Algorithm Info Card --%>
        <div class="card card-custom border-start border-4 mb-4" style="border-left-color: #4f46e5 !important;">
            <div class="card-body p-4">
                <h6 class="fw-bold text-uppercase mb-2" style="color: #3730a3; font-size: 0.8rem; letter-spacing: 0.05em;">
                    <i class="bi bi-sort-numeric-down me-2"></i>Merge Sort Applied
                </h6>
                <p class="mb-0 text-secondary">
                    Items below are sorted by expiry date in <strong>ascending order</strong>
                    (soonest to expire first) using a custom <code>MergeSort.sortByExpiryDate()</code>
                    implementation — O(n log n) divide-and-conquer algorithm.
                    <span class="badge rounded-pill px-2 py-1 ms-1" style="background-color: #e0e7ff; color: #3730a3;">Collections.sort() is NOT used.</span>
                </p>
            </div>
        </div>

        <%-- Sorted Items Table --%>
        <div class="card card-custom">
            <div class="card-header bg-transparent border-0 pt-4 pb-3 px-4 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0" style="color: #0f172a;">
                    <i class="bi bi-sort-down me-2" style="color: #4f46e5;"></i>Inventory Sorted by Expiry Date <span class="badge rounded-pill ms-2" style="background-color: #e2e8f0; color: #475569;">${sortedItems.size()} items</span>
                </h5>
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
                            <th class="ps-4">Rank</th>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Quantity</th>
                            <th>Unit Price</th>
                            <th>Expiry Date</th>
                            <th class="pe-4">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${sortedItems}" varStatus="loop">
                        <tr>
                            <td class="ps-4 fw-semibold text-muted">#${loop.index + 1}</td>
                            <td><code class="px-2 py-1 rounded" style="background-color: #f1f5f9; color: #475569;">${item.id}</code></td>
                            <td class="fw-bold text-dark">${item.name}</td>
                            <td><span class="badge rounded-pill" style="background-color: #f1f5f9; color: #475569;">${item.category}</span></td>
                            <td class="fw-medium">${item.quantity} units</td>
                            <td class="fw-medium">$<fmt:formatNumber value="${item.price}" maxFractionDigits="2"/></td>
                            <td><strong class="font-monospace text-dark">${item.expiryDate}</strong></td>
                            <td class="pe-4">
                                <c:choose>
                                    <c:when test="${item.expiryDate lt today}">
                                        <span class="badge rounded-pill status-expired px-3 py-2"><i class="bi bi-x-circle-fill me-1"></i>Expired</span>
                                    </c:when>
                                    <c:when test="${item.expiryDate le today30}">
                                        <span class="badge rounded-pill status-warning px-3 py-2"><i class="bi bi-exclamation-triangle-fill me-1"></i>Expiring Soon</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge rounded-pill status-valid px-3 py-2"><i class="bi bi-check-circle-fill me-1"></i>Valid</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty sortedItems}">
                        <tr>
                            <td colspan="8" class="text-center text-muted py-5">
                                <div class="mb-3"><i class="bi bi-inbox fs-1 text-black-50 opacity-25"></i></div>
                                <h6 class="fw-medium text-dark mb-1">No items found</h6>
                                <p class="small mb-0">Your inventory is currently empty.</p>
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
                    <li class="mb-1"><strong>Abstraction:</strong> MergeSort logic is fully encapsulated in the MergeSort class.</li>
                    <li class="mb-1"><strong>Encapsulation:</strong> Expiry date is private in Item; accessed via getExpiryDate().</li>
                    <li><strong>Algorithm:</strong> Merge Sort O(n log n) — divide list in half, sort each half, merge back.</li>
                </ul>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>