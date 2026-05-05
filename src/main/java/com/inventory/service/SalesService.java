package com.inventory.service;

import com.inventory.model.Item;
import com.inventory.model.Sale;
import com.inventory.util.FileHandler;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * OOP Concept: ABSTRACTION (Service Layer)
 * SalesService handles all sales business logic:
 *  - Recording a sale and decrementing inventory stock.
 *  - Retrieving sales history.
 *  - Computing revenue totals for reports.
 */
public class SalesService {

    private final String salesFilePath;
    private final String itemsFilePath;

    public SalesService(String salesFilePath, String itemsFilePath) {
        this.salesFilePath = salesFilePath;
        this.itemsFilePath = itemsFilePath;
    }

    /**
     * Processes a sale:
     *  1. Validates that the item exists and has sufficient stock.
     *  2. Decrements the item's quantity in items.txt (Read-Modify-Overwrite).
     *  3. Appends the sale record to sales.txt.
     *
     * @return null on success, or an error message string on failure.
     */
    public String processSale(Sale sale) {
        // Read current inventory
        List<Item> items = FileHandler.readItems(itemsFilePath);
        Item target = null;
        for (Item item : items) {
            if (item.getId().equals(sale.getItemId())) {
                target = item;
                break;
            }
        }

        if (target == null) {
            return "Item not found: " + sale.getItemId();
        }
        if (target.getQuantity() < sale.getQuantitySold()) {
            return "Insufficient stock. Available: " + target.getQuantity();
        }

        // Decrement stock (Read-Modify-Overwrite via FileHandler)
        target.setQuantity(target.getQuantity() - sale.getQuantitySold());
        FileHandler.updateItem(itemsFilePath, target);

        // Persist the sale record
        FileHandler.addSale(salesFilePath, sale);
        return null; // null = success
    }

    /**
     * Returns all sales records.
     */
    public List<Sale> getAllSales() {
        return FileHandler.readSales(salesFilePath);
    }

    /**
     * Computes total revenue across all sales.
     */
    public double getTotalRevenue() {
        double total = 0;
        for (Sale sale : FileHandler.readSales(salesFilePath)) {
            total += sale.getTotalPrice();
        }
        return total;
    }

    /**
     * Returns a map of itemName → total quantity sold.
     * Used to determine the top-selling item for reports.
     */
    public Map<String, Integer> getSalesByItem() {
        Map<String, Integer> map = new HashMap<>();
        for (Sale sale : FileHandler.readSales(salesFilePath)) {
            map.merge(sale.getItemName(), sale.getQuantitySold(), Integer::sum);
        }
        return map;
    }

    /**
     * Returns the name of the best-selling item (highest total quantity sold).
     */
    public String getTopSellingItem() {
        Map<String, Integer> map = getSalesByItem();
        return map.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("N/A");
    }
}
