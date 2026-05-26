package com.inventory.service;

import com.inventory.model.Item;
import com.inventory.util.FileHandler;
import com.inventory.util.MergeSort;
import com.inventory.util.Stack;

import java.util.*;

public class InventoryService {

    private final String filePath;
    private final Stack itemStack;
    private final Map<String, Stack> categoryStacks;

    public InventoryService(String filePath) {
        this.filePath       = filePath;
        this.itemStack      = new Stack();
        this.categoryStacks = new LinkedHashMap<>();

        List<Item> existing = FileHandler.readItems(filePath);
        for (Item item : existing) {
            itemStack.push(item);
            getCategoryStack(item.getCategory()).push(item);
        }
    }

    private Stack getCategoryStack(String category) {
        String key = category == null ? "Uncategorized" : category.trim();
        categoryStacks.putIfAbsent(key, new Stack());
        return categoryStacks.get(key);
    }

    public void addItem(Item item) {
        itemStack.push(item);
        getCategoryStack(item.getCategory()).push(item);
        FileHandler.addItem(filePath, item);
    }

    public List<Item> getAllItems() {
        return FileHandler.readItems(filePath);
    }

    public Map<String, List<Item>> getItemsByCategory() {
        Map<String, List<Item>> result = new LinkedHashMap<>();
        for (Map.Entry<String, Stack> entry : categoryStacks.entrySet()) {
            String category = entry.getKey();
            Stack  stack    = entry.getValue();

            List<Item> lifoList = new ArrayList<>();
            List<Item> allInStack = stack.toList();
            for (Item item : allInStack) {
                lifoList.add(item);
            }
            if (!lifoList.isEmpty()) {
                result.put(category, lifoList);
            }
        }
        return result;
    }

    public boolean updateItem(Item item) {
        itemStack.removeById(item.getId());
        itemStack.push(item);
        String category = item.getCategory() == null ? "Uncategorized" : item.getCategory().trim();
        Stack catStack = getCategoryStack(category);
        catStack.removeById(item.getId());
        catStack.push(item);
        return FileHandler.updateItem(filePath, item);
    }

    public Item deleteLastAdded() {
        if (itemStack.isEmpty()) return null;
        Item top = itemStack.pop();
        getCategoryStack(top.getCategory()).removeById(top.getId());
        FileHandler.deleteItem(filePath, top.getId());
        return top;
    }

    public boolean deleteItemById(String itemId) {
        Item removed = itemStack.removeById(itemId);
        if (removed != null) {
            getCategoryStack(removed.getCategory()).removeById(itemId);
        }
        return FileHandler.deleteItem(filePath, itemId);
    }

    public Item peekStack() {
        return itemStack.peek();
    }

    public int stackSize() {
        return itemStack.size();
    }

    public List<Item> getItemsSortedByExpiry() {
        List<Item> items = FileHandler.readItems(filePath);
        return MergeSort.sortByExpiryDate(items);
    }
}
