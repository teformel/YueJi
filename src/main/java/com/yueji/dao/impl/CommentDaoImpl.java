package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.CommentDao;
import com.yueji.model.Comment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDaoImpl implements CommentDao {

    @Override
    public Comment findById(int id) {
        String sql = "SELECT * FROM t_comment WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Comment c = new Comment();
                    c.setId(rs.getInt("id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setNovelId(rs.getInt("novel_id"));
                    c.setContent(rs.getString("content"));
                    c.setReplyToId(rs.getInt("reply_to_id"));
                    c.setCreatedTime(rs.getTimestamp("created_time"));
                    c.setStatus(rs.getInt("status"));
                    c.setScore(rs.getInt("score"));
                    return c;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Comment> findByNovelId(int novelId) {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT c.*, u.username FROM t_comment c " +
                "JOIN t_user u ON c.user_id = u.id " +
                "WHERE c.novel_id = ? AND c.status = 1 ORDER BY c.created_time DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, novelId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Comment c = new Comment();
                    c.setId(rs.getInt("id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setNovelId(rs.getInt("novel_id"));
                    c.setContent(rs.getString("content"));
                    c.setReplyToId(rs.getInt("reply_to_id")); // although display might not need it yet
                    c.setCreatedTime(rs.getTimestamp("created_time"));
                    c.setStatus(rs.getInt("status"));
                    c.setUsername(rs.getString("username"));
                    c.setScore(rs.getInt("score"));
                    // Avatar not in t_user anymore based on requirement, removed.
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Comment> findByAuthorId(int authorId) {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT c.*, u.username, n.name as novel_name FROM t_comment c " +
                "JOIN t_user u ON c.user_id = u.id " +
                "JOIN t_novel n ON c.novel_id = n.id " +
                "WHERE n.author_id = ? AND c.status = 1 ORDER BY c.created_time DESC";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, authorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Comment c = new Comment();
                    c.setId(rs.getInt("id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setNovelId(rs.getInt("novel_id"));
                    c.setNovelName(rs.getString("novel_name"));
                    c.setContent(rs.getString("content"));
                    c.setCreatedTime(rs.getTimestamp("created_time"));
                    c.setStatus(rs.getInt("status"));
                    c.setUsername(rs.getString("username"));
                    c.setScore(rs.getInt("score"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void create(Comment comment) throws SQLException {
        String sql = "INSERT INTO t_comment (user_id, novel_id, content, reply_to_id, status, created_time, score) VALUES (?, ?, ?, ?, 1, CURRENT_TIMESTAMP, ?)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, comment.getUserId());
            stmt.setInt(2, comment.getNovelId());
            stmt.setString(3, comment.getContent());
            if (comment.getReplyToId() != null) stmt.setInt(4, comment.getReplyToId()); else stmt.setNull(4, Types.INTEGER);
            if (comment.getScore() != null) stmt.setInt(5, comment.getScore()); else stmt.setInt(5, 5);
            stmt.executeUpdate();
        }
    }

    @Override
    public void delete(int id) throws SQLException {
        String sql = "UPDATE t_comment SET status = 0 WHERE id = ?"; // Soft delete
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    @Override
    public double getAverageScore(int novelId) {
        String sql = "SELECT COALESCE(AVG(score), 0.0) FROM t_comment WHERE novel_id = ? AND status = 1";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, novelId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    double score = rs.getDouble(1);
                    System.out.println("DEBUG: Novel " + novelId + " average score: " + score);
                    return score;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}
