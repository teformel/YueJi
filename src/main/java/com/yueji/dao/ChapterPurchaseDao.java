package com.yueji.dao;

import com.yueji.model.ChapterPurchase;
import java.sql.SQLException;

import java.util.List;

public interface ChapterPurchaseDao {
    boolean isPurchased(int userId, int chapterId);
    List<Integer> getPurchasedChapterIds(int userId, int novelId);
    void create(ChapterPurchase purchase) throws SQLException;
}
