package com.yueji.service;

import com.yueji.model.CoinLog;
import java.math.BigDecimal;
import java.util.List;

public interface AssetService {
    void recharge(int userId, BigDecimal amount) throws Exception;
    boolean purchaseChapter(int userId, int chapterId) throws Exception; // Helper only, logic might be in NovelService? 
    // Actually, purchase needs ACID. It's better here.
    List<CoinLog> getTransactionHistory(int userId);
}
