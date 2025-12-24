package com.yueji.service;

import com.yueji.model.Comment;
import com.yueji.model.User;

import java.util.List;

public interface CommentService {
    List<Comment> getCommentsByNovelId(int novelId);
    void addComment(Comment comment);
    boolean deleteComment(int commentId, User operator);
}
