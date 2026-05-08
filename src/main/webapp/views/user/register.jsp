<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="error" type="java.lang.String"--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — InvenTrack</title>
    <!--suppress HtmlUnknownTarget -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
        .register-card {
            border-radius: 20px;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            z-index: 10;
        }
        .brand-icon { font-size: 3rem; color: #10b981; }
        .btn-success { background-color: #10b981; border-color: #10b981; border-radius: 10px; }
        .btn-success:hover { background-color: #059669; border-color: #059669; }
        .form-control, .form-select { border-radius: 10px; padding: 0.75rem 1rem; }
        .input-group-text { border-radius: 10px 0 0 10px; background: transparent; border-right: none; }
        .form-control { border-left: none; }
        .form-control:focus, .form-select:focus { box-shadow: none; border-color: #dee2e6; }
        .input-group:focus-within { box-shadow: 0 0 0 0.25rem rgba(16, 185, 129, 0.25); border-radius: 10px; }
        .input-group:focus-within .input-group-text, .input-group:focus-within .form-control { border-color: #34d399; }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center">
    <div class="overlay"></div>
    <div class="container position-relative">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card register-card border-0">
                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <i class="bi bi-person-plus-fill brand-icon"></i>
                            <h2 class="fw-bold mt-2 text-dark">Create Account</h2>
                            <p class="text-secondary">Join InvenTrack</p>
                        </div>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger border-0 rounded-3 shadow-sm">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                            </div>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/register" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label fw-semibold text-dark">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text text-muted"><i class="bi bi-person"></i></span>
                                    <input type="text" class="form-control" id="username"
                                           name="username" placeholder="Choose a username" required autofocus>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label fw-semibold text-dark">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text text-muted"><i class="bi bi-lock"></i></span>
                                    <input type="password" class="form-control" id="password"
                                           name="password" placeholder="Choose a password" required>
                                </div>
                            </div>
                            <div class="mb-4">
                                <label for="role" class="form-label fw-semibold text-dark">Role</label>
                                <select class="form-select" id="role" name="role">
                                    <option value="user" selected>User</option>
                                    <option value="admin">Admin</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success w-100 py-2 fw-semibold shadow-sm">
                                <i class="bi bi-person-check me-2"></i>Register
                            </button>
                        </form>
                        <hr class="my-4">
                        <p class="text-center text-secondary mb-0">
                            Already have an account?
                            <a href="${pageContext.request.contextPath}/login" class="text-success fw-semibold text-decoration-none">Sign in</a>
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