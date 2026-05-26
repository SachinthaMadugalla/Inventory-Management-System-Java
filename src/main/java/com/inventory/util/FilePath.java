package com.inventory.util;

import javax.servlet.ServletContext;
import java.io.File;

public class FilePath {

    private static String resolveDataDir(ServletContext context) {
        // getRealPath("/") gives the absolute path to the web application root
        String webAppRoot = context.getRealPath("/");
        File dataDir = new File(webAppRoot).getParentFile();
        File dataDirFinal = new File(dataDir, "data");

        if (!dataDirFinal.exists()) {
            dataDirFinal.mkdirs();
        }
        return dataDirFinal.getAbsolutePath() + File.separator;
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
