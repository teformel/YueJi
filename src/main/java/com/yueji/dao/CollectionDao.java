package com.yueji.dao;

import com.yueji.model.Collection;
import java.sql.SQLException;
import java.util.List;

public interface CollectionDao {
    List<Collection> findByUserId(int userId);
    void add(int userId, int novelId) throws SQLException;
    void remove(int userId, int novelId) throws SQLException;
    boolean isCollected(int userId, int novelId);
}
