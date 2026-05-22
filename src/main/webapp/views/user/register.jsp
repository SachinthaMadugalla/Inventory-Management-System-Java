<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="error"        type="java.lang.String"--%>
<%--@elvariable id="success"      type="java.lang.String"--%>
<%--@elvariable id="prevUsername" type="java.lang.String"--%>
<%--@elvariable id="prevEmail"    type="java.lang.String"--%>
<%--@elvariable id="prevRole"     type="java.lang.String"--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — Lumenara</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=Outfit:wght@300;400;500;600&family=JetBrains+Mono:wght@400;500&display=swap');

        :root {
            --bg-0:#050810; --green:#00E896; --g-dim:rgba(0,232,150,.10);
            --g-glow:rgba(0,232,150,.38); --g-soft:rgba(0,232,150,.20);
            --violet:#7C3AED; --v-dim:rgba(124,58,237,.10);
            --tx1:#ECF0FF; --tx2:#7A8BA6; --tx3:#3A4A5E;
            --bd:rgba(255,255,255,.065); --bd2:rgba(255,255,255,.12);
            --bdg:rgba(0,232,150,.20); --red:#F87171; --r-dim:rgba(248,113,113,.10);
        }
        *,*::before,*::after { box-sizing:border-box; }
        body {
            font-family:'Outfit',system-ui,sans-serif;
            background-color:var(--bg-0);
            background-image:radial-gradient(circle at 1px 1px,rgba(255,255,255,.035) 1px,transparent 0);
            background-size:28px 28px;
            color:var(--tx1);
            min-height:100vh;
            display:flex;
            align-items:flex-start;           /* keep card from being vertically centered (prevents clipping) */
            justify-content:center;
            padding:60px 16px;                /* give room at top so card is not hidden under taskbar */
            margin:0;
            position:relative;
            overflow:auto;                    /* allow page scrolling when viewport is small */
        }
        body::before {
            content:''; position:fixed; top:-200px; right:-120px;
            width:700px; height:700px; border-radius:50%;
            background:radial-gradient(circle,rgba(0,232,150,.09) 0%,transparent 68%);
            animation:orb1 26s ease-in-out infinite; pointer-events:none; z-index:0;
        }
        body::after {
            content:''; position:fixed; bottom:-180px; left:-120px;
            width:600px; height:600px; border-radius:50%;
            background:radial-gradient(circle,rgba(124,58,237,.09) 0%,transparent 68%);
            animation:orb2 32s ease-in-out infinite; pointer-events:none; z-index:0;
        }
        @keyframes orb1 {
            0%,100%{transform:translate(0,0) scale(1);}
            35%{transform:translate(55px,-70px) scale(1.07);}
            70%{transform:translate(-45px,60px) scale(.94);}
        }
        @keyframes orb2 {
            0%,100%{transform:translate(0,0) scale(1);}
            40%{transform:translate(-65px,-55px) scale(1.06);}
            75%{transform:translate(75px,65px) scale(.93);}
        }
        @keyframes cardEnter {
            from{opacity:0;transform:translateY(28px) scale(.97);filter:blur(3px);}
            to{opacity:1;transform:none;filter:none;}
        }
        @keyframes iconPulse {
            0%,100%{box-shadow:0 0 10px var(--g-glow);}
            50%{box-shadow:0 0 28px var(--g-glow),0 0 56px var(--g-soft);}
        }
        @keyframes rippleGrow { to{transform:scale(3.5);opacity:0;} }

        .auth-card {
            position:relative;
            z-index:10;
            width:100%;
            max-width:440px;
            background:rgba(9,14,28,.88);
            backdrop-filter:blur(28px); -webkit-backdrop-filter:blur(28px);
            border-radius:24px;
            padding:40px 36px 34px;
            animation:cardEnter .55s cubic-bezier(.16,1,.3,1) both;
            max-height: calc(100vh - 80px); /* leaves some space above/below for comfortable viewing */
            overflow:auto;                  /* allows inner scrolling so the Create Account button is reachable */
        }
        .auth-card::before {
            content:''; position:absolute; inset:-1px; border-radius:25px;
            background:linear-gradient(135deg,rgba(0,232,150,.35),rgba(124,58,237,.25),rgba(0,232,150,.08));
            z-index:-1;
        }
        .auth-brand { display:flex; flex-direction:column; align-items:center; margin-bottom:28px; }
        .auth-brand-icon {
            width:58px; height:58px; border-radius:17px;
            background:linear-gradient(140deg,var(--green),rgba(0,232,150,.5));
            display:flex; align-items:center; justify-content:center;
            font-size:26px; color:#040A14; margin-bottom:14px;
            animation:iconPulse 3.5s ease-in-out infinite;
        }
        .auth-brand-name {
            font-family:'Syne',sans-serif; font-size:22px; font-weight:800;
            background:linear-gradient(120deg,var(--tx1) 50%,var(--green));
            -webkit-background-clip:text; -webkit-text-fill-color:transparent;
            background-clip:text; letter-spacing:-.4px;
        }
        .auth-brand-sub { font-size:12.5px; color:var(--tx2); margin-top:5px; text-align:center; }

        .auth-alert {
            display:flex; align-items:flex-start; gap:10px;
            padding:12px 14px; border-radius:12px;
            font-size:13px; line-height:1.5; margin-bottom:18px;
        }
        .auth-alert.is-error   { background:var(--r-dim); border:1px solid rgba(248,113,113,.2); color:var(--red); }
        .auth-alert.is-success { background:var(--g-dim); border:1px solid var(--bdg); color:var(--green); }
        .auth-dismiss {
            margin-left:auto; flex-shrink:0; background:none; border:none;
            color:inherit; opacity:.55; cursor:pointer; font-size:14px; padding:0; line-height:1;
        }
        .auth-dismiss:hover { opacity:1; }

        .field-label {
            display:block; font-size:9.5px; font-weight:600;
            letter-spacing:1px; text-transform:uppercase;
            color:var(--tx2); margin-bottom:7px;
        }
        .input-wrap { position:relative; margin-bottom:14px; }
        .input-icon {
            position:absolute; left:13px; top:50%; transform:translateY(-50%);
            font-size:14px; color:var(--tx3); pointer-events:none;
        }
        .input-modern {
            width:100%; background:rgba(255,255,255,.04); border:1px solid var(--bd2);
            border-radius:12px; padding:11px 38px 11px 38px;
            color:var(--tx1); font-family:'Outfit',sans-serif; font-size:14px;
            outline:none; transition:border-color .2s,box-shadow .2s;
        }
        .input-modern::placeholder { color:var(--tx3); }
        .input-modern:focus {
            border-color:var(--green);
            box-shadow:0 0 0 3px var(--g-dim),0 0 22px rgba(0,232,150,.06);
        }
        .pw-toggle {
            position:absolute; right:12px; top:50%; transform:translateY(-50%);
            font-size:14px; color:var(--tx3); cursor:pointer;
            background:none; border:none; padding:4px; line-height:1; transition:color .15s;
        }
        .pw-toggle:hover { color:var(--tx1); }
        .auth-select {
            width:100%; background:rgba(255,255,255,.04); border:1px solid var(--bd2);
            border-radius:12px; padding:11px 14px;
            color:var(--tx1); font-family:'Outfit',sans-serif; font-size:14px;
            outline:none; transition:border-color .2s,box-shadow .2s;
        }
        .auth-select:focus { border-color:var(--green); box-shadow:0 0 0 3px var(--g-dim); }
        .auth-select option { background:#090E1C; color:var(--tx1); }

        /* ── password strength bar ── */
        .strength-bar-wrap {
            height:4px; border-radius:4px;
            background:rgba(255,255,255,.07);
            margin-top:-8px; margin-bottom:10px; overflow:hidden;
        }
        .strength-bar {
            height:100%; border-radius:4px; width:0;
            transition:width .3s ease, background .3s ease;
        }
        .strength-hint {
            font-size:11px; color:var(--tx2); margin-bottom:10px; min-height:16px;
        }

        /* ── match indicator ── */
        .match-hint { font-size:11px; margin-top:-8px; margin-bottom:10px; min-height:16px; }
        .match-hint.ok  { color:var(--green); }
        .match-hint.bad { color:var(--red); }

        .btn-auth {
            width:100%; padding:12px; border-radius:999px; border:none;
            background:var(--green); color:#040A14;
            font-family:'Outfit',sans-serif; font-size:14px; font-weight:700;
            cursor:pointer; display:flex; align-items:center; justify-content:center; gap:9px;
            margin-top:8px; box-shadow:0 4px 20px var(--g-glow);
            position:relative; overflow:hidden; transition:box-shadow .2s,transform .1s;
        }
        .btn-auth::before {
            content:''; position:absolute; top:0; width:45%; height:100%;
            background:linear-gradient(90deg,transparent,rgba(255,255,255,.18),transparent);
            transform:skewX(-18deg); left:-80%; transition:left .45s ease;
        }
        .btn-auth:hover::before { left:130%; }
        .btn-auth:hover { box-shadow:0 8px 30px var(--g-glow),0 0 0 3px var(--g-dim); }
        .btn-auth:active { transform:scale(.98); }
        .ripple {
            position:absolute; border-radius:50%;
            background:rgba(255,255,255,.2); transform:scale(0);
            animation:rippleGrow .5s linear; pointer-events:none;
        }

        .or-divider { display:flex; align-items:center; gap:12px; margin:22px 0 18px; }
        .or-line { flex:1; height:1px; background:linear-gradient(90deg,transparent,var(--bd2),transparent); }
        .or-text { font-size:10px; color:var(--tx3); letter-spacing:.8px; font-weight:600; }
        .auth-foot { text-align:center; font-size:13px; color:var(--tx2); }
        .auth-foot a { color:var(--green); text-decoration:none; font-weight:600; transition:opacity .15s; }
        .auth-foot a:hover { opacity:.75; }
        .card-stamp {
            text-align:center; margin-top:22px;
            font-family:'JetBrains Mono',monospace;
            font-size:9.5px; color:var(--tx3); letter-spacing:.8px;
        }
    </style>
</head>
<body>

<div class="auth-card">

    <div class="auth-brand">
        <div class="auth-brand-icon"><i class="bi bi-person-plus-fill"></i></div>
        <div class="auth-brand-name">Create Account</div>
        <div class="auth-brand-sub">Join Lumenara</div>
    </div>

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

    <form action="${pageContext.request.contextPath}/register" method="post" id="reg-form">

        <%-- Username --%>
        <label for="username" class="field-label">Username</label>
        <div class="input-wrap">
            <i class="bi bi-person input-icon"></i>
            <input type="text" class="input-modern" id="username" name="username"
                   placeholder="Choose a username" required maxlength="50"
                   value="${not empty prevUsername ? prevUsername : ''}">
        </div>

        <%-- Email --%>
        <label for="email" class="field-label">Email Address</label>
        <div class="input-wrap">
            <i class="bi bi-envelope input-icon"></i>
            <input type="email" class="input-modern" id="email" name="email"
                   placeholder="Enter your email address" required maxlength="150"
                   autocomplete="email"
                   value="${not empty prevEmail ? prevEmail : ''}">
        </div>

        <%-- Role --%>
        <label for="role" class="field-label">Role</label>
        <div class="input-wrap" style="margin-bottom:14px;">
            <select class="auth-select" id="role" name="role">
                <option value="user"  ${(empty prevRole || prevRole == 'user')  ? 'selected' : ''}>User</option>
                <option value="admin" ${prevRole == 'admin' ? 'selected' : ''}>Admin</option>
            </select>
        </div>

        <%-- Password --%>
        <label for="password" class="field-label">Password</label>
        <div class="input-wrap" style="margin-bottom:6px;">
            <i class="bi bi-lock input-icon"></i>
            <input type="password" class="input-modern" id="password" name="password"
                   placeholder="At least 8 chars, 1 letter &amp; 1 number" required maxlength="100"
                   autocomplete="new-password">
            <button type="button" class="pw-toggle" id="pw-toggle-1" aria-label="Toggle password">
                <i class="bi bi-eye" id="pw-icon-1"></i>
            </button>
        </div>
        <%-- Strength bar --%>
        <div class="strength-bar-wrap"><div class="strength-bar" id="strength-bar"></div></div>
        <div class="strength-hint" id="strength-hint"></div>

        <%-- Confirm Password --%>
        <label for="confirmPassword" class="field-label">Confirm Password</label>
        <div class="input-wrap" style="margin-bottom:6px;">
            <i class="bi bi-lock-fill input-icon"></i>
            <input type="password" class="input-modern" id="confirmPassword" name="confirmPassword"
                   placeholder="Repeat your password" required maxlength="100"
                   autocomplete="new-password">
            <button type="button" class="pw-toggle" id="pw-toggle-2" aria-label="Toggle confirm password">
                <i class="bi bi-eye" id="pw-icon-2"></i>
            </button>
        </div>
        <div class="match-hint" id="match-hint"></div>

        <button type="submit" class="btn-auth" id="btn-register">
            <i class="bi bi-person-check"></i>Create Account
        </button>

    </form>

    <div class="or-divider"><div class="or-line"></div><span class="or-text">OR</span><div class="or-line"></div></div>

    <div class="auth-foot">
        Already have an account?
        <a href="${pageContext.request.contextPath}/login">Sign in</a>
    </div>

    <div class="card-stamp">LUMENARA &middot; NEW ACCOUNT</div>
</div>

<script>
    (function () {
        /* ── Password show/hide toggles ── */
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
        togglePw('pw-toggle-1', 'pw-icon-1', 'password');
        togglePw('pw-toggle-2', 'pw-icon-2', 'confirmPassword');

        /* ── Password strength meter ── */
        var pwInput   = document.getElementById('password');
        var bar       = document.getElementById('strength-bar');
        var hint      = document.getElementById('strength-hint');

        function scorePassword(pw) {
            var score = 0;
            if (pw.length >= 8)  score++;
            if (pw.length >= 12) score++;
            if (/[A-Z]/.test(pw)) score++;
            if (/[0-9]/.test(pw)) score++;
            if (/[^A-Za-z0-9]/.test(pw)) score++;
            return score;
        }

        var levels = [
            { pct: '0%',   color: 'transparent', label: '' },
            { pct: '25%',  color: '#F87171',      label: '⚠ Weak' },
            { pct: '50%',  color: '#FBBF24',      label: '▲ Fair' },
            { pct: '75%',  color: '#34D399',      label: '✓ Good' },
            { pct: '100%', color: '#00E896',      label: '✦ Strong' },
            { pct: '100%', color: '#00E896',      label: '✦ Strong' }
        ];

        if (pwInput) {
            pwInput.addEventListener('input', function () {
                var score = this.value.length === 0 ? 0 : Math.max(1, scorePassword(this.value));
                var lvl   = levels[score] || levels[0];
                bar.style.width      = lvl.pct;
                bar.style.background = lvl.color;
                hint.textContent     = lvl.label;
                hint.style.color     = lvl.color;
            });
        }

        /* ── Confirm password match indicator ── */
        var confirmInput = document.getElementById('confirmPassword');
        var matchHint    = document.getElementById('match-hint');

        function checkMatch() {
            if (!confirmInput.value) { matchHint.textContent = ''; return; }
            if (pwInput.value === confirmInput.value) {
                matchHint.textContent = '✓ Passwords match';
                matchHint.className   = 'match-hint ok';
            } else {
                matchHint.textContent = '✗ Passwords do not match';
                matchHint.className   = 'match-hint bad';
            }
        }
        if (confirmInput) {
            confirmInput.addEventListener('input', checkMatch);
            pwInput.addEventListener('input', checkMatch);
        }

        /* ── Client-side form validation before submit ── */
        var form = document.getElementById('reg-form');
        if (form) {
            form.addEventListener('submit', function (e) {
                var pw  = document.getElementById('password').value;
                var cpw = document.getElementById('confirmPassword').value;

                if (!/(?=.*[A-Za-z])(?=.*\d).{8,}/.test(pw)) {
                    e.preventDefault();
                    hint.textContent = '✗ Min 8 chars, 1 letter and 1 number required';
                    hint.style.color = '#F87171';
                    document.getElementById('password').focus();
                    return;
                }
                if (pw !== cpw) {
                    e.preventDefault();
                    matchHint.textContent = '✗ Passwords do not match';
                    matchHint.className   = 'match-hint bad';
                    document.getElementById('confirmPassword').focus();
                }
            });
        }

        /* ── Ripple on btn-auth ── */
        document.querySelectorAll('.btn-auth').forEach(function (b) {
            b.addEventListener('click', function (e) {
                var r = document.createElement('span');
                r.className = 'ripple';
                var rect = b.getBoundingClientRect(), sz = Math.max(rect.width, rect.height);
                r.style.cssText = 'width:' + sz + 'px;height:' + sz + 'px;left:'
                    + (e.clientX - rect.left - sz / 2) + 'px;top:'
                    + (e.clientY - rect.top  - sz / 2) + 'px;';
                b.appendChild(r);
                setTimeout(function () { r.parentNode && r.remove(); }, 550);
            });
        });
    })();
</script>
</body>
</html>
