package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.service.InventoryService;
import com.inventory.service.SalesService;
import com.inventory.util.FileHandler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * DashboardServlet — aggregates summary statistics for the admin dashboard.
 *
 * OOP Concept: ABSTRACTION
 * Delegates data retrieval to InventoryService and SalesService.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session guard — redirect to login if not authenticated
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemsPath = getServletContext().getRealPath(FileHandler.ITEMS_FILE);
        String salesPath = getServletContext().getRealPath(FileHandler.SALES_FILE);

        InventoryService inventoryService = new InventoryService(itemsPath);
        SalesService salesService = new SalesService(salesPath, itemsPath);

        List<Item> items = inventoryService.getAllItems();

        // Compute low-stock count (quantity < 10)
        long lowStockCount = items.stream().filter(i -> i.getQuantity() < 10).count();

        req.setAttribute("totalItems",    items.size());
        req.setAttribute("totalSales",    salesService.getAllSales().size());
        req.setAttribute("totalRevenue",  salesService.getTotalRevenue());
        req.setAttribute("lowStockCount", lowStockCount);
        req.setAttribute("recentItems",   items.subList(0, Math.min(5, items.size())));

        req.getRequestDispatcher("/views/dashboard.jsp").forward(req, resp);
    }
}
