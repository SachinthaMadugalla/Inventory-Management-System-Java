package com.inventory.service;

import com.inventory.model.Report;
import com.inventory.util.FileHandler;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

/**
 * OOP Concept: ABSTRACTION (Service Layer)
 * ReportService generates and persists summary reports.
 */
public class ReportService {

    private final String reportsFilePath;
    private SalesService salesService;

    public ReportService(String reportsFilePath, SalesService salesService) {
        this.reportsFilePath = reportsFilePath;
        this.salesService    = salesService;
    }

    // Overloaded constructor for when only deleting is needed
    public ReportService(String reportsFilePath) {
        this.reportsFilePath = reportsFilePath;
    }

    /**
     * Generates a new Report from current sales data and saves it to reports.txt.
     */
    public Report generateReport() {
        if (salesService == null) {
            throw new IllegalStateException("SalesService must be initialized to generate a report.");
        }
        
        List<?> sales = salesService.getAllSales();
        double revenue = salesService.getTotalRevenue();
        String topItem = salesService.getTopSellingItem();

        Report report = new Report(
                "RPT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase(),
                LocalDate.now().toString(),
                sales.size(),
                revenue,
                topItem
        );

        FileHandler.addReport(reportsFilePath, report);
        return report;
    }

    /**
     * Returns all previously generated reports.
     */
    public List<Report> getAllReports() {
        return FileHandler.readReports(reportsFilePath);
    }

    /**
     * Deletes a report by its ID.
     */
    public boolean deleteReport(String reportId) {
        List<Report> reports = getAllReports();
        boolean removed = reports.removeIf(r -> r.getReportId().equals(reportId));
        if (removed) {
            FileHandler.writeReports(reportsFilePath, reports);
        }
        return removed;
    }
}