package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.service.InventoryService;
import com.inventory.util.FilePath;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/editStock")
public class EditStockServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemId    = req.getParameter("id");
        String itemsPath = FilePath.getItemsPath(getServletContext());
        InventoryService service = new InventoryService(itemsPath);

        List<Item> items = service.getAllItems();
        Item target = null;
        for (Item item : items) {
            if (item.getId().equals(itemId)) {
                target = item;
                break;
            }
        }

        if (target == null) {
            resp.sendRedirect(req.getContextPath() + "/viewInventory");
            return;
        }

        req.setAttribute("item", target);
        req.getRequestDispatcher("/views/inventory/editStock.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String id         = req.getParameter("id");
        String name       = req.getParameter("name");
        String category   = req.getParameter("category");
        String qtyStr     = req.getParameter("quantity");
        String priceStr   = req.getParameter("price");
        String expiryDate = req.getParameter("expiryDate");

        if (name == null || name.trim().isEmpty()
                || category == null || category.trim().isEmpty()
                || qtyStr == null || qtyStr.trim().isEmpty()
                || priceStr == null || priceStr.trim().isEmpty()) {
            req.setAttribute("error", "Name, Category, Quantity, and Price are required.");
            doGet(req, resp);
            return;
        }

        boolean isExpiryRequired = "Medicine".equalsIgnoreCase(category)
                || "Food".equalsIgnoreCase(category)
                || "Beverages".equalsIgnoreCase(category);

        if (isExpiryRequired && (expiryDate == null || expiryDate.trim().isEmpty())) {
            req.setAttribute("error", "Expiry Date is required for Medicine, Food, and Beverages.");
            doGet(req, resp);
            return;
        }

        if (expiryDate == null || expiryDate.trim().isEmpty()) {
            expiryDate = "N/A";
        }

        int    quantity;
        double price;
        try {
            quantity = Integer.parseInt(qtyStr.trim());
            price    = Double.parseDouble(priceStr.trim());
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Quantity and Price must be valid numbers.");
            doGet(req, resp);
            return;
        }

        String itemsPath = FilePath.getItemsPath(getServletContext());
        InventoryService service = new InventoryService(itemsPath);
        Item existingItem = null;
        for (Item item : service.getAllItems()) {
            if (item.getId().equals(id)) {
                existingItem = item;
                break;
            }
        }
        
        String status = (existingItem != null) ? existingItem.getStatus() : "Active";

        Item updated = new Item(id, name.trim(), category.trim(),
                quantity, price, expiryDate.trim(), status);

        service.updateItem(updated);

        session.setAttribute("successMsg", "Item updated successfully.");
        resp.sendRedirect(req.getContextPath() + "/viewInventory");
    }
}
