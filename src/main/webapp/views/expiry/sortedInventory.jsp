<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="activePage" value="expiry" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sorted Inventory — InvenTrack</title>
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
        <h2 class="fw-bold mb-1">Sorted Inventory View</h2>
        <p class="text-muted mb-4">Component 02 — All items sorted by expiry date using Merge Sort (O(n log n))</p>

        <%-- Algorithm Info Card --%>
        <div class="card border-0 shadow-sm mb-4 border-start border-4 border-primary">
            <div class="card-body">
                <h6 class="fw-semibold text-primary"><i class="bi bi-sort-numeric-up me-2"></i>Merge Sort Applied</h6>
                <p class="mb-0 small">
                    Items below are sorted by expiry date in <strong>ascending order</strong>
                    (soonest to expire first) using a custom <code>MergeSort.sortByExpiryDate()</code>
                    implementation — O(n log n) divide-and-conquer algorithm.
                    <strong>Collections.sort() is NOT used.</strong>
                </p>
            </div>
        </div>

        <%-- Sorted Items Table --%>
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white fw-semibold d-flex justify-content-between align-items-center">
                <span><i class="bi bi-sort-up me-2"></i>Inventory Sorted by Expiry Date (${sortedItems.size()} items)</span>
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
                            <th>#</th>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Quantity</th>
                            <th>Unit Price</th>
                            <th>Expiry Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${sortedItems}" varStatus="loop">
                        <tr>
                            <td class="text-muted small">${loop.index + 1}</td>
                            <td><code class="small">${item.id}</code></td>
                            <td class="fw-semibold">${item.name}</td>
                            <td><span class="badge bg-secondary">${item.category}</span></td>
                            <td>${item.quantity}</td>
                            <td>$<fmt:formatNumber value="${item.price}" maxFractionDigits="2"/></td>
                            <td>${item.expiryDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.expiryDate lt today}">
                                        <span class="badge bg-danger">Expired</span>
                                    </c:when>
                                    <c:when test="${item.expiryDate le today30}">
                                        <span class="badge bg-warning text-dark">Expiring Soon</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success">Valid</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty sortedItems}">
                        <tr>
                            <td colspan="8" class="text-center text-muted py-4">
                                <i class="bi bi-inbox fs-3 d-block mb-2"></i>No items in inventory.
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
                <li><strong>Abstraction:</strong> MergeSort logic is fully encapsulated in the MergeSort class.</li>
                <li><strong>Encapsulation:</strong> Expiry date is private in Item; accessed via getExpiryDate().</li>
                <li><strong>Algorithm:</strong> Merge Sort O(n log n) — divide list in half, sort each half, merge back.</li>
            </ul>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
