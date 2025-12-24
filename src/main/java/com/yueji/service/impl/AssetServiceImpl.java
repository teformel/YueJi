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
        this.novelDao = BeanFactory.getBean(com.yueji.dao.NovelDao.class);
        this.authorDao = BeanFactory.getBean(com.yueji.dao.AuthorDao.class);
    }
    private final com.yueji.dao.NovelDao novelDao;
    private final com.yueji.dao.AuthorDao authorDao;

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
            log.setRemark("用户充值");
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
            log.setRemark("购买章节：" + chapter.getTitle());
            coinLogDao.create(log);

            // Author gets income
            com.yueji.model.Novel novel = novelDao.findById(chapter.getNovelId());
            if (novel != null) {
                com.yueji.model.Author author = authorDao.findById(novel.getAuthorId());
                if (author != null && author.getUserId() != null) {
                    User authorUser = userDao.findById(author.getUserId());
                    if (authorUser != null) {
                        authorUser.setCoinBalance(authorUser.getCoinBalance().add(price));
                        userDao.update(authorUser);
                        
                        CoinLog incomeLog = new CoinLog();
                        incomeLog.setUserId(authorUser.getId());
                        incomeLog.setType(2); // Author Income (稿费)
                        incomeLog.setAmount(price);
                        incomeLog.setRemark("稿费获得：" + chapter.getTitle());
                        coinLogDao.create(incomeLog);
                    }
                }
            }

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
