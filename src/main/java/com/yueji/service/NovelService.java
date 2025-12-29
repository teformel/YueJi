package com.yueji.service;

import com.yueji.model.Novel;
import com.yueji.model.Chapter;
import com.yueji.model.Category;
import java.util.List;

public interface NovelService {
    List<Novel> getRecommendedNovels(); // For homepage

    List<Novel> searchNovels(String keyword, Integer categoryId);

    Novel getNovelDetails(int id);

    List<Chapter> getChapterList(int novelId); // Without content

    Chapter getChapterContent(int userId, int chapterId); // With content and permission check

    List<Category> getAllCategories();

    // Admin functions
    void createNovel(Novel novel) throws Exception;

    void updateNovel(Novel novel) throws Exception;

    void updateNovelStatus(int id, int status) throws Exception; // New method

    void deleteNovel(int id) throws Exception;

    List<Novel> adminSearchNovels(String keyword, Integer categoryId); // New method

    void addChapter(Chapter chapter) throws Exception;

    void updateChapter(Chapter chapter) throws Exception;

    void deleteChapter(int id) throws Exception;

    Chapter getChapterById(int id); // For admin detail/update

    long getNovelCount();

    void incrementViewCount(int novelId) throws java.sql.SQLException;
}
