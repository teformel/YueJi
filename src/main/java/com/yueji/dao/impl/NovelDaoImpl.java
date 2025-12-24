package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.NovelDao;
import com.yueji.model.Novel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NovelDaoImpl implements NovelDao {

    @Override
    public long count() {
        String sql = "SELECT COUNT(*) FROM t_novel";
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
    public List<Novel> findAll() {
        return search(null, null);
    }

    @Override
    public List<Novel> search(String keyword, Integer categoryId) {
        List<Novel> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT n.*, a.penname as author_name, c.name as category_name FROM t_novel n " +
                "LEFT JOIN t_author a ON n.author_id = a.id " +
                "LEFT JOIN t_category c ON n.category_id = c.id WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (n.name LIKE ? OR a.penname LIKE ?) ");
        }
        if (categoryId != null) {
            sql.append("AND n.category_id = ? ");
        }
        sql.append("ORDER BY n.id DESC"); // Use ID or create_time if available (t_novel doesn't have create_time in schema, using ID)

        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String pattern = "%" + keyword + "%";
                stmt.setString(paramIndex++, pattern);
                stmt.setString(paramIndex++, pattern);
            }
            if (categoryId != null) {
                stmt.setInt(paramIndex++, categoryId);
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

    @Override
    public Novel findById(int id) {
        String sql = "SELECT n.*, a.penname as author_name, c.name as category_name FROM t_novel n " +
                     "LEFT JOIN t_author a ON n.author_id = a.id " +
                     "LEFT JOIN t_category c ON n.category_id = c.id WHERE n.id = ?";
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

    @Override
    public List<Novel> findByAuthorId(int authorId) {
        List<Novel> list = new ArrayList<>();
        String sql = "SELECT n.*, a.penname as author_name, c.name as category_name FROM t_novel n " +
                     "LEFT JOIN t_author a ON n.author_id = a.id " +
                     "LEFT JOIN t_category c ON n.category_id = c.id WHERE n.author_id = ? " +
                     "ORDER BY n.id DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, authorId);
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

    @Override
    public void create(Novel novel) throws SQLException {
        String sql = "INSERT INTO t_novel (name, author_id, category_id, description, cover, status, total_chapters) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novel.getName());
            if (novel.getAuthorId() != null) stmt.setInt(2, novel.getAuthorId()); else stmt.setNull(2, Types.INTEGER);
            if (novel.getCategoryId() != null) stmt.setInt(3, novel.getCategoryId()); else stmt.setNull(3, Types.INTEGER);
            stmt.setString(4, novel.getDescription());
            stmt.setString(5, novel.getCover());
            if (novel.getStatus() != null) stmt.setInt(6, novel.getStatus()); else stmt.setNull(6, Types.INTEGER);
            if (novel.getTotalChapters() != null) stmt.setInt(7, novel.getTotalChapters()); else stmt.setNull(7, Types.INTEGER);
            stmt.executeUpdate();
        }
    }

    @Override
    public void update(Novel novel) throws SQLException {
        String sql = "UPDATE t_novel SET name=?, author_id=?, category_id=?, description=?, cover=?, status=?, total_chapters=? WHERE id=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novel.getName());
            if (novel.getAuthorId() != null) stmt.setInt(2, novel.getAuthorId()); else stmt.setNull(2, Types.INTEGER);
            if (novel.getCategoryId() != null) stmt.setInt(3, novel.getCategoryId()); else stmt.setNull(3, Types.INTEGER);
            stmt.setString(4, novel.getDescription());
            stmt.setString(5, novel.getCover());
            if (novel.getStatus() != null) stmt.setInt(6, novel.getStatus()); else stmt.setNull(6, Types.INTEGER);
            if (novel.getTotalChapters() != null) stmt.setInt(7, novel.getTotalChapters()); else stmt.setNull(7, Types.INTEGER);
            stmt.setInt(8, novel.getId());
            stmt.executeUpdate();
        }
    }

    @Override
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM t_novel WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    @Override
    public void incrementViewCount(int id) throws SQLException {
        String sql = "UPDATE t_novel SET view_count = view_count + 1 WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    @Override
    public void incrementTotalChapters(int id) throws SQLException {
        String sql = "UPDATE t_novel SET total_chapters = total_chapters + 1 WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    @Override
    public void decrementTotalChapters(int id) throws SQLException {
        String sql = "UPDATE t_novel SET total_chapters = GREATEST(0, total_chapters - 1) WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Novel mapRow(ResultSet rs) throws SQLException {
        Novel n = new Novel();
        n.setId(rs.getInt("id"));
        n.setName(rs.getString("name"));
        n.setAuthorId(rs.getInt("author_id"));
        n.setCategoryId(rs.getInt("category_id"));
        n.setDescription(rs.getString("description"));
        n.setCover(rs.getString("cover"));
        n.setStatus(rs.getInt("status"));
        n.setTotalChapters(rs.getInt("total_chapters"));
        if(hasColumn(rs, "view_count")) {
            n.setViewCount(rs.getInt("view_count"));
        } else {
            n.setViewCount(0);
        }
        
        if (hasColumn(rs, "author_name")) {
            n.setAuthorName(rs.getString("author_name"));
        }
        if (hasColumn(rs, "category_name")) {
            n.setCategoryName(rs.getString("category_name"));
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
