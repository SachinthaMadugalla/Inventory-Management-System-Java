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
import java.util.List;

@WebServlet("/userManagement")
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        //Verify admin role
        String role = (String) session.getAttribute("role");
        if (!"admin".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/dashboard"); // Or an error page
            return;
        }

        UserService userService = new UserService(FilePath.getUsersPath(getServletContext()));
        List<User> users = userService.getAllUsers();
        
        req.setAttribute("users", users);
        req.getRequestDispatcher("/views/user/userManagement.jsp").forward(req, resp);
    }
}