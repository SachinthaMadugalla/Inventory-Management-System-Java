<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="activePage" value="expiry" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expiry Management — InvenTrack</title>
    <!--suppress HtmlUnknownTarget -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!--suppress HtmlUnknownTarget -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        /* ============================================================
           InvenTrack — Midnight Ops Theme
           Palette : Dark Navy + Electric Forest Green + Deep Violet
           Fonts   : Syne (display) · Outfit (body) · JetBrains Mono
           ============================================================ */

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

        /* ===========================  BASE  =========================== */
        *, *::before, *::after { box-sizing: border-box; }

        html { scroll-behavior: smooth; }

        body {
            font-family: 'Outfit', system-ui, sans-serif;
            background-color: var(--bg-0);
            background-image: radial-gradient(circle at 1px 1px, rgba(255,255,255,0.035) 1px, transparent 0);
            background-size: 28px 28px;
            color: var(--tx1);
            min-height: 100vh;
            margin: 0; padding: 0;
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

        /* ===========================  KEYFRAMES  =========================== */
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

        /* ===========================  LAYOUT  =========================== */
        .d-flex { position:relative; z-index:1; }
        .main-content {
            margin-left: 256px;
            padding: 28px 36px;
            animation: fadeIn .45s ease;
            width: 100%;
        }

        /* ===========================  SIDEBAR  =========================== */
        .sidebar-fixed {
            position: fixed !important;
            top:0; left:0; width:256px !important; height:100vh;
            overflow-y: auto; z-index:100;
            background: rgba(5,8,16,0.94) !important;
            backdrop-filter: blur(28px);
            -webkit-backdrop-filter: blur(28px);
            border-right: 1px solid var(--bd2) !important;
            padding: 26px 18px !important;
            display: flex; flex-direction:column;
            color: var(--tx1) !important;
            animation: slideLeft .4s ease;
            transition: transform 0.3s ease-in-out;
        }
        .sidebar-fixed::-webkit-scrollbar { width:3px; }
        .sidebar-fixed::-webkit-scrollbar-thumb { background: var(--bd2); border-radius:2px; }

        .sidebar-brand {
            display:flex; align-items:center; gap:12px;
            padding:6px 10px; color:var(--tx1) !important;
            text-decoration:none; margin-bottom:6px;
            transition:opacity .2s;
        }
        .sidebar-brand:hover { opacity:.8; }
        .sidebar-brand-icon {
            width:38px; height:38px; border-radius:11px;
            background: linear-gradient(140deg, var(--green), rgba(0,232,150,.5));
            display:flex; align-items:center; justify-content:center;
            font-size:18px; color:#fff; flex-shrink:0;
            animation: iconGlow 3.5s ease-in-out infinite;
        }
        .sidebar-brand-text {
            font-family:'Syne',sans-serif;
            font-size:18px; font-weight:800; letter-spacing:-.4px;
            background: linear-gradient(120deg, var(--tx1) 40%, var(--green));
            -webkit-background-clip:text; -webkit-text-fill-color:transparent;
            background-clip:text;
        }
        .sidebar-section-label {
            font-family:'Outfit',sans-serif;
            font-size:9.5px; font-weight:600;
            letter-spacing:1.4px; text-transform:uppercase;
            color: var(--tx3); padding:16px 12px 7px;
        }
        .nav-pills .nav-link {
            font-family:'Outfit',sans-serif;
            display:flex; align-items:center; gap:12px;
            padding:10px 14px; margin-bottom:3px;
            border-radius:12px; border:none;
            color:var(--tx2) !important;
            font-size:14px; font-weight:500;
            transition: all .18s ease;
            text-decoration:none !important;
            position:relative; overflow:hidden;
        }
        .nav-pills .nav-link i { font-size:15px; width:17px; flex-shrink:0; }
        .nav-pills .nav-link:hover {
            color:var(--tx1) !important;
            background:rgba(255,255,255,.04) !important;
            transform:translateX(2px);
        }
        .nav-pills .nav-link.active {
            color: var(--green) !important;
            background: var(--g-dim) !important;
            border-left: 3px solid var(--green) !important;
            padding-left:11px !important;
            animation: glowPulse 3.2s ease infinite;
        }
        .nav-pills .nav-link.active i { color:var(--green) !important; }
        /* shimmer on active nav item */
        .nav-pills .nav-link.active::after {
            content:'';
            position:absolute; top:0; width:40%; height:100%;
            background:linear-gradient(90deg,transparent,rgba(0,232,150,.08),transparent);
            animation: shimmerSweep 3.5s ease-in-out infinite;
        }
        .sidebar-userbox {
            background: rgba(255,255,255,.03);
            border:1px solid var(--bd); border-radius:12px;
            padding:12px; margin-bottom:4px;
        }
        .sidebar-userbox .u-name { font-size:13px; font-weight:600; color:var(--tx1); }
        .sidebar-userbox .u-role {
            display:inline-block; margin-top:5px;
            font-size:9.5px; font-weight:600; text-transform:uppercase; letter-spacing:.7px;
            padding:3px 9px; border-radius:999px;
            background:var(--g-dim); color:var(--green); border:1px solid var(--bdg);
        }
        .sidebar-fixed .btn-outline-danger {
            background:transparent !important;
            border:1px solid rgba(248,113,113,.2) !important;
            color:var(--red) !important; border-radius:12px !important;
            font-weight:600 !important; font-size:13px !important;
            transition:all .2s !important;
        }
        .sidebar-fixed .btn-outline-danger:hover {
            background:var(--r-dim) !important;
            border-color:var(--red) !important;
            box-shadow:0 0 14px var(--r-glow) !important;
        }

        /* ===========================  TOPBAR  =========================== */
        .topbar {
            display:flex; justify-content:space-between; align-items:center;
            gap:16px; margin-bottom:26px;
            padding:18px 24px;
            background:var(--card);
            backdrop-filter:blur(24px); -webkit-backdrop-filter:blur(24px);
            border:1px solid var(--bd); border-radius:20px;
            box-shadow:0 4px 28px rgba(0,0,0,.3);
            animation: fadeUp .4s ease .04s both;
            position:relative; overflow:hidden;
        }
        .topbar::after {
            content:'';
            position:absolute; bottom:0; left:0; right:0; height:1px;
            background:linear-gradient(90deg,transparent,var(--bdg),transparent);
        }
        .topbar-header {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .topbar h2 {
            font-family:'Syne',sans-serif;
            font-size:22px; font-weight:800; margin:0 0 2px;
            letter-spacing:-.5px;
            background:linear-gradient(120deg,var(--tx1) 50%,var(--green));
            -webkit-background-clip:text; -webkit-text-fill-color:transparent;
            background-clip:text;
        }
        .topbar .topbar-sub { font-size:13px; color:var(--tx2); margin:0; }
        .topbar-actions { display:flex; gap:10px; align-items:center; flex-shrink:0; flex-wrap:wrap; }
        .user-pill {
            display:flex; align-items:center; gap:10px;
            padding:6px 14px 6px 6px;
            background:rgba(255,255,255,.04);
            border:1px solid var(--bd2); border-radius:999px;
        }
        .user-pill-avatar {
            width:32px; height:32px; border-radius:50%;
            background:linear-gradient(140deg,var(--green),var(--violet));
            color:#fff; display:flex; align-items:center; justify-content:center;
            font-weight:700; font-size:13px;
        }
        .user-pill-name { font-size:13px; font-weight:600; color:var(--tx1); line-height:1.2; }
        .user-pill-role { font-size:10px; color:var(--green); line-height:1.2; font-weight:600; letter-spacing:.4px; text-transform:uppercase; }
        .menu-toggle {
            display: none;
            background: transparent;
            border: none;
            color: var(--tx1);
            font-size: 24px;
            cursor: pointer;
            padding: 0;
        }

        /* ===========================  CARDS  =========================== */
        .card {
            background:var(--card) !important;
            backdrop-filter:blur(18px); -webkit-backdrop-filter:blur(18px);
            border:1px solid var(--bd) !important;
            border-radius:18px !important;
            box-shadow:0 4px 24px rgba(0,0,0,.22) !important;
            transition:transform .25s ease, box-shadow .25s ease, border-color .25s ease;
            animation: fadeUp .4s ease both;
            position:relative; overflow:hidden;
        }
        /* scan-line sweep across each card */
        .card::before {
            content:'';
            position:absolute; top:0; left:0; right:0; height:1.5px;
            background:linear-gradient(90deg,transparent,var(--bdg),transparent);
            animation: scanLine 8s ease-in-out infinite;
            pointer-events:none; z-index:1;
        }
        .card:hover {
            transform:translateY(-3px);
            box-shadow:0 14px 44px rgba(0,0,0,.38), 0 0 0 1px var(--bdg) !important;
            border-color:var(--bdg) !important;
        }
        .card:nth-child(2) { animation-delay:.07s; }
        .card:nth-child(3) { animation-delay:.12s; }
        .card:nth-child(4) { animation-delay:.17s; }
        .card:nth-child(5) { animation-delay:.22s; }
        .card-header {
            font-family:'Syne',sans-serif;
            background:transparent !important;
            border-bottom:1px solid var(--bd) !important;
            padding:15px 22px !important;
            font-weight:700; font-size:13px; letter-spacing:.2px;
            color:var(--tx1);
            display:flex; align-items:center; justify-content:space-between;
        }
        .card-body { padding:22px !important; }
        .card-body.p-0 { padding:0 !important; }

        /* ===========================  STAT CARDS  =========================== */
        .stat-card {
            background:var(--card) !important;
            backdrop-filter:blur(20px) !important;
            border:1px solid var(--bd) !important;
            border-radius:18px !important;
            box-shadow:0 4px 24px rgba(0,0,0,.2) !important;
            color:var(--tx1) !important;
            position:relative; overflow:hidden;
            transition:transform .25s ease, box-shadow .25s ease;
        }
        .stat-card::after {
            content:''; position:absolute;
            bottom:0; left:0; right:0; height:3px;
            border-radius:0 0 18px 18px;
        }
        .stat-card:hover {
            transform:translateY(-4px) scale(1.01);
            box-shadow:0 18px 48px rgba(0,0,0,.42) !important;
        }
        .stat-card.is-green { background:rgba(0,232,150,.06) !important; border-color:var(--bdg) !important; }
        .stat-card.is-green::after { background:linear-gradient(90deg,var(--green),rgba(0,232,150,.2)); }
        .stat-card.is-violet { background:rgba(124,58,237,.06) !important; border-color:var(--bdv) !important; }
        .stat-card.is-violet::after { background:linear-gradient(90deg,var(--violet),rgba(124,58,237,.2)); }
        .stat-card.is-blue { background:rgba(56,189,248,.06) !important; border-color:rgba(56,189,248,.2) !important; }
        .stat-card.is-blue::after { background:linear-gradient(90deg,var(--blue),rgba(56,189,248,.2)); }
        .stat-card.is-amber { background:rgba(251,191,36,.06) !important; border-color:rgba(251,191,36,.2) !important; }
        .stat-card.is-amber::after { background:linear-gradient(90deg,var(--amber),rgba(251,191,36,.2)); }
        .stat-icon-badge {
            width:46px; height:46px; border-radius:13px;
            display:flex; align-items:center; justify-content:center;
            font-size:20px; margin-bottom:14px;
        }
        .is-green  .stat-icon-badge { background:var(--g-dim); color:var(--green); box-shadow:0 0 14px var(--g-soft); }
        .is-violet .stat-icon-badge { background:var(--v-dim); color:var(--violet); }
        .is-blue   .stat-icon-badge { background:var(--b-dim); color:var(--blue);   }
        .is-amber  .stat-icon-badge { background:var(--a-dim); color:var(--amber);  }
        .stat-number {
            font-family:'Syne',sans-serif;
            font-size:38px; font-weight:800; line-height:1;
            letter-spacing:-1.5px; color:var(--tx1);
            margin-bottom:7px;
        }
        .stat-label { font-size:13px; color:var(--tx2); font-weight:500; margin-bottom:12px; }
        .stat-chip {
            display:inline-flex; align-items:center; gap:5px;
            font-size:11px; font-weight:600;
            padding:4px 10px; border-radius:999px;
            background:var(--g-dim); color:var(--green);
        }

        /* ===========================  BUTTONS  =========================== */
        .btn {
            font-family:'Outfit',sans-serif !important;
            border-radius:999px !important;
            font-weight:600 !important; font-size:13.5px !important;
            padding:9px 20px !important;
            position:relative; overflow:hidden;
            transition:all .2s ease !important;
            letter-spacing:.1px;
        }
        .btn-sm { padding:6px 14px !important; font-size:12px !important; }
        .btn::before {
            content:'';
            position:absolute; top:0; width:45%; height:100%;
            background:linear-gradient(90deg,transparent,rgba(255,255,255,.12),transparent);
            transform:skewX(-18deg);
            left:-80%; transition:left .45s ease;
        }
        .btn:hover::before { left:130%; }
        .btn-primary, .btn-success {
            background:var(--green) !important; border-color:var(--green) !important;
            color:#040A14 !important; font-weight:700 !important;
            box-shadow:0 4px 18px var(--g-glow) !important;
        }
        .btn-primary:hover,.btn-success:hover {
            transform:translateY(-1px);
            box-shadow:0 8px 28px var(--g-glow),0 0 0 3px var(--g-dim) !important;
        }
        .btn-warning {
            background:var(--amber) !important; border-color:var(--amber) !important;
            color:#040A14 !important; box-shadow:0 4px 18px var(--a-glow) !important;
        }
        .btn-warning:hover { transform:translateY(-1px); box-shadow:0 8px 28px var(--a-glow) !important; }
        .btn-danger {
            background:var(--red) !important; border-color:var(--red) !important;
            color:#040A14 !important; box-shadow:0 4px 18px var(--r-glow) !important;
        }
        .btn-danger:hover { transform:translateY(-1px); box-shadow:0 8px 28px var(--r-glow) !important; }
        .btn-info {
            background:var(--blue) !important; border-color:var(--blue) !important;
            color:#040A14 !important; box-shadow:0 4px 18px var(--b-glow) !important;
        }
        .btn-info:hover, .btn-info.text-white:hover { transform:translateY(-1px); box-shadow:0 8px 28px var(--b-glow) !important; }
        .btn-info.text-white { color:#040A14 !important; }
        .btn-outline-secondary {
            background:transparent !important; border:1px solid var(--bd2) !important;
            color:var(--tx2) !important;
        }
        .btn-outline-secondary:hover { background:rgba(255,255,255,.04) !important; color:var(--tx1) !important; }
        .btn-outline-primary {
            background:transparent !important; border:1px solid var(--green) !important;
            color:var(--green) !important;
        }
        .btn-outline-primary:hover { background:var(--g-dim) !important; box-shadow:0 0 14px var(--g-soft) !important; }
        .btn-outline-warning {
            background:transparent !important; border:1px solid var(--amber) !important;
            color:var(--amber) !important;
        }
        .btn-outline-warning:hover { background:var(--a-dim) !important; }
        .btn-outline-danger {
            background:transparent !important; border:1px solid rgba(248,113,113,.3) !important;
            color:var(--red) !important;
        }
        .btn-outline-danger:hover { background:var(--r-dim) !important; }
        .btn:active { transform:scale(.97) !important; }
        .ripple {
            position:absolute; border-radius:50%;
            background:rgba(255,255,255,.18);
            transform:scale(0); animation:rippleGrow .5s linear;
            pointer-events:none;
        }

        /* ===========================  BADGES  =========================== */
        .badge {
            font-family:'Outfit',sans-serif !important;
            font-weight:600 !important; font-size:10.5px !important;
            padding:4px 10px !important; border-radius:999px !important;
            letter-spacing:.2px;
        }
        .badge.bg-primary { background:var(--g-dim) !important; color:var(--green) !important; border:1px solid var(--bdg); }
        .badge.bg-success  { background:var(--g-dim) !important; color:var(--green) !important; border:1px solid var(--bdg); }
        .badge.bg-secondary{ background:rgba(255,255,255,.05) !important; color:var(--tx2) !important; border:1px solid var(--bd); }
        .badge.bg-danger   { background:var(--r-dim) !important; color:var(--red) !important; border:1px solid rgba(248,113,113,.25); }
        .badge.bg-warning  { background:var(--a-dim) !important; color:var(--amber) !important; border:1px solid rgba(251,191,36,.25); }
        .badge.bg-info     { background:var(--b-dim) !important; color:var(--blue) !important; border:1px solid rgba(56,189,248,.25); }
        .badge.fs-6 { font-size:12.5px !important; padding:5px 12px !important; }

        /* ===========================  TABLES  =========================== */
        .table { font-size:13.5px; }
        .table thead th,
        .table thead.table-dark th,
        .table thead.table-light th {
            font-family:'Outfit',sans-serif;
            background:rgba(255,255,255,.02) !important;
            color:var(--tx3) !important;
            font-weight:600; font-size:10.5px; text-transform:uppercase; letter-spacing:.9px;
            border:none !important; border-bottom:1px solid var(--bd) !important;
            padding:13px 20px !important;
        }
        .table tbody td {
            padding:13px 20px !important; vertical-align:middle;
            border-color:var(--bd) !important; color:var(--tx1);
        }
        .table-hover tbody tr { transition:background .15s; }
        .table-hover tbody tr:hover td { background:rgba(0,232,150,.025) !important; }
        /* stagger entrance */
        .table tbody tr {
            opacity:0;
            animation:fadeUp .35s ease forwards;
        }
        .table tbody tr:nth-child(1)  { animation-delay:.04s; }
        .table tbody tr:nth-child(2)  { animation-delay:.08s; }
        .table tbody tr:nth-child(3)  { animation-delay:.12s; }
        .table tbody tr:nth-child(4)  { animation-delay:.16s; }
        .table tbody tr:nth-child(5)  { animation-delay:.20s; }
        .table tbody tr:nth-child(6)  { animation-delay:.24s; }
        .table tbody tr:nth-child(7)  { animation-delay:.28s; }
        .table tbody tr:nth-child(8)  { animation-delay:.32s; }
        .table tbody tr:nth-child(9)  { animation-delay:.36s; }
        .table tbody tr:nth-child(10) { animation-delay:.40s; }
        .table tbody tr:nth-child(11) { animation-delay:.44s; }
        .table tbody tr:nth-child(12) { animation-delay:.48s; }
        .table tbody tr:nth-child(13) { animation-delay:.52s; }
        .table tbody tr:nth-child(14) { animation-delay:.56s; }
        .table tbody tr:nth-child(15) { animation-delay:.60s; }
        .table-danger,
        .table > :not(caption) > * > .table-danger {
            background:var(--r-dim) !important; color:var(--tx1) !important;
        }

        /* ===========================  FORMS  =========================== */
        .form-control, .form-select {
            font-family:'Outfit',sans-serif !important;
            background:rgba(255,255,255,.04) !important;
            border:1px solid var(--bd2) !important;
            border-radius:12px !important;
            padding:11px 14px !important;
            font-size:14px !important; color:var(--tx1) !important;
            transition:border-color .2s, box-shadow .2s !important;
        }
        .form-control::placeholder { color:var(--tx3) !important; }
        .form-control:focus, .form-select:focus {
            background:rgba(0,232,150,.04) !important;
            border-color:var(--green) !important;
            box-shadow:0 0 0 3px var(--g-dim), 0 0 22px rgba(0,232,150,.06) !important;
            color:var(--tx1) !important;
        }
        .form-select option { background:var(--bg-1); color:var(--tx1); }
        .form-label {
            font-family:'Outfit',sans-serif !important;
            font-weight:600 !important; font-size:11px !important;
            text-transform:uppercase; letter-spacing:.7px;
            color:var(--tx2) !important; margin-bottom:7px;
        }
        .form-text { font-size:12px; color:var(--tx3); }
        .input-group-text {
            background:rgba(255,255,255,.04) !important;
            border:1px solid var(--bd2) !important;
            color:var(--tx2) !important; border-radius:12px !important;
        }

        /* ===========================  ALERTS  =========================== */
        .alert {
            border-radius:14px !important;
            padding:14px 18px !important; font-size:13.5px;
            border:1px solid transparent !important;
            backdrop-filter:blur(8px);
        }
        .alert-info    { background:var(--b-dim) !important; color:var(--blue)   !important; border-color:rgba(56,189,248,.2) !important; }
        .alert-success { background:var(--g-dim) !important; color:var(--green)  !important; border-color:var(--bdg) !important; }
        .alert-danger  { background:var(--r-dim) !important; color:var(--red)    !important; border-color:rgba(248,113,113,.2) !important; }
        .alert-primary { background:var(--g-dim) !important; color:var(--green)  !important; border-color:var(--bdg) !important; }
        .alert-warning { background:var(--a-dim) !important; color:var(--amber)  !important; border-color:rgba(251,191,36,.2) !important; }
        .btn-close { filter:invert(1) !important; opacity:.55 !important; }
        .btn-close:hover { opacity:1 !important; }

        /* ===========================  MISC  =========================== */
        code {
            font-family:'JetBrains Mono',monospace;
            background:rgba(0,232,150,.08); color:var(--green);
            padding:2px 8px; border-radius:6px; font-size:11.5px;
            border:1px solid var(--bdg);
        }
        .text-muted   { color:var(--tx2) !important; }
        .text-primary { color:var(--green) !important; }
        .text-success { color:var(--green) !important; }
        .text-danger  { color:var(--red) !important; }
        .text-warning { color:var(--amber) !important; }
        .text-info    { color:var(--blue) !important; }
        hr { border-color:var(--bd) !important; opacity:1; }
        h1,h2,h3,h4,h5,h6 { font-family:'Syne',sans-serif; letter-spacing:-.3px; color:var(--tx1); }
        .fw-bold, .fw-semibold { font-family:'Syne',sans-serif !important; }

        .gradient-text {
            background:linear-gradient(120deg,var(--tx1) 40%,var(--green));
            -webkit-background-clip:text; -webkit-text-fill-color:transparent;
            background-clip:text;
        }
        .glow-divider {
            height:1px; border:none; margin:18px 0;
            background:linear-gradient(90deg,transparent,var(--bdg),transparent);
        }
        .expired-row{background:var(--r-dim)!important;}
        .warning-row{background:var(--a-dim)!important;}
        .summary-pill{display:inline-flex;align-items:center;gap:8px;padding:10px 18px;background:rgba(255,255,255,.03);border:1px solid var(--bd2);border-radius:999px;font-family:'Syne',sans-serif;font-weight:700;font-size:14px;}
        .summary-pill.is-red{color:var(--red);border-color:rgba(248,113,113,.3);}
        .summary-pill.is-amber{color:var(--amber);border-color:rgba(251,191,36,.3);}
        .summary-pill.is-green{color:var(--green);border-color:var(--bdg);}

        @media (max-width: 992px) {
            .main-content {
                margin-left: 0 !important;
                padding: 16px !important;
            }
            .sidebar-fixed {
                transform: translateX(-100%);
            }
            .sidebar-fixed.show {
                transform: translateX(0);
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
                <button class="menu-toggle" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebar" aria-controls="sidebar">
                    <i class="bi bi-list"></i>
                </button>
                <div>
                    <h2>Expiry Management</h2>
                    <p class="topbar-sub">Component 02 — Items sorted by expiry date using custom <strong>MergeSort O(n log n)</strong>.</p>
                </div>
            </div>
            <div class="topbar-actions">
                <div class="user-pill">
                    <span class="user-pill-avatar">${fn:toUpperCase(fn:substring(sessionScope.username, 0, 1))}</span>
                    <div>
                        <div class="user-pill-name">${sessionScope.username}</div>
                        <div class="user-pill-role">${sessionScope.role}</div>
                    </div>
                </div>
            </div>
        </div>

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
        <div class="d-flex flex-wrap gap-2 mb-4">
            <span class="summary-pill is-red"><i class="bi bi-x-circle"></i>Expired: ${expired.size()}</span>
            <span class="summary-pill is-amber"><i class="bi bi-exclamation-triangle"></i>Expiring Soon (&#8804;30 days): ${expiringSoon.size()}</span>
            <span class="summary-pill is-green"><i class="bi bi-check-circle"></i>Total Sorted: ${sortedItems.size()}</span>
        </div>

        <%-- Sorted Items Table --%>
        <div class="card" style="animation-delay:.10s">
            <div class="card-header"><span><i class="bi bi-table me-2"></i>All Items — Sorted by Expiry Date (Ascending)</span></div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark"><tr>
                            <th>#</th><th>ID</th><th>Name</th><th>Category</th>
                            <th>Quantity</th><th>Expiry Date</th><th>Status</th>
                        </tr></thead>
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
                                <td class="small" style="color:var(--tx3);">${rank}</td>
                                <td><code>${item.id}</code></td>
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
                            <tr><td colspan="7" class="text-center py-5" style="color:var(--tx3);"><i class="bi bi-inbox fs-2 d-block mb-2"></i>No items to display.</td></tr>
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
<script>
    (function(){
        /* ---- Ripple on all .btn ---- */
        document.addEventListener('click',function(e){
            const b=e.target.closest('.btn');
            if(!b)return;
            const r=document.createElement('span');
            r.className='ripple';
            const rect=b.getBoundingClientRect();
            const sz=Math.max(rect.width,rect.height);
            r.style.cssText='width:'+sz+'px;height:'+sz+'px;left:'+(e.clientX-rect.left-sz/2)+'px;top:'+(e.clientY-rect.top-sz/2)+'px;';
            b.appendChild(r);
            setTimeout(function(){r.parentNode&&r.remove();},550);
        });

        /* ---- Animated stat counters ---- */
        function easeOut(t){return 1-Math.pow(1-t,3);}
        document.querySelectorAll('[data-count]').forEach(function(el){
            var raw=el.dataset.count, end=parseFloat(raw)||0;
            if(!end)return;
            var isF=raw.indexOf('.')!==-1, pre=el.dataset.prefix||'', dur=1500, t0=performance.now();
            function step(now){
                var p=Math.min((now-t0)/dur,1),v=end*easeOut(p);
                el.textContent=pre+(isF?v.toFixed(2):Math.round(v));
                if(p<1)requestAnimationFrame(step);
            }
            requestAnimationFrame(step);
        });

        /* ---- Auth-page btn-auth ripple ---- */
        document.querySelectorAll('.btn-auth').forEach(function(b){
            b.addEventListener('click',function(e){
                var r=document.createElement('span');
                r.className='ripple';
                var rect=b.getBoundingClientRect(),sz=Math.max(rect.width,rect.height);
                r.style.cssText='width:'+sz+'px;height:'+sz+'px;left:'+(e.clientX-rect.left-sz/2)+'px;top:'+(e.clientY-rect.top-sz/2)+'px;';
                b.appendChild(r);
                setTimeout(function(){r.parentNode&&r.remove();},550);
            });
        });
    })();
</script></body>
</html>