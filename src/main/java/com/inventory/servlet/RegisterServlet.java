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

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String role     = req.getParameter("role");

        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Username and password are required.");
            req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
            return;
        }

        // Default role to "user" if not provided or invalid
        if (!"admin".equalsIgnoreCase(role) && !"user".equalsIgnoreCase(role)) {
            role = "user";
        }

        User newUser = new User(username.trim(), password.trim(), role.toLowerCase());

        String usersPath = getServletContext().getRealPath(FileHandler.USERS_FILE);
        UserService userService = new UserService(usersPath);

        boolean success = userService.register(newUser);
        if (success) {
            req.setAttribute("success", "Account created! You can now log in.");
            req.getRequestDispatcher("/views/user/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Username '" + username + "' is already taken.");
            req.getRequestDispatcher("/views/user/register.jsp").forward(req, resp);
        }
    }
}