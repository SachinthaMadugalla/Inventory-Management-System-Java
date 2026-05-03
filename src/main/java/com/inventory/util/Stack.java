package com.inventory.util;

import com.inventory.model.Item;
import java.util.ArrayList;
import java.util.List;

/**
 * OOP Concept: DATA STRUCTURE — Custom Stack (LIFO)
 * It is used in Component 01 (Inventory Management) to track the order
 * in which Items are added, so that "Delete Last Added" always removes
 * the most recently pushed item — true LIFO behaviour.
 * Why a Stack here?
 *   - push(item)  → called when a new item is added to inventory.
 *   - pop()       → called when the user clicks "Delete Last Added",
 *                   ensuring the most recently added item is removed first.
 *   - peek()      → lets the UI show which item would be removed next.
 */
public class Stack {

    // Internal storage — an ArrayList gives O(1) push/pop at the end.
    private final List<Item> storage;

    public Stack() {
        this.storage = new ArrayList<>();
    }

    /**
     * PUSH — adds an item to the top of the stack.
     * Called every time a new inventory item is saved.
     * Time complexity: O(1) amortised.
     */
    public void push(Item item) {
        storage.add(item);
    }

    /**
     * POP — removes and returns the top (most recently added) item.
     * Called when the user triggers "Delete Last Added".
     * Time complexity: O(1).
     *
     * @throws IllegalStateException if the stack is empty.
     */
    public Item pop() {
        if (isEmpty()) {
            throw new IllegalStateException("Stack is empty — nothing to pop.");
        }
        return storage.remove(storage.size() - 1);
    }

    /**
     * PEEK — returns the top item without removing it.
     * Used to display which item will be deleted next.
     * Time complexity: O(1).
     */
    public Item peek() {
        if (isEmpty()) return null;
        return storage.get(storage.size() - 1);
    }

    /**
     * Returns true if the stack contains no items.
     */
    public boolean isEmpty() {
        return storage.isEmpty();
    }

    /**
     * Returns the number of items currently in the stack.
     */
    public int size() {
        return storage.size();
    }

    /**
     * Returns a snapshot of all items in the stack (bottom → top order).
     * Useful for displaying the stack contents in the UI.
     */
    public List<Item> getAll() {
        return new ArrayList<>(storage);
    }

    /**
     * Rebuilds the stack from a list of items (e.g., loaded from file).
     * Items are pushed in list order so the last element is the top.
     */
    public void loadFrom(List<Item> items) {
        storage.clear();
        storage.addAll(items);
    }

    /**
     * Removes a specific item by ID from anywhere in the stack.
     * Used when a targeted delete (by ID) is performed from the UI.
     */
    public void removeById(String itemId) {
        storage.removeIf(item -> item.getId().equals(itemId));
    }
}
