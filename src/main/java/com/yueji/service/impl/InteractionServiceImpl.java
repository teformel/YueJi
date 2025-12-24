package com.yueji.service.impl;

import com.yueji.common.BeanFactory;
import com.yueji.dao.CollectionDao;
import com.yueji.dao.CommentDao;
import com.yueji.model.Collection;
import com.yueji.model.Comment;
import com.yueji.service.InteractionService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        // 1. Fetch all active comments for this novel
        List<Comment> all = commentDao.findByNovelId(novelId);
        if (all == null || all.isEmpty()) return new ArrayList<>();

        Map<Integer, Comment> map = new HashMap<>();
        List<Comment> roots = new ArrayList<>();

        // 2. Pre-process: Map everything and enrich with reading metadata
        for (Comment c : all) {
            map.put(c.getId(), c);
            com.yueji.model.ReadingProgress rp = readingProgressDao.findByUserAndNovel(c.getUserId(), c.getNovelId());
            if (rp != null) {
                c.setReadingDuration(rp.getTotalReadingTime());
            }
        }

        // 3. Assemble tree: Separate roots from replies
        for (Comment c : all) {
            Integer pId = c.getReplyToId();
            if (pId == null || pId == 0) {
                // This is a top-level book review
                roots.add(c);
            } else {
                // This is a reply to another comment
                Comment parent = map.get(pId);
                if (parent != null) {
                    parent.getReplies().add(c);
                } else {
                    // ORPHAN: The parent comment might be deleted or from another novel
                    // WE DO NOT ADD TO ROOTS. This prevents "flattening" of replies.
                }
            }
        }
        return roots;
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

    private final com.yueji.dao.FollowDao followDao = BeanFactory.getBean(com.yueji.dao.FollowDao.class);

    @Override
    public void followAuthor(int userId, int authorId) throws Exception {
        followDao.follow(userId, authorId);
    }

    @Override
    public void unfollowAuthor(int userId, int authorId) throws Exception {
        followDao.unfollow(userId, authorId);
    }

    @Override
    public boolean isFollowingAuthor(int userId, int authorId) {
        return followDao.isFollowing(userId, authorId);
    }

    @Override
    public List<com.yueji.model.Follow> getUserFollowList(int userId) {
        return followDao.getFollowedAuthorsByUserId(userId);
    }
}
