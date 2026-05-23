package com.inventory.servlet;

import com.inventory.model.Expiry;
import com.inventory.model.Item;
import com.inventory.service.ExpiryService;
import com.inventory.service.InventoryService;
import com.inventory.util.FilePath;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/expiryManagement")
public class ExpiryServlet extends HttpServlet {

    private ExpiryService expiryService;
    private InventoryService inventoryService;
    private String itemsPath;
    private String expiryItemsPath;

    @Override
    public void init() throws ServletException {
        super.init();
        // Initialize file paths
        itemsPath = FilePath.getItemsPath(getServletContext());
        expiryItemsPath = getServletContext().getRealPath("/data/expiry_items.csv");

        // Initialize services
        this.expiryService = new ExpiryService(itemsPath, expiryItemsPath);
        this.inventoryService = new InventoryService(itemsPath);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Existing Item-related expiry data
        List<Item> sortedItems = inventoryService.getItemsSortedByExpiry();
        List<Item> expired = expiryService.getExpiredItems();
        List<Item> expiringSoon = expiryService.getExpiringSoonItems();

        req.setAttribute("sortedItems", sortedItems);
        req.setAttribute("expiringSoon", expiringSoon);
        req.setAttribute("expired", expired);

        // New Expiry object CRUD data
        List<Expiry> expiryItems = expiryService.getAllExpiryItems();
        req.setAttribute("expiryItems", expiryItems);

        req.getRequestDispatcher("/views/expiry/expiryManagement.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/expiryManagement");
            return;
        }

        try {
            switch (action) {
                case "add":
                    addExpiryItem(req);
                    break;
                case "update":
                    updateExpiryItem(req);
                    break;
                case "delete":
                    deleteExpiryItem(req);
                    break;
                case "markDisposed": // Action for marking an Item as disposed
                    String itemIdToDispose = req.getParameter("itemIdToDispose");
                    expiryService.markItemAsDisposed(itemIdToDispose);
                    break;
                case "clearDisposed": // Action for clearing all disposed Items
                    expiryService.clearAllDisposedItems();
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in ExpiryServlet doPost: " + e.getMessage());
            req.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/expiryManagement");
    }

    private void addExpiryItem(HttpServletRequest req) {
        String itemId = req.getParameter("itemId");
        String expiryDate = req.getParameter("expiryDate");
        Expiry newExpiry = new Expiry(null, itemId, expiryDate, false);
        expiryService.addExpiryItem(newExpiry);
    }

    private void updateExpiryItem(HttpServletRequest req) {
        String id = req.getParameter("id");
        String itemId = req.getParameter("itemId");
        String expiryDate = req.getParameter("expiryDate");
        boolean disposed = Boolean.parseBoolean(req.getParameter("disposed"));
        Expiry updatedExpiry = new Expiry(id, itemId, expiryDate, disposed);
        expiryService.updateExpiryItem(updatedExpiry);
    }

    private void deleteExpiryItem(HttpServletRequest req) {
        String id = req.getParameter("id");
        expiryService.deleteExpiryItem(id);
    }
}