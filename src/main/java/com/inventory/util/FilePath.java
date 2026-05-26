package com.inventory.util;

import javax.servlet.ServletContext;
import java.io.File;

public class FilePath {

    private static volatile String DATA_DIR = null;

    private static String resolveDataDir() {
        // This method is now simplified to always point to a stable, visible directory
        // on the user's desktop. This avoids all issues with temporary server paths.
        if (DATA_DIR == null) {
            String desktopPath = System.getProperty("user.home") + File.separator + "Desktop";
            File dataDir = new File(desktopPath, "InventoryData");

            if (!dataDir.exists()) {
                dataDir.mkdirs(); // Create the directory if it doesn't exist
            }
            DATA_DIR = dataDir.getAbsolutePath() + File.separator;
        }
        return DATA_DIR;
    }

    // All methods now use the simplified, context-independent path resolver.
    public static String getItemsPath(ServletContext context) {
        return resolveDataDir() + "items.txt";
    }

    public static String getUsersPath(ServletContext context) {
        return resolveDataDir() + "users.txt";
    }

    public static String getSalesPath(ServletContext context) {
        return resolveDataDir() + "sales.txt";
    }

    public static String getReportsPath(ServletContext context) {
        return resolveDataDir() + "reports.txt";
    }
    
    public static String getExpiryItemsPath(ServletContext context) {
        return resolveDataDir() + "expiry_items.csv";
    }
}
