package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.service.InventoryService;
import com.inventory.util.FileHandler;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * ExpiryServlet — Component 02: Expiry Management
 *
 * GET /expiryManagement → loads items sorted by expiry date (MergeSort),
 *                         flags items expiring within 30 days, and forwards
 *                         to the expiry management JSP.
 *
 * KEY VIVA POINT — MergeSort:
 * InventoryService.getItemsSortedByExpiry() calls MergeSort.sortByExpiryDate(),
 * which is a hand-written O(n log n) divide-and-conquer algorithm.
 * Collections.sort() is NOT used.
 *
 * OOP Concept: ABSTRACTION
 * Sorting logic is hidden inside MergeSort; this servlet just calls the service.
 */
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

        String itemsPath = getServletContext().getRealPath(FileHandler.ITEMS_FILE);
        InventoryService service = new InventoryService(itemsPath);

        // MergeSort — O(n log n), soonest-to-expire first
        List<Item> sortedItems = service.getItemsSortedByExpiry();

        // Flag items expiring within the next 30 days
        String today30 = LocalDate.now().plusDays(30).toString();
        String today   = LocalDate.now().toString();
        List<Item> expiringSoon = new ArrayList<>();
        List<Item> expired      = new ArrayList<>();

        for (Item item : sortedItems) {
            if (item.getExpiryDate().compareTo(today) < 0) {
                expired.add(item);
            } else if (item.getExpiryDate().compareTo(today30) <= 0) {
                expiringSoon.add(item);
            }
        }

        req.setAttribute("sortedItems",   sortedItems);
        req.setAttribute("expiringSoon",  expiringSoon);
        req.setAttribute("expired",       expired);

        req.getRequestDispatcher("/views/inventory/expiryManagement.jsp").forward(req, resp);
    }
}
