package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.service.InventoryService;
import com.inventory.service.SalesService;
import com.inventory.util.FilePath;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemsPath = FilePath.getItemsPath(getServletContext());
        String salesPath = FilePath.getSalesPath(getServletContext());

        InventoryService inventoryService = new InventoryService(itemsPath);
        SalesService salesService = new SalesService(salesPath, itemsPath);

        List<Item> items = inventoryService.getAllItems();

        long lowStockCount = items.stream().filter(i -> i.getQuantity() < 10).count();

        req.setAttribute("totalItems",    items.size());
        req.setAttribute("totalSales",    salesService.getAllSales().size());
        req.setAttribute("totalRevenue",  salesService.getTotalRevenue());
        req.setAttribute("lowStockCount", lowStockCount);
        req.setAttribute("recentItems",   items.subList(0, Math.min(5, items.size())));

        req.getRequestDispatcher("/views/dashboard.jsp").forward(req, resp);
    }
}
