package com.inventory.model;

/**OOP Concept: ENCAPSULATION*/
public class Item {

    //Private variables
    private String id;
    private String name;
    private String category;
    private int    quantity;
    private double price;
    private String expiryDate; // Format: YYYY-MM-DD
    private String status;     // e.g., "Active", "Disposed"

    // --- Constructors ---
    public Item() {}

    public Item(String id, String name, String category,
                int quantity, double price, String expiryDate) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.quantity = quantity;
        this.price = price;
        this.expiryDate = expiryDate;
        this.status = "Active"; // Default status
    }

    public Item(String id, String name, String category,
                int quantity, double price, String expiryDate, String status) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.quantity = quantity;
        this.price = price;
        this.expiryDate = expiryDate;
        this.status = status;
    }

    // --- Getters & Setters ---
    public String getId()                    { return id; }
    public void   setId(String id)           { this.id = id; }

    public String getName()                  { return name; }
    public void   setName(String name)       { this.name = name; }

    public String getCategory()              { return category; }
    public void   setCategory(String c)      { this.category = c; }

    public int    getQuantity()              { return quantity; }
    public void   setQuantity(int q)         { this.quantity = q; }

    public double getPrice()                 { return price; }
    public void   setPrice(double p)         { this.price = p; }

    public String getExpiryDate()            { return expiryDate; }
    public void   setExpiryDate(String d)    { this.expiryDate = d; }

    public String getStatus()                { return status; }
    public void   setStatus(String s)        { this.status = s; }

    /*Serializes the Item to a CSV line for file storage.*/
    public String toCsv() {
        return id + "," + name + "," + category + ","
                + quantity + "," + price + "," + expiryDate + "," + status;
    }

    /* Deserializes a CSV line back into an Item object.*/
    public static Item fromCsv(String csv) {
        String[] parts = csv.split(",", -1);
        if (parts.length < 6) return null;
        try {
            String status = parts.length > 6 ? parts[6].trim() : "Active";
            return new Item(
                    parts[0].trim(),
                    parts[1].trim(),
                    parts[2].trim(),
                    Integer.parseInt(parts[3].trim()),
                    Double.parseDouble(parts[4].trim()),
                    parts[5].trim(),
                    status
            );
        } catch (NumberFormatException e) {
            return null; // Skip malformed lines
        }
    }

    @Override
    public String toString() {
        return "Item{id='" + id + "', name='" + name + "', qty=" + quantity + "}";
    }
}
