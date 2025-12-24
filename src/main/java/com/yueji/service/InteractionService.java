package com.yueji.service;

import com.yueji.model.Comment;
import com.yueji.model.Collection;
import java.util.List;

public interface InteractionService {
    void addComment(Comment comment) throws Exception;
    void deleteComment(int id) throws Exception;
    List<Comment> getNovelComments(int novelId);
    List<Comment> getAuthorReceivedComments(int authorId);
    double getNovelAverageScore(int novelId);
    
    void addToBookshelf(int userId, int novelId) throws Exception;
    void removeFromBookshelf(int userId, int novelId) throws Exception;
    List<Collection> getUserBookshelf(int userId);
    boolean isInBookshelf(int userId, int novelId);
    
    // Reading Progress
    void updateReadingProgress(int userId, int novelId, int chapterId, int scrollY) throws Exception;
    void syncReadingTime(int userId, int novelId, int seconds) throws Exception;
    com.yueji.model.ReadingProgress getReadingProgress(int userId, int novelId);

    // Follow System (FR-C-003)
    void followAuthor(int userId, int authorId) throws Exception;
    void unfollowAuthor(int userId, int authorId) throws Exception;
    boolean isFollowingAuthor(int userId, int authorId);
    List<com.yueji.model.Follow> getUserFollowList(int userId);
}
