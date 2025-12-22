package com.yueji.dao;

import com.yueji.model.ChapterPurchase;
import java.sql.SQLException;

public interface ChapterPurchaseDao {
    boolean isPurchased(int userId, int chapterId);
    void create(ChapterPurchase purchase) throws SQLException;
}
