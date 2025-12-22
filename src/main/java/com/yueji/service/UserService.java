package com.yueji.service;

import com.yueji.model.User;
import java.sql.SQLException;

public interface UserService {
    User login(String username, String password);
    void register(User user) throws Exception;
    void updateProfile(User user) throws Exception;
    void updatePassword(int userId, String oldPwd, String newPwd) throws Exception;
    User getUserById(int id);
    java.util.List<User> getAllUsers();

}
