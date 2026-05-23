package com.inventory.servlet;


import com.inventory.service.ExpiryService;
import com.inventory.util.FilePath;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/disposeItem")
public class DisposeItemServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        String itemsPath = FilePath.getItemsPath(getServletContext());
        ExpiryService expiryService = new ExpiryService(itemsPath);

        if ("mark".equals(action)) {
            String itemId = req.getParameter("itemId");
            expiryService.markItemAsDisposed(itemId);
            req.getSession().setAttribute("successMsg", "Item marked as disposed.");
        } else if ("clear".equals(action)) {
            expiryService.clearAllDisposedItems();
            req.getSession().setAttribute("successMsg", "Disposed items cleared.");
        }

        resp.sendRedirect(req.getContextPath() + "/expiryManagement");
    }
}
