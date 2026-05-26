package com.inventory.model;

public class Admin extends User {

    //Optional admin specific field
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

    public Admin(String fullName, String username, String password,
                 String email, String adminCode) {
        super(username, password, "admin", email);
        this.adminCode = adminCode;
    }

    //Getter & Setter
    public String getAdminCode() { return adminCode; }
    public void   setAdminCode(String code) { this.adminCode = code; }

    //Uses the parent User.toCsv() so the format stays consistent:
    @Override
    public String toCsv() {
        return super.toCsv(); //username,password,role,email
    }


    //Reads an Admin from the standard 5-field User CSV line.
    // Falls back gracefully for old 3-field records.
    public static Admin fromCsv(String csv) {
        User u = User.fromCsv(csv);
        if (u == null) return null;
        Admin admin = new Admin();
        admin.setUsername(u.getUsername());
        admin.setPassword(u.getPassword());
        admin.setRole("admin");
        admin.setEmail(u.getEmail());
        return admin;
    }

    @Override
    public String toString() {
        return "Admin{username='" + getUsername() + "', email='" + getEmail() + "'}";
    }
}
