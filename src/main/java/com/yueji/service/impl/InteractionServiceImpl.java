package com.yueji.service.impl;

import com.yueji.common.BeanFactory;
import com.yueji.dao.CollectionDao;
import com.yueji.dao.CommentDao;
import com.yueji.model.Collection;
import com.yueji.model.Comment;
import com.yueji.service.InteractionService;

import java.util.List;

public class InteractionServiceImpl implements InteractionService {

    private final CommentDao commentDao;
    private final CollectionDao collectionDao;

    public InteractionServiceImpl() {
        this.commentDao = BeanFactory.getBean(CommentDao.class);
        this.collectionDao = BeanFactory.getBean(CollectionDao.class);
    }

    @Override
    public void addComment(Comment comment) throws Exception {
        commentDao.create(comment);
    }

    @Override
    public List<Comment> getNovelComments(int novelId) {
        List<Comment> list = commentDao.findByNovelId(novelId);
        // Link reading duration to comments
        for (Comment c : list) {
            com.yueji.model.ReadingProgress rp = readingProgressDao.findByUserAndNovel(c.getUserId(), c.getNovelId());
            if (rp != null) {
                c.setReadingDuration(rp.getTotalReadingTime());
            }
        }
        return list;
    }

    @Override
    public List<Comment> getAuthorReceivedComments(int authorId) {
        return commentDao.findByAuthorId(authorId);
    }

    @Override
    public double getNovelAverageScore(int novelId) {
        return commentDao.getAverageScore(novelId);
    }

    @Override
    public void deleteComment(int id) throws Exception {
        commentDao.delete(id);
    }

    @Override
    public void addToBookshelf(int userId, int novelId) throws Exception {
        collectionDao.add(userId, novelId);
    }

    @Override
    public void removeFromBookshelf(int userId, int novelId) throws Exception {
        collectionDao.remove(userId, novelId);
    }

    @Override
    public List<Collection> getUserBookshelf(int userId) {
        return collectionDao.findByUserId(userId);
    }

    @Override
    public boolean isInBookshelf(int userId, int novelId) {
        return collectionDao.isCollected(userId, novelId);
    }
    
    private final com.yueji.dao.ReadingProgressDao readingProgressDao = BeanFactory.getBean(com.yueji.dao.ReadingProgressDao.class);

    @Override
    public void updateReadingProgress(int userId, int novelId, int chapterId, int scrollY) throws Exception {
        readingProgressDao.upsert(userId, novelId, chapterId, scrollY);
    }

    @Override
    public void syncReadingTime(int userId, int novelId, int seconds) throws Exception {
        readingProgressDao.addReadingTime(userId, novelId, seconds);
    }

    @Override
    public com.yueji.model.ReadingProgress getReadingProgress(int userId, int novelId) {
        return readingProgressDao.findByUserAndNovel(userId, novelId);
    }
}
