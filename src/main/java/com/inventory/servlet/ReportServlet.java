package com.inventory.servlet;

import com.inventory.model.Report;
import com.inventory.service.ReportService;
import com.inventory.service.SalesService;
import com.inventory.util.FileHandler;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * ReportServlet — generates and displays reports.
 *
 * GET  /reports → shows all past reports.
 * POST /reports → generates a new report from current sales data.
 */
@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reportsPath = FileHandler.REPORTS_FILE;
        String salesPath   = FileHandler.SALES_FILE;
        String itemsPath   = FileHandler.ITEMS_FILE;

        SalesService salesService   = new SalesService(salesPath, itemsPath);
        ReportService reportService = new ReportService(reportsPath, salesService);

        List<Report> reports = reportService.getAllReports();
        req.setAttribute("reports", reports);

        // Flash message
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            req.setAttribute("successMsg", successMsg);
            session.removeAttribute("successMsg");
        }

        req.getRequestDispatcher("/views/report/viewReport.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reportsPath = FileHandler.REPORTS_FILE;
        String salesPath   = FileHandler.SALES_FILE;
        String itemsPath   = FileHandler.ITEMS_FILE;

        SalesService salesService   = new SalesService(salesPath, itemsPath);
        ReportService reportService = new ReportService(reportsPath, salesService);

        Report generated = reportService.generateReport();
        session.setAttribute("successMsg",
                "Report generated: " + generated.getReportId()
                        + " | Revenue: $" + generated.getTotalRevenue());

        resp.sendRedirect(req.getContextPath() + "/reports");
    }
}
