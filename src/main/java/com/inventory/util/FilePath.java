package com.inventory.util;

import javax.servlet.ServletContext;
import java.io.File;

/*
 * Default location (auto-created on first run):
 *   Windows: C:\Users\<you>\inventory-app\data\
 */
public class FilePath {

    private static final String DATA_DIR = resolveDataDir();

    private static String resolveDataDir() {
        // 1. JVM system property
        String override = System.getProperty("inventory.data.dir");
        // 2. Environment variable
        if (override == null || override.isEmpty()) {
            override = System.getenv("INVENTORY_DATA_DIR");
        }
        // 3. Default: <user home>/inventory-app/data
        String base = (override != null && !override.isEmpty())
                ? override
                : System.getProperty("user.home") + File.separator
                + "inventory-app" + File.separator + "data";

        File dir = new File(base);
        if (!dir.exists()) {
            dir.mkdirs(); // create the folder on first run
        }
        return dir.getAbsolutePath() + File.separator;
    }

    public static String getItemsPath(ServletContext context) {
        return DATA_DIR + "items.txt";
    }

    public static String getUsersPath(ServletContext context) {
        return DATA_DIR + "users.txt";
    }

    public static String getSalesPath(ServletContext context) {
        return DATA_DIR + "sales.txt";
    }

    public static String getReportsPath(ServletContext context) {
        return DATA_DIR + "reports.txt";
    }
}