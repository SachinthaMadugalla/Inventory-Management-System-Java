package com.inventory.model;

public class User {

    private String username;
    private String password;
    private String role;
    private String email;

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

    public String getUsername() { return username; }
    public void   setUsername(String u) { this.username = u; }

    public String getPassword() { return password; }
    public void   setPassword(String p) { this.password = p; }

    public String getRole() { return role; }
    public void   setRole(String r) { this.role = r; }

    public String getEmail() { return email; }
    public void   setEmail(String e) { this.email = e; }

    public String toCsv() {
        String em = (email != null) ? email : "";
        return username + "," + password + "," + role + "," + em;
    }

    public static User fromCsv(String csv) {
        if (csv == null || csv.trim().isEmpty()) {
            return null;
        }
        String[] parts = csv.split(",", -1);

        // A valid user record must have at least 3 parts (user, pass, role)
        if (parts.length < 3) {
            return null;
        }

        String username = parts[0].trim();
        String password = parts[1].trim();
        String role = parts[2].trim();
        String email = (parts.length > 3) ? parts[3].trim() : "";

        if (username.isEmpty() || password.isEmpty() || role.isEmpty()) {
            return null; // Core fields cannot be empty
        }

        return new User(username, password, role, email);
    }

    @Override
    public String toString() {
        return "User{username='" + username + "', role='" + role + "'}";
    }
}