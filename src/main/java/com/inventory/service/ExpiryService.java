package com.inventory.service;

import com.inventory.model.Expiry;
import com.inventory.model.Item;
import com.inventory.util.FileHandler;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

public class ExpiryService {

    private final String itemsPath;
    private final String expiryItemsPath;

    public ExpiryService(String itemsPath, String expiryItemsPath) {
        this.itemsPath = itemsPath;
        this.expiryItemsPath = expiryItemsPath;
    }

    // --- Item-related Expiry Methods ---

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

    // --- Expiry Object CRUD Methods ---

    public List<Expiry> getAllExpiryItems() {
        return FileHandler.readExpiryItems(expiryItemsPath);
    }

    public void addExpiryItem(Expiry expiry) {
        List<Expiry> expiryItems = getAllExpiryItems();
        if (expiry.getId() == null || expiry.getId().isEmpty()) {
            expiry.setId(UUID.randomUUID().toString());
        }
        expiryItems.add(expiry);
        FileHandler.writeExpiryItems(expiryItemsPath, expiryItems);
    }

    public Expiry getExpiryItemById(String id) {
        return getAllExpiryItems().stream()
                .filter(e -> e.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    public void updateExpiryItem(Expiry updatedExpiry) {
        List<Expiry> expiryItems = getAllExpiryItems();
        boolean found = false;
        for (int i = 0; i < expiryItems.size(); i++) {
            if (expiryItems.get(i).getId().equals(updatedExpiry.getId())) {
                expiryItems.set(i, updatedExpiry);
                found = true;
                break;
            }
        }
        if (found) {
            FileHandler.writeExpiryItems(expiryItemsPath, expiryItems);
        }
    }

    public void deleteExpiryItem(String id) {
        List<Expiry> expiryItems = getAllExpiryItems();
        if (expiryItems.removeIf(e -> e.getId().equals(id))) {
            FileHandler.writeExpiryItems(expiryItemsPath, expiryItems);
        }
    }
}