package com.yueji.service.impl;

import com.yueji.common.BeanFactory;
import com.yueji.dao.*;
import com.yueji.model.Category;
import com.yueji.model.Chapter;
import com.yueji.model.Novel;
import com.yueji.service.NovelService;

import java.util.List;

public class NovelServiceImpl implements NovelService {

    private final NovelDao novelDao;
    private final ChapterDao chapterDao;
    private final CategoryDao categoryDao;
    private final ChapterPurchaseDao chapterPurchaseDao;

    public NovelServiceImpl() {
        this.novelDao = BeanFactory.getBean(NovelDao.class);
        this.chapterDao = BeanFactory.getBean(ChapterDao.class);
        this.categoryDao = BeanFactory.getBean(CategoryDao.class);
        this.chapterPurchaseDao = BeanFactory.getBean(ChapterPurchaseDao.class);
    }

    @Override
    public List<Novel> getRecommendedNovels() {
        return novelDao.findAll(); // Simplified recommendation
    }

    @Override
    public List<Novel> searchNovels(String keyword, Integer categoryId) {
        return novelDao.search(keyword, categoryId);
    }

    @Override
    public Novel getNovelDetails(int id) {
        return novelDao.findById(id);
    }

    @Override
    public List<Chapter> getChapterList(int novelId) {
        return chapterDao.findByNovelId(novelId);
    }

    @Override
    public Chapter getChapterContent(int userId, int chapterId) {
        Chapter chapter = chapterDao.findById(chapterId);
        if (chapter == null) return null;

        // Check permission if paid
        if (chapter.getIsPaid() == 1) {
            // Check if purchased
            boolean purchased = chapterPurchaseDao.isPurchased(userId, chapterId);
            if (!purchased) {
                // Remove content for unauthorized access if implementation requires strict security
                // Or throw exception. For now, we return empty content or handle in Controller
                chapter.setContent("此章节为付费章节，请购买后阅读。");
            }
        }
        return chapter;
    }

    @Override
    public List<Category> getAllCategories() {
        return categoryDao.findAll();
    }

    @Override
    public void createNovel(Novel novel) throws Exception {
        if (novel.getStatus() == null) novel.setStatus(1); // Default to Serializing
        if (novel.getTotalChapters() == null) novel.setTotalChapters(0); // Default to 0
        novelDao.create(novel);
    }

    @Override
    public void updateNovel(Novel novel) throws Exception {
        novelDao.update(novel);
    }

    @Override
    public void deleteNovel(int id) throws Exception {
        novelDao.delete(id);
    }

    @Override
    public void addChapter(Chapter chapter) throws Exception {
        chapterDao.create(chapter);
    }

    @Override
    public void updateChapter(Chapter chapter) throws Exception {
        chapterDao.update(chapter);
    }

    @Override
    public void deleteChapter(int id) throws Exception {
        chapterDao.delete(id);
    }

    @Override
    public Chapter getChapterById(int id) {
        return chapterDao.findById(id);
    }

    @Override
    public long getNovelCount() {
        return novelDao.count();
    }

    @Override
    public void incrementViewCount(int novelId) throws java.sql.SQLException {
        novelDao.incrementViewCount(novelId);
    }
}
