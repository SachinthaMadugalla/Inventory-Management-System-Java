<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--@elvariable id="error" type="java.lang.String"--%>

<c:set var="activePage" value="addStock" scope="request"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Add Stock — Lumenara</title>
  <!--suppress HtmlUnknownTarget -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!--suppress HtmlUnknownTarget -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    /* ============================================================
       Lumenara — Midnight Ops Theme
       ============================================================ */

    @import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=Outfit:wght@300;400;500;600&family=JetBrains+Mono:wght@400;500&display=swap');

    :root {
      --bg-0:   #f0f2f5;
      --bg-1:   #ffffff;
      --bg-2:   #f8f9fa;
      --card:   #ffffff;
      --card-h: #f8f9fa;

      --green:  #00a65a;
      --g-dim:  rgba(0,166,90,0.12);
      --g-glow: rgba(0,166,90,0.35);
      --g-soft: rgba(0,166,90,0.22);

      --violet: #605ca8;
      --v-dim:  rgba(96,92,168,0.12);
      --v-glow: rgba(96,92,168,0.30);

      --blue:   #0073b7;
      --b-dim:  rgba(0,115,183,0.12);
      --b-glow: rgba(0,115,183,0.28);

      --amber:  #f39c12;
      --a-dim:  rgba(243,156,18,0.12);
      --a-glow: rgba(243,156,18,0.30);

      --red:    #dd4b39;
      --r-dim:  rgba(221,75,57,0.12);
      --r-glow: rgba(221,75,57,0.28);

      --tx1: #333333;
      --tx2: #666666;
      --tx3: #aaaaaa;

      --bd:  rgba(0,0,0,0.08);
      --bd2: rgba(0,0,0,0.13);
      --bdg: rgba(0,166,90,0.22);
      --bdv: rgba(96,92,168,0.22);
    }

    /* ===========================  BASE  =========================== */
    *, *::before, *::after { box-sizing: border-box; }

    html { scroll-behavior: smooth; }

    body {
      font-family: 'Outfit', system-ui, sans-serif;
      background-color: var(--bg-0);
      background-image: none;
      background-size: 28px 28px;
      color: var(--tx1);
      min-height: 100vh;
      margin: 0; padding: 0;
    }
    body::before {
      content: '';
      position: fixed; top: -220px; right: -160px;
      width: 720px; height: 720px; border-radius: 50%;
      background: none;
      animation: orb1 26s ease-in-out infinite;
      pointer-events: none; z-index: 0;
    }
    body::after {
      content: '';
      position: fixed; bottom: -200px; left: -160px;
      width: 640px; height: 640px; border-radius: 50%;
      background: none;
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
    @keyframes scanLine {
      0%   { transform: translateY(-100%); opacity:0;   }
      8%   { opacity:.35; }
      92%  { opacity:.35; }
      100% { transform: translateY(500%);  opacity:0;   }
    }

    /* ===========================  LAYOUT  =========================== */
    .d-flex { position:relative; z-index:1; }
    .main-content {
      margin-left: 256px !important;
      padding: 28px 36px !important;
      animation: fadeIn .45s ease;
      transition: margin-left 0.3s ease-in-out;
    }

    /* ===========================  SIDEBAR  =========================== */
    .sidebar-fixed {
      position: fixed !important;
      top:0; left:0; width:256px !important; height:100vh;
      overflow-y: auto; z-index:100;
      background: #222d32 !important;
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
      background: linear-gradient(140deg, var(--green), rgba(0,166,90,.5));
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
      background:#f8f9fa !important;
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
      background:linear-gradient(90deg,transparent,rgba(0,166,90,.08),transparent);
      animation: shimmerSweep 3.5s ease-in-out infinite;
    }
    .sidebar-userbox {
      background: rgba(0,0,0,.03);
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
      border:1px solid rgba(221,75,57,.2) !important;
      color:var(--red) !important; border-radius:12px !important;
      font-weight:600 !important; font-size:13px !important;
      transition:all .2s !important;
    }
    .sidebar-fixed .btn-outline-danger:hover {
      background:var(--r-dim) !important;
      border-color:var(--red) !important;
      box-shadow:0 0 14px var(--r-glow) !important;
    }


    /* ===  Light-theme sidebar text overrides  === */
    .sidebar-fixed { background: #222d32 !important; border-right: 1px solid rgba(0,0,0,.2) !important; }
    .sidebar-fixed, .sidebar-fixed .sidebar-brand,
    .sidebar-fixed .u-name { color: rgba(255,255,255,.85) !important; }
    .sidebar-fixed .sidebar-brand-text {
      background: linear-gradient(120deg, #ffffff 40%, var(--green));
      -webkit-background-clip:text; -webkit-text-fill-color:transparent;
      background-clip:text;
    }
    .sidebar-fixed .sidebar-section-label { color: rgba(255,255,255,.30) !important; }
    .sidebar-fixed .nav-pills .nav-link { color: rgba(255,255,255,.65) !important; }
    .sidebar-fixed .nav-pills .nav-link:hover { color: #fff !important; background: rgba(255,255,255,.07) !important; }
    .sidebar-fixed .nav-pills .nav-link.active { color: var(--green) !important; background: rgba(0,166,90,.15) !important; }
    .sidebar-fixed .nav-pills .nav-link.active i { color: var(--green) !important; }
    .sidebar-fixed .sidebar-userbox { background: rgba(255,255,255,.05) !important; border-color: rgba(255,255,255,.08) !important; }
    .sidebar-fixed::-webkit-scrollbar-thumb { background: rgba(255,255,255,.15); }
    .sidebar-fixed .text-muted { color: rgba(255,255,255,.45) !important; }
    /* ===========================  TOPBAR  =========================== */
    .topbar {
      display:flex; justify-content:space-between; align-items:center;
      gap:16px; margin-bottom:26px;
      padding:18px 24px;
      background:var(--card);
      backdrop-filter:blur(24px); -webkit-backdrop-filter:blur(24px);
      border:1px solid var(--bd); border-radius:20px;
      box-shadow:0 4px 28px rgba(0,0,0,.08);
      animation: fadeUp .4s ease .04s both;
      position:relative; overflow:hidden;
    }
    .topbar::after {
      content:'';
      position:absolute; bottom:0; left:0; right:0; height:1px;
      background:linear-gradient(90deg,transparent,var(--bdg),transparent);
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
      background:#f8f9fa;
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

    /* ===========================  CARDS  =========================== */
    .card {
      background:var(--card) !important;
      backdrop-filter:blur(18px); -webkit-backdrop-filter:blur(18px);
      border:1px solid var(--bd) !important;
      border-radius:18px !important;
      box-shadow:0 4px 24px rgba(0,0,0,.07) !important;
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
      box-shadow:0 14px 44px rgba(0,0,0,.10), 0 0 0 1px var(--bdg) !important;
      border-color:var(--bdg) !important;
    }
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
    .btn::before {
      content:'';
      position:absolute; top:0; width:45%; height:100%;
      background:linear-gradient(90deg,transparent,rgba(255,255,255,.12),transparent);
      transform:skewX(-18deg);
      left:-80%; transition:left .45s ease;
    }
    .btn:hover::before { left:130%; }
    .btn-primary {
      background:var(--green) !important; border-color:var(--green) !important;
      color:#ffffff !important; font-weight:700 !important;
      box-shadow:0 4px 18px var(--g-glow) !important;
    }
    .btn-primary:hover {
      transform:translateY(-1px);
      box-shadow:0 8px 28px var(--g-glow),0 0 0 3px var(--g-dim) !important;
    }
    .btn-outline-secondary {
      background:transparent !important; border:1px solid var(--bd2) !important;
      color:var(--tx2) !important;
    }
    .btn-outline-secondary:hover { background:#f8f9fa !important; color:var(--tx1) !important; }
    .ripple {
      position:absolute; border-radius:50%;
      background:rgba(255,255,255,.18);
      transform:scale(0); animation:rippleGrow .5s linear;
      pointer-events:none;
    }

    /* ===========================  FORMS  =========================== */
    .form-control, .form-select {
      font-family:'Outfit',sans-serif !important;
      background:#f8f9fa !important;
      border:1px solid var(--bd2) !important;
      border-radius:12px !important;
      padding:11px 14px !important;
      font-size:14px !important; color:var(--tx1) !important;
      transition:border-color .2s, box-shadow .2s !important;
    }
    .form-control::placeholder { color:var(--tx3) !important; }
    .form-control:focus, .form-select:focus {
      background:rgba(0,166,90,.04) !important;
      border-color:var(--green) !important;
      box-shadow:0 0 0 3px var(--g-dim), 0 0 22px rgba(0,166,90,.06) !important;
      color:var(--tx1) !important;
    }
    .form-label {
      font-family:'Outfit',sans-serif !important;
      font-weight:600 !important; font-size:11px !important;
      text-transform:uppercase; letter-spacing:.7px;
      color:var(--tx2) !important; margin-bottom:7px;
    }

    /* ===========================  ALERTS  =========================== */
    .alert {
      border-radius:14px !important;
      padding:14px 18px !important; font-size:13.5px;
      border:1px solid transparent !important;
      backdrop-filter:blur(8px);
    }
    .alert-danger  { background:var(--r-dim) !important; color:var(--red)    !important; border-color:rgba(221,75,57,.2) !important; }

    @media (max-width: 992px) {
      .sidebar-fixed {
        transform: translateX(-100%);
      }
      .sidebar-fixed.show {
        transform: translateX(0);
      }
      .main-content {
        margin-left: 0 !important;
      }
    }
  </style>
</head>
<body>
<div class="d-flex">
  <jsp:include page="/views/common/sidebar.jsp"/>

  <div class="main-content flex-grow-1">

    <div class="topbar">
      <div>
        <button class="btn btn-primary d-lg-none" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebar" aria-controls="sidebar">
          <i class="bi bi-list"></i>
        </button>
        <h2 class="d-none d-lg-block">Add New Stock</h2>
        <p class="topbar-sub d-none d-lg-block">Enter details for the new inventory item.</p>
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

    <c:if test="${not empty error}">
      <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
    </c:if>

    <div class="card" style="max-width:760px;animation-delay:.05s">
      <div class="card-header"><span><i class="bi bi-plus-circle me-2"></i>New Item Details</span></div>
      <div class="card-body">
        <form action="${pageContext.request.contextPath}/addStock" method="post">
          <div class="row g-3">
            <div class="col-md-6">
              <label for="name" class="form-label">Item Name</label>
              <input type="text" class="form-control" id="name" name="name" required>
            </div>
            <div class="col-md-6">
              <label for="category" class="form-label">Category</label>
              <select class="form-select" id="category" name="category" required>
                <c:forEach var="cat" items="${['Medicine','Food','Electronics','Clothing','Beverages','Other']}">
                  <option value="${cat}">${cat}</option>
                </c:forEach>
              </select>
            </div>
            <div class="col-md-4">
              <label for="quantity" class="form-label">Quantity</label>
              <input type="number" class="form-control" id="quantity" name="quantity" min="1" required>
            </div>
            <div class="col-md-4">
              <label for="price" class="form-label">Unit Price (Rs.)</label>
              <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" required>
            </div>
            <div class="col-md-4">
              <label for="expiryDate" class="form-label">Expiry Date <span id="expiry-required" style="color:var(--red); display:none;">*</span></label>
              <input type="date" class="form-control" id="expiryDate" name="expiryDate">
            </div>
            <div class="col-12 mt-3">
              <button type="submit" class="btn btn-primary px-4">
                <i class="bi bi-plus-circle me-2"></i>Add Stock
              </button>
              <a href="${pageContext.request.contextPath}/viewInventory"
                 class="btn btn-outline-secondary ms-2 mt-2 mt-sm-0">Cancel</a>
            </div>
          </div>
        </form>
      </div>
    </div>

  </div>
</div>
<!--suppress HtmlUnknownTarget -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  (function(){
    const categorySelect = document.getElementById('category');
    const expiryDateInput = document.getElementById('expiryDate');
    const expiryRequiredSpan = document.getElementById('expiry-required');

    const requiredCategories = ['Medicine', 'Food', 'Beverages'];

    function toggleExpiryRequirement() {
      const selectedCategory = categorySelect.value;
      if (requiredCategories.includes(selectedCategory)) {
        expiryDateInput.required = true;
        expiryRequiredSpan.style.display = 'inline';
      } else {
        expiryDateInput.required = false;
        expiryRequiredSpan.style.display = 'none';
      }
    }

    categorySelect.addEventListener('change', toggleExpiryRequirement);
    toggleExpiryRequirement();
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
  })();
</script></body>
</html>