package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.ReadingProgressDao;
import com.yueji.model.ReadingProgress;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ReadingProgressDaoImpl implements ReadingProgressDao {

    @Override
    public void upsert(int userId, int novelId, int chapterId, int scrollY) throws SQLException {
        // Upsert logic (PostgreSQL 9.5+ uses ON CONFLICT)
        String sql = "INSERT INTO t_reading_progress (user_id, novel_id, chapter_id, scroll_y, update_time) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP) " +
                     "ON CONFLICT (user_id, novel_id) DO UPDATE SET chapter_id = EXCLUDED.chapter_id, scroll_y = EXCLUDED.scroll_y, update_time = CURRENT_TIMESTAMP";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, novelId);
            stmt.setInt(3, chapterId);
            stmt.setInt(4, scrollY);
            stmt.executeUpdate();
        }
    }

    @Override
    public ReadingProgress findByUserAndNovel(int userId, int novelId) {
        String sql = "SELECT * FROM t_reading_progress WHERE user_id = ? AND novel_id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, novelId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ReadingProgress rp = new ReadingProgress();
                    rp.setId(rs.getInt("id"));
                    rp.setUserId(rs.getInt("user_id"));
                    rp.setNovelId(rs.getInt("novel_id"));
                    rp.setChapterId(rs.getInt("chapter_id"));
                    rp.setScrollY(rs.getInt("scroll_y"));
                    rp.setUpdateTime(rs.getTimestamp("update_time"));
                    rp.setTotalReadingTime(rs.getInt("total_reading_time"));
                    return rp;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void addReadingTime(int userId, int novelId, int seconds) throws SQLException {
        // Upsert style: increase if exists, or insert new
        String sql = "INSERT INTO t_reading_progress (user_id, novel_id, chapter_id, scroll_y, total_reading_time, update_time) VALUES (?, ?, 0, 0, ?, CURRENT_TIMESTAMP) " +
                     "ON CONFLICT (user_id, novel_id) DO UPDATE SET total_reading_time = t_reading_progress.total_reading_time + ?, update_time = CURRENT_TIMESTAMP";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, novelId);
            stmt.setInt(3, seconds);
            stmt.setInt(4, seconds);
            stmt.executeUpdate();
        }
    }
}
