package com.inventory.servlet;

import com.inventory.model.User;
import com.inventory.service.EmailService;
import com.inventory.service.UserService;
import com.inventory.util.FileHandler;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.Instant;

/**
 * ForgotPasswordServlet — three-step OTP-based password reset.
 *
 * Step 1  GET  /forgotPassword       → show "enter your email" form
 * Step 1  POST action=sendOtp        → look up email, generate OTP, send email,
 *                                      store OTP + expiry + username in session
 * Step 2  POST action=verifyOtp      → verify OTP (with 10-min expiry check),
 *                                      mark session as verified
 * Step 3  POST action=resetPassword  → validate password strength + match,
 *                                      update password, clear session data
 */
@WebServlet("/forgotPassword")
public class ForgotPasswordServlet extends HttpServlet {

    // OTP is valid for 10 minutes
    private static final long OTP_VALIDITY_SECONDS = 10 * 60;

    // Minimum password strength: 8+ chars, at least one letter and one digit
    private static final String PASSWORD_PATTERN = "^(?=.*[A-Za-z])(?=.*\\d).{8,}$";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Always start fresh — clear any leftover reset session data
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("resetOtp");
            session.removeAttribute("resetOtpExpiry");
            session.removeAttribute("resetUsername");
            session.removeAttribute("otpVerified");
        }
        req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        UserService  userService  = new UserService(FileHandler.USERS_FILE);
        EmailService emailService = new EmailService();

        // ── STEP 1: look up email, generate & send OTP ───────────────────────
        if ("sendOtp".equals(action)) {
            String email = req.getParameter("email");

            if (email == null || email.trim().isEmpty()) {
                req.setAttribute("error", "Please enter your email address.");
                req.setAttribute("step", "email");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
                return;
            }

            if (!email.trim().matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
                req.setAttribute("error", "Please enter a valid email address.");
                req.setAttribute("step", "email");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
                return;
            }

            User user = userService.findByEmail(email.trim());
            if (user == null) {
                // Generic message — don't reveal whether the email is registered
                req.setAttribute("success",
                        "If that email is registered, a 6-digit OTP has been sent to it.");
                req.setAttribute("step", "otp");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
                return;
            }

            // Generate OTP and store it in the session
            String otp    = emailService.generateOtp();
            long   expiry = Instant.now().getEpochSecond() + OTP_VALIDITY_SECONDS;

            HttpSession session = req.getSession();
            session.setAttribute("resetOtp",       otp);
            session.setAttribute("resetOtpExpiry", expiry);
            session.setAttribute("resetUsername",  user.getUsername());
            session.setAttribute("otpVerified",    false);

            // Send the OTP email
            try {
                emailService.sendOtpEmail(email.trim(), otp);
            } catch (MessagingException e) {
                getServletContext().log("[ForgotPassword] Failed to send OTP: " + e.getMessage());
                req.setAttribute("error",
                        "Could not send the OTP email. Please try again later.");
                req.setAttribute("step", "email");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("step",    "otp");
            req.setAttribute("success",
                    "A 6-digit OTP has been sent to " + maskEmail(email.trim()) + ". Check your inbox.");
            req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
            return;
        }

        // ── STEP 2: verify the OTP ────────────────────────────────────────────
        if ("verifyOtp".equals(action)) {
            HttpSession session   = req.getSession(false);
            String      enteredOtp = req.getParameter("otp");

            if (session == null
                    || session.getAttribute("resetOtp")       == null
                    || session.getAttribute("resetOtpExpiry") == null) {
                req.setAttribute("error", "Session expired. Please start again.");
                req.setAttribute("step", "email");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
                return;
            }

            String storedOtp = (String) session.getAttribute("resetOtp");
            long   expiry    = (Long)   session.getAttribute("resetOtpExpiry");

            // Check expiry
            if (Instant.now().getEpochSecond() > expiry) {
                session.removeAttribute("resetOtp");
                session.removeAttribute("resetOtpExpiry");
                req.setAttribute("error", "Your OTP has expired. Please request a new one.");
                req.setAttribute("step", "email");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
                return;
            }

            // Check OTP value
            if (!storedOtp.equals(enteredOtp != null ? enteredOtp.trim() : "")) {
                req.setAttribute("error", "Incorrect OTP. Please try again.");
                req.setAttribute("step", "otp");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
                return;
            }

            // OTP correct — mark session as verified and advance to step 3
            session.setAttribute("otpVerified", true);
            req.setAttribute("step", "newPassword");
            req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
            return;
        }

        // ── STEP 3: set the new password ──────────────────────────────────────
        if ("resetPassword".equals(action)) {
            HttpSession session = req.getSession(false);

            // Guard: must have passed OTP verification
            if (session == null
                    || !Boolean.TRUE.equals(session.getAttribute("otpVerified"))
                    || session.getAttribute("resetUsername") == null) {
                req.setAttribute("error", "Session expired or invalid. Please start again.");
                req.setAttribute("step", "email");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
                return;
            }

            String username        = (String) session.getAttribute("resetUsername");
            String newPassword     = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");

            if (newPassword == null || newPassword.trim().isEmpty()
                    || confirmPassword == null || confirmPassword.trim().isEmpty()) {
                req.setAttribute("error", "Please fill in both password fields.");
                req.setAttribute("step", "newPassword");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
                return;
            }

            // Password strength check
            if (!newPassword.matches(PASSWORD_PATTERN)) {
                req.setAttribute("error",
                        "Password must be at least 8 characters and include at least one letter and one number.");
                req.setAttribute("step", "newPassword");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
                return;
            }

            // Password match check
            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("error", "Passwords do not match. Please try again.");
                req.setAttribute("step", "newPassword");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
                return;
            }

            boolean success = userService.resetPassword(username, newPassword);

            // Clear all reset-related session data
            session.removeAttribute("resetOtp");
            session.removeAttribute("resetOtpExpiry");
            session.removeAttribute("resetUsername");
            session.removeAttribute("otpVerified");

            if (success) {
                req.setAttribute("success", "Password reset successfully. You can now log in.");
                req.getRequestDispatcher("/views/user/login.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Something went wrong. Please try again.");
                req.setAttribute("step", "email");
                req.getRequestDispatcher("/views/user/forgotPassword.jsp").forward(req, resp);
            }
            return;
        }

        // Unknown action — go back to start
        resp.sendRedirect(req.getContextPath() + "/forgotPassword");
    }

    /** Masks an email for display: "sachini@gmail.com" → "sa****@gmail.com" */
    private String maskEmail(String email) {
        int at = email.indexOf('@');
        if (at <= 2) return email;
        return email.substring(0, 2) + "****" + email.substring(at);
    }
}

