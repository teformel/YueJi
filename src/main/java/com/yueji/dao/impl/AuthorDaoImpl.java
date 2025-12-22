package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.AuthorDao;
import com.yueji.model.Author;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuthorDaoImpl implements AuthorDao {

    @Override
    public List<Author> findAll() {
        List<Author> list = new ArrayList<>();
        String sql = "SELECT * FROM t_author ORDER BY id DESC";
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
    public Author findById(int id) {
        String sql = "SELECT * FROM t_author WHERE id = ?";
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
    public Author findByUserId(int userId) {
        String sql = "SELECT * FROM t_author WHERE user_id = ?";
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

    @Override
    public void create(Author author) throws SQLException {
        String sql = "INSERT INTO t_author (user_id, penname, introduction, status) VALUES (?, ?, ?, 1)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (author.getUserId() != null) stmt.setInt(1, author.getUserId()); else stmt.setNull(1, Types.INTEGER);
            stmt.setString(2, author.getPenname());
            stmt.setString(3, author.getIntroduction());
            stmt.executeUpdate();
        }
    }

    @Override
    public void update(Author author) throws SQLException {
        String sql = "UPDATE t_author SET user_id=?, penname=?, introduction=?, status=? WHERE id=?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (author.getUserId() != null) stmt.setInt(1, author.getUserId()); else stmt.setNull(1, Types.INTEGER);
            stmt.setString(2, author.getPenname());
            stmt.setString(3, author.getIntroduction());
            stmt.setInt(4, author.getStatus());
            stmt.setInt(5, author.getId());
            stmt.executeUpdate();
        }
    }

    @Override
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM t_author WHERE id = ?";
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
        a.setPenname(rs.getString("penname"));
        a.setIntroduction(rs.getString("introduction"));
        a.setStatus(rs.getInt("status"));
        return a;
    }
}
