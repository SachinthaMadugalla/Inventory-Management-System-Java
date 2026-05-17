package com.inventory.service;

import com.inventory.model.User;
import com.inventory.util.FileHandler;

import java.util.List;

public class UserService {

    private final String filePath;

    public UserService(String filePath) {
        this.filePath = filePath;
    }

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

    public List<User> getAllUsers() {
        return FileHandler.readUsers(filePath);
    }

    public boolean deleteUser(String username) {
        List<User> users = FileHandler.readUsers(filePath);
        boolean removed = users.removeIf(u -> u.getUsername().equals(username));
        if (removed) FileHandler.writeUsers(filePath, users);
        return removed;
    }
}
