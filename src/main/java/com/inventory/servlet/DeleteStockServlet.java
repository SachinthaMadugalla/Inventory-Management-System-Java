package com.inventory.servlet;

import com.inventory.model.Item;
import com.inventory.service.InventoryService;
import com.inventory.util.FilePath;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;

@WebServlet("/deleteStock")
public class DeleteStockServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String itemsPath = FilePath.getItemsPath(getServletContext());
        InventoryService service = new InventoryService(itemsPath);

        String mode   = req.getParameter("mode");
        String itemId = req.getParameter("itemId");

        if ("last".equals(mode)) {
            Item removed = service.deleteLastAdded();
            if (removed != null) {
                session.setAttribute("successMsg",
                        "LIFO Delete: Removed '" + removed.getName() + "' (last added).");
            } else {
                session.setAttribute("successMsg", "Stack is empty — nothing to delete.");
            }
        } else if ("byId".equals(mode) && itemId != null && !itemId.isEmpty()) {
            boolean deleted = service.deleteItemById(itemId);
            session.setAttribute("successMsg",
                    deleted ? "Item deleted successfully." : "Item not found.");
        } else {
            session.setAttribute("successMsg", "Invalid delete request.");
        }

        resp.sendRedirect(req.getContextPath() + "/viewInventory");
    }
}
