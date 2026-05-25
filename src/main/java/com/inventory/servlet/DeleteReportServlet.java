package com.inventory.servlet;

import com.inventory.service.ReportService;
import com.inventory.util.FilePath;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/deleteReport")
public class DeleteReportServlet extends HttpServlet {

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

        String reportId = req.getParameter("reportId");

        if (reportId != null && !reportId.trim().isEmpty()) {
            String reportsPath = FilePath.getReportsPath(getServletContext());
            ReportService reportService = new ReportService(reportsPath);
            
            boolean success = reportService.deleteReport(reportId);
            
            if (success) {
                session.setAttribute("successMsg", "Report '" + reportId + "' deleted successfully.");
            } else {
                session.setAttribute("errorMsg", "Could not delete report '" + reportId + "'.");
            }
        }

        resp.sendRedirect(req.getContextPath() + "/reports");
    }
}