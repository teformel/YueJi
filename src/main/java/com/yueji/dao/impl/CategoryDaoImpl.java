package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.CategoryDao;
import com.yueji.model.Category;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDaoImpl implements CategoryDao {

    @Override
    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM t_category ORDER BY id ASC";
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
    public Category findById(int id) {
        String sql = "SELECT * FROM t_category WHERE id = ?";
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
    public void create(Category category) throws SQLException {
        String sql = "INSERT INTO t_category (name, created_time) VALUES (?, CURRENT_TIMESTAMP)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getName());
            stmt.executeUpdate();
        }
    }

    @Override
    public void update(Category category) throws SQLException {
        String sql = "UPDATE t_category SET name = ? WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, category.getName());
            stmt.setInt(2, category.getId());
            stmt.executeUpdate();
        }
    }

    @Override
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM t_category WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Category mapRow(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setCreatedTime(rs.getTimestamp("created_time"));
        return c;
    }
}
