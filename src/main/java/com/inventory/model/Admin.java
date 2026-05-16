package com.inventory.model;

public class Admin extends User {

    //Private field specific to Admin (Encapsulation)
    private String adminCode;

    //Constructors
    public Admin() {
        super();
        setRole("admin"); // Admins always have role = "admin"
    }

    public Admin(String username, String password, String adminCode) {
        super(username, password, "admin");
        this.adminCode = adminCode;
    }

    //Getter & Setter
    public String getAdminCode()             { return adminCode; }
    public void   setAdminCode(String code)  { this.adminCode = code; }

    @Override
    public String toCsv() {
        return super.toCsv() + "," + adminCode;
    }


    public static Admin fromCsv(String csv) {
        String[] parts = csv.split(",", -1);
        if (parts.length < 4) return null;
        Admin admin = new Admin(parts[0].trim(), parts[1].trim(), parts[3].trim());
        return admin;
    }

    @Override
    public String toString() {
        return "Admin{username='" + getUsername() + "', adminCode='" + adminCode + "'}";
    }
}

