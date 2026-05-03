package com.inventory.util;

import com.inventory.model.Item;
import com.inventory.model.Sale;
import com.inventory.model.User;
import com.inventory.model.Report;

import java.io.*;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.List;

/**
 * OOP Concept: ABSTRACTION
 * FileHandler hides all file I/O complexity behind clean, high-level methods.
 * Callers never deal with BufferedReader/Writer directly — they just call
 * readItems(), writeItems(), etc.
 *
 * File Integrity Strategy:
 * All "update" and "delete" operations follow the Read-Modify-Overwrite pattern:
 *   1. Read the entire file into a List in memory.
 *   2. Modify the List (add / remove / update the target object).
 *   3. Overwrite the file with the updated List.
 * This guarantees the file is always in a consistent state.
 */
public class FileHandler {

    // -----------------------------------------------------------------------
    // Path resolution — files live in the "data/" folder at the project root.
    // ServletContext.getRealPath() is used at runtime; these constants are the
    // relative names passed in from servlets.
    // -----------------------------------------------------------------------
    public static final String ITEMS_FILE   = "data/items.txt";
    public static final String SALES_FILE   = "data/sales.txt";
    public static final String USERS_FILE   = "data/users.txt";
    public static final String REPORTS_FILE = "data/reports.txt";

    // -----------------------------------------------------------------------
    // Generic low-level helpers
    // -----------------------------------------------------------------------

    /**
     * Reads every non-blank line from a file and returns them as a List.
     * OOP Concept: ABSTRACTION — callers don't know how the file is opened.
     */
    public static List<String> readLines(String filePath) {
        List<String> lines = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return lines;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    lines.add(line.trim());
                }
            }
        } catch (IOException e) {
            System.err.println("[FileHandler] Error reading " + filePath + ": " + e.getMessage());
        }
        return lines;
    }

    /**
     * Overwrites a file with the given list of lines.
     * Each element becomes one line in the file.
     */
    public static void writeLines(String filePath, List<String> lines) {
        File file = new File(filePath);
        // Ensure parent directories exist
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, false))) {
            for (String line : lines) {
                bw.write(line);
                bw.newLine();
            }
        } catch (IOException e) {
            System.err.println("[FileHandler] Error writing " + filePath + ": " + e.getMessage());
        }
    }

    /**
     * Appends a single line to a file without reading the whole file.
     * Used for simple append operations (e.g., adding a new sale).
     */
    public static void appendLine(String filePath, String line) {
        File file = new File(filePath);
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, true))) {
            bw.write(line);
            bw.newLine();
        } catch (IOException e) {
            System.err.println("[FileHandler] Error appending to " + filePath + ": " + e.getMessage());
        }
    }

    // -----------------------------------------------------------------------
    // Item CRUD operations
    // -----------------------------------------------------------------------

    /** Reads all Items from items.txt. */
    public static List<Item> readItems(String filePath) {
        List<Item> items = new ArrayList<>();
        for (String line : readLines(filePath)) {
            Item item = Item.fromCsv(line);
            if (item != null) items.add(item);
        }
        return items;
    }

    /**
     * Overwrites items.txt with the provided list.
     * Used after any add / update / delete operation (Read-Modify-Overwrite).
     */
    public static void writeItems(String filePath, List<Item> items) {
        List<String> lines = new ArrayList<>();
        for (Item item : items) {
            lines.add(item.toCsv());
        }
        writeLines(filePath, lines);
    }

    /**
     * Adds a new Item by appending its CSV line.
     * For the Stack-based add, the caller pushes to the Stack first,
     * then calls this method to persist.
     */
    public static void addItem(String filePath, Item item) {
        appendLine(filePath, item.toCsv());
    }

    /**
     * Updates an existing Item identified by its ID.
     * Read-Modify-Overwrite pattern.
     */
    public static boolean updateItem(String filePath, Item updated) {
        List<Item> items = readItems(filePath);
        boolean found = false;
        for (int i = 0; i < items.size(); i++) {
            if (items.get(i).getId().equals(updated.getId())) {
                items.set(i, updated);
                found = true;
                break;
            }
        }
        if (found) writeItems(filePath, items);
        return found;
    }

    /**
     * Deletes an Item by ID.
     * Read-Modify-Overwrite pattern.
     * NOTE: The servlet layer also calls stack.pop() before calling this,
     * ensuring the LIFO Stack invariant is maintained.
     */
    public static boolean deleteItem(String filePath, String itemId) {
        List<Item> items = readItems(filePath);
        boolean removed = items.removeIf(i -> i.getId().equals(itemId));
        if (removed) writeItems(filePath, items);
        return removed;
    }

    // -----------------------------------------------------------------------
    // Sale CRUD operations
    // -----------------------------------------------------------------------

    /** Reads all Sales from sales.txt. */
    public static List<Sale> readSales(String filePath) {
        List<Sale> sales = new ArrayList<>();
        for (String line : readLines(filePath)) {
            Sale sale = Sale.fromCsv(line);
            if (sale != null) sales.add(sale);
        }
        return sales;
    }

    /** Overwrites sales.txt with the provided list. */
    public static void writeSales(String filePath, List<Sale> sales) {
        List<String> lines = new ArrayList<>();
        for (Sale sale : sales) {
            lines.add(sale.toCsv());
        }
        writeLines(filePath, lines);
    }

    /** Appends a new Sale record. */
    public static void addSale(String filePath, Sale sale) {
        appendLine(filePath, sale.toCsv());
    }

    // -----------------------------------------------------------------------
    // User CRUD operations
    // -----------------------------------------------------------------------

    /** Reads all Users from users.txt. */
    public static List<User> readUsers(String filePath) {
        List<User> users = new ArrayList<>();
        for (String line : readLines(filePath)) {
            User user = User.fromCsv(line);
            if (user != null) users.add(user);
        }
        return users;
    }

    /** Overwrites users.txt with the provided list. */
    public static void writeUsers(String filePath, List<User> users) {
        List<String> lines = new ArrayList<>();
        for (User user : users) {
            lines.add(user.toCsv());
        }
        writeLines(filePath, lines);
    }

    /** Appends a new User record. */
    public static void addUser(String filePath, User user) {
        appendLine(filePath, user.toCsv());
    }

    // -----------------------------------------------------------------------
    // Report CRUD operations
    // -----------------------------------------------------------------------

    /** Reads all Reports from reports.txt. */
    public static List<Report> readReports(String filePath) {
        List<Report> reports = new ArrayList<>();
        for (String line : readLines(filePath)) {
            Report report = Report.fromCsv(line);
            if (report != null) reports.add(report);
        }
        return reports;
    }

    /** Appends a new Report record. */
    public static void addReport(String filePath, Report report) {
        appendLine(filePath, report.toCsv());
    }

    /** Overwrites reports.txt with the provided list. */
    public static void writeReports(String filePath, List<Report> reports) {
        List<String> lines = new ArrayList<>();
        for (Report r : reports) {
            lines.add(r.toCsv());
        }
        writeLines(filePath, lines);
    }
}
