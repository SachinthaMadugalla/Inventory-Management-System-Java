package com.inventory.util;

import javax.servlet.ServletContext;
import java.io.File;

public class FilePath {

    private static volatile String DATA_DIR = null;

    private static String resolveDataDir() {
        if (DATA_DIR == null) {
            // Use the project's root directory as the base for the data folder.
            // This ensures that the data files are always located inside the project
            // and are visible within the IDE (e.g., IntelliJ).
            // System.getProperty("user.dir") reliably points to the project root
            // when running from most IDEs or via Maven.
            String projectRoot = System.getProperty("user.dir");
            File dataDir = new File(projectRoot, "data");

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
