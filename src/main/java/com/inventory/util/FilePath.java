package com.inventory.util;

import javax.servlet.ServletContext;
import java.io.File;

public class FilePath {

    // This path points directly to the project's source data folder.
    // This is for development convenience to see live changes in the project files.
    private static final String DATA_DIR = "C:/Users/sachi/Desktop/Inventory-Management-System-Java/data/";

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
