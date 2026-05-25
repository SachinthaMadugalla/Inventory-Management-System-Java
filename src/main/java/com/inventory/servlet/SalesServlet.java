package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.model.Sale;
import com.inventory.service.InventoryService;
import com.inventory.service.SalesService;
import com.inventory.util.FilePath;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

/**
 * SalesServlet — Display sales form (GET) and process sales transactions (POST).
 * Validates stock, creates sale record with unique ID, delegates to SalesService for persistence.
 * OOP: ABSTRACTION (business logic delegated to SalesService).
 */
@WebServlet("/processSale")
public class SalesServlet extends HttpServlet {

    @Override
    // GET: Load and display sales form with available items
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Verify user is logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemsPath = FilePath.getItemsPath(getServletContext());
        InventoryService inventoryService = new InventoryService(itemsPath);
        List<Item> items = inventoryService.getAllItems();

        // Pass items to JSP view
        req.setAttribute("items", items);
        req.getRequestDispatcher("/views/sales/addSale.jsp").forward(req, resp);
    }

    @Override
    // POST: Validate input, create sale record, process via SalesService
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Verify user is logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Extract form parameters
        String itemId  = req.getParameter("itemId");
        String qtyStr  = req.getParameter("quantity");

        String itemsPath = FilePath.getItemsPath(getServletContext());
        String salesPath = FilePath.getSalesPath(getServletContext());

        InventoryService inventoryService = new InventoryService(itemsPath);
        SalesService salesService = new SalesService(salesPath, itemsPath);

        // Find item details (name, price) for sale record
        Item selectedItem = null;
        for (Item item : inventoryService.getAllItems()) {
            if (item.getId().equals(itemId)) {
                selectedItem = item;
                break;
            }
        }

        // Validate: item exists
        if (selectedItem == null) {
            req.setAttribute("error", "Selected item not found.");
            doGet(req, resp);
            return;
        }

        // Validate: quantity is valid positive integer
        int qty;
        try {
            qty = Integer.parseInt(qtyStr.trim());
            if (qty <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Quantity must be a positive integer.");
            doGet(req, resp);
            return;
        }

        // Calculate total price and generate unique sale ID
        double totalPrice = selectedItem.getPrice() * qty;
        String saleId = "SLE-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // Create Sale object with current date
        Sale sale = new Sale(saleId, itemId, selectedItem.getName(),
                qty, totalPrice, LocalDate.now().toString());

        // Delegate to service: validates stock, decrements inventory, records sale
        String error = salesService.processSale(sale);
        if (error != null) {
            req.setAttribute("error", error);
            doGet(req, resp);
            return;
        }

        session.setAttribute("successMsg", "Sale recorded successfully! Total: Rs." + totalPrice);
        resp.sendRedirect(req.getContextPath() + "/viewSales");
    }
}