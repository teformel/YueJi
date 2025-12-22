package com.yueji.dao.impl;

import com.yueji.common.DbUtils;
import com.yueji.dao.CommentDao;
import com.yueji.model.Comment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDaoImpl implements CommentDao {

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
    public void create(Comment comment) throws SQLException {
        String sql = "INSERT INTO t_comment (user_id, novel_id, content, reply_to_id, status, created_time) VALUES (?, ?, ?, ?, 1, CURRENT_TIMESTAMP)";
        try (Connection conn = DbUtils.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, comment.getUserId());
            stmt.setInt(2, comment.getNovelId());
            stmt.setString(3, comment.getContent());
            if (comment.getReplyToId() != null) stmt.setInt(4, comment.getReplyToId()); else stmt.setNull(4, Types.INTEGER);
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
}
