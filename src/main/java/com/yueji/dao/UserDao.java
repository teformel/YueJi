package com.yueji.dao;

import com.yueji.model.User;
import java.util.List;
import java.sql.SQLException;

public interface UserDao {
    User findByUsername(String username);
    User findById(int id);
    void create(User user) throws SQLException;
    void update(User user) throws SQLException;
    void updatePassword(int userId, String newPassword) throws SQLException;
    List<User> findAll();
    long count();
}
