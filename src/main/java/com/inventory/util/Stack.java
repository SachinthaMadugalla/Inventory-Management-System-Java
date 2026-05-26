package com.inventory.util;

import com.inventory.model.Item;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/*
 * OOP Concept: DATA STRUCTURE — Custom Stack (LIFO)
 */
public class Stack {

    // Internal storage — ArrayList gives O(1) push/pop at the end.
    private final List<Item> storage;

    public Stack() {
        this.storage = new ArrayList<>();
    }

    /** PUSH — adds an item to the top of the stack. */
    public void push(Item item) {
        storage.add(item);
    }

    /** POP — removes and returns the top (most recently added) item. */
    public Item pop() {
        if (isEmpty()) {
            throw new IllegalStateException("Stack is empty — nothing to pop.");
        }
        return storage.remove(storage.size() - 1);
    }

    /** PEEK — returns the top item without removing it. */
    public Item peek() {
        if (isEmpty()) return null;
        return storage.get(storage.size() - 1);
    }

    /** Returns true if the stack contains no items. */
    public boolean isEmpty() {
        return storage.isEmpty();
    }

    /** Returns the number of items currently in the stack. */
    public int size() {
        return storage.size();
    }

    /** Clears the stack. */
    public void clear() {
        storage.clear();
    }

    /** Returns all items in LIFO order (most recently added first). */
    public List<Item> toList() {
        List<Item> result = new ArrayList<>(storage);
        Collections.reverse(result); // newest first
        return result;
    }

    /** Returns a snapshot of all items in the stack (bottom → top order). */
    public List<Item> getAll() {
        return new ArrayList<>(storage);
    }

    /** Rebuilds the stack from a list of items (e.g., loaded from file). */
    public void loadFrom(List<Item> items) {
        storage.clear();
        storage.addAll(items);
    }

    /**
     * Removes a specific item by ID from anywhere in the stack.
     * Returns the removed item, or null if not found.
     */
    public Item removeById(String itemId) {
        for (int i = storage.size() - 1; i >= 0; i--) {
            if (storage.get(i).getId().equals(itemId)) {
                return storage.remove(i);
            }
        }
        return null;
    }
}
