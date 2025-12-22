package com.yueji.dao;

import com.yueji.model.CoinLog;
import java.sql.SQLException;
import java.util.List;

public interface CoinLogDao {
    void create(CoinLog log) throws SQLException;
    List<CoinLog> findByUserId(int userId);
}
