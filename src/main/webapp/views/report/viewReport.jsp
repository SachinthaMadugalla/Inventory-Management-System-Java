<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%--@elvariable id="successMsg" type="java.lang.String"--%>
<%--@elvariable id="reports" type="java.util.List"--%>
<c:set var="activePage" value="reports" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports — InvenTrack</title>
    <!--suppress HtmlUnknownTarget -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!--suppress HtmlUnknownTarget -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; }
        .main-content  { margin-left: 260px; padding: 2.5rem; }
        .card-custom { border-radius: 16px; border: none; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03); }
        .table-custom th { text-transform: uppercase; font-size: 0.75rem; letter-spacing: 0.05em; color: #64748b; background-color: #f1f5f9; border-bottom: none; padding: 1rem; }
        .table-custom td { padding: 1rem; vertical-align: middle; border-bottom: 1px solid #e2e8f0; color: #334155; }
        .btn-info { background-color: #0ea5e9; border-color: #0ea5e9; border-radius: 10px; font-weight: 500; }
        .btn-info:hover { background-color: #0369a1; border-color: #0369a1; }
    </style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="/views/common/sidebar.jsp"/>

    <div class="main-content flex-grow-1">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-1" style="color: #0f172a;">Sales Reports</h2>
                <p class="text-muted mb-0">Generate and view sales summary reports</p>
            </div>
            <%-- Generate Report button --%>
            <form action="${pageContext.request.contextPath}/reports" method="post">
                <button type="submit" class="btn btn-info text-white px-4 py-2 shadow-sm">
                    <i class="bi bi-file-earmark-bar-graph me-2"></i>Generate New Report
                </button>
            </form>
        </div>

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success alert-dismissible fade show border-0 rounded-3 shadow-sm">
                <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <%-- Reports Table --%>
        <div class="card card-custom">
            <div class="card-header bg-transparent border-0 pt-4 pb-3 px-4">
                <h5 class="fw-bold mb-0" style="color: #0f172a;">
                    <i class="bi bi-bar-chart-line me-2 text-info"></i>Generated Reports <span class="badge rounded-pill ms-2" style="background-color: #e2e8f0; color: #475569;">${reports.size()} total</span>
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-custom align-middle mb-0">
                        <thead>
                        <tr>
                            <th class="ps-4">Report ID</th>
                            <th>Generated Date</th>
                            <th>Total Sales</th>
                            <th>Total Revenue</th>
                            <th class="pe-4">Top Selling Item</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="report" items="${reports}">
                            <tr>
                                <td class="ps-4"><code class="px-2 py-1 rounded" style="background-color: #f1f5f9; color: #64748b;">${report.reportId}</code></td>
                                <td><span class="text-secondary"><i class="bi bi-clock me-2 small"></i>${report.generatedDate}</span></td>
                                <td><span class="badge rounded-pill px-3 py-2" style="background-color: #e0f2fe; color: #0369a1;">${report.totalSales} sales</span></td>
                                <td class="text-success fw-bold fs-5">
                                    $<fmt:formatNumber value="${report.totalRevenue}" maxFractionDigits="2"/>
                                </td>
                                <td class="pe-4">
                                <span class="badge rounded-pill px-3 py-2" style="background-color: #fffbeb; color: #b45309;">
                                    <i class="bi bi-trophy-fill me-1"></i>${report.topItemName}
                                </span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty reports}">
                            <tr>
                                <td colspan="5" class="text-center text-muted py-5">
                                    <div class="mb-3"><i class="bi bi-file-earmark-x fs-1 text-black-50 opacity-25"></i></div>
                                    <h6 class="fw-medium text-dark mb-1">No reports generated yet</h6>
                                    <p class="small mb-0">Click "Generate New Report" above to create your first sales summary.</p>
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
<!--suppress HtmlUnknownTarget -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>