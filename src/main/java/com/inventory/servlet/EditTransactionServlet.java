package com.inventory.servlet;

import com.inventory.model.Sale;
import com.inventory.service.SalesService;
import com.inventory.util.FileHandler;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * EditTransactionServlet — Component 03: Edit Transaction
 *
 * GET  /editTransaction?id=XXX → loads the sale record and shows the edit form.
 * POST /editTransaction         → saves the updated transaction record.
 *
 * OOP Concept: ABSTRACTION
 * File read/write is delegated to SalesService → FileHandler.
 * OOP Concept: ENCAPSULATION
 * Sale fields are private; accessed only through getters/setters.
 */
@WebServlet("/editTransaction")
public class EditTransactionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String saleId    = req.getParameter("id");
        String salesPath = FileHandler.SALES_FILE;
        String itemsPath = FileHandler.ITEMS_FILE;
        SalesService service = new SalesService(salesPath, itemsPath);

        Sale target = null;
        for (Sale sale : service.getAllSales()) {
            if (sale.getSaleId().equals(saleId)) {
                target = sale;
                break;
            }
        }

        if (target == null) {
            resp.sendRedirect(req.getContextPath() + "/viewSales");
            return;
        }

        req.setAttribute("sale", target);
        req.getRequestDispatcher("/views/sales/editTransaction.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String saleId    = req.getParameter("saleId");
        String itemId    = req.getParameter("itemId");
        String itemName  = req.getParameter("itemName");
        String qtyStr    = req.getParameter("quantitySold");
        String priceStr  = req.getParameter("totalPrice");
        String saleDate  = req.getParameter("saleDate");

        int    qty;
        double totalPrice;
        try {
            qty        = Integer.parseInt(qtyStr.trim());
            totalPrice = Double.parseDouble(priceStr.trim());
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Quantity and Total Price must be valid numbers.");
            doGet(req, resp);
            return;
        }

        String salesPath = FileHandler.SALES_FILE;
        String itemsPath = FileHandler.ITEMS_FILE;
        SalesService service = new SalesService(salesPath, itemsPath);

        // Read-Modify-Overwrite
        List<Sale> sales = service.getAllSales();
        boolean updated = false;
        for (Sale sale : sales) {
            if (sale.getSaleId().equals(saleId)) {
                sale.setItemId(itemId.trim());
                sale.setItemName(itemName.trim());
                sale.setQuantitySold(qty);
                sale.setTotalPrice(totalPrice);
                sale.setSaleDate(saleDate.trim());
                updated = true;
                break;
            }
        }

        if (updated) {
            FileHandler.writeSales(salesPath, sales);
            session.setAttribute("successMsg", "Transaction updated successfully.");
        } else {
            session.setAttribute("successMsg", "Transaction not found.");
        }

        resp.sendRedirect(req.getContextPath() + "/viewSales");
    }
}
