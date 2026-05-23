<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="error"   type="java.lang.String"--%>
<%--@elvariable id="success" type="java.lang.String"--%>
<%--@elvariable id="step"    type="java.lang.String"  values: email | otp | newPassword --%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Forgot Password — Lumenara</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=Outfit:wght@300;400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
  <style>
    /* ── Lumenara — Forgot Password · midnight-purple palette ── */
    :root {
      --bg:     #07041A;
      --green:  #00E896;
      --violet: #8B5CF6;
      --v-deep: #5B21B6;
      --g-dim:  rgba(0,232,150,.10);
      --g-glow: rgba(0,232,150,.38);
      --v-dim:  rgba(139,92,246,.12);
      --v-glow: rgba(139,92,246,.40);
      --tx1:    #EEE8FF;
      --tx2:    #8878A6;
      --tx3:    #3A2F5A;
      --bd2:    rgba(255,255,255,.10);
      --bdv:    rgba(139,92,246,.25);
      --bdg:    rgba(0,232,150,.18);
      --red:    #F87171;
      --r-dim:  rgba(248,113,113,.10);
    }
    *, *::before, *::after { box-sizing: border-box; }
    body {
      font-family: 'Outfit', system-ui, sans-serif;
      background-color: var(--bg);
      background-image: radial-gradient(circle at 1px 1px, rgba(139,92,246,.06) 1px, transparent 0);
      background-size: 32px 32px;
      min-height: 100vh;
      display: flex; align-items: center; justify-content: center;
      padding: 32px 16px; color: var(--tx1); margin: 0;
    }
    .orb { position: fixed; border-radius: 50%; pointer-events: none; z-index: 0; }
    .orb-1 {
      top: -30%; right: -20%; width: 75vw; height: 75vw;
      background: radial-gradient(circle, rgba(91,33,182,.10) 0%, transparent 65%);
      animation: orb-drift 30s ease-in-out infinite;
    }
    .orb-2 {
      bottom: -30%; left: -20%; width: 65vw; height: 65vw;
      background: radial-gradient(circle, rgba(55,10,120,.12) 0%, transparent 65%);
      animation: orb-drift 38s ease-in-out infinite reverse;
    }
    @keyframes orb-drift {
      0%,100% { transform: translate(0,0) scale(1); }
      33%     { transform: translate(50px,-60px) scale(1.06); }
      66%     { transform: translate(-40px,55px) scale(.95); }
    }
    .auth-card {
      position: relative; z-index: 10;
      width: 100%; max-width: 420px;
      background: rgba(7,4,22,.88);
      backdrop-filter: blur(28px) saturate(140%);
      -webkit-backdrop-filter: blur(28px) saturate(140%);
      border-radius: 26px; padding: 42px 38px 36px;
      animation: card-rise .65s cubic-bezier(.16,1,.3,1) both;
    }
    .auth-card::before {
      content: ''; position: absolute; inset: -1px; border-radius: 27px;
      background: linear-gradient(140deg,
      rgba(139,92,246,.55), rgba(80,30,180,.35),
      rgba(0,232,150,.15), rgba(139,92,246,.20));
      z-index: -1;
    }
    @keyframes card-rise {
      from { opacity:0; transform:translateY(30px) scale(.96); filter:blur(5px); }
      to   { opacity:1; transform:none; filter:none; }
    }

    /* brand */
    .auth-brand { display:flex; flex-direction:column; align-items:center; margin-bottom:28px; }
    .brand-icon {
      width:62px; height:62px; border-radius:19px;
      background: linear-gradient(140deg, var(--violet), rgba(100,50,220,.55));
      display:flex; align-items:center; justify-content:center;
      font-size:28px; color:#EEE8FF; margin-bottom:16px;
      animation: icon-pulse 3.8s ease-in-out infinite;
    }
    @keyframes icon-pulse {
      0%,100% { box-shadow: 0 0 14px var(--v-glow); }
      50%     { box-shadow: 0 0 32px var(--v-glow), 0 0 64px var(--v-dim); }
    }
    .brand-name {
      font-family: 'Syne', sans-serif; font-size:22px; font-weight:800; letter-spacing:-.5px;
      background: linear-gradient(125deg, var(--tx1) 40%, var(--violet));
      -webkit-background-clip:text; -webkit-text-fill-color:transparent; background-clip:text;
    }
    .brand-sub { font-size:12.5px; color:var(--tx2); margin-top:5px; text-align:center; }

    /* step indicator */
    .step-bar { display:flex; align-items:center; gap:6px; margin-bottom:24px; }
    .step-dot {
      width:28px; height:28px; border-radius:50%; flex-shrink:0;
      display:flex; align-items:center; justify-content:center;
      font-size:11px; font-weight:700;
    }
    .step-dot.active  { background:var(--violet); color:#fff; box-shadow:0 0 12px var(--v-glow); }
    .step-dot.done    { background:var(--green);  color:#031510; }
    .step-dot.pending { background:rgba(139,92,246,.12); color:var(--tx3); border:1px solid var(--bdv); }
    .step-line { flex:1; height:1px; background:rgba(139,92,246,.20); }
    .step-labels { display:flex; justify-content:space-between; margin-top:6px; margin-bottom:18px; }
    .step-labels span { font-size:9.5px; color:var(--tx3); letter-spacing:.4px; text-align:center; flex:1; }
    .step-labels span.active-label { color:var(--violet); font-weight:600; }

    /* alerts */
    .auth-alert {
      display:flex; align-items:flex-start; gap:10px;
      padding:12px 14px; border-radius:12px;
      font-size:13px; line-height:1.5; margin-bottom:18px;
    }
    .auth-alert.is-error   { background:var(--r-dim); border:1px solid rgba(248,113,113,.22); color:var(--red); }
    .auth-alert.is-success { background:var(--g-dim); border:1px solid var(--bdg); color:var(--green); }
    .auth-dismiss {
      margin-left:auto; flex-shrink:0; background:none; border:none;
      color:inherit; opacity:.55; cursor:pointer; font-size:14px; padding:0;
    }
    .auth-dismiss:hover { opacity:1; }

    /* fields */
    .field-label {
      display:block; font-size:9.5px; font-weight:600;
      letter-spacing:1.1px; text-transform:uppercase;
      color:var(--tx2); margin-bottom:7px;
    }
    .input-wrap { position:relative; margin-bottom:14px; }
    .input-icon {
      position:absolute; left:13px; top:50%; transform:translateY(-50%);
      font-size:14px; color:var(--tx3); pointer-events:none;
    }
    .input-field {
      width:100%; background:rgba(139,92,246,.05);
      border:1px solid rgba(139,92,246,.18); border-radius:12px;
      padding:11px 14px 11px 38px; color:var(--tx1);
      font-family:'Outfit',sans-serif; font-size:14px; outline:none;
      transition:border-color .2s, box-shadow .2s, background .2s;
    }
    .input-field::placeholder { color:var(--tx3); }
    .input-field:focus {
      border-color:var(--violet); background:rgba(139,92,246,.08);
      box-shadow:0 0 0 3px var(--v-dim), 0 0 24px rgba(139,92,246,.06);
    }
    /* OTP input — large centred digits */
    .otp-field {
      width:100%; background:rgba(139,92,246,.05);
      border:1px solid rgba(139,92,246,.18); border-radius:12px;
      padding:14px; color:var(--tx1);
      font-family:'JetBrains Mono',monospace; font-size:28px;
      font-weight:700; letter-spacing:14px; text-align:center;
      outline:none;
      transition:border-color .2s, box-shadow .2s;
    }
    .otp-field:focus {
      border-color:var(--violet); background:rgba(139,92,246,.08);
      box-shadow:0 0 0 3px var(--v-dim);
    }
    .pw-toggle {
      position:absolute; right:12px; top:50%; transform:translateY(-50%);
      font-size:14px; color:var(--tx3); cursor:pointer;
      background:none; border:none; padding:4px; line-height:1; transition:color .15s;
    }
    .pw-toggle:hover { color:var(--tx1); }

    /* hint text */
    .field-hint { font-size:11.5px; color:var(--tx2); margin-top:-8px; margin-bottom:14px; }

    /* password strength bar */
    .strength-bar-wrap {
      height:4px; border-radius:4px;
      background:rgba(255,255,255,.07);
      margin-top:-8px; margin-bottom:8px; overflow:hidden;
    }
    .strength-bar { height:100%; border-radius:4px; width:0; transition:width .3s,background .3s; }
    .strength-hint { font-size:11px; color:var(--tx2); margin-bottom:10px; min-height:16px; }
    .match-hint { font-size:11px; margin-top:-8px; margin-bottom:10px; min-height:16px; }
    .match-hint.ok  { color:var(--green); }
    .match-hint.bad { color:var(--red); }

    /* primary button */
    .btn-primary {
      width:100%; padding:13px; border-radius:999px; border:none;
      background:linear-gradient(135deg, var(--violet) 0%, var(--v-deep) 100%);
      color:#fff; font-family:'Outfit',sans-serif;
      font-size:14.5px; font-weight:700; letter-spacing:.3px;
      cursor:pointer; display:flex; align-items:center; justify-content:center; gap:9px;
      margin-top:10px; box-shadow:0 4px 24px var(--v-glow);
      position:relative; overflow:hidden;
      transition:box-shadow .22s, transform .1s;
    }
    .btn-primary::before {
      content:''; position:absolute; top:0; left:-80%; width:45%; height:100%;
      background:linear-gradient(90deg,transparent,rgba(255,255,255,.18),transparent);
      transform:skewX(-18deg); transition:left .45s ease;
    }
    .btn-primary:hover::before { left:130%; }
    .btn-primary:hover { box-shadow:0 8px 34px var(--v-glow), 0 0 0 3px var(--v-dim); }
    .btn-primary:active { transform:scale(.98); }

    .or-divider { display:flex; align-items:center; gap:12px; margin:22px 0 18px; }
    .or-line { flex:1; height:1px; background:linear-gradient(90deg,transparent,rgba(139,92,246,.22),transparent); }
    .or-text { font-size:10px; color:var(--tx3); letter-spacing:.9px; font-weight:600; }
    .auth-foot { text-align:center; font-size:13px; color:var(--tx2); }
    .auth-foot a { color:var(--violet); text-decoration:none; font-weight:600; transition:opacity .15s; }
    .auth-foot a:hover { opacity:.75; }
    .card-stamp {
      text-align:center; margin-top:22px;
      font-family:'JetBrains Mono',monospace;
      font-size:9.5px; color:var(--tx3); letter-spacing:.9px;
    }
  </style>
</head>
<body>

<div class="orb orb-1"></div>
<div class="orb orb-2"></div>

<div class="auth-card">

  <div class="auth-brand">
    <div class="brand-icon"><i class="bi bi-shield-lock-fill"></i></div>
    <div class="brand-name">Reset Password</div>
    <div class="brand-sub">Lumenara &middot; Account Recovery</div>
  </div>

  <%-- ── Step indicator ── --%>
  <c:set var="currentStep" value="${empty step ? 'email' : step}" />
  <div class="step-bar">
    <div class="step-dot ${currentStep == 'email' ? 'active' : 'done'}">
      <c:choose>
        <c:when test="${currentStep != 'email'}"><i class="bi bi-check-lg"></i></c:when>
        <c:otherwise>1</c:otherwise>
      </c:choose>
    </div>
    <div class="step-line"></div>
    <div class="step-dot ${currentStep == 'otp' ? 'active' : (currentStep == 'newPassword' ? 'done' : 'pending')}">
      <c:choose>
        <c:when test="${currentStep == 'newPassword'}"><i class="bi bi-check-lg"></i></c:when>
        <c:otherwise>2</c:otherwise>
      </c:choose>
    </div>
    <div class="step-line"></div>
    <div class="step-dot ${currentStep == 'newPassword' ? 'active' : 'pending'}">3</div>
  </div>
  <div class="step-labels">
    <span class="${currentStep == 'email' ? 'active-label' : ''}">Email</span>
    <span class="${currentStep == 'otp' ? 'active-label' : ''}">Verify OTP</span>
    <span class="${currentStep == 'newPassword' ? 'active-label' : ''}">New Password</span>
  </div>

  <%-- Alerts --%>
  <c:if test="${not empty error}">
    <div class="auth-alert is-error" id="err-alert">
      <i class="bi bi-exclamation-triangle-fill" style="font-size:14px;flex-shrink:0;margin-top:1px;"></i>
      <span>${error}</span>
      <button class="auth-dismiss" onclick="document.getElementById('err-alert').remove()" aria-label="Dismiss">
        <i class="bi bi-x-lg"></i>
      </button>
    </div>
  </c:if>
  <c:if test="${not empty success}">
    <div class="auth-alert is-success">
      <i class="bi bi-check-circle-fill" style="font-size:14px;flex-shrink:0;margin-top:1px;"></i>
      <span>${success}</span>
    </div>
  </c:if>

  <%-- ══ STEP 1: Enter email ══ --%>
  <c:if test="${currentStep == 'email'}">
    <form action="${pageContext.request.contextPath}/forgotPassword" method="post" novalidate>
      <input type="hidden" name="action" value="sendOtp">

      <label for="email" class="field-label">Registered Email</label>
      <div class="input-wrap">
        <i class="bi bi-envelope input-icon"></i>
        <input type="email" class="input-field" id="email" name="email"
               placeholder="Enter your registered email" required autofocus maxlength="150">
      </div>
      <p class="field-hint">We'll send a 6-digit OTP to this address.</p>

      <button type="submit" class="btn-primary">
        <i class="bi bi-send"></i>Send OTP
      </button>
    </form>
  </c:if>

  <%-- ══ STEP 2: Enter OTP ══ --%>
  <c:if test="${currentStep == 'otp'}">
    <form action="${pageContext.request.contextPath}/forgotPassword" method="post" novalidate>
      <input type="hidden" name="action" value="verifyOtp">

      <label for="otp" class="field-label">Enter OTP</label>
      <div class="input-wrap">
        <input type="text" class="otp-field" id="otp" name="otp"
               placeholder="000000" maxlength="6" required autofocus
               inputmode="numeric" autocomplete="one-time-code">
      </div>
      <p class="field-hint">
        <i class="bi bi-clock" style="margin-right:4px;"></i>
        This code expires in 10 minutes. Check your inbox (and spam folder).
      </p>

      <button type="submit" class="btn-primary">
        <i class="bi bi-shield-check"></i>Verify OTP
      </button>
    </form>
  </c:if>

  <%-- ══ STEP 3: Set new password ══ --%>
  <c:if test="${currentStep == 'newPassword'}">
    <form action="${pageContext.request.contextPath}/forgotPassword" method="post" novalidate>
      <input type="hidden" name="action" value="resetPassword">

      <label for="newPassword" class="field-label">New Password</label>
      <div class="input-wrap" style="margin-bottom:6px;">
        <i class="bi bi-lock input-icon"></i>
        <input type="password" class="input-field" id="newPassword" name="newPassword"
               placeholder="Min 8 chars, 1 letter &amp; 1 number" required maxlength="100"
               autocomplete="new-password">
        <button type="button" class="pw-toggle" id="pw-toggle-1" aria-label="Toggle">
          <i class="bi bi-eye" id="pw-icon-1"></i>
        </button>
      </div>
      <div class="strength-bar-wrap"><div class="strength-bar" id="strength-bar"></div></div>
      <div class="strength-hint" id="strength-hint"></div>

      <label for="confirmPassword" class="field-label">Confirm New Password</label>
      <div class="input-wrap" style="margin-bottom:6px;">
        <i class="bi bi-lock-fill input-icon"></i>
        <input type="password" class="input-field" id="confirmPassword" name="confirmPassword"
               placeholder="Repeat new password" required maxlength="100"
               autocomplete="new-password">
        <button type="button" class="pw-toggle" id="pw-toggle-2" aria-label="Toggle">
          <i class="bi bi-eye" id="pw-icon-2"></i>
        </button>
      </div>
      <div class="match-hint" id="match-hint"></div>

      <button type="submit" class="btn-primary">
        <i class="bi bi-arrow-repeat"></i>Reset Password
      </button>
    </form>
  </c:if>

  <div class="or-divider">
    <div class="or-line"></div><span class="or-text">OR</span><div class="or-line"></div>
  </div>
  <div class="auth-foot">
    Remembered it?
    <a href="${pageContext.request.contextPath}/login">Back to Sign In</a>
  </div>
  <div class="card-stamp">LUMENARA &middot; ACCOUNT RECOVERY</div>
</div>

<script>
  (function () {
    // Password visibility toggles
    function togglePw(btnId, iconId, inputId) {
      var btn = document.getElementById(btnId);
      var inp = document.getElementById(inputId);
      var ico = document.getElementById(iconId);
      if (!btn || !inp) return;
      btn.addEventListener('click', function () {
        var hidden = inp.type === 'password';
        inp.type      = hidden ? 'text' : 'password';
        ico.className = hidden ? 'bi bi-eye-slash' : 'bi bi-eye';
      });
    }
    togglePw('pw-toggle-1', 'pw-icon-1', 'newPassword');
    togglePw('pw-toggle-2', 'pw-icon-2', 'confirmPassword');

    // Password strength meter
    var pwInput = document.getElementById('newPassword');
    var bar     = document.getElementById('strength-bar');
    var hint    = document.getElementById('strength-hint');
    var levels  = [
      { pct:'0%',   color:'transparent', label:'' },
      { pct:'25%',  color:'#F87171',     label:'⚠ Weak' },
      { pct:'50%',  color:'#FBBF24',     label:'▲ Fair' },
      { pct:'75%',  color:'#34D399',     label:'✓ Good' },
      { pct:'100%', color:'#00E896',     label:'✦ Strong' },
      { pct:'100%', color:'#00E896',     label:'✦ Strong' }
    ];
    function score(pw) {
      var s = 0;
      if (pw.length >= 8)  s++;
      if (pw.length >= 12) s++;
      if (/[A-Z]/.test(pw)) s++;
      if (/[0-9]/.test(pw)) s++;
      if (/[^A-Za-z0-9]/.test(pw)) s++;
      return s;
    }
    if (pwInput && bar) {
      pwInput.addEventListener('input', function () {
        var s = this.value.length === 0 ? 0 : Math.max(1, score(this.value));
        var l = levels[s] || levels[0];
        bar.style.width      = l.pct;
        bar.style.background = l.color;
        hint.textContent     = l.label;
        hint.style.color     = l.color;
        checkMatch();
      });
    }

    // Confirm password match indicator
    var confirmInput = document.getElementById('confirmPassword');
    var matchHint    = document.getElementById('match-hint');
    function checkMatch() {
      if (!confirmInput || !confirmInput.value) {
        if (matchHint) matchHint.textContent = '';
        return;
      }
      if (pwInput.value === confirmInput.value) {
        matchHint.textContent = '✓ Passwords match';
        matchHint.className   = 'match-hint ok';
      } else {
        matchHint.textContent = '✗ Passwords do not match';
        matchHint.className   = 'match-hint bad';
      }
    }
    if (confirmInput) confirmInput.addEventListener('input', checkMatch);

    // Auto-submit OTP form when 6 digits are entered
    var otpInput = document.getElementById('otp');
    if (otpInput) {
      otpInput.addEventListener('input', function () {
        if (this.value.replace(/\D/g, '').length === 6) {
          this.value = this.value.replace(/\D/g, '');
          this.closest('form').submit();
        }
      });
    }
  })();
</script>
</body>
</html>

