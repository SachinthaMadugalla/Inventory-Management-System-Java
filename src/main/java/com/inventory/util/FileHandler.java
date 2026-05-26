package com.inventory.util;

import com.inventory.model.Item;
import com.inventory.model.Sale;
import com.inventory.model.User;
import com.inventory.model.Report;
import com.inventory.model.Expiry;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FileHandler {

    public static synchronized List<String> readLines(String filePath) {
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

    public static synchronized void writeLines(String filePath, List<String> lines) {
        File file = new File(filePath);
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
            throw new RuntimeException("Failed to write to file: " + filePath, e);
        }
    }

    public static synchronized void appendLine(String filePath, String line) {
        File file = new File(filePath);
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs();
        }
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, true))) {
            bw.write(line);
            bw.newLine();
        } catch (IOException e) {
            System.err.println("[FileHandler] Error appending to " + filePath + ": " + e.getMessage());
            throw new RuntimeException("Failed to append to file: " + filePath, e);
        }
    }

    public static List<Item> readItems(String filePath) {
        List<Item> items = new ArrayList<>();
        for (String line : readLines(filePath)) {
            Item item = Item.fromCsv(line);
            if (item != null) items.add(item);
        }
        return items;
    }

    public static void writeItems(String filePath, List<Item> items) {
        List<String> lines = new ArrayList<>();
        for (Item item : items) {
            lines.add(item.toCsv());
        }
        writeLines(filePath, lines);
    }

    public static void addItem(String filePath, Item item) {
        appendLine(filePath, item.toCsv());
    }

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

    public static boolean deleteItem(String filePath, String itemId) {
        List<Item> items = readItems(filePath);
        boolean removed = items.removeIf(i -> i.getId().equals(itemId));
        if (removed) writeItems(filePath, items);
        return removed;
    }

    public static List<Sale> readSales(String filePath) {
        List<Sale> sales = new ArrayList<>();
        for (String line : readLines(filePath)) {
            Sale sale = Sale.fromCsv(line);
            if (sale != null) sales.add(sale);
        }
        return sales;
    }

    public static void writeSales(String filePath, List<Sale> sales) {
        List<String> lines = new ArrayList<>();
        for (Sale sale : sales) {
            lines.add(sale.toCsv());
        }
        writeLines(filePath, lines);
    }

    public static void addSale(String filePath, Sale sale) {
        appendLine(filePath, sale.toCsv());
    }

    public static boolean deleteSale(String filePath, String saleId) {
        List<Sale> sales = readSales(filePath);
        boolean removed = sales.removeIf(s -> s.getSaleId().equals(saleId));
        if (removed) writeSales(filePath, sales);
        return removed;
    }

    public static List<User> readUsers(String filePath) {
        List<User> users = new ArrayList<>();
        for (String line : readLines(filePath)) {
            User user = User.fromCsv(line);
            if (user != null) users.add(user);
        }
        return users;
    }

    public static void writeUsers(String filePath, List<User> users) {
        List<String> lines = new ArrayList<>();
        for (User user : users) {
            lines.add(user.toCsv());
        }
        writeLines(filePath, lines);
    }

    public static void addUser(String filePath, User user) {
        appendLine(filePath, user.toCsv());
    }

    public static List<Report> readReports(String filePath) {
        List<Report> reports = new ArrayList<>();
        for (String line : readLines(filePath)) {
            Report report = Report.fromCsv(line);
            if (report != null) reports.add(report);
        }
        return reports;
    }

    public static void addReport(String filePath, Report report) {
        appendLine(filePath, report.toCsv());
    }

    public static void writeReports(String filePath, List<Report> reports) {
        List<String> lines = new ArrayList<>();
        for (Report r : reports) {
            lines.add(r.toCsv());
        }
        writeLines(filePath, lines);
    }
    
    public static List<Expiry> readExpiryItems(String filePath) {
        List<Expiry> expiryItems = new ArrayList<>();
        for (String line : readLines(filePath)) {
            Expiry expiry = Expiry.fromCsv(line);
            if (expiry != null) expiryItems.add(expiry);
        }
        return expiryItems;
    }

    public static void writeExpiryItems(String filePath, List<Expiry> expiryItems) {
        List<String> lines = new ArrayList<>();
        for (Expiry expiry : expiryItems) {
            lines.add(expiry.toCsv());
        }
        writeLines(filePath, lines);
    }
}
