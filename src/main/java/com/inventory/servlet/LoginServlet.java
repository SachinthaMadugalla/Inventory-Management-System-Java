package com.inventory.servlet;

import com.inventory.model.User;
import com.inventory.service.UserService;
import com.inventory.util.FileHandler;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Remember Me session duration: 7 days in seconds
    private static final int REMEMBER_ME_SECONDS = 7 * 24 * 60 * 60;

    // Default session timeout: 30 minutes
    private static final int DEFAULT_SESSION_SECONDS = 30 * 60;

    // Displays the login page
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/user/login.jsp").forward(req, resp);
    }

    // Processes the submitted login form
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // The field accepts either a username or an email address
        String usernameOrEmail = req.getParameter("usernameOrEmail");
        String password        = req.getParameter("password");
        String rememberMe      = req.getParameter("rememberMe"); // "on" if checked

        // Trim inputs to avoid trailing-space issues
        if (usernameOrEmail != null) usernameOrEmail = usernameOrEmail.trim();
        if (password        != null) password        = password.trim();

        // Delegate authentication to the service layer (supports email OR username)
        UserService userService = new UserService(FileHandler.USERS_FILE);
        User user = userService.authenticate(usernameOrEmail, password);

        if (user != null) {
            // Create a new session and store user info
            HttpSession session = req.getSession();
            session.setAttribute("loggedInUser", user);
            session.setAttribute("username",     user.getUsername());
            session.setAttribute("role",         user.getRole());

            // ApplyRemember Me: extend session timeout if checked
            if ("on".equals(rememberMe)) {
                session.setMaxInactiveInterval(REMEMBER_ME_SECONDS);
            } else {
                session.setMaxInactiveInterval(DEFAULT_SESSION_SECONDS);
            }

            // Redirect based on role
            if ("admin".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/viewInventory");
            }
        } else {
            req.setAttribute("error", "Invalid username/email or password.");
            req.setAttribute("prevInput", usernameOrEmail); // preserve the typed value
            req.getRequestDispatcher("/views/user/login.jsp").forward(req, resp);
        }
    }
}
