package com.inventory.service;

import com.inventory.model.User;
import com.inventory.util.FileHandler;

import java.util.List;

public class UserService {

    private final String filePath;

    public UserService(String filePath) {
        this.filePath = filePath;
    }

    /**
     * Authenticates a user by matching username OR email with the password.
     * Returns the matching User object, or null if credentials are invalid.
     */
    public User authenticate(String usernameOrEmail, String password) {
        if (usernameOrEmail == null || password == null) return null;
        List<User> users = FileHandler.readUsers(filePath);
        for (User user : users) {
            boolean matchIdentifier = user.getUsername().equals(usernameOrEmail)
                    || (user.getEmail() != null
                    && user.getEmail().equalsIgnoreCase(usernameOrEmail));
            if (matchIdentifier && user.getPassword().equals(password)) {
                return user;
            }
        }
        return null; // Authentication failed
    }

    /**
     * Registers a new user if neither the username nor the email is already taken.
     * Returns:
     *   "ok"              — success
     *   "username_taken"  — username already exists
     *   "email_taken"     — email already registered
     */
    public String register(User newUser) {
        List<User> users = FileHandler.readUsers(filePath);
        for (User u : users) {
            if (u.getUsername().equalsIgnoreCase(newUser.getUsername())) {
                return "username_taken";
            }
            if (newUser.getEmail() != null && !newUser.getEmail().isEmpty()
                    && newUser.getEmail().equalsIgnoreCase(u.getEmail())) {
                return "email_taken";
            }
        }
        FileHandler.addUser(filePath, newUser);
        return "ok";
    }

    // Returns all registered users.
    public List<User> getAllUsers() {
        return FileHandler.readUsers(filePath);
    }

    // Deletes a user by username.
    public boolean deleteUser(String username) {
        List<User> users = FileHandler.readUsers(filePath);
        boolean removed = users.removeIf(u -> u.getUsername().equals(username));
        if (removed) FileHandler.writeUsers(filePath, users);
        return removed;
    }

    /**
     * Finds a user by their registered email address (case-insensitive).
     * Returns the User object, or null if no match is found.
     */
    public User findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) return null;
        List<User> users = FileHandler.readUsers(filePath);
        for (User u : users) {
            if (email.trim().equalsIgnoreCase(u.getEmail())) {
                return u;
            }
        }
        return null;
    }

    /**
     * Resets the password for the given username.
     * OTP verification is handled in the servlet (stored in session).
     * Returns true on success, false if the username is not found.
     */
    public boolean resetPassword(String username, String newPassword) {
        List<User> users = FileHandler.readUsers(filePath);
        for (User u : users) {
            if (u.getUsername().equalsIgnoreCase(username)) {
                u.setPassword(newPassword.trim());
                FileHandler.writeUsers(filePath, users);
                return true;
            }
        }
        return false;
    }
}
