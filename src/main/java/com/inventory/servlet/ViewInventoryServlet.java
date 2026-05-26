package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.service.InventoryService;
import com.inventory.util.FilePath;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.*;

/*
 * ViewInventoryServlet — Component 01: View Inventory
 * OOP Concept: ABSTRACTION
 *
 * Fix: items are now grouped by category (LinkedHashMap preserves insertion
 * order) and passed to the JSP as "categoryGroups" so each category renders
 * as its own panel — matching the UI design.
 */
@WebServlet("/viewInventory")
public class ViewInventoryServlet extends HttpServlet {

    // Canonical category order shown in the UI
    private static final List<String> CATEGORY_ORDER =
            Arrays.asList("Medicine", "Food", "Electronics",
                    "Clothing", "Beverages", "Other");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Session guard
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemsPath = FilePath.getItemsPath(getServletContext());
        InventoryService service = new InventoryService(itemsPath);

        List<Item> items = service.getAllItems();

        // --- Group items by category (preserving canonical order) ---
        // Use a LinkedHashMap so the JSP iterates in CATEGORY_ORDER sequence.
        Map<String, List<Item>> categoryGroups = new LinkedHashMap<>();
        for (String cat : CATEGORY_ORDER) {
            categoryGroups.put(cat, new ArrayList<>());
        }
        for (Item item : items) {
            String cat = item.getCategory();
            // Put unknown categories under "Other"
            if (!categoryGroups.containsKey(cat)) {
                categoryGroups.put(cat, new ArrayList<>());
            }
            categoryGroups.get(cat).add(item);
        }
        // Remove empty categories so the JSP doesn't render blank panels
        categoryGroups.entrySet().removeIf(e -> e.getValue().isEmpty());

        // Pass data to the JSP
        req.setAttribute("items",          items);
        req.setAttribute("categoryGroups", categoryGroups);
        req.setAttribute("stackTop",       service.peekStack());
        req.setAttribute("stackSize",      service.stackSize());

        // Carry over flash messages from redirects
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            req.setAttribute("successMsg", successMsg);
            session.removeAttribute("successMsg");
        }

        req.getRequestDispatcher("/views/inventory/viewInventory.jsp").forward(req, resp);
    }
}
