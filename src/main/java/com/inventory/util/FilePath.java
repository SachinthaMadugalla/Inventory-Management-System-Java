package com.inventory.util;

import javax.servlet.ServletContext;
import java.io.File;

public class FilePath {

    private static volatile String DATA_DIR = null;

    private static String resolveDataDir() {
        if (DATA_DIR == null) {
            // Point directly to the project's data folder to prevent data loss 
            // from Tomcat deploying to a temporary directory.
            String basePath = "C:/Users/USER/Desktop/OOP Project/Inventory-Management-System-Java/data";
            File dataDir = new File(basePath);

            if (!dataDir.exists()) {
                dataDir.mkdirs(); 
            }
            DATA_DIR = dataDir.getAbsolutePath() + File.separator;
        }
        return DATA_DIR;
    }

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
