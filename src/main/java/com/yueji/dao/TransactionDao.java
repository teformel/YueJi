package com.yueji.dao;

import com.yueji.common.DbUtils;
import java.sql.*;

public class TransactionDao {

    public void createOrder(int userId, int amount, double payment) throws SQLException {
        Connection conn = null;
        try {
            conn = DbUtils.getConnection();
            conn.setAutoCommit(false); // Transaction

            // 1. Create Order
            String sqlOrder = "INSERT INTO sys_order (user_id, amount, payment_amount, created_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
            try (PreparedStatement stmt = conn.prepareStatement(sqlOrder)) {
                stmt.setInt(1, userId);
                stmt.setInt(2, amount);
                stmt.setDouble(3, payment);
                stmt.executeUpdate();
            }

            // 2. Add Gold
            String sqlUpdate = "UPDATE sys_user SET gold_balance = gold_balance + ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sqlUpdate)) {
                stmt.setInt(1, amount);
                stmt.setInt(2, userId);
                stmt.executeUpdate();
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null)
                conn.rollback();
            throw e;
        } finally {
            DbUtils.closeQuietly(conn);
        }
    }

    public boolean purchaseChapter(int userId, int chapterId, int price) throws SQLException {
        Connection conn = null;
        try {
            conn = DbUtils.getConnection();
            conn.setAutoCommit(false);

            // Check balance
            String sqlCheck = "SELECT gold_balance FROM sys_user WHERE id = ?";
            int balance = 0;
            try (PreparedStatement stmt = conn.prepareStatement(sqlCheck)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next())
                        balance = rs.getInt(1);
                    else
                        return false; // User not found
                }
            }

            if (balance < price) {
                return false; // Insufficient funds
            }

            // Deduct Gold
            String sqlDeduct = "UPDATE sys_user SET gold_balance = gold_balance - ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sqlDeduct)) {
                stmt.setInt(1, price);
                stmt.setInt(2, userId);
                stmt.executeUpdate();
            }

            // Record Purchase
            String sqlRecord = "INSERT INTO sys_chapter_purchase (user_id, chapter_id, price, created_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
            try (PreparedStatement stmt = conn.prepareStatement(sqlRecord)) {
                stmt.setInt(1, userId);
                stmt.setInt(2, chapterId);
                stmt.setInt(3, price);
                stmt.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null)
                conn.rollback();
            throw e;
        } finally {
            DbUtils.closeQuietly(conn);
        }
    }

    public boolean isChapterPurchased(int userId, int chapterId) {
        String sql = "SELECT id FROM sys_chapter_purchase WHERE user_id = ? AND chapter_id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, chapterId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
