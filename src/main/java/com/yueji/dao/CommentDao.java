package com.yueji.dao;

import com.yueji.model.Comment;
import java.sql.SQLException;
import java.util.List;

public interface CommentDao {
    List<Comment> findByNovelId(int novelId);
    Comment findById(int id);
    void create(Comment comment) throws SQLException;
    void delete(int id) throws SQLException;
}
