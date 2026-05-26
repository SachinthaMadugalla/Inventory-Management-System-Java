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
 * 
 * VIVA NOTE: SINGLE RESPONSIBILITY PRINCIPLE (SRP)
 * This servlet has only ONE job: Handle the HTTP POST request to delete a sale.
 * It extracts data, checks security, and delegates the heavy lifting to the Service Layer.
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

        // Security/Business Rule - Only 'admin' users can delete sales.
        String role = (String) session.getAttribute("role");
        if (role == null || !role.equals("admin")) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        // Extracting the target ID passed from the viewSales.jsp form
        String saleId = req.getParameter("saleId");
        
        if (saleId != null && !saleId.trim().isEmpty()) {
            String salesPath = FilePath.getSalesPath(getServletContext());
            String itemsPath = FilePath.getItemsPath(getServletContext());
            
            //  ABSTRACTION IN ACTION
            // The Servlet doesn't know HOW the data is deleted (e.g., text files, databases).
            // It relies entirely on the SalesService abstraction.
            SalesService salesService = new SalesService(salesPath, itemsPath);

            // Delegation. The Servlet asks the Service Layer to do the work.
            boolean deleted = salesService.deleteSale(saleId);
            
            // State management. Setting a message to show on the View later.
            if (deleted) {
                session.setAttribute("successMsg", "Transaction " + saleId + " deleted successfully.");
            } else {
                session.setAttribute("errorMsg", "Failed to delete transaction " + saleId + ".");
            }
        }
        
        // Redirect back to the View controller to reload the page.
        resp.sendRedirect(req.getContextPath() + "/viewSales");
    }
}