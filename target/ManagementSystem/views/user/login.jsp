<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="error" type="java.lang.String"--%>
<%--@elvariable id="success" type="java.lang.String"--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — InvenTrack</title>
    <!-- Bootstrap 5 CSS -->
    <!--suppress HtmlUnknownTarget -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <!--suppress HtmlUnknownTarget -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%); min-height: 100vh; }
        .login-card { border-radius: 16px; box-shadow: 0 20px 60px rgba(0,0,0,0.4); }
        .brand-icon { font-size: 3rem; color: #0d6efd; }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card login-card border-0">
                    <div class="card-body p-5">
                        <!-- Brand -->
                        <div class="text-center mb-4">
                            <i class="bi bi-box-seam-fill brand-icon"></i>
                            <h2 class="fw-bold mt-2">InvenTrack</h2>
                            <p class="text-muted">Inventory &amp; Stock Management</p>
                        </div>

                        <!-- Error / Success alerts -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>${success}
                            </div>
                        </c:if>

                        <!-- Login Form -->
                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" class="form-control" id="username"
                                           name="username" placeholder="Enter username" required autofocus>
                                </div>
                            </div>
                            <div class="mb-4">
                                <label for="password" class="form-label fw-semibold">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password" class="form-control" id="password"
                                           name="password" placeholder="Enter password" required>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                                <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
                            </button>
                        </form>

                        <hr class="my-4">
                        <p class="text-center text-muted mb-0">
                            Don't have an account?
                            <a href="${pageContext.request.contextPath}/register" class="text-decoration-none">Register here</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--suppress HtmlUnknownTarget -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>