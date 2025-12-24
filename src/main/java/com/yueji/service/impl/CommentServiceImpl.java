package com.yueji.service.impl;

import com.yueji.common.BeanFactory;
import com.yueji.dao.CommentDao;
import com.yueji.model.Comment;
import com.yueji.model.User;
import com.yueji.service.CommentService;

import java.sql.SQLException;
import java.util.List;

public class CommentServiceImpl implements CommentService {
    private final CommentDao commentDao;

    public CommentServiceImpl() {
        this.commentDao = BeanFactory.getBean(CommentDao.class);
    }

    @Override
    public List<Comment> getCommentsByNovelId(int novelId) {
        return commentDao.findByNovelId(novelId);
    }

    @Override
    public void addComment(Comment comment) {
        try {
            commentDao.create(comment);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Add comment failed");
        }
    }

    @Override
    public boolean deleteComment(int commentId, User operator) {
        Comment comment = commentDao.findById(commentId);
        if (comment == null) {
            return false;
        }

        // Logic: Admin (role=1) OR Owner (userId == operator.id)
        if (operator.getRole() == 1 || operator.getId().equals(comment.getUserId())) {
            try {
                commentDao.delete(commentId);
                return true;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}
