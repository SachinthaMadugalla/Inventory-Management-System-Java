package com.inventory.model;

/**
 * Sale — Model class representing a sales transaction.
 * OOP: ENCAPSULATION (private fields with getters/setters).
 * Supports CSV serialization (toCsv/fromCsv) for file persistence.
 */
public class Sale {

    // Private fields (Encapsulation)
    private String saleId;       // Unique sale identifier
    private String itemId;       // Reference to sold item
    private String itemName;     // Item name (cached for record)
    private int    quantitySold; // Number of units sold
    private double totalPrice;   // Quantity × Item Price
    private String saleDate;     // Sale date (YYYY-MM-DD format)

    // Default constructor
    public Sale() {}

    // Parameterized constructor
    public Sale(String saleId, String itemId, String itemName,
                int quantitySold, double totalPrice, String saleDate) {
        this.saleId       = saleId;
        this.itemId       = itemId;
        this.itemName     = itemName;
        this.quantitySold = quantitySold;
        this.totalPrice   = totalPrice;
        this.saleDate     = saleDate;
    }

    // Getters & Setters for all fields
    public String getSaleId()                    { return saleId; }
    public void   setSaleId(String id)           { this.saleId = id; }

    public String getItemId()                    { return itemId; }
    public void   setItemId(String id)           { this.itemId = id; }

    public String getItemName()                  { return itemName; }
    public void   setItemName(String n)          { this.itemName = n; }

    public int    getQuantitySold()              { return quantitySold; }
    public void   setQuantitySold(int q)         { this.quantitySold = q; }

    public double getTotalPrice()                { return totalPrice; }
    public void   setTotalPrice(double p)        { this.totalPrice = p; }

    public String getSaleDate()                  { return saleDate; }
    public void   setSaleDate(String d)          { this.saleDate = d; }

    // Convert Sale object to CSV format for file storage
    public String toCsv() {
        return saleId + "," + itemId + "," + itemName + ","
                + quantitySold + "," + totalPrice + "," + saleDate;
    }

    // Parse CSV line back into Sale object (Deserialization)
    public static Sale fromCsv(String csv) {
        String[] parts = csv.split(",", -1);
        if (parts.length < 6) return null;  // Invalid format
        try {
            return new Sale(
                    parts[0].trim(),
                    parts[1].trim(),
                    parts[2].trim(),
                    Integer.parseInt(parts[3].trim()),
                    Double.parseDouble(parts[4].trim()),
                    parts[5].trim()
            );
        } catch (NumberFormatException e) {
            return null;  // Skip malformed lines
        }
    }

    // String representation for debugging
    @Override
    public String toString() {
        return "Sale{saleId='" + saleId + "', itemName='" + itemName
                + "', qty=" + quantitySold + ", total=" + totalPrice + "}";
    }
}