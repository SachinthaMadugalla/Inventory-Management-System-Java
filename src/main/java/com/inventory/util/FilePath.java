package com.inventory.util;

import javax.servlet.ServletContext;
import java.io.File;

/**
 * FilePath — resolves absolute paths for all data files.
 *
 * Priority (highest to lowest):
 *  1. JVM system property  -Dinventory.data.dir=...
 *  2. Environment variable  INVENTORY_DATA_DIR=...
 *  3. <webapp-root>/data/  (default — keeps data inside the deployment)
 *
 * Using the webapp real-path as the default ensures that items.txt and
 * the other flat files live in the project's own data/ folder, so they
 * are visible in the source tree and survive redeploys without moving.
 */
public class FilePath {

    // Resolved once per JVM; the ServletContext is only needed for fallback.
    private static volatile String DATA_DIR = null;

    private static String resolveDataDir(ServletContext context) {
        if (DATA_DIR != null) return DATA_DIR;

        // 1. JVM system property
        String override = System.getProperty("inventory.data.dir");

        // 2. Environment variable
        if (override == null || override.isEmpty()) {
            override = System.getenv("INVENTORY_DATA_DIR");
        }

        String base;
        if (override != null && !override.isEmpty()) {
            base = override;
        } else if (context != null) {
            // 3. Default: <webapp-root>/data/
            // getRealPath("/data") returns the absolute disk path of WEB-INF/../data
            String realPath = context.getRealPath("/data");
            base = (realPath != null) ? realPath : (context.getRealPath("/") + "data");
        } else {
            // Fallback when no context available (unit tests, etc.)
            base = System.getProperty("user.home") + File.separator
                    + "inventory-app" + File.separator + "data";
        }

        File dir = new File(base);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        DATA_DIR = dir.getAbsolutePath() + File.separator;
        return DATA_DIR;
    }

    public static String getItemsPath(ServletContext context) {
        return resolveDataDir(context) + "items.txt";
    }

    public static String getUsersPath(ServletContext context) {
        return resolveDataDir(context) + "users.txt";
    }

    public static String getSalesPath(ServletContext context) {
        return resolveDataDir(context) + "sales.txt";
    }

    public static String getReportsPath(ServletContext context) {
        return resolveDataDir(context) + "reports.txt";
    }
}
