package com.yueji.service;

import com.yueji.model.Comment;
import com.yueji.model.Collection;
import java.util.List;

public interface InteractionService {
    void addComment(Comment comment) throws Exception;
    List<Comment> getNovelComments(int novelId);
    
    void addToBookshelf(int userId, int novelId) throws Exception;
    void removeFromBookshelf(int userId, int novelId) throws Exception;
    List<Collection> getUserBookshelf(int userId);
    boolean isInBookshelf(int userId, int novelId);
    
    // Reading Progress
    void updateReadingProgress(int userId, int novelId, int chapterId, int scrollY) throws Exception;
    com.yueji.model.ReadingProgress getReadingProgress(int userId, int novelId);

}
