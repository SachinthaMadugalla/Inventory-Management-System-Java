package com.inventory.util;

import com.inventory.model.Item;
import com.inventory.model.Sale;
import com.inventory.model.User;
import com.inventory.model.Report;
import com.inventory.model.Expiry;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class FileHandler {

    private static List<String> readLines(String filePath) {
        List<String> lines = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) {
            return lines;
        }
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            lines = br.lines().filter(line -> line != null && !line.trim().isEmpty()).collect(Collectors.toList());
        } catch (IOException e) {
            System.err.println("Error reading file: " + filePath);
            e.printStackTrace();
        }
        return lines;
    }

    private static void writeLines(String filePath, List<String> lines) {
        File file = new File(filePath);
        try {
            if (file.getParentFile() != null) {
                file.getParentFile().mkdirs();
            }
        } catch (Exception e) {
            System.err.println("Error creating directory for: " + filePath);
            e.printStackTrace();
        }
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, false))) {
            for (int i = 0; i < lines.size(); i++) {
                bw.write(lines.get(i));
                if (i < lines.size() - 1) {
                    bw.newLine();
                }
            }
        } catch (IOException e) {
            System.err.println("Error writing to file: " + filePath);
            e.printStackTrace();
        }
    }

    private static void appendLine(String filePath, String line) {
        File file = new File(filePath);
        try {
            if (file.getParentFile() != null) {
                file.getParentFile().mkdirs();
            }
        } catch (Exception e) {
            System.err.println("Error creating directory for: " + filePath);
            e.printStackTrace();
        }
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(file, true))) {
            bw.write(line);
            bw.newLine();
        } catch (IOException e) {
            System.err.println("Error appending to file: " + filePath);
            e.printStackTrace();
        }
    }

    public static synchronized List<Item> readItems(String filePath) {
        List<Item> items = new ArrayList<>();
        for (String line : readLines(filePath)) {
            Item item = Item.fromCsv(line);
            if (item != null) items.add(item);
        }
        return items;
    }

    public static synchronized void writeItems(String filePath, List<Item> items) {
        List<String> lines = items.stream().map(Item::toCsv).collect(Collectors.toList());
        writeLines(filePath, lines);
    }

    public static synchronized void addItem(String filePath, Item item) {
        appendLine(filePath, item.toCsv());
    }

    public static synchronized boolean updateItem(String filePath, Item updatedItem) {
        List<Item> items = readItems(filePath);
        boolean found = false;
        for (int i = 0; i < items.size(); i++) {
            if (items.get(i).getId().equals(updatedItem.getId())) {
                items.set(i, updatedItem);
                found = true;
                break;
            }
        }
        if (found) {
            writeItems(filePath, items);
        }
        return found;
    }

    public static synchronized boolean deleteItem(String filePath, String itemId) {
        List<Item> items = readItems(filePath);
        boolean removed = items.removeIf(item -> item.getId().equals(itemId));
        if (removed) {
            writeItems(filePath, items);
        }
        return removed;
    }

    public static synchronized List<Sale> readSales(String filePath) {
        List<Sale> sales = new ArrayList<>();
        for (String line : readLines(filePath)) {
            Sale sale = Sale.fromCsv(line);
            if (sale != null) sales.add(sale);
        }
        return sales;
    }

    public static synchronized void writeSales(String filePath, List<Sale> sales) {
        List<String> lines = sales.stream().map(Sale::toCsv).collect(Collectors.toList());
        writeLines(filePath, lines);
    }

    public static synchronized void addSale(String filePath, Sale sale) {
        appendLine(filePath, sale.toCsv());
    }

    public static synchronized boolean deleteSale(String filePath, String saleId) {
        List<Sale> sales = readSales(filePath);
        boolean removed = sales.removeIf(s -> s.getSaleId().equals(saleId));
        if (removed) {
            writeSales(filePath, sales);
        }
        return removed;
    }

    public static synchronized List<User> readUsers(String filePath) {
        List<User> users = new ArrayList<>();
        for (String line : readLines(filePath)) {
            User user = User.fromCsv(line);
            if (user != null) users.add(user);
        }
        return users;
    }

    public static synchronized void writeUsers(String filePath, List<User> users) {
        List<String> lines = users.stream().map(User::toCsv).collect(Collectors.toList());
        writeLines(filePath, lines);
    }

    public static synchronized void addUser(String filePath, User user) {
        appendLine(filePath, user.toCsv());
    }

    public static synchronized List<Report> readReports(String filePath) {
        List<Report> reports = new ArrayList<>();
        for (String line : readLines(filePath)) {
            Report report = Report.fromCsv(line);
            if (report != null) reports.add(report);
        }
        return reports;
    }

    public static synchronized void addReport(String filePath, Report report) {
        appendLine(filePath, report.toCsv());
    }

    public static synchronized void writeReports(String filePath, List<Report> reports) {
        List<String> lines = reports.stream().map(Report::toCsv).collect(Collectors.toList());
        writeLines(filePath, lines);
    }
    
    public static synchronized List<Expiry> readExpiryItems(String filePath) {
        List<Expiry> expiryItems = new ArrayList<>();
        for (String line : readLines(filePath)) {
            Expiry expiry = Expiry.fromCsv(line);
            if (expiry != null) expiryItems.add(expiry);
        }
        return expiryItems;
    }

    public static synchronized void writeExpiryItems(String filePath, List<Expiry> expiryItems) {
        List<String> lines = expiryItems.stream().map(Expiry::toCsv).collect(Collectors.toList());
        writeLines(filePath, lines);
    }
}