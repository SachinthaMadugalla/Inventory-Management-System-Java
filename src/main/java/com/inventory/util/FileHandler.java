package com.inventory.util;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * FileHandler — Abstraction of all file I/O operations.
 * All read/write operations for data storage are isolated here.
 */
public class FileHandler {

    /**
     * Read all non-empty lines from a file.
     * Returns an empty list if the file does not exist yet.
     */
    public static List<String> readLines(String filePath) {
        List<String> lines = new ArrayList<>();
        File file = new File(filePath);
        if (!file.exists()) return lines;
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) lines.add(line.trim());
            }
        } catch (IOException e) {
            System.err.println("[FileHandler] Error reading " + filePath + ": " + e.getMessage());
        }
        return lines;
    }

    /**
     * Overwrite a file with the given list of lines.
     */
    public static void writeLines(String filePath, List<String> lines) {
        ensureFileExists(filePath);
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, false))) {
            for (String line : lines) {
                bw.write(line);
                bw.newLine();
            }
        } catch (IOException e) {
            System.err.println("[FileHandler] Error writing " + filePath + ": " + e.getMessage());
        }
    }

    /**
     * Append a single line to a file.
     */
    public static void appendLine(String filePath, String line) {
        ensureFileExists(filePath);
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true))) {
            bw.write(line);
            bw.newLine();
        } catch (IOException e) {
            System.err.println("[FileHandler] Error appending to " + filePath + ": " + e.getMessage());
        }
    }

    /**
     * Create a file (and parent directories) if it does not already exist.
     */
    public static void ensureFileExists(String filePath) {
        File file = new File(filePath);
        try {
            if (file.getParentFile() != null) file.getParentFile().mkdirs();
            if (!file.exists()) file.createNewFile();
        } catch (IOException e) {
            System.err.println("[FileHandler] Could not create file " + filePath + ": " + e.getMessage());
        }
    }

    /**
     * Delete a specific line that starts with the given key (first field).
     * Returns true if a line was removed.
     */
    public static boolean deleteLineByKey(String filePath, String key) {
        List<String> lines = readLines(filePath);
        boolean removed = lines.removeIf(l -> l.startsWith(key + "|"));
        if (removed) writeLines(filePath, lines);
        return removed;
    }

    /**
     * Update a line whose first field matches the given key.
     * Returns true if the line was found and updated.
     */
    public static boolean updateLineByKey(String filePath, String key, String newLine) {
        List<String> lines = readLines(filePath);
        boolean found = false;
        for (int i = 0; i < lines.size(); i++) {
            if (lines.get(i).startsWith(key + "|")) {
                lines.set(i, newLine);
                found = true;
                break;
            }
        }
        if (found) writeLines(filePath, lines);
        return found;
    }
}
