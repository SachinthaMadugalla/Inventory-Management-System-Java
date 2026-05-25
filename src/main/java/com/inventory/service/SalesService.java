package com.inventory.service;

import com.inventory.model.Item;
import com.inventory.model.Sale;
import com.inventory.util.FileHandler;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * SalesService — Handles all sales business logic (Component 03).
 * Processes sales, manages inventory deduction, calculates revenue, and generates reports.
 * OOP: ABSTRACTION (hides file I/O complexity; servlets only call high-level methods).
 */
public class SalesService {

    private final String salesFilePath;   // Path to sales.txt
    private final String itemsFilePath;   // Path to items.txt

    public SalesService(String salesFilePath, String itemsFilePath) {
        this.salesFilePath = salesFilePath;
        this.itemsFilePath = itemsFilePath;
    }

    /**
     * Process a sale: validate stock → decrement inventory → record sale.
     * Returns null on success, error message on failure.
     * Uses Read-Modify-Overwrite pattern for data consistency.
     */
    public String processSale(Sale sale) {
        // Read all items from file
        List<Item> items = FileHandler.readItems(itemsFilePath);

        // Find the item being sold
        Item target = null;
        for (Item item : items) {
            if (item.getId().equals(sale.getItemId())) {
                target = item;
                break;
            }
        }

        // Validate: item exists
        if (target == null) {
            return "Item not found: " + sale.getItemId();
        }

        // Validate: sufficient stock available
        if (target.getQuantity() < sale.getQuantitySold()) {
            return "Insufficient stock. Available: " + target.getQuantity();
        }

        // Decrement stock and persist to items.txt
        target.setQuantity(target.getQuantity() - sale.getQuantitySold());
        FileHandler.updateItem(itemsFilePath, target);

        // Record the sale in sales.txt
        FileHandler.addSale(salesFilePath, sale);
        return null; // null indicates success
    }

    /**
     * Retrieve all sales records from file.
     */
    public List<Sale> getAllSales() {
        return FileHandler.readSales(salesFilePath);
    }

    /**
     * Calculate total revenue (sum of all totalPrice values).
     * Used for dashboard reports.
     */
    public double getTotalRevenue() {
        double total = 0;
        for (Sale sale : FileHandler.readSales(salesFilePath)) {
            total += sale.getTotalPrice();
        }
        return total;
    }

    /**
     * Map item names to total quantity sold (for analytics).
     * Example: {"Milk": 50, "Bread": 35} → Milk is top seller
     */
    public Map<String, Integer> getSalesByItem() {
        Map<String, Integer> map = new HashMap<>();
        for (Sale sale : FileHandler.readSales(salesFilePath)) {
            // Accumulate quantities for each item
            map.merge(sale.getItemName(), sale.getQuantitySold(), Integer::sum);
        }
        return map;
    }

    /**
     * Find the best-selling item (highest total quantity sold).
     * Used in Component 05 (Reports) for top-selling analysis.
     */
    public String getTopSellingItem() {
        Map<String, Integer> map = getSalesByItem();
        return map.entrySet().stream()
                .max(Map.Entry.comparingByValue())  // Find entry with max value
                .map(Map.Entry::getKey)              // Extract item name
                .orElse("N/A");                       // Default if no sales exist
    }
}