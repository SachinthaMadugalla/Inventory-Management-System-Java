package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.service.InventoryService;
import com.inventory.util.FilePath;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/expiryManagement")
public class ExpiryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemsPath = FilePath.getItemsPath(getServletContext());
        InventoryService inventoryService = new InventoryService(itemsPath);
        ExpiryService expiryService = new ExpiryService(itemsPath);

        List<Item> sortedItems = inventoryService.getItemsSortedByExpiry();
        List<Item> expired = expiryService.getExpiredItems();
        List<Item> expiringSoon = expiryService.getExpiringSoonItems();

        req.setAttribute("sortedItems", sortedItems);
        req.setAttribute("expiringSoon", expiringSoon);
        req.setAttribute("expired", expired);

        req.getRequestDispatcher("/views/expiry/expiryManagment.jsp").forward(req, resp);
    }
}
