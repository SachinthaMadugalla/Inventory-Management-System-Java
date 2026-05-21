package com.inventory.servlet;

import com.inventory.model.User;
import com.inventory.service.UserService;
import com.inventory.util.FileHandler;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

/**
 * RegisterServlet — allows new users to create an account.
 *
 * GET  /register → shows the registration form.
 * POST /register → validates and saves the new user.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName        = req.getParameter("fullName");
        String username        = req.getParameter("username");
        String email           = req.getParameter("email");
        String password        = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String role            = req.getParameter("role");

        // ── Validate required fields ──────────────────────────────────────────
        if (fullName == null || fullName.trim().isEmpty()) {
            req.setAttribute("error", "Full name is required.");
            preserveInput(req, fullName, username, email, role);
            req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
            return;
        }

        if (username == null || username.trim().isEmpty()) {
            req.setAttribute("error", "Username is required.");
            preserveInput(req, fullName, username, email, role);
            req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "Email address is required.");
            preserveInput(req, fullName, username, email, role);
            req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
            return;
        }

        // Basic email format check
        if (!email.trim().matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            req.setAttribute("error", "Please enter a valid email address.");
            preserveInput(req, fullName, username, email, role);
            req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Password is required.");
            preserveInput(req, fullName, username, email, role);
            req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
            return;
        }

        // Password strength: at least 8 chars, one letter, one digit
        if (!password.matches("^(?=.*[A-Za-z])(?=.*\\d).{8,}$")) {
            req.setAttribute("error",
                    "Password must be at least 8 characters and include at least one letter and one number.");
            preserveInput(req, fullName, username, email, role);
            req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            preserveInput(req, fullName, username, email, role);
            req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
            return;
        }

        // Default role to "user" if not provided or invalid
        if (!"admin".equalsIgnoreCase(role) && !"user".equalsIgnoreCase(role)) {
            role = "user";
        }

        User newUser = new User(
                fullName.trim(),
                username.trim(),
                password.trim(),
                role.toLowerCase(),
                email.trim().toLowerCase()
        );

        UserService userService = new UserService(FileHandler.USERS_FILE);
        String result = userService.register(newUser);

        switch (result) {
            case "ok":
                req.setAttribute("success", "Account created! You can now log in.");
                req.getRequestDispatcher("/views/user/login.jsp").forward(req, resp);
                break;
            case "username_taken":
                req.setAttribute("error", "Username '" + username.trim() + "' is already taken.");
                preserveInput(req, fullName, username, email, role);
                req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
                break;
            case "email_taken":
                req.setAttribute("error", "An account with that email address already exists.");
                preserveInput(req, fullName, username, email, role);
                req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
                break;
            default:
                req.setAttribute("error", "Registration failed. Please try again.");
                req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
        }
    }

    /** Re-populates form fields after a validation error so the user doesn't retype everything. */
    private void preserveInput(HttpServletRequest req,
                               String fullName, String username,
                               String email, String role) {
        req.setAttribute("prevFullName", fullName  != null ? fullName.trim()  : "");
        req.setAttribute("prevUsername", username  != null ? username.trim()  : "");
        req.setAttribute("prevEmail",    email     != null ? email.trim()     : "");
        req.setAttribute("prevRole",     role      != null ? role             : "user");
    }
}
