package com.inventory.model;
public class Expiry {
    private String id;
    private String itemId;
    private String expiryDate;
    private boolean disposed;

    public Expiry() {
    }

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
        String[] parts = csv.split(",");
        if (parts.length < 4) return null;
        return new Expiry(parts[0], parts[1], parts[2], Boolean.parseBoolean(parts[3]));
    }
}