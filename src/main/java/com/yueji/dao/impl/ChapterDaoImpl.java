package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.ChapterDao;
import com.yueji.model.Chapter;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChapterDaoImpl implements ChapterDao {

    @Override
    public List<Chapter> findByNovelId(int novelId) {
        List<Chapter> list = new ArrayList<>();
        // Note: Content excluded for list view performance optimization, conforming to logic
        String sql = "SELECT id, novel_id, title, price, is_paid, create_time FROM t_chapter WHERE novel_id = ? ORDER BY id ASC";
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

    @Override
    public Chapter findById(int id) {
        String sql = "SELECT * FROM t_chapter WHERE id = ?";
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

    @Override
    public void create(Chapter chapter) throws SQLException {
        String sql = "INSERT INTO t_chapter (novel_id, title, content, price, is_paid, create_time) VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, chapter.getNovelId());
            stmt.setString(2, chapter.getTitle());
            stmt.setString(3, chapter.getContent());
            if (chapter.getPrice() != null) stmt.setBigDecimal(4, chapter.getPrice()); else stmt.setNull(4, Types.DECIMAL);
            if (chapter.getIsPaid() != null) stmt.setInt(5, chapter.getIsPaid()); else stmt.setNull(5, Types.INTEGER);
            stmt.executeUpdate();
        }
    }

    @Override
    public void update(Chapter chapter) throws SQLException {
        String sql = "UPDATE t_chapter SET title=?, content=?, price=?, is_paid=? WHERE id=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, chapter.getTitle());
            stmt.setString(2, chapter.getContent());
            if (chapter.getPrice() != null) stmt.setBigDecimal(3, chapter.getPrice()); else stmt.setNull(3, Types.DECIMAL);
            if (chapter.getIsPaid() != null) stmt.setInt(4, chapter.getIsPaid()); else stmt.setNull(4, Types.INTEGER);
            stmt.setInt(5, chapter.getId());
            stmt.executeUpdate();
        }
    }

    @Override
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM t_chapter WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    @Override
    public int countByNovelId(int novelId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM t_chapter WHERE novel_id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, novelId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    private Chapter mapRow(ResultSet rs, boolean includeContent) throws SQLException {
        Chapter c = new Chapter();
        c.setId(rs.getInt("id"));
        c.setNovelId(rs.getInt("novel_id"));
        c.setTitle(rs.getString("title"));
        c.setPrice(rs.getBigDecimal("price"));
        c.setIsPaid(rs.getInt("is_paid"));
        c.setCreateTime(rs.getTimestamp("create_time"));
        if (includeContent) {
            c.setContent(rs.getString("content"));
        }
        return c;
    }
}
