package com.inventory.service;

import com.inventory.model.Item;
import com.inventory.util.FileHandler;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

public class ExpiryService {

    private final String itemsPath;

    public ExpiryService(String itemsPath) {
        this.itemsPath = itemsPath;
    }

    public List<Item> getExpiredItems() {
        List<Item> allItems = FileHandler.readItems(itemsPath);
        String today = LocalDate.now().toString();
        return allItems.stream()
                .filter(item -> !"N/A".equals(item.getExpiryDate()) && item.getExpiryDate().compareTo(today) < 0)
                .collect(Collectors.toList());
    }

    public List<Item> getExpiringSoonItems() {
        List<Item> allItems = FileHandler.readItems(itemsPath);
        String today = LocalDate.now().toString();
        String thirtyDaysFromNow = LocalDate.now().plusDays(30).toString();
        return allItems.stream()
                .filter(item -> !"N/A".equals(item.getExpiryDate()) && item.getExpiryDate().compareTo(today) >= 0 && item.getExpiryDate().compareTo(thirtyDaysFromNow) <= 0)
                .collect(Collectors.toList());
    }

    public boolean markItemAsDisposed(String itemId) {
        List<Item> allItems = FileHandler.readItems(itemsPath);
        boolean updated = false;
        for (Item item : allItems) {
            if (item.getId().equals(itemId)) {
                item.setStatus("Disposed");
                updated = true;
                break;
            }
        }
        if (updated) {
            FileHandler.writeItems(itemsPath, allItems);
        }
        return updated;
    }

    public boolean clearAllDisposedItems() {
        List<Item> allItems = FileHandler.readItems(itemsPath);
        List<Item> itemsToKeep = allItems.stream()
                .filter(item -> !"Disposed".equalsIgnoreCase(item.getStatus()))
                .collect(Collectors.toList());

        if (itemsToKeep.size() < allItems.size()) {
            FileHandler.writeItems(itemsPath, itemsToKeep);
            return true;
        }
        return false;
    }
}