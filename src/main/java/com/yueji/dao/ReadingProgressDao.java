package com.yueji.dao;

import java.sql.SQLException;

public interface ReadingProgressDao {
    void upsert(int userId, int novelId, int chapterId, int scrollY) throws SQLException;
    com.yueji.model.ReadingProgress findByUserAndNovel(int userId, int novelId);
}
