package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.UserDao;
import com.yueji.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDaoImpl implements UserDao {

    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM t_user";
        try (Connection conn = DbUtils.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public User findByUsername(String username) {
        String sql = "SELECT * FROM t_user WHERE username = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User findById(int id) {
        String sql = "SELECT * FROM t_user WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void create(User user) throws SQLException {
        String sql = "INSERT INTO t_user (username, password, realname, phone, coin_balance, role, status, create_time) VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getRealname());
            stmt.setString(4, user.getPhone());
            stmt.setBigDecimal(5, user.getCoinBalance());
            stmt.setInt(6, user.getRole());
            stmt.setInt(7, user.getStatus());
            stmt.executeUpdate();
        }
    }

    @Override
    public void update(User user) throws SQLException {
        String sql = "UPDATE t_user SET realname = ?, phone = ?, coin_balance = ?, role = ?, status = ? WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getRealname());
            stmt.setString(2, user.getPhone());
            stmt.setBigDecimal(3, user.getCoinBalance());
            stmt.setInt(4, user.getRole());
            stmt.setInt(5, user.getStatus());
            stmt.setInt(6, user.getId());
            stmt.executeUpdate();
        }
    }

    @Override
    public void updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE t_user SET password = ? WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }

    @Override
    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM t_user ORDER BY id DESC";
        try (Connection conn = DbUtils.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void updateLastLoginTime(int userId) throws SQLException {
        String sql = "UPDATE t_user SET last_login_time = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        }
    }

    @Override
    public long countActiveUsersToday() {
        String sql = "SELECT COUNT(DISTINCT id) FROM t_user WHERE last_login_time >= CURRENT_DATE";
        try (Connection conn = DbUtils.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setRealname(rs.getString("realname"));
        user.setPhone(rs.getString("phone"));
        user.setCoinBalance(rs.getBigDecimal("coin_balance"));
        user.setRole(rs.getInt("role"));
        user.setStatus(rs.getInt("status"));
        user.setCreateTime(rs.getTimestamp("create_time"));
        user.setLastLoginTime(rs.getTimestamp("last_login_time"));
        return user;
    }
}
