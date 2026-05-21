package com.inventory.service;

import com.inventory.model.Item;
import com.inventory.util.FileHandler;
import com.inventory.util.MergeSort;
import com.inventory.util.Stack;

import java.util.List;

/*OOP Concept: ABSTRACTION (Service Layer)*/
public class InventoryService {

    private final String filePath;

    /*OOP Concept: ENCAPSULATION*/
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

    /* Adds a new item.*/
    public void addItem(Item item) {
        itemStack.push(item);           // Stack.push() — LIFO add
        FileHandler.addItem(filePath, item);
    }

    /*Returns all items read from the file.*/
    public List<Item> getAllItems() {
        return FileHandler.readItems(filePath);
    }

    /*Updates an existing item (Read-Modify-Overwrite via FileHandler).*/
    public boolean updateItem(Item item) {
        // Also update the stack's copy
        itemStack.removeById(item.getId());
        itemStack.push(item);
        return FileHandler.updateItem(filePath, item);
    }

    /*Deletes the most recently added item (true LIFO / Stack.pop()).*/
    public Item deleteLastAdded() {
        if (itemStack.isEmpty()) return null;

        Item top = itemStack.pop();                    // Stack.pop() — LIFO remove
        FileHandler.deleteItem(filePath, top.getId()); // Persist the deletion
        return top;
    }

    /*Deletes a specific item by ID.*/
    public boolean deleteItemById(String itemId) {
        itemStack.removeById(itemId);                  // Keep stack in sync
        return FileHandler.deleteItem(filePath, itemId);
    }

    /*Returns the item at the top of the stack (most recently added)*/
    public Item peekStack() {
        return itemStack.peek();
    }

    /*Returns the current stack size.*/
    public int stackSize() {
        return itemStack.size();
    }


    // Sorting — Component 02

    /*Returns all items sorted by expiry date (ascending) using the custom*/
    public List<Item> getItemsSortedByExpiry() {
        List<Item> items = FileHandler.readItems(filePath);
        return MergeSort.sortByExpiryDate(items); // Custom MergeSort — NOT Collections.sort()
    }
}
