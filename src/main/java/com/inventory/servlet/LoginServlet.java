package com.inventory.servlet;

import com.inventory.model.User;
import com.inventory.service.UserService;
import com.inventory.util.FileHandler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    //Displays the login page
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/user/login.jsp").forward(req, resp);
    }

    //Processes the submitted login form
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Resolve the absolute path to users.txt at runtime
        String usersPath = getServletContext().getRealPath(FileHandler.USERS_FILE);

        // OOP: delegate authentication to the service layer (Abstraction)
        UserService userService = new UserService(usersPath);
        User user = userService.authenticate(username, password);

        if (user != null) {
            // Store user in session for subsequent requests
            HttpSession session = req.getSession();
            session.setAttribute("loggedInUser", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            // Redirect based on role
            if ("admin".equalsIgnoreCase(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/viewInventory");
            }
        } else {
            req.setAttribute("error", "Invalid username or password.");
            req.getRequestDispatcher("/views/user/login.jsp").forward(req, resp);
        }
    }
}
