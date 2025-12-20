package com.yueji.dao;

import com.yueji.common.DbUtils;
import com.yueji.model.User;

import java.sql.*;

public class UserDao {

    public User findByUsername(String username) {
        String sql = "SELECT * FROM sys_user WHERE username = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement createStatement = conn.prepareStatement(sql)) {
            createStatement.setString(1, username);
            try (ResultSet rs = createStatement.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void create(User user) throws SQLException {
        String sql = "INSERT INTO sys_user (username, password, nickname, role, gold_balance, created_at) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getNickname());
            stmt.setString(4, user.getRole());
            stmt.setInt(5, user.getGoldBalance());
            stmt.executeUpdate();
        }
    }

    public void update(User user) throws SQLException {
        String sql = "UPDATE sys_user SET nickname = ?, avatar = ?, gold_balance = ? WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getNickname());
            stmt.setString(2, user.getAvatar());
            stmt.setInt(3, user.getGoldBalance());
            stmt.setInt(4, user.getId());
            stmt.executeUpdate();
        }
    }

    public void updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE sys_user SET password = ? WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }

    // Helper to map ResultSet to User object
    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setNickname(rs.getString("nickname"));
        user.setRole(rs.getString("role"));
        user.setGoldBalance(rs.getInt("gold_balance"));
        user.setAvatar(rs.getString("avatar"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
