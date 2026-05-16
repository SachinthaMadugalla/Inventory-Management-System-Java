package com.inventory.model;

public class User {

    //Private fields (Encapsulation)
    private String username;
    private String password;
    private String role; // "admin" or "user"

    //Constructors
    public User() {}

    public User(String username, String password, String role) {
        this.username = username;
        this.password = password;
        this.role     = role;
    }

    //Getters & Setters
    public String getUsername()              { return username; }
    public void   setUsername(String u)      { this.username = u; }

    public String getPassword()              { return password; }
    public void   setPassword(String p)      { this.password = p; }

    public String getRole()                  { return role; }
    public void   setRole(String r)          { this.role = r; }

    /**
     * Serialises the object to a CSV line for file storage.
     * Format: username,password,role
     */
    public String toCsv() {
        return username + "," + password + "," + role;
    }

    /**
     * Deserialises a CSV line back into a User object.
     */
    public static User fromCsv(String csv) {
        String[] parts = csv.split(",", -1);
        if (parts.length < 3) return null;
        return new User(parts[0].trim(), parts[1].trim(), parts[2].trim());
    }

    @Override
    public String toString() {
        return "User{username='" + username + "', role='" + role + "'}";
    }
}

