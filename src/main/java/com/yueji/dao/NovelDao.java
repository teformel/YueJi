package com.yueji.dao;

import com.yueji.common.DbUtils;
import com.yueji.model.Novel;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NovelDao {

    public List<Novel> findAll() {
        return search(null, null);
    }

    public List<Novel> search(String keyword, String category) {
        List<Novel> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT n.*, a.name as author_name FROM sys_novel n " +
                        "LEFT JOIN sys_author a ON n.author_id = a.id WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (n.title LIKE ? OR a.name LIKE ?) ");
        }
        if (category != null && !category.isEmpty()) {
            sql.append("AND n.category = ? ");
        }
        sql.append("ORDER BY n.created_at DESC");

        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String pattern = "%" + keyword + "%";
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
            }
            if (category != null && !category.isEmpty()) {
                stmt.setString(paramIndex++, category);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Novel findById(int id) {
        String sql = "SELECT n.*, a.name as author_name FROM sys_novel n " +
                "LEFT JOIN sys_author a ON n.author_id = a.id WHERE n.id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void create(Novel novel) throws SQLException {
        String sql = "INSERT INTO sys_novel (title, author_id, category, intro, cover_url, is_free, created_at) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novel.getTitle());
            stmt.setInt(2, novel.getAuthorId());
            stmt.setString(3, novel.getCategory());
            stmt.setString(4, novel.getIntro());
            stmt.setString(5, novel.getCoverUrl());
            stmt.setBoolean(6, novel.getIsFree());
            stmt.executeUpdate();
        }
    }

    public void update(Novel novel) throws SQLException {
        String sql = "UPDATE sys_novel SET title=?, author_id=?, category=?, intro=?, cover_url=?, is_free=? WHERE id=?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novel.getTitle());
            stmt.setInt(2, novel.getAuthorId());
            stmt.setString(3, novel.getCategory());
            stmt.setString(4, novel.getIntro());
            stmt.setString(5, novel.getCoverUrl());
            stmt.setBoolean(6, novel.getIsFree());
            stmt.setInt(7, novel.getId());
            stmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM sys_novel WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Novel mapRow(ResultSet rs) throws SQLException {
        Novel n = new Novel();
        n.setId(rs.getInt("id"));
        n.setTitle(rs.getString("title"));
        n.setAuthorId(rs.getInt("author_id"));
        n.setCategory(rs.getString("category"));
        n.setIntro(rs.getString("intro"));
        n.setCoverUrl(rs.getString("cover_url"));
        n.setIsFree(rs.getBoolean("is_free"));
        n.setCreatedAt(rs.getTimestamp("created_at"));
        if (hasColumn(rs, "author_name")) {
            n.setAuthorName(rs.getString("author_name"));
        }
        return n;
    }

    private boolean hasColumn(ResultSet rs, String columnName) {
        try {
            rs.findColumn(columnName);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }
}
