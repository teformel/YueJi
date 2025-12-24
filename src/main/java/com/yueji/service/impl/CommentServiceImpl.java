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
    private final com.yueji.dao.ReadingProgressDao readingProgressDao;

    public CommentServiceImpl() {
        this.commentDao = BeanFactory.getBean(CommentDao.class);
        this.readingProgressDao = BeanFactory.getBean(com.yueji.dao.ReadingProgressDao.class);
    }

    @Override
    public List<Comment> getCommentsByNovelId(int novelId) {
        List<Comment> allComments = commentDao.findByNovelId(novelId);
        List<Comment> rootComments = new java.util.ArrayList<>();
        java.util.Map<Integer, Comment> commentMap = new java.util.HashMap<>();

        // First pass: put all comments into a map
        for (Comment c : allComments) {
            commentMap.put(c.getId(), c);
        }

        // Second pass: build the tree
        for (Comment c : allComments) {
            if (c.getReplyToId() == null || c.getReplyToId() == 0) {
                rootComments.add(c);
            } else {
                Comment parent = commentMap.get(c.getReplyToId());
                if (parent != null) {
                    parent.getReplies().add(c);
                } else {
                    // If parent is not found (maybe deleted/status=0), treat as root or skip
                    // Here we treat as root for safety if it belongs to this novel
                    rootComments.add(c);
                }
            }
        }
        return rootComments;
    }

    @Override
    public void addComment(Comment comment) {
        try {
            // Capture current reading duration as a snapshot
            com.yueji.model.ReadingProgress rp = readingProgressDao.findByUserAndNovel(comment.getUserId(), comment.getNovelId());
            if (rp != null) {
                comment.setReadingDuration(rp.getTotalReadingTime());
            } else {
                comment.setReadingDuration(0);
            }
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
