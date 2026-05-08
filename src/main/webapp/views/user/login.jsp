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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: url('https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=2070&auto=format&fit=crop') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
        }
        .overlay {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.85);
            backdrop-filter: blur(8px);
        }
        .login-card {
            border-radius: 20px;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            z-index: 10;
        }
        .brand-icon { font-size: 3.5rem; color: #4f46e5; }
        .btn-primary { background-color: #4f46e5; border-color: #4f46e5; border-radius: 10px; }
        .btn-primary:hover { background-color: #4338ca; border-color: #4338ca; }
        .form-control { border-radius: 10px; padding: 0.75rem 1rem; }
        .input-group-text { border-radius: 10px 0 0 10px; background: transparent; border-right: none; }
        .form-control { border-left: none; }
        .form-control:focus { box-shadow: none; border-color: #dee2e6; }
        .input-group:focus-within { box-shadow: 0 0 0 0.25rem rgba(79, 70, 229, 0.25); border-radius: 10px; }
        .input-group:focus-within .input-group-text, .input-group:focus-within .form-control { border-color: #818cf8; }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center">
    <div class="overlay"></div>
    <div class="container position-relative">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card login-card border-0">
                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <i class="bi bi-box-seam-fill brand-icon"></i>
                            <h2 class="fw-bold mt-2 text-dark">InvenTrack</h2>
                            <p class="text-secondary">Inventory &amp; Stock Management</p>
                        </div>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show border-0 rounded-3 shadow-sm" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success border-0 rounded-3 shadow-sm" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>${success}
                            </div>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold text-dark">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text text-muted"><i class="bi bi-person"></i></span>
                                    <input type="text" class="form-control" id="username"
                                           name="username" placeholder="Enter username" required autofocus>
                                </div>
                            </div>
                            <div class="mb-4">
                                <label for="password" class="form-label fw-semibold text-dark">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text text-muted"><i class="bi bi-lock"></i></span>
                                    <input type="password" class="form-control" id="password"
                                           name="password" placeholder="Enter password" required>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold shadow-sm">
                                <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
                            </button>
                        </form>
                        <hr class="my-4">
                        <p class="text-center text-secondary mb-0">
                            Don't have an account?
                            <a href="${pageContext.request.contextPath}/register" class="text-primary fw-semibold text-decoration-none">Register here</a>
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