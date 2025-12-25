package com.yueji.service.impl;

import com.yueji.common.BeanFactory;
import com.yueji.dao.UserDao;
import com.yueji.dao.CoinLogDao;
import com.yueji.model.User;
import com.yueji.service.UserService;

import java.math.BigDecimal;
import java.sql.SQLException;

public class UserServiceImpl implements UserService {

    private final UserDao userDao;
    private final CoinLogDao coinLogDao;
    private final com.yueji.dao.ReadingProgressDao readingProgressDao;

    public UserServiceImpl() {
        this.userDao = BeanFactory.getBean(UserDao.class);
        this.coinLogDao = BeanFactory.getBean(CoinLogDao.class);
        this.readingProgressDao = BeanFactory.getBean(com.yueji.dao.ReadingProgressDao.class);
    }

    private void populateLevelInfo(User user) {
        if (user == null) return;
        try {
            // 1. 获取统计数据
            BigDecimal totalRecharge = coinLogDao.getTotalRecharge(user.getId());
            long totalReadingSeconds = readingProgressDao.getTotalReadingTime(user.getId());
            int readNovels = readingProgressDao.getReadNovelCount(user.getId());

            // 2. 计算经验值
            // 总经验 = (累计充值 * 1) + (阅读时长(分) * 2) + (阅读小说数 * 50)
            int expFromRecharge = totalRecharge.intValue();
            int expFromReading = (int) (totalReadingSeconds / 60) * 2;
            int expFromNovels = readNovels * 50;
            
            int totalExp = expFromRecharge + expFromReading + expFromNovels;

            // 3. 计算等级
            // 等级 = floor(sqrt(总经验) / 10) + 1
            // 例如: 0 -> 1, 100 -> 2, 400 -> 3
            int level = (int) (Math.sqrt(totalExp) / 10) + 1;
            if (level > 10) level = 10; // Cap at 10

            // 4. 计算下一级所需经验
            // 下一级 = 当前等级 + 1
            // 下一级所需经验 = ((当前等级) * 10)^2
            // 例如: 当前等级 1, 目标等级 2. 所需经验 = (1*10)^2 = 100.
            // 例如: 当前等级 2, 目标等级 3. 所需经验 = (2*10)^2 = 400.
            int targetLevel = level; // 逻辑: 达到 sqrt/10 + 1.
            // 举例: exp 99. sqrt(99)=9.9. /10 = 0.99. +1 = 1. 等级 1.
            // 下一级边界是 sqrt(exp)/10 = 1 => sqrt(exp)=10 => exp=100.
            
            int nextLevelBoundary = (int) Math.pow(targetLevel * 10, 2);

            user.setLevel(level);
            user.setCurrentExp(totalExp);
            user.setNextLevelExp(nextLevelBoundary);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public User login(String username, String password) {
        User user = userDao.findByUsername(username);
        String hashedInput = com.yueji.common.AuthUtils.md5(password);
        if (user != null && user.getPassword().equalsIgnoreCase(hashedInput)) {
            if (user.getStatus() == 0) return null; // Disabled
            
            populateLevelInfo(user); // 填充等级信息
            return user;
        }
        return null;
    }

    @Override
    public void register(User user) throws Exception {
        if (userDao.findByUsername(user.getUsername()) != null) {
            throw new Exception("用户名已存在");
        }
        user.setCoinBalance(BigDecimal.ZERO);
        user.setRole(0); 
        user.setStatus(1); 
        
        user.setPassword(com.yueji.common.AuthUtils.md5(user.getPassword()));
        
        userDao.create(user);
    }

    @Override
    public void updateProfile(User user) throws Exception {
        userDao.update(user);
    }

    @Override
    public void updatePassword(int userId, String oldPwd, String newPwd) throws Exception {
        User user = userDao.findById(userId);
        String hashedOld = com.yueji.common.AuthUtils.md5(oldPwd);
        if (user != null && user.getPassword().equalsIgnoreCase(hashedOld)) {
            userDao.updatePassword(userId, com.yueji.common.AuthUtils.md5(newPwd));
        } else {
            throw new Exception("原密码错误");
        }
    }

    @Override
    public User getUserById(int id) {
        User user = userDao.findById(id);
        populateLevelInfo(user);
        return user;
    }

    @Override
    public java.util.List<User> getAllUsers() {
        return userDao.findAll();
    }

    @Override
    public void updateUserStatus(int userId, int status) throws Exception {
        User user = userDao.findById(userId);
        if (user != null) {
            user.setStatus(status);
            userDao.update(user);
        }
    }

    @Override
    public void updateUserRole(int userId, int role) throws Exception {
        User user = userDao.findById(userId);
        if (user != null) {
            user.setRole(role);
            userDao.update(user);
        }
    }

    @Override
    public long getUserCount() {
        return userDao.count();
    }

    @Override
    public void updateLastLoginTime(int userId) {
        try {
            userDao.updateLastLoginTime(userId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public long getActiveUserCountToday() {
        return userDao.countActiveUsersToday();
    }
}
