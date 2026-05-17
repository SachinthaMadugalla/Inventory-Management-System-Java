package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.model.Sale;
import com.inventory.service.InventoryService;
import com.inventory.service.SalesService;
import com.inventory.util.FileHandler;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@WebServlet("/processSale")
public class SalesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemsPath = FileHandler.ITEMS_FILE;
        InventoryService inventoryService = new InventoryService(itemsPath);
        List<Item> items = inventoryService.getAllItems();

        req.setAttribute("items", items);
        req.getRequestDispatcher("/views/sales/addSale.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemId  = req.getParameter("itemId");
        String qtyStr  = req.getParameter("quantity");

        String itemsPath = FileHandler.ITEMS_FILE;
        String salesPath = FileHandler.SALES_FILE;

        InventoryService inventoryService = new InventoryService(itemsPath);
        SalesService salesService = new SalesService(salesPath, itemsPath);

        // Find the item to get its name and price
        Item selectedItem = null;
        for (Item item : inventoryService.getAllItems()) {
            if (item.getId().equals(itemId)) {
                selectedItem = item;
                break;
            }
        }

        if (selectedItem == null) {
            req.setAttribute("error", "Selected item not found.");
            doGet(req, resp);
            return;
        }

        int qty;
        try {
            qty = Integer.parseInt(qtyStr.trim());
            if (qty <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Quantity must be a positive integer.");
            doGet(req, resp);
            return;
        }

        double totalPrice = selectedItem.getPrice() * qty;
        String saleId = "SLE-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        Sale sale = new Sale(saleId, itemId, selectedItem.getName(),
                qty, totalPrice, LocalDate.now().toString());

        // Delegate to service — handles stock decrement + sale persistence
        String error = salesService.processSale(sale);
        if (error != null) {
            req.setAttribute("error", error);
            doGet(req, resp);
            return;
        }

        session.setAttribute("successMsg", "Sale recorded successfully! Total: $" + totalPrice);
        resp.sendRedirect(req.getContextPath() + "/viewSales");
    }
}
