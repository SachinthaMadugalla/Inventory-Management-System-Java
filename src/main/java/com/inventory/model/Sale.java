package com.inventory.model;

/**
 * OOP Concept: ENCAPSULATION
 * All fields are private with public getters/setters.
 *
 * Sale represents a single sales transaction stored in sales.txt.
 * CSV Format: saleId,itemId,itemName,quantitySold,totalPrice,saleDate
 */
public class Sale {

    // --- Private fields (Encapsulation) ---
    private String saleId;
    private String itemId;
    private String itemName;
    private int    quantitySold;
    private double totalPrice;
    private String saleDate; // Format: YYYY-MM-DD

    // --- Constructors ---
    public Sale() {}

    public Sale(String saleId, String itemId, String itemName,
                int quantitySold, double totalPrice, String saleDate) {
        this.saleId       = saleId;
        this.itemId       = itemId;
        this.itemName     = itemName;
        this.quantitySold = quantitySold;
        this.totalPrice   = totalPrice;
        this.saleDate     = saleDate;
    }

    // --- Getters & Setters ---
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

    /**
     * Serialises the Sale to a CSV line for file storage.
     */
    public String toCsv() {
        return saleId + "," + itemId + "," + itemName + ","
             + quantitySold + "," + totalPrice + "," + saleDate;
    }

    /**
     * Deserialises a CSV line back into a Sale object.
     */
    public static Sale fromCsv(String csv) {
        String[] parts = csv.split(",", -1);
        if (parts.length < 6) return null;
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
            return null;
        }
    }

    @Override
    public String toString() {
        return "Sale{saleId='" + saleId + "', itemName='" + itemName
             + "', qty=" + quantitySold + ", total=" + totalPrice + "}";
    }
}
