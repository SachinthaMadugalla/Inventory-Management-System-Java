package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.service.InventoryService;
import com.inventory.util.FileHandler;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

/**
 * DeleteStockServlet — Component 01: Delete Stock
 *
 * Handles two delete modes:
 *  1. DELETE LAST ADDED (LIFO) — calls stack.pop() via service.deleteLastAdded().
 *  2. DELETE BY ID         — calls service.deleteItemById(id).
 *
 * KEY VIVA POINT — Stack.pop():
 * When mode=last, InventoryService.deleteLastAdded() calls stack.pop() to
 * retrieve the most recently added item, then removes it from the file.
 * This is true LIFO behaviour — NOT a random ID deletion.
 *
 * OOP Concept: ABSTRACTION
 * The servlet never touches the Stack directly; it delegates to the service.
 */
@WebServlet("/deleteStock")
public class DeleteStockServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session guard — only admins can delete
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemsPath = getServletContext().getRealPath(FileHandler.ITEMS_FILE);
        InventoryService service = new InventoryService(itemsPath);

        String mode   = req.getParameter("mode");   // "last" or "byId"
        String itemId = req.getParameter("itemId");

        if ("last".equals(mode)) {
            // --- LIFO Delete: stack.pop() ---
            Item removed = service.deleteLastAdded(); // calls stack.pop() internally
            if (removed != null) {
                session.setAttribute("successMsg",
                        "LIFO Delete: Removed '" + removed.getName() + "' (last added).");
            } else {
                session.setAttribute("successMsg", "Stack is empty — nothing to delete.");
            }
        } else if ("byId".equals(mode) && itemId != null && !itemId.isEmpty()) {
            // --- Targeted Delete by ID ---
            boolean deleted = service.deleteItemById(itemId);
            session.setAttribute("successMsg",
                    deleted ? "Item deleted successfully." : "Item not found.");
        } else {
            session.setAttribute("successMsg", "Invalid delete request.");
        }

        resp.sendRedirect(req.getContextPath() + "/viewInventory");
    }
}
