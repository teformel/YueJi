package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.FollowDao;
import com.yueji.model.Follow;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FollowDaoImpl implements FollowDao {

    @Override
    public void follow(int userId, int authorId) {
        String sql = "INSERT INTO t_follow (user_id, author_id) VALUES (?, ?) ON CONFLICT DO NOTHING";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, authorId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void unfollow(int userId, int authorId) {
        String sql = "DELETE FROM t_follow WHERE user_id = ? AND author_id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, authorId);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public boolean isFollowing(int userId, int authorId) {
        String sql = "SELECT 1 FROM t_follow WHERE user_id = ? AND author_id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, authorId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<Follow> getFollowedAuthorsByUserId(int userId) {
        String sql = "SELECT f.*, a.penname as author_penname, u.realname as author_name " +
                     "FROM t_follow f " +
                     "JOIN t_author a ON f.author_id = a.id " +
                     "LEFT JOIN t_user u ON a.user_id = u.id " +
                     "WHERE f.user_id = ? ORDER BY f.created_time DESC";
        List<Follow> list = new ArrayList<>();
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Follow f = new Follow();
                    f.setId(rs.getInt("id"));
                    f.setUserId(rs.getInt("user_id"));
                    f.setAuthorId(rs.getInt("author_id"));
                    f.setCreatedTime(rs.getTimestamp("created_time"));
                    f.setAuthorPenname(rs.getString("author_penname"));
                    f.setAuthorName(rs.getString("author_name"));
                    list.add(f);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }
}
