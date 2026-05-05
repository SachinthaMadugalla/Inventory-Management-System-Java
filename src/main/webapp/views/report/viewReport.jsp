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
    <style>
        body { background-color: #f0f2f5; }
        .main-content  { margin-left: 250px; padding: 2rem; }
    </style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="/views/common/sidebar.jsp"/>

    <div class="main-content flex-grow-1">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-0">Reports</h2>
                <p class="text-muted">Generate and view sales summary reports</p>
            </div>
            <%-- Generate Report button --%>
            <form action="${pageContext.request.contextPath}/reports" method="post">
                <button type="submit" class="btn btn-info text-white">
                    <i class="bi bi-file-earmark-bar-graph me-2"></i>Generate New Report
                </button>
            </form>
        </div>

        <c:if test="${not empty successMsg}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="bi bi-check-circle-fill me-2"></i>${successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <%-- Reports Table --%>
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white fw-semibold">
                <i class="bi bi-bar-chart-line me-2"></i>Generated Reports (${reports.size()} total)
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                        <tr>
                            <th>Report ID</th>
                            <th>Generated Date</th>
                            <th>Total Sales</th>
                            <th>Total Revenue</th>
                            <th>Top Item</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="report" items="${reports}">
                            <tr>
                                <td><code class="small">${report.reportId}</code></td>
                                <td>${report.generatedDate}</td>
                                <td><span class="badge bg-primary">${report.totalSales}</span></td>
                                <td class="text-success fw-semibold">
                                    $<fmt:formatNumber value="${report.totalRevenue}" maxFractionDigits="2"/>
                                </td>
                                <td>
                                <span class="badge bg-warning text-dark">
                                    <i class="bi bi-trophy me-1"></i>${report.topItemName}
                                </span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty reports}">
                            <tr>
                                <td colspan="5" class="text-center text-muted py-4">
                                    <i class="bi bi-file-earmark-x fs-3 d-block mb-2"></i>
                                    No reports generated yet. Click "Generate New Report" above.
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