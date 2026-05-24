<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="activePage" value="editProfile" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile — Lumenara</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=Outfit:wght@300;400;500;600&family=JetBrains+Mono:wght@400;500&display=swap');

        :root {
            --bg-0:   #050810;
            --bg-1:   #090E1C;
            --bg-2:   #0D1526;
            --card:   rgba(9, 14, 28, 0.82);
            --card-h: rgba(12, 19, 38, 0.95);

            --green:  #00E896;
            --g-dim:  rgba(0,232,150,0.10);
            --g-glow: rgba(0,232,150,0.38);
            --g-soft: rgba(0,232,150,0.20);

            --violet: #7C3AED;
            --v-dim:  rgba(124,58,237,0.10);
            --v-glow: rgba(124,58,237,0.35);

            --blue:   #38BDF8;
            --b-dim:  rgba(56,189,248,0.10);
            --b-glow: rgba(56,189,248,0.30);

            --amber:  #FBBF24;
            --a-dim:  rgba(251,191,36,0.10);
            --a-glow: rgba(251,191,36,0.30);

            --red:    #F87171;
            --r-dim:  rgba(248,113,113,0.10);
            --r-glow: rgba(248,113,113,0.28);

            --tx1: #ECF0FF;
            --tx2: #7A8BA6;
            --tx3: #3A4A5E;

            --bd:  rgba(255,255,255,0.065);
            --bd2: rgba(255,255,255,0.12);
            --bdg: rgba(0,232,150,0.20);
            --bdv: rgba(124,58,237,0.22);
        }
        body {
            font-family: 'Outfit', system-ui, sans-serif;
            background-color: var(--bg-0);
            background-image: radial-gradient(circle at 1px 1px, rgba(255,255,255,0.035) 1px, transparent 0);
            background-size: 28px 28px;
            color: var(--tx1);
            overflow-x: hidden;
        }
        body::before {
            content: '';
            position: fixed; top: -220px; right: -160px;
            width: 720px; height: 720px; border-radius: 50%;
            background: radial-gradient(circle, rgba(0,232,150,0.07) 0%, transparent 68%);
            animation: orb1 26s ease-in-out infinite;
            pointer-events: none; z-index: 0;
        }
        body::after {
            content: '';
            position: fixed; bottom: -200px; left: -160px;
            width: 640px; height: 640px; border-radius: 50%;
            background: radial-gradient(circle, rgba(124,58,237,0.07) 0%, transparent 68%);
            animation: orb2 32s ease-in-out infinite;
            pointer-events: none; z-index: 0;
        }

        @keyframes orb1 {
            0%,100% { transform: translate(0,0)   scale(1);    }
            35%     { transform: translate(55px,-70px) scale(1.07); }
            70%     { transform: translate(-45px, 60px) scale(0.94); }
        }
        @keyframes orb2 {
            0%,100% { transform: translate(0,0)   scale(1);    }
            40%     { transform: translate(-65px,-55px) scale(1.06); }
            75%     { transform: translate(75px,  65px) scale(0.93); }
        }
        @keyframes fadeUp {
            from { opacity:0; transform:translateY(18px); }
            to   { opacity:1; transform:translateY(0);    }
        }
        @keyframes fadeIn {
            from { opacity:0; }
            to   { opacity:1; }
        }
        @keyframes slideLeft {
            from { opacity:0; transform:translateX(-18px); }
            to   { opacity:1; transform:translateX(0);     }
        }
        @keyframes glowPulse {
            0%,100% { box-shadow: 0 0 8px  var(--g-glow); }
            50%     { box-shadow: 0 0 22px var(--g-glow), 0 0 44px var(--g-soft); }
        }
        @keyframes iconGlow {
            0%,100% { box-shadow: 0 4px 14px var(--g-glow); }
            50%     { box-shadow: 0 4px 28px var(--g-glow), 0 0 56px var(--g-soft); }
        }
        @keyframes shimmerSweep {
            0%   { left: -80%; }
            100% { left: 140%; }
        }
        @keyframes rippleGrow {
            to { transform: scale(3.5); opacity:0; }
        }
        @keyframes statusPulse {
            0%,100% { opacity:1; }
            50%     { opacity:0.35; }
        }
        @keyframes scanLine {
            0%   { transform: translateY(-100%); opacity:0;   }
            8%   { opacity:.35; }
            92%  { opacity:.35; }
            100% { transform: translateY(500%);  opacity:0;   }
        }

        .d-flex { position:relative; z-index:1; }
        .main-content {
            margin-left: 256px;
            padding: 28px 36px;
            animation: fadeIn .45s ease;
            width: 100%;
            transition: margin-left 0.3s ease-in-out;
        }

        .topbar {
            display:flex;
            justify-content:space-between;
            align-items:center;
            gap:16px;
            margin-bottom:26px;
            padding:18px 24px;
            background:var(--card);
            backdrop-filter:blur(24px);
            -webkit-backdrop-filter:blur(24px);
            border:1px solid var(--bd);
            border-radius:20px;
            box-shadow:0 4px 28px rgba(0,0,0,.3);
            animation: fadeUp .4s ease .04s both;
        }
        .topbar-header {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .menu-toggle {
            display: none;
            background: transparent;
            border: none;
            color: var(--tx1);
            font-size: 24px;
            cursor: pointer;
            padding: 0;
        }
        .topbar h2 {
            font-family:'Syne',sans-serif;
            font-size:22px;
            font-weight:800;
            margin:0 0 2px;
            letter-spacing:-.5px;
            background:linear-gradient(120deg,var(--tx1) 50%,var(--green));
            -webkit-background-clip:text;
            -webkit-text-fill-color:transparent;
            background-clip:text;
        }
        .card {
            background:var(--card) !important;
            backdrop-filter:blur(18px);
            -webkit-backdrop-filter:blur(18px);
            border:1px solid var(--bd) !important;
            border-radius:18px !important;
            box-shadow:0 4px 24px rgba(0,0,0,.22) !important;
            animation: fadeUp .4s ease both;
        }
        .card-body { padding:22px !important; }
        .form-control, .form-select {
            font-family:'Outfit',sans-serif !important;
            background:rgba(255,255,255,.04) !important;
            border:1px solid var(--bd2) !important;
            border-radius:12px !important;
            padding:11px 14px !important;
            font-size:14px !important;
            color:var(--tx1) !important;
        }
        .form-control:focus, .form-select:focus {
            background:rgba(0,232,150,.04) !important;
            border-color:var(--green) !important;
            box-shadow:0 0 0 3px var(--g-dim) !important;
        }
        .form-label {
            font-family:'Outfit',sans-serif !important;
            font-weight:600 !important;
            font-size:11px !important;
            text-transform:uppercase;
            letter-spacing:.7px;
            color:var(--tx2) !important;
        }
        .btn-primary {
            background:var(--green) !important;
            border-color:var(--green) !important;
            color:#040A14 !important;
            font-weight:700 !important;
        }

        .alert {
            border-radius:14px !important;
            padding:14px 18px !important; font-size:13.5px;
            border:1px solid transparent !important;
            backdrop-filter:blur(8px);
        }
        .alert-success { background:var(--g-dim) !important; color:var(--green)  !important; border-color:var(--bdg) !important; }
        .alert-danger  { background:var(--r-dim) !important; color:var(--red)    !important; border-color:rgba(248,113,113,.2) !important; }

        @media (max-width: 992px) {
            .sidebar-fixed {
                transform: translateX(-100%);
            }
            .sidebar-fixed.show {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0 !important;
                padding: 16px !important;
            }
            .menu-toggle {
                display: block;
            }
        }
    </style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="/views/common/sidebar.jsp"/>
    <div class="main-content flex-grow-1">
        <div class="topbar">
            <div class="topbar-header">
                <button class="menu-toggle d-lg-none" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebar" aria-controls="sidebar">
                    <i class="bi bi-list"></i>
                </button>
                <div>
                    <h2>Edit Profile</h2>
                </div>
            </div>
        </div>

        <div class="card" style="max-width: 600px;">
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/editProfile" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username" value="${user.username}" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email Address</label>
                        <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                    </div>
                    <hr>
                    <h5 class="mt-4">Change Password</h5>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">New Password</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword">
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm New Password</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                    </div>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>