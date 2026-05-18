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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .sidebar-fixed { position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto; z-index: 100; }
        .main-content  { margin-left: 260px; padding: 2.5rem; }
        .card-custom { border-radius: 16px; border: none; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03); }
        .expired-row td { background-color: #fef2f2 !important; color: #991b1b; }
        .warning-row td { background-color: #fffbeb !important; }
        .table-custom th { text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; color: #64748b; background-color: #f1f5f9; border-bottom: none; padding: 1rem; }
        .table-custom td { padding: 1rem; vertical-align: middle; border-bottom: 1px solid #e2e8f0; }
        .summary-card { border-radius: 16px; border: none; transition: transform 0.2s; }
        .summary-card:hover { transform: translateY(-3px); }
    </style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="/views/common/sidebar.jsp"/>

    <div class="main-content flex-grow-1">
        <h2 class="fw-bold mb-1" style="color: #0f172a;">Expiry Management</h2>
        <p class="text-muted mb-4">Component 02 — Items sorted by expiry date using custom <strong>MergeSort O(n log n)</strong>.</p>

        <%-- Algorithm Info --%>
        <div class="alert alert-info border-0 rounded-3 shadow-sm mb-4 d-flex align-items-start" style="background-color: #eff6ff; color: #1e3a8a;">
            <i class="bi bi-sort-numeric-down fs-4 me-3 mt-1" style="color: #3b82f6;"></i>
            <div>
                <h6 class="fw-bold mb-1">MergeSort Algorithm Active</h6>
                <p class="mb-0 small">
                    Items below are sorted by <code>expiryDate</code> (YYYY-MM-DD) in ascending order using a
                    hand-written divide-and-conquer Merge Sort — <strong>NOT</strong> <code>Collections.sort()</code>.
                    Time complexity: <strong>O(n log n)</strong> guaranteed.
                </p>
            </div>
        </div>

        <%-- Summary Badges --%>
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card summary-card shadow-sm h-100" style="background: linear-gradient(135deg, #ef4444 0%, #b91c1c 100%); color: white;">
                    <div class="card-body p-4 d-flex align-items-center position-relative overflow-hidden">
                        <div style="z-index: 2;">
                            <h6 class="text-uppercase fw-bold mb-1" style="color: #fca5a5; font-size: 0.8rem; letter-spacing: 1px;">Expired Items</h6>
                            <h2 class="display-5 fw-bold mb-0">${expired.size()}</h2>
                        </div>
                        <i class="bi bi-x-octagon position-absolute" style="font-size: 5rem; opacity: 0.15; right: -10px; bottom: -15px;"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card summary-card shadow-sm h-100" style="background: linear-gradient(135deg, #f59e0b 0%, #b45309 100%); color: white;">
                    <div class="card-body p-4 d-flex align-items-center position-relative overflow-hidden">
                        <div style="z-index: 2;">
                            <h6 class="text-uppercase fw-bold mb-1" style="color: #fde68a; font-size: 0.8rem; letter-spacing: 1px;">Expiring Soon (&le;30 days)</h6>
                            <h2 class="display-5 fw-bold mb-0">${expiringSoon.size()}</h2>
                        </div>
                        <i class="bi bi-exclamation-triangle position-absolute" style="font-size: 5rem; opacity: 0.15; right: -10px; bottom: -15px;"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card summary-card shadow-sm h-100" style="background: linear-gradient(135deg, #10b981 0%, #047857 100%); color: white;">
                    <div class="card-body p-4 d-flex align-items-center position-relative overflow-hidden">
                        <div style="z-index: 2;">
                            <h6 class="text-uppercase fw-bold mb-1" style="color: #a7f3d0; font-size: 0.8rem; letter-spacing: 1px;">Total Sorted Items</h6>
                            <h2 class="display-5 fw-bold mb-0">${sortedItems.size()}</h2>
                        </div>
                        <i class="bi bi-check2-all position-absolute" style="font-size: 5rem; opacity: 0.15; right: -10px; bottom: -15px;"></i>
                    </div>
                </div>
            </div>
        </div>

        <%-- Sorted Items Table --%>
        <div class="card card-custom">
            <div class="card-header bg-transparent border-0 pt-4 pb-3 px-4">
                <h5 class="fw-bold mb-0" style="color: #0f172a;"><i class="bi bi-calendar-event me-2 text-primary"></i>All Items — Sorted by Expiry Date (Ascending)</h5>
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
                            <th>Expiry Date</th>
                            <th class="pe-4">Status</th>
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
                            <td class="ps-4 fw-semibold text-muted">#${rank}</td>
                            <td><code class="px-2 py-1 rounded" style="background-color: rgba(0,0,0,0.05); color: inherit;">${item.id}</code></td>
                            <td class="fw-bold" style="color: ${empty rowClass ? '#334155' : 'inherit'};">${item.name}</td>
                            <td><span class="badge rounded-pill" style="background-color: rgba(0,0,0,0.05); color: ${empty rowClass ? '#475569' : 'inherit'}; border: 1px solid rgba(0,0,0,0.1);">${item.category}</span></td>
                            <td class="fw-medium">${item.quantity} units</td>
                            <td><strong class="font-monospace">${item.expiryDate}</strong></td>
                            <td class="pe-4">
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
                                        <span class="badge rounded-pill bg-danger-subtle text-danger px-3 py-2"><i class="bi bi-x-octagon-fill me-1"></i>Expired</span>
                                    </c:when>
                                    <c:when test="${isSoon}">
                                        <span class="badge rounded-pill bg-warning-subtle text-warning-emphasis px-3 py-2"><i class="bi bi-exclamation-triangle-fill me-1"></i>Expiring Soon</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge rounded-pill bg-success-subtle text-success px-3 py-2"><i class="bi bi-check-circle-fill me-1"></i>Good</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <c:set var="rank" value="${rank + 1}"/>
                        </c:forEach>
                        <c:if test="${empty sortedItems}">
                        <tr>
                            <td colspan="7" class="text-center text-muted py-5">
                                <div class="mb-3"><i class="bi bi-calendar-x fs-1 text-black-50 opacity-25"></i></div>
                                <h6 class="fw-medium text-dark mb-1">No items found</h6>
                                <p class="small mb-0">There are no items in inventory to sort.</p>
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