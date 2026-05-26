package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.service.InventoryService;
import com.inventory.util.FilePath;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/addStock")
public class AddStockServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemsPath = FilePath.getItemsPath(getServletContext());
        InventoryService service = new InventoryService(itemsPath);

        req.setAttribute("stackTop",  service.peekStack());
        req.setAttribute("stackSize", service.stackSize());

        req.getRequestDispatcher("/views/inventory/addStock.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

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
            req.setAttribute("error", "Quantity must be an integer and Price must be a number.");
            doGet(req, resp);
            return;
        }

        String itemId = "ITM-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        Item newItem = new Item(itemId, name.trim(), category.trim(),
                quantity, price, expiryDate.trim(), "Active");

        String itemsPath = FilePath.getItemsPath(getServletContext());
        InventoryService service = new InventoryService(itemsPath);
        service.addItem(newItem);

        req.getSession().setAttribute("successMsg", "Item '" + name + "' added successfully!");
        resp.sendRedirect(req.getContextPath() + "/viewInventory");
    }
}
