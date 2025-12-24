package com.yueji.common;

import com.yueji.dao.*;
import com.yueji.dao.impl.*;
import com.yueji.service.*;
import com.yueji.service.impl.*;

import java.util.HashMap;
import java.util.Map;

public class BeanFactory {
    private static final Map<Class<?>, Object> beans = new HashMap<>();

    static {
        // Initialize DAOs
        beans.put(UserDao.class, new UserDaoImpl());
        beans.put(NovelDao.class, new NovelDaoImpl());
        beans.put(ChapterDao.class, new ChapterDaoImpl());
        beans.put(AuthorDao.class, new AuthorDaoImpl());
        beans.put(CategoryDao.class, new CategoryDaoImpl());
        beans.put(CommentDao.class, new CommentDaoImpl());
        beans.put(CollectionDao.class, new CollectionDaoImpl());
        beans.put(CoinLogDao.class, new CoinLogDaoImpl());
        beans.put(ChapterPurchaseDao.class, new ChapterPurchaseDaoImpl());
        beans.put(ReadingProgressDao.class, new ReadingProgressDaoImpl());

        // Initialize Services (Inject DAOs)
        beans.put(UserService.class, new UserServiceImpl());
        beans.put(NovelService.class, new NovelServiceImpl());
        beans.put(InteractionService.class, new InteractionServiceImpl());
        beans.put(AssetService.class, new AssetServiceImpl());
        beans.put(AuthorService.class, new AuthorServiceImpl());
        beans.put(CommentService.class, new CommentServiceImpl());
    }


    @SuppressWarnings("unchecked")
    public static <T> T getBean(Class<T> clazz) {
        return (T) beans.get(clazz);
    }
}
