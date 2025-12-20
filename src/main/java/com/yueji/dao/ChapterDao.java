package com.yueji.dao;

import com.yueji.common.DbUtils;
import com.yueji.model.Chapter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChapterDao {

    public List<Chapter> findByNovelId(int novelId) {
        List<Chapter> list = new ArrayList<>();
        // Usually we don't load content in list view for performance, but here
        // simplistic approach.
        // Actually, let's ONLY load id, title, price, etc. WITHOUT content to save
        // bandwidth.
        String sql = "SELECT id, novel_id, title, word_count, price, sort_order, created_at FROM sys_chapter WHERE novel_id = ? ORDER BY sort_order ASC";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, novelId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs, false));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Chapter findById(int id) {
        String sql = "SELECT * FROM sys_chapter WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return mapRow(rs, true);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void create(Chapter chapter) throws SQLException {
        String sql = "INSERT INTO sys_chapter (novel_id, title, content, word_count, price, sort_order, created_at) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, chapter.getNovelId());
            stmt.setString(2, chapter.getTitle());
            stmt.setString(3, chapter.getContent());
            stmt.setInt(4, chapter.getWordCount());
            stmt.setInt(5, chapter.getPrice());
            stmt.setInt(6, chapter.getSortOrder());
            stmt.executeUpdate();
        }
    }

    public void update(Chapter chapter) throws SQLException {
        String sql = "UPDATE sys_chapter SET title=?, content=?, word_count=?, price=?, sort_order=? WHERE id=?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, chapter.getTitle());
            stmt.setString(2, chapter.getContent());
            stmt.setInt(3, chapter.getWordCount());
            stmt.setInt(4, chapter.getPrice());
            stmt.setInt(5, chapter.getSortOrder());
            stmt.setInt(6, chapter.getId());
            stmt.executeUpdate();
        }
    }
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM sys_chapter WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Chapter mapRow(ResultSet rs, boolean includeContent) throws SQLException {
        Chapter c = new Chapter();
        c.setId(rs.getInt("id"));
        c.setNovelId(rs.getInt("novel_id"));
        c.setTitle(rs.getString("title"));
        c.setWordCount(rs.getInt("word_count"));
        c.setPrice(rs.getInt("price"));
        c.setSortOrder(rs.getInt("sort_order"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        if (includeContent) {
            c.setContent(rs.getString("content"));
        }
        return c;
    }
}
