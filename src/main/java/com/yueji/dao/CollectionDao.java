package com.yueji.dao;

import com.yueji.common.DbUtils;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CollectionDao {

    public List<Map<String, Object>> findByUserId(int userId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT c.id, c.novel_id, n.title, n.cover_url FROM sys_collection c " +
                "JOIN sys_novel n ON c.novel_id = n.id WHERE c.user_id = ? ORDER BY c.created_at DESC";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", rs.getInt("id"));
                    map.put("novelId", rs.getInt("novel_id"));
                    map.put("title", rs.getString("title"));
                    map.put("coverUrl", rs.getString("cover_url"));
                    list.add(map);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void add(int userId, int novelId) throws SQLException {
        String sql = "INSERT INTO sys_collection (user_id, novel_id, created_at) VALUES (?, ?, CURRENT_TIMESTAMP) ON CONFLICT DO NOTHING";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, novelId);
            stmt.executeUpdate();
        }
    }

    public void remove(int userId, int novelId) throws SQLException {
        String sql = "DELETE FROM sys_collection WHERE user_id = ? AND novel_id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, novelId);
            stmt.executeUpdate();
        }
    }

    public boolean isCollected(int userId, int novelId) {
        String sql = "SELECT 1 FROM sys_collection WHERE user_id = ? AND novel_id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, novelId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
