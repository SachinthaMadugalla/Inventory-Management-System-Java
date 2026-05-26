package com.inventory.model;

public class User {

    //Encapsulation
    private String username;
    private String password;
    private String role;      //for admin or user
    private String email;

    //Constructors
    public User() {}

    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role     = role;
    }

    public User(String username, String password, String role, String email) {
        this.username = username;
        this.password = password;
        this.role     = role;
        this.email    = email;
    }

    //Getters & Setters
    public String getUsername() { return username; }
    public void   setUsername(String u) { this.username = u; }

    public String getPassword() { return password; }
    public void   setPassword(String p) { this.password = p; }

    public String getRole() { return role; }
    public void   setRole(String r) { this.role = r; }

    public String getEmail() { return email; }
    public void   setEmail(String e) { this.email = e; }

    /**
     * CSV format: username,password,role,email
     * fullName and email are optional for backward-compatibility with old records.
     *
     * Old 3-field records (username,password,role) are still readable via fromCsv().
     */
    public String toCsv() {
        String em = (email    != null) ? email    : "";
        return username + "," + password + "," + role + "," + em;
    }

    public static User fromCsv(String csv) {
        String[] parts = csv.split(",", -1);
        if (parts.length < 3) return null;

        User u = new User();

        if (parts.length == 3) {
            // Legacy format: username,password,role
            u.setUsername(parts[0].trim());
            u.setPassword(parts[1].trim());
            u.setRole(parts[2].trim());
        } else if (parts.length == 4) {
            // Old 4-field format: username,password,role,email
            u.setUsername(parts[0].trim());
            u.setPassword(parts[1].trim());
            u.setRole(parts[2].trim());
            u.setEmail(parts[3].trim());
        } else {
            // New 5-field:format:username,password,role,email
            u.setUsername(parts[1].trim());
            u.setPassword(parts[2].trim());
            u.setRole(parts[3].trim());
            u.setEmail(parts[4].trim());
        }
        return u;
    }

    @Override
    public String toString() {
        return "User{username='" + username + "', role='" + role + "'}";
    }
}
