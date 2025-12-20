package com.yueji.dao;

import com.yueji.common.DbUtils;
import com.yueji.model.Comment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDao {

    public List<Comment> findByNovelId(int novelId) {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT c.*, u.username, u.avatar FROM sys_comment c " +
                "JOIN sys_user u ON c.user_id = u.id " +
                "WHERE c.novel_id = ? ORDER BY c.created_at DESC";
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
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setUsername(rs.getString("username"));
                    c.setAvatar(rs.getString("avatar"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void create(Comment comment) throws SQLException {
        String sql = "INSERT INTO sys_comment (user_id, novel_id, content, created_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, comment.getUserId());
            stmt.setInt(2, comment.getNovelId());
            stmt.setString(3, comment.getContent());
            stmt.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM sys_comment WHERE id = ?";
        try (Connection conn = DbUtils.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }
}
