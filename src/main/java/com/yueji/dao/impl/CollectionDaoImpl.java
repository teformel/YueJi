package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.CollectionDao;
import com.yueji.model.Collection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CollectionDaoImpl implements CollectionDao {

    @Override
    public List<Collection> findByUserId(int userId) {
        List<Collection> list = new ArrayList<>();
        String sql = "SELECT c.id, c.novel_id, c.create_time, n.name as novel_name, n.cover, rp.chapter_id as last_read_chapter_id " +
                     "FROM t_collection c " +
                     "JOIN t_novel n ON c.novel_id = n.id " +
                     "LEFT JOIN t_reading_progress rp ON c.user_id = rp.user_id AND c.novel_id = rp.novel_id " +
                     "WHERE c.user_id = ? ORDER BY c.create_time DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Collection col = new Collection();
                    col.setId(rs.getInt("id"));
                    col.setUserId(userId);
                    col.setNovelId(rs.getInt("novel_id"));
                    col.setCreateTime(rs.getTimestamp("create_time"));
                    col.setNovelName(rs.getString("novel_name"));
                    col.setCover(rs.getString("cover"));
                    if (rs.getObject("last_read_chapter_id") != null) {
                        col.setLastReadChapterId(rs.getInt("last_read_chapter_id"));
                    }
                    list.add(col);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void add(int userId, int novelId) throws SQLException {
        String sql = "INSERT INTO t_collection (user_id, novel_id, create_time) VALUES (?, ?, CURRENT_TIMESTAMP) ON CONFLICT DO NOTHING";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, novelId);
            stmt.executeUpdate();
        }
    }

    @Override
    public void remove(int userId, int novelId) throws SQLException {
        String sql = "DELETE FROM t_collection WHERE user_id = ? AND novel_id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, novelId);
            stmt.executeUpdate();
        }
    }

    @Override
    public boolean isCollected(int userId, int novelId) {
        String sql = "SELECT id FROM t_collection WHERE user_id = ? AND novel_id = ?";
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
