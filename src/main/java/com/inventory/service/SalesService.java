package com.inventory.service;

import com.inventory.model.Item;
import com.inventory.model.Sale;
import com.inventory.util.FileHandler;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * SalesService — Handles all sales business logic (Component 03).
 * 
 * VIVA NOTE - OOP PRINCIPLES:
 * 1. SINGLE RESPONSIBILITY PRINCIPLE (SRP): This class is solely responsible for Sales business rules.
 * 2. ABSTRACTION: It hides file I/O complexity from the Servlets (Servlets just call high-level methods).
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

    public List<Sale> getAllSales() {
        return FileHandler.readSales(salesFilePath);
    }

    public double getTotalRevenue() {
        double total = 0;
        for (Sale sale : FileHandler.readSales(salesFilePath)) {
            total += sale.getTotalPrice();
        }
        return total;
    }

    public Map<String, Integer> getSalesByItem() {
        Map<String, Integer> map = new HashMap<>();
        for (Sale sale : FileHandler.readSales(salesFilePath)) {
            map.merge(sale.getItemName(), sale.getQuantitySold(), Integer::sum);
        }
        return map;
    }

    public String getTopSellingItem() {
        Map<String, Integer> map = getSalesByItem();
        return map.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("N/A");
    }

    /**
     * Deletes a sale by its ID.
     * 
     * VIVA NOTE: ABSTRACTION
     * The SalesService doesn't deal with FileReader/FileWriter. It abstracts that 
     * responsibility to the FileHandler, creating a clean Separation of Concerns.
     */
    public boolean deleteSale(String saleId) {
        return FileHandler.deleteSale(salesFilePath, saleId);
    }
}