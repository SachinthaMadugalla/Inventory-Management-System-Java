package com.inventory.model;

/**
 * OOP Concept: ENCAPSULATION
 * All fields are private with public getters/setters.
 *
 * Report is a summary object generated from sales data.
 * CSV Format: reportId,generatedDate,totalSales,totalRevenue,topItemName
 */
public class Report {

    // --- Private fields (Encapsulation) ---
    private String reportId;
    private String generatedDate;
    private int    totalSales;
    private double totalRevenue;
    private String topItemName;

    // --- Constructors ---
    public Report() {}

    public Report(String reportId, String generatedDate,
                  int totalSales, double totalRevenue, String topItemName) {
        this.reportId      = reportId;
        this.generatedDate = generatedDate;
        this.totalSales    = totalSales;
        this.totalRevenue  = totalRevenue;
        this.topItemName   = topItemName;
    }

    // --- Getters & Setters ---
    public String getReportId()                  { return reportId; }
    public void   setReportId(String id)         { this.reportId = id; }

    public String getGeneratedDate()             { return generatedDate; }
    public void   setGeneratedDate(String d)     { this.generatedDate = d; }

    public int    getTotalSales()                { return totalSales; }
    public void   setTotalSales(int t)           { this.totalSales = t; }

    public double getTotalRevenue()              { return totalRevenue; }
    public void   setTotalRevenue(double r)      { this.totalRevenue = r; }

    public String getTopItemName()               { return topItemName; }
    public void   setTopItemName(String n)       { this.topItemName = n; }

    /**
     * Serialises the Report to a CSV line for file storage.
     */
    public String toCsv() {
        return reportId + "," + generatedDate + ","
             + totalSales + "," + totalRevenue + "," + topItemName;
    }

    /**
     * Deserialises a CSV line back into a Report object.
     */
    public static Report fromCsv(String csv) {
        String[] parts = csv.split(",", -1);
        if (parts.length < 5) return null;
        try {
            return new Report(
                parts[0].trim(),
                parts[1].trim(),
                Integer.parseInt(parts[2].trim()),
                Double.parseDouble(parts[3].trim()),
                parts[4].trim()
            );
        } catch (NumberFormatException e) {
            return null;
        }
    }

    @Override
    public String toString() {
        return "Report{id='" + reportId + "', revenue=" + totalRevenue + "}";
    }
}
