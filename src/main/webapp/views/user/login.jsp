<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@elvariable id="error"   type="java.lang.String"--%>
<%--@elvariable id="success" type="java.lang.String"--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Lumenara</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=Outfit:wght@300;400;500;600&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <style>
        /* ============================================================
           Lumenara — Login · Midnight Purple 3D Crystal Field
           ============================================================ */
        :root {
            --bg:      #07041A;
            --green:   #00E896;
            --violet:  #8B5CF6;
            --v-deep:  #5B21B6;
            --g-dim:   rgba(0,232,150,.10);
            --g-glow:  rgba(0,232,150,.38);
            --g-soft:  rgba(0,232,150,.18);
            --v-dim:   rgba(139,92,246,.12);
            --v-glow:  rgba(139,92,246,.40);
            --v-soft:  rgba(139,92,246,.20);
            --tx1:     #EEE8FF;
            --tx2:     #8878A6;
            --tx3:     #3A2F5A;
            --bd:      rgba(255,255,255,.055);
            --bd2:     rgba(255,255,255,.10);
            --bdv:     rgba(139,92,246,.25);
            --bdg:     rgba(0,232,150,.18);
            --red:     #F87171;
            --r-dim:   rgba(248,113,113,.10);
        }

        *, *::before, *::after { box-sizing: border-box; }

        body {
            font-family: 'Outfit', system-ui, sans-serif;
            /* midnight purple base */
            background-color: var(--bg);
            /* fine dot grid for texture */
            background-image: radial-gradient(
                    circle at 1px 1px,
                    rgba(139,92,246,.06) 1px, transparent 0);
            background-size: 32px 32px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 32px 16px;
            overflow: hidden;
            position: relative;
            color: var(--tx1);
            margin: 0;
        }

        /* ── canvas fills the background ── */
        #crystal-canvas {
            position: fixed;
            inset: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 1;
        }

        /* ── two large ambient orbs ── */
        .orb {
            position: fixed;
            border-radius: 50%;
            pointer-events: none;
            z-index: 0;
        }
        .orb-1 {
            top: -30%; right: -20%;
            width: 75vw; height: 75vw;
            background: radial-gradient(circle,
            rgba(91,33,182,.10) 0%, transparent 65%);
            animation: orb-drift 30s ease-in-out infinite;
        }
        .orb-2 {
            bottom: -30%; left: -20%;
            width: 65vw; height: 65vw;
            background: radial-gradient(circle,
            rgba(55,10,120,.12) 0%, transparent 65%);
            animation: orb-drift 38s ease-in-out infinite reverse;
        }
        @keyframes orb-drift {
            0%,100% { transform: translate(0,0)       scale(1);    }
            33%     { transform: translate(50px,-60px) scale(1.06); }
            66%     { transform: translate(-40px,55px) scale(.95);  }
        }

        /* ── auth card ── */
        .auth-card {
            position: relative;
            z-index: 10;
            width: 100%;
            max-width: 420px;
            background: rgba(7, 4, 22, 0.88);
            backdrop-filter: blur(28px) saturate(140%);
            -webkit-backdrop-filter: blur(28px) saturate(140%);
            border-radius: 26px;
            padding: 42px 38px 36px;
            animation: card-rise .65s cubic-bezier(.16,1,.3,1) both;
            transition: box-shadow .4s ease;
        }
        /* gradient crystal-glass border */
        .auth-card::before {
            content: '';
            position: absolute; inset: -1px;
            border-radius: 27px;
            background: linear-gradient(140deg,
            rgba(139,92,246,.55),
            rgba(80,30,180,.35),
            rgba(0,232,150,.15),
            rgba(139,92,246,.20));
            z-index: -1;
        }
        /* outer halo breathe */
        .auth-card::after {
            content: '';
            position: absolute; inset: -28px;
            border-radius: 50px;
            background: radial-gradient(ellipse at 50% 55%,
            rgba(91,33,182,.08) 0%, transparent 68%);
            animation: halo 5s ease-in-out infinite;
            pointer-events: none; z-index: -2;
        }
        @keyframes card-rise {
            from { opacity:0; transform:translateY(30px) scale(.96); filter:blur(5px); }
            to   { opacity:1; transform:none; filter:none; }
        }
        @keyframes halo {
            0%,100% { opacity:.5; transform:scale(1);    }
            50%     { opacity:1;  transform:scale(1.05); }
        }

        /* ── brand ── */
        .auth-brand {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 32px;
        }
        .brand-icon {
            width: 62px; height: 62px; border-radius: 19px;
            background: linear-gradient(140deg, var(--green), rgba(0,200,110,.45));
            display: flex; align-items: center; justify-content: center;
            font-size: 28px; color: #03100A;
            margin-bottom: 16px;
            animation: icon-pulse 3.8s ease-in-out infinite;
        }
        @keyframes icon-pulse {
            0%,100% { box-shadow: 0 0 14px var(--g-glow); }
            50%     { box-shadow: 0 0 32px var(--g-glow), 0 0 64px var(--g-soft); }
        }
        .brand-name {
            font-family: 'Syne', sans-serif;
            font-size: 23px; font-weight: 800; letter-spacing: -.5px;
            background: linear-gradient(125deg, var(--tx1) 40%, var(--violet));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .brand-sub {
            font-size: 12.5px; color: var(--tx2);
            margin-top: 5px; text-align: center; letter-spacing: .2px;
        }

        /* ── alerts ── */
        .auth-alert {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 12px 14px; border-radius: 12px;
            font-size: 13px; line-height: 1.5;
            margin-bottom: 18px;
        }
        .auth-alert.is-error {
            background: var(--r-dim);
            border: 1px solid rgba(248,113,113,.22);
            color: var(--red);
        }
        .auth-alert.is-success {
            background: var(--g-dim);
            border: 1px solid var(--bdg);
            color: var(--green);
        }
        .auth-dismiss {
            margin-left: auto; flex-shrink: 0;
            background: none; border: none;
            color: inherit; opacity: .55;
            cursor: pointer; font-size: 14px; padding: 0;
        }
        .auth-dismiss:hover { opacity: 1; }

        /* ── form fields ── */
        .field-label {
            display: block;
            font-size: 9.5px; font-weight: 600;
            letter-spacing: 1.1px; text-transform: uppercase;
            color: var(--tx2); margin-bottom: 7px;
        }
        .input-wrap { position: relative; margin-bottom: 14px; }
        .input-icon {
            position: absolute; left: 13px; top: 50%;
            transform: translateY(-50%);
            font-size: 14px; color: var(--tx3); pointer-events: none;
        }
        .input-field {
            width: 100%;
            background: rgba(139,92,246,.05);
            border: 1px solid rgba(139,92,246,.18);
            border-radius: 12px;
            padding: 11px 38px 11px 38px;
            color: var(--tx1);
            font-family: 'Outfit', sans-serif; font-size: 14px;
            outline: none;
            transition: border-color .2s, box-shadow .2s, background .2s;
        }
        .input-field::placeholder { color: var(--tx3); }
        .input-field:focus {
            border-color: var(--violet);
            background: rgba(139,92,246,.08);
            box-shadow: 0 0 0 3px var(--v-dim), 0 0 24px rgba(139,92,246,.06);
        }
        .pw-toggle {
            position: absolute; right: 12px; top: 50%;
            transform: translateY(-50%);
            font-size: 14px; color: var(--tx3);
            cursor: pointer; background: none; border: none;
            padding: 4px; line-height: 1; transition: color .15s;
        }
        .pw-toggle:hover { color: var(--tx1); }

        /* ── submit button ── */
        .btn-login {
            width: 100%; padding: 13px;
            border-radius: 999px; border: none;
            background: linear-gradient(135deg, var(--green) 0%, rgba(0,200,120,.85) 100%);
            color: #031510;
            font-family: 'Outfit', sans-serif;
            font-size: 14.5px; font-weight: 700;
            letter-spacing: .3px;
            cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 9px;
            margin-top: 10px;
            box-shadow: 0 4px 24px var(--g-glow);
            position: relative; overflow: hidden;
            transition: box-shadow .22s, transform .1s;
        }
        .btn-login::before {
            content: '';
            position: absolute; top: 0; left: -80%;
            width: 45%; height: 100%;
            background: linear-gradient(90deg, transparent,
            rgba(255,255,255,.20), transparent);
            transform: skewX(-18deg);
            transition: left .45s ease;
        }
        .btn-login:hover::before { left: 130%; }
        .btn-login:hover  {
            box-shadow: 0 8px 34px var(--g-glow), 0 0 0 3px var(--g-dim);
        }
        .btn-login:active { transform: scale(.98); }

        .ripple {
            position: absolute; border-radius: 50%;
            background: rgba(255,255,255,.22);
            transform: scale(0);
            animation: ripple-pop .52s linear;
            pointer-events: none;
        }
        @keyframes ripple-pop { to { transform: scale(3.5); opacity: 0; } }

        /* ── divider & footer ── */
        .or-divider { display: flex; align-items: center; gap: 12px; margin: 22px 0 18px; }
        .or-line {
            flex: 1; height: 1px;
            background: linear-gradient(90deg, transparent, rgba(139,92,246,.22), transparent);
        }
        .or-text { font-size: 10px; color: var(--tx3); letter-spacing: .9px; font-weight: 600; }

        .auth-foot { text-align: center; font-size: 13px; color: var(--tx2); }
        .auth-foot a {
            color: var(--violet); text-decoration: none;
            font-weight: 600; transition: opacity .15s;
        }
        .auth-foot a:hover { opacity: .75; }

        .card-stamp {
            text-align: center; margin-top: 22px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 9.5px; color: var(--tx3); letter-spacing: .9px;
        }
    </style>
</head>
<body>

<%-- 3D crystal canvas — filled entirely by JS --%>
<canvas id="crystal-canvas"></canvas>

<%-- ambient orbs --%>
<div class="orb orb-1"></div>
<div class="orb orb-2"></div>

<%-- ══════════════ Auth card ══════════════ --%>
<div class="auth-card" id="auth-card">

    <div class="auth-brand">
        <div class="brand-icon"><i class="bi bi-box-seam-fill"></i></div>
        <div class="brand-name">Lumenara</div>
        <div class="brand-sub">Inventory &amp; Stock Management</div>
    </div>

    <%-- Error alert --%>
    <c:if test="${not empty error}">
        <div class="auth-alert is-error" id="error-alert">
            <i class="bi bi-exclamation-triangle-fill"
               style="font-size:14px;flex-shrink:0;margin-top:1px;"></i>
            <span>${error}</span>
            <button class="auth-dismiss"
                    onclick="document.getElementById('error-alert').remove()"
                    aria-label="Dismiss">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
    </c:if>

    <%-- Success alert --%>
    <c:if test="${not empty success}">
        <div class="auth-alert is-success">
            <i class="bi bi-check-circle-fill"
               style="font-size:14px;flex-shrink:0;margin-top:1px;"></i>
            <span>${success}</span>
        </div>
    </c:if>

    <%-- Login form --%>
    <form action="${pageContext.request.contextPath}/login" method="post" novalidate>

        <label for="username" class="field-label">Username</label>
        <div class="input-wrap">
            <i class="bi bi-person input-icon"></i>
            <input type="text" class="input-field" id="username" name="username"
                   placeholder="Enter your username" maxlength="50"
                   required autofocus autocomplete="username">
        </div>

        <label for="password" class="field-label">Password</label>
        <div class="input-wrap">
            <i class="bi bi-lock input-icon"></i>
            <input type="password" class="input-field" id="password" name="password"
                   placeholder="Enter your password" maxlength="100"
                   required autocomplete="current-password">
            <button type="button" class="pw-toggle" id="pw-toggle"
                    aria-label="Toggle password visibility">
                <i class="bi bi-eye" id="pw-icon"></i>
            </button>
        </div>

        <button type="submit" class="btn-login" id="btn-login">
            <i class="bi bi-box-arrow-in-right"></i>Sign In
        </button>

    </form>

    <div class="or-divider">
        <div class="or-line"></div>
        <span class="or-text">OR</span>
        <div class="or-line"></div>
    </div>

    <div class="auth-foot">
        Don't have an account?
        <a href="${pageContext.request.contextPath}/register">Register here</a>
    </div>

    <div class="card-stamp">LUMENARA &middot; SECURE LOGIN &middot; v2.0</div>
</div>

<script>
    /* ============================================================
       CRYSTAL FIELD ENGINE
       — Perspective-projected 3D shapes (tetrahedra, octahedra,
         crystal shards) with per-face depth sorting (painter's
         algorithm), glowing vertices, and a floating particle
         network — all in midnight-purple + green/violet palette.
       ============================================================ */
    (function () {
        'use strict';

        var canvas = document.getElementById('crystal-canvas');
        var ctx    = canvas.getContext('2d');
        var W = 0, H = 0;

        function resize() {
            W = canvas.width  = window.innerWidth;
            H = canvas.height = window.innerHeight;
        }
        resize();
        window.addEventListener('resize', function () { resize(); initScene(); });

        /* ── perspective projection ── */
        var FOC = 680;

        function proj(x, y, z) {
            var d = z + FOC + 150;
            if (d < 10) d = 10;
            var s = FOC / d;
            return { sx: x * s + W * 0.5, sy: y * s + H * 0.5, s: s };
        }

        /* ── 3-axis rotation helpers ── */
        function rotX(p, a) {
            var s = Math.sin(a), c = Math.cos(a);
            return [p[0], p[1] * c - p[2] * s, p[1] * s + p[2] * c];
        }
        function rotY(p, a) {
            var s = Math.sin(a), c = Math.cos(a);
            return [p[0] * c + p[2] * s, p[1], -p[0] * s + p[2] * c];
        }
        function rotZ(p, a) {
            var s = Math.sin(a), c = Math.cos(a);
            return [p[0] * c - p[1] * s, p[0] * s + p[1] * c, p[2]];
        }

        /* ── face normal (normalised) ── */
        function faceNormal(v0, v1, v2) {
            var ax = v1[0] - v0[0], ay = v1[1] - v0[1], az = v1[2] - v0[2];
            var bx = v2[0] - v0[0], by = v2[1] - v0[1], bz = v2[2] - v0[2];
            var nx = ay * bz - az * by;
            var ny = az * bx - ax * bz;
            var nz = ax * by - ay * bx;
            var len = Math.sqrt(nx * nx + ny * ny + nz * nz) || 1;
            return [nx / len, ny / len, nz / len];
        }

        /* ── unit-scale shape definitions ── */
        /* Vertex coordinates + face index lists */
        var SHAPES = {
            tetra: {
                v: [[ 1, 1, 1],[ 1,-1,-1],[-1, 1,-1],[-1,-1, 1]],
                f: [[0,1,2],[0,1,3],[0,2,3],[1,2,3]]
            },
            octa: {
                v: [[ 1.3,0,0],[-1.3,0,0],[0, 1.3,0],[0,-1.3,0],[0,0, 1.3],[0,0,-1.3]],
                f: [[0,2,4],[0,4,3],[0,3,5],[0,5,2],
                    [1,4,2],[1,3,4],[1,5,3],[1,2,5]]
            },
            shard: {
                /* elongated bipyramid — classic crystal shape */
                v: [[ 0, 2.4, 0],[ 0,-2.4, 0],
                    [ 1, 0,   0],[-0.5, 0, 0.87],[-0.5, 0,-0.87]],
                f: [[0,2,3],[0,3,4],[0,4,2],
                    [1,3,2],[1,4,3],[1,2,4]]
            },
            prism: {
                /* triangular prism for variety */
                v: [[ 1, 1, 0],[-1, 1, 0],[ 0,-1, 0],
                    [ 1,-1, 1.6],[-1,-1, 1.6],[ 0, 1, 1.6]],
                f: [[0,1,2],[3,4,5],
                    [0,1,5],[0,5,3],[1,2,4],[1,4,5],[0,2,3],[2,4,3]]
            }
        };

        var crystals  = [];
        var particles = [];
        var tick      = 0;

        function initScene() {
            crystals  = [];
            particles = [];

            var typeList = ['tetra','octa','shard','shard','tetra','prism'];

            /* 13 crystals — scattered with bias toward screen edges */
            for (var i = 0; i < 13; i++) {
                var angle  = (i / 13) * Math.PI * 2 + Math.random() * 0.6;
                var radius = 0.28 + Math.random() * 0.74;
                var type   = typeList[Math.floor(Math.random() * typeList.length)];
                /* 60% violet, 40% green */
                var isViolet = Math.random() > 0.40;

                crystals.push({
                    type:    type,
                    cx:      Math.cos(angle) * radius * W * 0.54,
                    cy:      Math.sin(angle) * radius * H * 0.50,
                    cz:      -50 + Math.random() * 450,
                    rx:      Math.random() * 6.28,
                    ry:      Math.random() * 6.28,
                    rz:      Math.random() * 6.28,
                    srx:     (Math.random() - 0.5) * 0.0065,
                    sry:     (Math.random() - 0.5) * 0.0090,
                    srz:     (Math.random() - 0.5) * 0.0050,
                    size:    45 + Math.random() * 95,
                    isViolet:isViolet,
                    bob:     { phase: Math.random() * 6.28, amp: 12 + Math.random() * 22 }
                });
            }

            /* 70 floating network particles */
            for (var j = 0; j < 70; j++) {
                particles.push({
                    x:  (Math.random() - 0.5) * W * 2.2,
                    y:  (Math.random() - 0.5) * H * 2.2,
                    z:  Math.random() * 650,
                    vx: (Math.random() - 0.5) * 0.22,
                    vy: (Math.random() - 0.5) * 0.16,
                    vz: (Math.random() - 0.5) * 0.09,
                    r:  1.2 + Math.random() * 2.2,
                    /* 65% violet, 35% green */
                    isViolet: Math.random() > 0.35
                });
            }
        }
        initScene();

        /* ── temp arrays reused each frame to avoid GC pressure ── */
        var tmpFaces = [];

        /* ── draw a triangle face ── */
        function drawFace(sx0, sy0, sx1, sy1, sx2, sy2, fillStyle, lineStyle,
                          fillAlpha, lineAlpha, lw) {
            if (fillAlpha > 0.005) {
                ctx.globalAlpha = fillAlpha;
                ctx.fillStyle   = fillStyle;
                ctx.beginPath();
                ctx.moveTo(sx0, sy0);
                ctx.lineTo(sx1, sy1);
                ctx.lineTo(sx2, sy2);
                ctx.closePath();
                ctx.fill();
            }
            if (lineAlpha > 0.015) {
                ctx.globalAlpha = lineAlpha;
                ctx.strokeStyle = lineStyle;
                ctx.lineWidth   = lw;
                ctx.lineJoin    = 'round';
                ctx.beginPath();
                ctx.moveTo(sx0, sy0);
                ctx.lineTo(sx1, sy1);
                ctx.lineTo(sx2, sy2);
                ctx.closePath();
                ctx.stroke();
            }
        }

        /* ── main render loop ── */
        function frame() {
            tick++;
            ctx.clearRect(0, 0, W, H);

            /* ── 1 · soft radial background glow (purple atmosphere) ── */
            var bg = ctx.createRadialGradient(W * 0.5, H * 0.48, 0, W * 0.5, H * 0.48, W * 0.72);
            bg.addColorStop(0,   'rgba(55, 18, 130, 0.28)');
            bg.addColorStop(0.45,'rgba(30,  8,  80, 0.20)');
            bg.addColorStop(1,   'rgba(6,   2,  18, 0.10)');
            ctx.globalAlpha = 1;
            ctx.fillStyle   = bg;
            ctx.fillRect(0, 0, W, H);

            /* ── 2 · update + project particles ── */
            var projPts = [];
            for (var pi = 0; pi < particles.length; pi++) {
                var p = particles[pi];
                p.x += p.vx; p.y += p.vy; p.z += p.vz;
                /* wrap */
                if (p.x < -W)   p.x =  W;  if (p.x > W)   p.x = -W;
                if (p.y < -H)   p.y =  H;  if (p.y > H)   p.y = -H;
                if (p.z < 0)    p.z = 650; if (p.z > 650)  p.z =  0;

                var pp   = proj(p.x, p.y, p.z);
                var dfac = 1 - p.z / 650;
                projPts.push({
                    x:    pp.sx,
                    y:    pp.sy,
                    z:    p.z,
                    r:    Math.max(0.6, p.r * pp.s * 1.8),
                    dfac: dfac,
                    iv:   p.isViolet
                });
            }

            /* ── 3 · particle network connection lines ── */
            ctx.save();
            ctx.lineWidth = 0.55;
            for (var a = 0; a < projPts.length - 1; a++) {
                for (var b = a + 1; b < projPts.length; b++) {
                    var pa = projPts[a], pb = projPts[b];
                    var dx = pa.x - pb.x, dy = pa.y - pb.y;
                    if (Math.abs(dx) > 195 || Math.abs(dy) > 195) continue;
                    var dist = Math.sqrt(dx * dx + dy * dy);
                    if (dist > 195) continue;
                    var lineA = (1 - dist / 195) * 0.10 * pa.dfac * pb.dfac;
                    ctx.globalAlpha = lineA;
                    ctx.strokeStyle = 'rgba(130, 80, 240, 1)';
                    ctx.beginPath();
                    ctx.moveTo(pa.x, pa.y);
                    ctx.lineTo(pb.x, pb.y);
                    ctx.stroke();
                }
            }
            ctx.restore();

            /* ── 4 · particle dots ── */
            for (var qi = 0; qi < projPts.length; qi++) {
                var pp2 = projPts[qi];
                if (pp2.r < 0.5) continue;
                var col = pp2.iv ? [139, 92, 246] : [0, 232, 150];
                ctx.save();
                ctx.globalAlpha  = pp2.dfac * 0.72;
                ctx.fillStyle    = 'rgb(' + col[0] + ',' + col[1] + ',' + col[2] + ')';
                ctx.shadowColor  = 'rgb(' + col[0] + ',' + col[1] + ',' + col[2] + ')';
                ctx.shadowBlur   = 7;
                ctx.beginPath();
                ctx.arc(pp2.x, pp2.y, Math.min(pp2.r, 4.5), 0, 6.2832);
                ctx.fill();
                ctx.restore();
            }

            /* ── 5 · 3D crystals ── */
            for (var ci = 0; ci < crystals.length; ci++) {
                var cr     = crystals[ci];
                var shape  = SHAPES[cr.type];

                /* update rotation */
                cr.rx += cr.srx;
                cr.ry += cr.sry;
                cr.rz += cr.srz;

                /* bob offset */
                var bob = Math.sin(tick * 0.009 + cr.bob.phase) * cr.bob.amp;

                /* transform vertices: scale → rotate → translate */
                var wv = [];
                for (var vi = 0; vi < shape.v.length; vi++) {
                    var sv = shape.v[vi];
                    var p3 = [sv[0] * cr.size, sv[1] * cr.size, sv[2] * cr.size];
                    p3 = rotX(p3, cr.rx);
                    p3 = rotY(p3, cr.ry);
                    p3 = rotZ(p3, cr.rz);
                    wv.push([p3[0] + cr.cx,
                        p3[1] + cr.cy + bob,
                        p3[2] + cr.cz]);
                }

                /* project all vertices */
                var sv2d = new Array(wv.length);
                for (var pvi = 0; pvi < wv.length; pvi++) {
                    sv2d[pvi] = proj(wv[pvi][0], wv[pvi][1], wv[pvi][2]);
                }

                /* depth factor for the whole crystal */
                var depthFac = Math.max(0, 1 - cr.cz / 600) * 0.9 + 0.1;

                /* build face depth list for painter's sort */
                tmpFaces.length = 0;
                for (var fi2 = 0; fi2 < shape.f.length; fi2++) {
                    var fc = shape.f[fi2];
                    var avgZ = (wv[fc[0]][2] + wv[fc[1]][2] + wv[fc[2]][2]) / 3;
                    tmpFaces.push({ fi: fi2, avgZ: avgZ });
                }
                tmpFaces.sort(function (a, b) { return b.avgZ - a.avgZ; }); /* back-to-front */

                /* colors */
                var edgeCol  = cr.isViolet ? '#8B5CF6' : '#00E896';
                var fillFront= cr.isViolet ? 'rgba(90,30,200,1)' : 'rgba(0,140,80,1)';
                var fillBack = cr.isViolet ? 'rgba(45,12,110,1)' : 'rgba(0,70,45,1)';

                /* draw faces */
                for (var si2 = 0; si2 < tmpFaces.length; si2++) {
                    var fci   = tmpFaces[si2].fi;
                    var face  = shape.f[fci];
                    var i0 = face[0], i1 = face[1], i2 = face[2];

                    var n   = faceNormal(wv[i0], wv[i1], wv[i2]);
                    var dot = -n[2]; /* positive = facing camera */

                    /* very dim fill regardless of facing; brighter if facing cam */
                    var fillA  = (dot > 0 ? 0.03 + dot * 0.09 : 0.018) * depthFac;
                    var strokeA= (0.28 + Math.max(0, dot) * 0.42) * depthFac;

                    drawFace(
                        sv2d[i0].sx, sv2d[i0].sy,
                        sv2d[i1].sx, sv2d[i1].sy,
                        sv2d[i2].sx, sv2d[i2].sy,
                        dot > 0 ? fillFront : fillBack, edgeCol,
                        fillA, strokeA, 1.3
                    );
                }

                /* glowing vertex dots */
                var vcol = cr.isViolet ? [139, 92, 246] : [0, 232, 150];
                for (var vgi = 0; vgi < wv.length; vgi++) {
                    var sp  = sv2d[vgi];
                    var vdf = Math.max(0, 1 - wv[vgi][2] / 600);
                    ctx.save();
                    ctx.globalAlpha = vdf * 0.85 * depthFac;
                    ctx.fillStyle   = 'rgb(' + vcol[0] + ',' + vcol[1] + ',' + vcol[2] + ')';
                    ctx.shadowColor = 'rgb(' + vcol[0] + ',' + vcol[1] + ',' + vcol[2] + ')';
                    ctx.shadowBlur  = 11;
                    ctx.beginPath();
                    ctx.arc(sp.sx, sp.sy, 2.8, 0, 6.2832);
                    ctx.fill();
                    ctx.restore();
                }
            }

            requestAnimationFrame(frame);
        }
        frame();

        /* ── button ripple ── */
        document.addEventListener('click', function (e) {
            var btn = e.target.closest('.btn-login');
            if (!btn) return;
            var r    = document.createElement('span');
            r.className = 'ripple';
            var rect = btn.getBoundingClientRect();
            var sz   = Math.max(rect.width, rect.height);
            r.style.cssText =
                'width:'  + sz + 'px;height:' + sz + 'px;' +
                'left:'   + (e.clientX - rect.left - sz / 2) + 'px;' +
                'top:'    + (e.clientY - rect.top  - sz / 2) + 'px;';
            btn.appendChild(r);
            setTimeout(function () { r.parentNode && r.remove(); }, 550);
        });

    })(); /* end crystal engine */

    /* ── password toggle ── */
    (function () {
        var tog = document.getElementById('pw-toggle');
        var pw  = document.getElementById('password');
        var ico = document.getElementById('pw-icon');
        if (tog && pw) {
            tog.addEventListener('click', function () {
                var hidden    = pw.type === 'password';
                pw.type       = hidden ? 'text' : 'password';
                ico.className = hidden ? 'bi bi-eye-slash' : 'bi bi-eye';
            });
        }
    })();
</script>

</body>
</html>
