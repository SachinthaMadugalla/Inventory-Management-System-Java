package com.inventory.service;

import com.inventory.model.Item;
import com.inventory.util.FileHandler;
import com.inventory.util.MergeSort;
import com.inventory.util.Stack;

import java.util.List;

/**
 * OOP Concept: ABSTRACTION (Service Layer)
 * InventoryService encapsulates all business logic for inventory management.
 * Servlets call this service
 * Key responsibilities:
 *  - Maintain the in-memory Stack that tracks add order (LIFO).
 *  - Delegate file persistence to FileHandler.
 *  - Expose sortByExpiry() which uses the custom MergeSort algorithm.
 */
public class InventoryService {

    private final String filePath;

    /**
     * OOP Concept: ENCAPSULATION
     * The Stack is private — only this service can push/pop items.
     * It is rebuilt from the file on every service instantiation so that
     * the LIFO order reflects the file's current order.
     */
    private final Stack itemStack;

    public InventoryService(String filePath) {
        this.filePath  = filePath;
        this.itemStack = new Stack();
        // Rebuild the stack from the persisted file so LIFO order is preserved
        // across server restarts.
        List<Item> existing = FileHandler.readItems(filePath);
        itemStack.loadFrom(existing);
    }


    // CRUD operations

    /**
     * Adds a new item.
     * 1. Pushes the item onto the Stack (LIFO tracking).
     * 2. Persists it to the file via FileHandler.
     */
    public void addItem(Item item) {
        itemStack.push(item);           // Stack.push() — LIFO add
        FileHandler.addItem(filePath, item);
    }

    /**
     * Returns all items read from the file.
     */
    public List<Item> getAllItems() {
        return FileHandler.readItems(filePath);
    }

    /**
     * Updates an existing item (Read-Modify-Overwrite via FileHandler).
     */
    public boolean updateItem(Item item) {
        // Also update the stack's copy
        itemStack.removeById(item.getId());
        itemStack.push(item);
        return FileHandler.updateItem(filePath, item);
    }

    /**
     * Deletes the most recently added item (true LIFO / Stack.pop()).
     * This is the "Delete Last Added" operation for the viva demonstration.
     */
    public Item deleteLastAdded() {
        if (itemStack.isEmpty()) return null;

        Item top = itemStack.pop();                    // Stack.pop() — LIFO remove
        FileHandler.deleteItem(filePath, top.getId()); // Persist the deletion
        return top;
    }

    /**
     * Deletes a specific item by ID.
     * Also removes it from the stack to keep them in sync.
     */
    public boolean deleteItemById(String itemId) {
        itemStack.removeById(itemId);                  // Keep stack in sync
        return FileHandler.deleteItem(filePath, itemId);
    }

    /**
     * Returns the item at the top of the stack (most recently added)
     * without removing it. Used to show "next to be deleted" in the UI.
     */
    public Item peekStack() {
        return itemStack.peek();
    }

    /**
     * Returns the current stack size.
     */
    public int stackSize() {
        return itemStack.size();
    }

    // -----------------------------------------------------------------------
    // Sorting — Component 02
    // -----------------------------------------------------------------------

    /**
     * Returns all items sorted by expiry date (ascending) using the custom
     * MergeSort algorithm — O(n log n).
     * Soonest-to-expire items appear first.
     */
    public List<Item> getItemsSortedByExpiry() {
        List<Item> items = FileHandler.readItems(filePath);
        return MergeSort.sortByExpiryDate(items); // Custom MergeSort — NOT Collections.sort()
    }
}
