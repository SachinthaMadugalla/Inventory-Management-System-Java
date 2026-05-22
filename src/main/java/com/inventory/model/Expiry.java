package com.inventory.model;

public class Expiry {

    private String id;
    private String itemId;
    private String expiryDate; // Format: YYYY-MM-DD
    private boolean disposed;

    public Expiry() {}

    public Expiry(String id, String itemId, String expiryDate, boolean disposed) {
        this.id = id;
        this.itemId = itemId;
        this.expiryDate = expiryDate;
        this.disposed = disposed;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getItemId() {
        return itemId;
    }

    public void setItemId(String itemId) {
        this.itemId = itemId;
    }

    public String getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(String expiryDate) {
        this.expiryDate = expiryDate;
    }

    public boolean isDisposed() {
        return disposed;
    }

    public void setDisposed(boolean disposed) {
        this.disposed = disposed;
    }

    public String toCsv() {
        return id + "," + itemId + "," + expiryDate + "," + disposed;
    }

    public static Expiry fromCsv(String csv) {
        String[] parts = csv.split(",", -1);
        if (parts.length < 4) return null;
        try {
            return new Expiry(
                    parts[0].trim(),
                    parts[1].trim(),
                    parts[2].trim(),
                    Boolean.parseBoolean(parts[3].trim())
            );
        } catch (Exception e) {
            return null; // Skip malformed lines
        }
    }

    @Override
    public String toString() {
        return "Expiry{id='" + id + "', itemId='" + itemId + "', expiryDate='" + expiryDate + "', disposed=" + disposed + "}";
    }
}