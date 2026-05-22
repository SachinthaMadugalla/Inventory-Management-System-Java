package com.inventory.servlet;

import com.inventory.model.Sale;
import com.inventory.service.SalesService;
import com.inventory.util.FilePath;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * ViewSalesServlet — displays all sales records.
 */
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

        String salesPath = FilePath.getSalesPath(getServletContext());
        String itemsPath = FilePath.getItemsPath(getServletContext());
        SalesService salesService = new SalesService(salesPath, itemsPath);

        List<Sale> sales = salesService.getAllSales();
        double totalRevenue = salesService.getTotalRevenue();

        req.setAttribute("sales",        sales);
        req.setAttribute("totalRevenue", totalRevenue);

        // Flash message
        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            req.setAttribute("successMsg", successMsg);
            session.removeAttribute("successMsg");
        }

        req.getRequestDispatcher("/views/sales/viewSales.jsp").forward(req, resp);
    }
}
