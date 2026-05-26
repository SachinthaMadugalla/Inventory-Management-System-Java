package com.inventory.servlet;

import com.inventory.service.UserService;
import com.inventory.util.FilePath;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        String usernameToDelete = req.getParameter("username");
        String loggedInUsername = (String) session.getAttribute("username");

        if (usernameToDelete != null && !usernameToDelete.equals(loggedInUsername)) {
            UserService userService = new UserService(FilePath.getUsersPath(getServletContext()));
            boolean success = userService.deleteUser(usernameToDelete);
            if (success) {
                session.setAttribute("successMsg", "User '" + usernameToDelete + "' deleted successfully.");
            } else {
                session.setAttribute("errorMsg", "Could not delete user '" + usernameToDelete + "'.");
            }
        } else {
            session.setAttribute("errorMsg", "You cannot delete your own account.");
        }
        resp.sendRedirect(req.getContextPath() + "/userManagement");
    }
}