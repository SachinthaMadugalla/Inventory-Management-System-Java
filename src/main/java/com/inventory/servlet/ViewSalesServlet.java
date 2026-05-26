package com.inventory.servlet;

import com.inventory.model.Sale;
import com.inventory.service.SalesService;
import com.inventory.util.FilePath;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

/** * ViewSalesServlet — Displays all sales records with total revenue.
 *  * Validates user session, fetches sales from SalesService, and forwards to JSP view.
 *  * OOP: ABSTRACTION (delegates business logic to service layer). */
@WebServlet("/viewSales")
public class ViewSalesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Get sales data from service layer
        String salesPath = FilePath.getSalesPath(getServletContext());
        String itemsPath = FilePath.getItemsPath(getServletContext());
        SalesService salesService = new SalesService(salesPath, itemsPath);

        List<Sale> sales = salesService.getAllSales();
        double totalRevenue = salesService.getTotalRevenue();

        // Pass data to JSP view
        req.setAttribute("sales",        sales);
        req.setAttribute("totalRevenue", totalRevenue);


        // Handle success message from session
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            req.setAttribute("successMsg", successMsg);
            session.removeAttribute("successMsg");
        }

        // Handle error message from session
        String errorMsg = (String) session.getAttribute("errorMsg");
        if (errorMsg != null) {
            req.setAttribute("errorMsg", errorMsg);
            session.removeAttribute("errorMsg");
        }

        req.getRequestDispatcher("/views/sales/viewSales.jsp").forward(req, resp);
    }
}
