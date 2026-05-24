package com.inventory.servlet;

import com.inventory.model.User;
import com.inventory.service.UserService;
import com.inventory.util.FilePath;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setAttribute("user", session.getAttribute("loggedInUser"));
        req.getRequestDispatcher("/views/user/editProfile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("loggedInUser");
        String email = req.getParameter("email");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        UserService userService = new UserService(FilePath.getUsersPath(getServletContext()));

        // Update email
        if (email != null && !email.trim().isEmpty() && !email.trim().equalsIgnoreCase(currentUser.getEmail())) {
            currentUser.setEmail(email.trim());
        }

        // Update password
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("error", "Passwords do not match.");
                req.setAttribute("user", currentUser);
                req.getRequestDispatcher("/views/user/editProfile.jsp").forward(req, resp);
                return;
            }
            currentUser.setPassword(newPassword);
        }

        userService.updateUser(currentUser);
        session.setAttribute("loggedInUser", currentUser);
        req.setAttribute("success", "Profile updated successfully.");
        req.setAttribute("user", currentUser);
        req.getRequestDispatcher("/views/user/editProfile.jsp").forward(req, resp);
    }
}