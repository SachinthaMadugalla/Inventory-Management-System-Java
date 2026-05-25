package com.inventory.servlet;

import com.inventory.service.SalesService;
import com.inventory.util.FilePath;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * DeleteSaleServlet - Deletes a sale transaction.
 * Requires admin role.
 */
@WebServlet("/deleteSale")
public class DeleteSaleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Verify admin role
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("admin")) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        String saleId = req.getParameter("saleId");
        if (saleId != null && !saleId.trim().isEmpty()) {
            String salesPath = FilePath.getSalesPath(getServletContext());
            String itemsPath = FilePath.getItemsPath(getServletContext());
            SalesService salesService = new SalesService(salesPath, itemsPath);

            boolean deleted = salesService.deleteSale(saleId);
            if (deleted) {
                session.setAttribute("successMsg", "Transaction " + saleId + " deleted successfully.");
            } else {
                session.setAttribute("errorMsg", "Failed to delete transaction " + saleId + ".");
            }
        }
        
        resp.sendRedirect(req.getContextPath() + "/viewSales");
    }
}