package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.service.InventoryService;
import com.inventory.util.FileHandler;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.UUID;

/*
 * AddStockServlet — Component 01: Add Stock
 * OOP Concept: ABSTRACTION.
 */
@WebServlet("/addStock")
public class AddStockServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session guard
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemsPath = FileHandler.ITEMS_FILE;
        InventoryService service = new InventoryService(itemsPath);

        // Pass the top-of-stack item so the UI can show "next to be deleted"
        req.setAttribute("stackTop",  service.peekStack());
        req.setAttribute("stackSize", service.stackSize());

        req.getRequestDispatcher("/views/inventory/addStock.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session guard
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // --- Read form parameters ---
        String name       = req.getParameter("name");
        String category   = req.getParameter("category");
        String qtyStr     = req.getParameter("quantity");
        String priceStr   = req.getParameter("price");
        String expiryDate = req.getParameter("expiryDate");

        // --- Basic validation ---
        if (name == null || name.trim().isEmpty()
                || qtyStr == null || priceStr == null || expiryDate == null) {
            req.setAttribute("error", "All fields are required.");
            doGet(req, resp);
            return;
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

        // --- Build the Item ---
        String itemId = "ITM-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        Item newItem = new Item(itemId, name.trim(), category.trim(),
                quantity, price, expiryDate.trim());

        // --- Persist via service (which also calls stack.push()) ---
        String itemsPath = FileHandler.ITEMS_FILE;
        InventoryService service = new InventoryService(itemsPath);
        service.addItem(newItem); // ← stack.push() happens inside here

        req.getSession().setAttribute("successMsg", "Item '" + name + "' added successfully!");
        resp.sendRedirect(req.getContextPath() + "/viewInventory");
    }
}
