package com.yueji.service.impl;

import com.yueji.common.BeanFactory;
import com.yueji.common.DbUtils;
import com.yueji.dao.ChapterPurchaseDao;
import com.yueji.dao.CoinLogDao;
import com.yueji.dao.UserDao;
import com.yueji.dao.ChapterDao;
import com.yueji.model.ChapterPurchase;
import com.yueji.model.CoinLog;
import com.yueji.model.User;
import com.yueji.model.Chapter;
import com.yueji.service.AssetService;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

public class AssetServiceImpl implements AssetService {

    private final UserDao userDao;
    private final CoinLogDao coinLogDao;
    private final ChapterPurchaseDao chapterPurchaseDao;
    private final ChapterDao chapterDao;

    public AssetServiceImpl() {
        this.userDao = BeanFactory.getBean(UserDao.class);
        this.coinLogDao = BeanFactory.getBean(CoinLogDao.class);
        this.chapterPurchaseDao = BeanFactory.getBean(ChapterPurchaseDao.class);
        this.chapterDao = BeanFactory.getBean(ChapterDao.class);
    }

    @Override
    public void recharge(int userId, BigDecimal amount) throws Exception {
        try {
            DbUtils.beginTransaction();
            
            User user = userDao.findById(userId);
            if (user == null) throw new Exception("User not found");
            
            user.setCoinBalance(user.getCoinBalance().add(amount));
            userDao.update(user);
            
            CoinLog log = new CoinLog();
            log.setUserId(userId);
            log.setType(0); // Recharge
            log.setAmount(amount);
            log.setRemark("User Recharge");
            coinLogDao.create(log);
            
            DbUtils.commitTransaction();
        } catch (Exception e) {
            DbUtils.rollbackTransaction();
            throw e;
        }
    }

    @Override
    public boolean purchaseChapter(int userId, int chapterId) throws Exception {
        try {
            DbUtils.beginTransaction();

            if (chapterPurchaseDao.isPurchased(userId, chapterId)) {
                DbUtils.commitTransaction(); // Nothing changed but commit to close
                return true;
            }

            Chapter chapter = chapterDao.findById(chapterId);
            if (chapter == null) {
                DbUtils.rollbackTransaction();
                return false;
            }
            BigDecimal price = chapter.getPrice();

            User user = userDao.findById(userId);
            if (user == null || user.getCoinBalance().compareTo(price) < 0) {
                DbUtils.rollbackTransaction();
                return false;
            }

            user.setCoinBalance(user.getCoinBalance().subtract(price));
            userDao.update(user);

            ChapterPurchase purchase = new ChapterPurchase();
            purchase.setUserId(userId);
            purchase.setChapterId(chapterId);
            purchase.setPrice(price);
            chapterPurchaseDao.create(purchase);

            CoinLog log = new CoinLog();
            log.setUserId(userId);
            log.setType(1); // Spend
            log.setAmount(price);
            log.setRemark("Purchase Chapter: " + chapter.getTitle());
            coinLogDao.create(log);

            DbUtils.commitTransaction();
            return true;
        } catch (Exception e) {
            DbUtils.rollbackTransaction();
            throw e;
        }
    }

    @Override
    public List<CoinLog> getTransactionHistory(int userId) {
        return coinLogDao.findByUserId(userId);
    }
}
