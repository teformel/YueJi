package com.yueji.dao;

import com.yueji.common.DbUtils;
import com.yueji.model.Author;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuthorDao {

    public List<Author> findAll() {
        List<Author> list = new ArrayList<>();
        String sql = "SELECT * FROM sys_author ORDER BY id DESC";
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

    public Author findById(int id) {
        String sql = "SELECT * FROM sys_author WHERE id = ?";
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
    public Author findByUserId(int userId) {
        String sql = "SELECT * FROM sys_author WHERE user_id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next())
                    return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void create(Author author) throws SQLException {
        String sql = "INSERT INTO sys_author (user_id, name, bio, created_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (author.getUserId() != null) stmt.setInt(1, author.getUserId());
            else stmt.setNull(1, Types.INTEGER);
            stmt.setString(2, author.getName());
            stmt.setString(3, author.getBio());
            stmt.executeUpdate();
        }
    }

    public void update(Author author) throws SQLException {
        String sql = "UPDATE sys_author SET user_id = ?, name = ?, bio = ? WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (author.getUserId() != null) stmt.setInt(1, author.getUserId());
            else stmt.setNull(1, Types.INTEGER);
            stmt.setString(2, author.getName());
            stmt.setString(3, author.getBio());
            stmt.setInt(4, author.getId());
            stmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM sys_author WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Author mapRow(ResultSet rs) throws SQLException {
        Author a = new Author();
        a.setId(rs.getInt("id"));
        int userId = rs.getInt("user_id");
        if (!rs.wasNull()) a.setUserId(userId);
        a.setName(rs.getString("name"));
        a.setBio(rs.getString("bio"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }
}
