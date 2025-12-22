package com.yueji.dao;

import com.yueji.model.ReadingProgress;
import java.sql.SQLException;

public interface ReadingProgressDao {
    ReadingProgress findByUserAndNovel(int userId, int novelId);
    void upsert(int userId, int novelId, int chapterId, int scrollY) throws SQLException;
}
