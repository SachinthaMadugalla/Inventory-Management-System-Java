package com.inventory.service;

import com.inventory.model.Expiry;
import com.inventory.model.Item;
import com.inventory.util.FileHandler;
import java.io.*;
import java.time.LocalDate;
import java.util.ArrayList;
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
    
    // Fallback constructor for backward compatibility in other parts of the app
    public ExpiryService(String itemsPath) {
        this.itemsPath = itemsPath;
        this.expiryItemsPath = itemsPath.replace("items.txt", "expiry_items.csv"); // Default assumption
    }

    // --- Original Item-based expiry methods ---

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

    // --- New dedicated Expiry object CRUD operations ---

    public List<Expiry> getAllExpiryItems() {
        List<Expiry> expiryItems = new ArrayList<>();
        File file = new File(expiryItemsPath);
        if (!file.exists()) return expiryItems;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Expiry expiry = Expiry.fromCsv(line.trim());
                    if (expiry != null) expiryItems.add(expiry);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading " + expiryItemsPath + ": " + e.getMessage());
        }
        return expiryItems;
    }

    private void writeExpiryItems(List<Expiry> expiryItems) {
        File file = new File(expiryItemsPath);
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, false))) {
            for (Expiry expiry : expiryItems) {
                bw.write(expiry.toCsv());
                bw.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing " + expiryItemsPath + ": " + e.getMessage());
        }
    }

    public void addExpiryItem(Expiry expiry) {
        if (expiry.getId() == null || expiry.getId().isEmpty()) {
            expiry.setId("EXP-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }
        File file = new File(expiryItemsPath);
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, true))) {
            bw.write(expiry.toCsv());
            bw.newLine();
        } catch (IOException e) {
            System.err.println("Error appending to " + expiryItemsPath + ": " + e.getMessage());
        }
    }

    public boolean updateExpiryItem(Expiry updated) {
        List<Expiry> expiryItems = getAllExpiryItems();
        boolean found = false;
        for (int i = 0; i < expiryItems.size(); i++) {
            if (expiryItems.get(i).getId().equals(updated.getId())) {
                expiryItems.set(i, updated);
                found = true;
                break;
            }
        }
        if (found) {
            writeExpiryItems(expiryItems);
        }
        return found;
    }

    public boolean deleteExpiryItem(String id) {
        List<Expiry> expiryItems = getAllExpiryItems();
        boolean removed = expiryItems.removeIf(e -> e.getId().equals(id));
        if (removed) {
            writeExpiryItems(expiryItems);
        }
        return removed;
    }
}