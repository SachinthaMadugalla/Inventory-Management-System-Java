<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="activePage" value="expiry" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expiry Management — InvenTrack</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; }
        .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto; z-index: 100; }
        .main-content  { margin-left: 250px; padding: 2rem; }
        .expired-row   { background-color: #fff5f5 !important; }
        .warning-row   { background-color: #fffbf0 !important; }
    </style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="/views/common/sidebar.jsp"/>

    <div class="main-content flex-grow-1">
        <h2 class="fw-bold mb-1">Expiry Management</h2>
        <p class="text-muted mb-4">Component 02 — Items sorted by expiry date using custom <strong>MergeSort O(n log n)</strong>.</p>

        <%-- Algorithm Info --%>
        <div class="alert alert-primary mb-4">
            <h6 class="fw-bold"><i class="bi bi-sort-numeric-up me-2"></i>MergeSort Algorithm Active</h6>
            <p class="mb-0 small">
                Items below are sorted by <code>expiryDate</code> (YYYY-MM-DD) in ascending order using a
                hand-written divide-and-conquer Merge Sort — <strong>NOT</strong> <code>Collections.sort()</code>.
                Time complexity: <strong>O(n log n)</strong> guaranteed.
            </p>
        </div>

        <%-- Summary Badges --%>
        <div class="row g-3 mb-4">
            <div class="col-auto">
                <div class="card border-danger text-danger px-3 py-2 border-0 shadow-sm">
                    <strong><i class="bi bi-x-circle me-1"></i>Expired: ${expired.size()}</strong>
                </div>
            </div>
            <div class="col-auto">
                <div class="card border-warning text-warning px-3 py-2 border-0 shadow-sm">
                    <strong><i class="bi bi-exclamation-triangle me-1"></i>Expiring Soon (≤30 days): ${expiringSoon.size()}</strong>
                </div>
            </div>
            <div class="col-auto">
                <div class="card border-success text-success px-3 py-2 border-0 shadow-sm">
                    <strong><i class="bi bi-check-circle me-1"></i>Total Sorted: ${sortedItems.size()}</strong>
                </div>
            </div>
        </div>

        <%-- Sorted Items Table --%>
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-table me-2"></i>All Items — Sorted by Expiry Date (Ascending)
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
                            <th>Expiry Date</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="rank" value="1"/>
                        <c:forEach var="item" items="${sortedItems}">
                        <%-- Determine row class based on expiry status --%>
                        <c:set var="rowClass" value=""/>
                        <c:forEach var="exp" items="${expired}">
                            <c:if test="${exp.id == item.id}"><c:set var="rowClass" value="expired-row"/></c:if>
                        </c:forEach>
                        <c:forEach var="soon" items="${expiringSoon}">
                            <c:if test="${soon.id == item.id && empty rowClass}"><c:set var="rowClass" value="warning-row"/></c:if>
                        </c:forEach>

                        <tr class="${rowClass}">
                            <td class="text-muted small">${rank}</td>
                            <td><code class="small">${item.id}</code></td>
                            <td class="fw-semibold">${item.name}</td>
                            <td><span class="badge bg-secondary">${item.category}</span></td>
                            <td>${item.quantity}</td>
                            <td><strong>${item.expiryDate}</strong></td>
                            <td>
                                <c:set var="isExpired" value="false"/>
                                <c:forEach var="exp" items="${expired}">
                                    <c:if test="${exp.id == item.id}"><c:set var="isExpired" value="true"/></c:if>
                                </c:forEach>
                                <c:set var="isSoon" value="false"/>
                                <c:forEach var="soon" items="${expiringSoon}">
                                    <c:if test="${soon.id == item.id}"><c:set var="isSoon" value="true"/></c:if>
                                </c:forEach>

                                <c:choose>
                                    <c:when test="${isExpired}">
                                        <span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i>Expired</span>
                                    </c:when>
                                    <c:when test="${isSoon}">
                                        <span class="badge bg-warning text-dark"><i class="bi bi-exclamation-triangle me-1"></i>Expiring Soon</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Good</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <c:set var="rank" value="${rank + 1}"/>
                        </c:forEach>
                        <c:if test="${empty sortedItems}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                <i class="bi bi-inbox fs-3 d-block mb-2"></i>No items to display.
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>