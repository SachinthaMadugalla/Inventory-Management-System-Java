package com.inventory.util;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Shared utility for all members to handle File I/O.
 * This ensures data consistency across the project.
 */
public class FileHandler {

    // Relative path to the data folder from the project root
    private static final String DATA_PATH = "data/";

    /**
     * Reads all lines from a text file.
     * @param fileName Name of the file (e.g., "items.txt")
     * @return List of strings representing each line
     */
    public static List<String> readData(String fileName) {
        List<String> data = new ArrayList<>();
        File file = new File(DATA_PATH + fileName);

        if (!file.exists()) {
            return data;
        }

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    data.add(line);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading file: " + e.getMessage());
        }
        return data;
    }

    /**
     * Writes (Overwrites) a list of strings to a text file.
     * Use this for updating or deleting records.
     */
    public static void writeData(String fileName, List<String> lines) {
        try (PrintWriter pw = new PrintWriter(new FileWriter(DATA_PATH + fileName))) {
            for (String line : lines) {
                pw.println(line);
            }
        } catch (IOException e) {
            System.err.println("Error writing to file: " + e.getMessage());
        }
    }

    /**
     * Appends a single line to a text file.
     * Use this for adding new records (Member 1 and Member 3).
     */
    public static void appendData(String fileName, String line) {
        try (PrintWriter pw = new PrintWriter(new FileWriter(DATA_PATH + fileName, true))) {
            pw.println(line);
        } catch (IOException e) {
            System.err.println("Error appending to file: " + e.getMessage());
        }
    }
}