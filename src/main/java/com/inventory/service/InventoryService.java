package com.inventory.service;

import com.inventory.model.Item;
import com.inventory.util.FileHandler;
import com.inventory.util.MergeSort;
import com.inventory.util.Stack;

import java.util.*;

/*OOP Concept: ABSTRACTION (Service Layer)*/
public class InventoryService {

    private final String filePath;

    /*OOP Concept: ENCAPSULATION — one stack per category for LIFO per-category order*/
    private final Stack itemStack;
    private final Map<String, Stack> categoryStacks;

    public InventoryService(String filePath) {
        this.filePath       = filePath;
        this.itemStack      = new Stack();
        this.categoryStacks = new LinkedHashMap<>();

        // Rebuild stacks from file so LIFO order is preserved across restarts
        List<Item> existing = FileHandler.readItems(filePath);
        for (Item item : existing) {
            itemStack.push(item);
            getCategoryStack(item.getCategory()).push(item);
        }
    }

    // Returns (creating if absent) the per-category stack
    private Stack getCategoryStack(String category) {
        String key = category == null ? "Uncategorized" : category.trim();
        categoryStacks.putIfAbsent(key, new Stack());
        return categoryStacks.get(key);
    }

    // -----------------------------------------------------------------------
    // CRUD operations
    // -----------------------------------------------------------------------

    /** Adds a new item — pushes to both the global stack and its category stack. */
    public void addItem(Item item) {
        itemStack.push(item);
        getCategoryStack(item.getCategory()).push(item);
        FileHandler.addItem(filePath, item);
    }

    /** Returns all items read from the file. */
    public List<Item> getAllItems() {
        return FileHandler.readItems(filePath);
    }

    /**
     * Returns items grouped by category, each group in LIFO order
     * (most-recently-added first within the category).
     */
    public Map<String, List<Item>> getItemsByCategory() {
        Map<String, List<Item>> result = new LinkedHashMap<>();
        for (Map.Entry<String, Stack> entry : categoryStacks.entrySet()) {
            String category = entry.getKey();
            Stack  stack    = entry.getValue();

            // Drain stack into a list (LIFO = index 0 is most recent)
            List<Item> lifoList = new ArrayList<>();
            // We must NOT permanently pop — peek the internal order
            List<Item> allInStack = stack.toList(); // newest first
            for (Item item : allInStack) {
                lifoList.add(item);
            }
            if (!lifoList.isEmpty()) {
                result.put(category, lifoList);
            }
        }
        return result;
    }

    /** Updates an existing item (Read-Modify-Overwrite). */
    public boolean updateItem(Item item) {
        itemStack.removeById(item.getId());
        itemStack.push(item);
        // Sync category stack
        String category = item.getCategory() == null ? "Uncategorized" : item.getCategory().trim();
        Stack catStack = getCategoryStack(category);
        catStack.removeById(item.getId());
        catStack.push(item);
        return FileHandler.updateItem(filePath, item);
    }

    /** Deletes the most recently added item (true LIFO / Stack.pop()). */
    public Item deleteLastAdded() {
        if (itemStack.isEmpty()) return null;
        Item top = itemStack.pop();
        getCategoryStack(top.getCategory()).removeById(top.getId());
        FileHandler.deleteItem(filePath, top.getId());
        return top;
    }

    /** Deletes a specific item by ID. */
    public boolean deleteItemById(String itemId) {
        // Remove from global stack and whichever category stack holds it
        Item removed = itemStack.removeById(itemId);
        if (removed != null) {
            getCategoryStack(removed.getCategory()).removeById(itemId);
        }
        return FileHandler.deleteItem(filePath, itemId);
    }

    /** Returns the item at the top of the global stack (most recently added). */
    public Item peekStack() {
        return itemStack.peek();
    }

    /** Returns the current stack size. */
    public int stackSize() {
        return itemStack.size();
    }

    // Sorting — Component 02
    /** Returns all items sorted by expiry date (ascending) using the custom MergeSort. */
    public List<Item> getItemsSortedByExpiry() {
        List<Item> items = FileHandler.readItems(filePath);
        return MergeSort.sortByExpiryDate(items);
    }
}
