package com.inventory.service;

import com.inventory.model.User;
import com.inventory.util.FileHandler;

import java.util.List;

public class UserService {

    private final String filePath;

    public UserService(String filePath) {
        this.filePath = filePath;
    }

    //Authenticates a user by matching username and password.
    //Returns the matching User object, or null if credentials are invalid.
    public User authenticate(String username, String password) {
        List<User> users = FileHandler.readUsers(filePath);
        for (User user : users) {
            if (user.getUsername().equals(username)
                    && user.getPassword().equals(password)) {
                return user;
            }
        }
        return null; // Authentication failed
    }

    //Registers a new user if the username is not already taken.
    //Returns true on success, false if the username already exists.
    public boolean register(User newUser) {
        List<User> users = FileHandler.readUsers(filePath);
        for (User u : users) {
            if (u.getUsername().equalsIgnoreCase(newUser.getUsername())) {
                return false; // Username already taken
            }
        }
        FileHandler.addUser(filePath, newUser);
        return true;
    }

    //Returns all registered users.
    public List<User> getAllUsers() {
        return FileHandler.readUsers(filePath);
    }

    //Deletes a user by username
    public boolean deleteUser(String username) {
        List<User> users = FileHandler.readUsers(filePath);
        boolean removed = users.removeIf(u -> u.getUsername().equals(username));
        if (removed) FileHandler.writeUsers(filePath, users);
        return removed;
    }
}
