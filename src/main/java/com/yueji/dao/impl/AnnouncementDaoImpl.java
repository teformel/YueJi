package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.AnnouncementDao;
import com.yueji.model.Announcement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDaoImpl implements AnnouncementDao {

    @Override
    public void create(Announcement a) throws SQLException {
        String sql = "INSERT INTO t_announcement (title, content, is_active) VALUES (?, ?, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, a.getTitle());
            stmt.setString(2, a.getContent());
            stmt.setInt(3, a.getIsActive() != null ? a.getIsActive() : 1);
            stmt.executeUpdate();
        }
    }

    @Override
    public void update(Announcement a) throws SQLException {
        String sql = "UPDATE t_announcement SET title = ?, content = ?, is_active = ? WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, a.getTitle());
            stmt.setString(2, a.getContent());
            stmt.setInt(3, a.getIsActive());
            stmt.setInt(4, a.getId());
            stmt.executeUpdate();
        }
    }

    @Override
    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM t_announcement WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    @Override
    public Announcement findById(int id) {
        String sql = "SELECT * FROM t_announcement WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Announcement> findAll() {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT * FROM t_announcement ORDER BY create_time DESC";
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
    public List<Announcement> findActive() {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT * FROM t_announcement WHERE is_active = 1 ORDER BY create_time DESC";
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

    private Announcement mapRow(ResultSet rs) throws SQLException {
        Announcement a = new Announcement();
        a.setId(rs.getInt("id"));
        a.setTitle(rs.getString("title"));
        a.setContent(rs.getString("content"));
        a.setCreateTime(rs.getTimestamp("create_time"));
        a.setIsActive(rs.getInt("is_active"));
        return a;
    }
}
