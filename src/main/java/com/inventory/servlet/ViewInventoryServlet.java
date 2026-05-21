package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.service.InventoryService;
import com.inventory.util.FileHandler;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

/*
 * ViewInventoryServlet — Component 01: View Inventory
 * OOP Concept: ABSTRACTION
 */
@WebServlet("/viewInventory")
public class ViewInventoryServlet extends HttpServlet {

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

        List<Item> items = service.getAllItems();

        // Pass stack metadata so the UI can show the "Delete Last Added" button
        req.setAttribute("items",     items);
        req.setAttribute("stackTop",  service.peekStack());
        req.setAttribute("stackSize", service.stackSize());

        // Carry over any flash messages from redirects
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            req.setAttribute("successMsg", successMsg);
            session.removeAttribute("successMsg");
        }

        req.getRequestDispatcher("/views/inventory/viewInventory.jsp").forward(req, resp);
    }
}
