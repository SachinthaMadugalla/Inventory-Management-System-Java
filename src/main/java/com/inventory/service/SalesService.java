package com.inventory.service;

import com.inventory.model.Item;
import com.inventory.model.Sale;
import com.inventory.util.FileHandler;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SalesService {

    private final String salesFilePath;
    private final String itemsFilePath;

    public SalesService(String salesFilePath, String itemsFilePath) {
        this.salesFilePath = salesFilePath;
        this.itemsFilePath = itemsFilePath;
    }

    public String processSale(Sale sale) {
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

        target.setQuantity(target.getQuantity() - sale.getQuantitySold());
        FileHandler.updateItem(itemsFilePath, target);

        FileHandler.addSale(salesFilePath, sale);
        return null;
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

    public boolean deleteSale(String saleId) {
        return FileHandler.deleteSale(salesFilePath, saleId);
    }
}
