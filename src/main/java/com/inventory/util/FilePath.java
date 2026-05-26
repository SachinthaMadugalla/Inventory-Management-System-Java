package com.inventory.util;

import javax.servlet.ServletContext;
import java.io.File;

public class FilePath {

    private static String resolveDataDir(ServletContext context) {
        // The "data" directory is at the project root, not in WEB-INF.
        // getRealPath("/") points to the root of the web application.
        // We need to go up one level to find the project root.
        String webAppRoot = context.getRealPath("/");
        File projectRoot = new File(webAppRoot).getParentFile().getParentFile();
        File dataDir = new File(projectRoot, "data");

        if (!dataDir.exists()) {
            dataDir.mkdirs();
        }
        return dataDir.getAbsolutePath() + File.separator;
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

    public static String getExpiryItemsPath(ServletContext context) {
        return resolveDataDir(context) + "expiry_items.csv";
    }
}