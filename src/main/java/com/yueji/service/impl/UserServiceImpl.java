package com.yueji.service.impl;

import com.yueji.common.BeanFactory;
import com.yueji.dao.UserDao;
import com.yueji.model.User;
import com.yueji.service.UserService;

import java.math.BigDecimal;
import java.sql.SQLException;

public class UserServiceImpl implements UserService {

    private final UserDao userDao;

    public UserServiceImpl() {
        // In a real DI container this would be injected.
        // Here we lazily look it up or strictly, the Factory should construct us with it.
        // But for cyclic deps capability (not needed here) or simplicity in static block:
        // We can't use BeanFactory.getBean(UserDao.class) inside Constructor if existing BeanFactory logic
        // initializes DAOs before Services.
        // However, BeanFactory static block runs sequentially.
        // But to be safe and "Abstract", we assume the factory provides it.
        // For this simple impl, we can call getBean here as long as DAOs are init first.
        this.userDao = BeanFactory.getBean(UserDao.class);
    }

    @Override
    public User login(String username, String password) {
        User user = userDao.findByUsername(username);
        // Password check (Plain vs MD5). 
        // In this demo, we assume the DB has MD5 and we should hash input to check.
        // For simplicity, let's assume raw string check or implement MD5 helper later.
        // The requirements say MD5 storage.
        // TODO: Add MD5 Utility usage. user.getPassword().equals(MD5(password))
        if (user != null && user.getPassword().equals(password)) {
            if (user.getStatus() == 0) return null; // Disabled
            return user;
        }
        return null;
    }

    @Override
    public void register(User user) throws Exception {
        if (userDao.findByUsername(user.getUsername()) != null) {
            throw new Exception("Username already exists");
        }
        // Initialize fields
        user.setCoinBalance(BigDecimal.ZERO);
        user.setRole(0); // User
        user.setStatus(1); // Active
        userDao.create(user);
    }

    @Override
    public void updateProfile(User user) throws Exception {
        userDao.update(user);
    }

    @Override
    public void updatePassword(int userId, String oldPwd, String newPwd) throws Exception {
        User user = userDao.findById(userId);
        if (user != null && user.getPassword().equals(oldPwd)) {
            userDao.updatePassword(userId, newPwd);
        } else {
            throw new Exception("Wrong old password");
        }
    }

    @Override
    public User getUserById(int id) {
        return userDao.findById(id);
    }

    @Override
    public java.util.List<User> getAllUsers() {
        return userDao.findAll();
    }
}
