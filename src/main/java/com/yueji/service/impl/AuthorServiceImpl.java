package com.yueji.service.impl;

import com.yueji.common.BeanFactory;
import com.yueji.dao.AuthorDao;
import com.yueji.model.Author;
import com.yueji.service.AuthorService;

import java.util.List;

public class AuthorServiceImpl implements AuthorService {
    private final AuthorDao authorDao;

    public AuthorServiceImpl() {
        this.authorDao = BeanFactory.getBean(AuthorDao.class);
    }

    @Override
    public List<Author> getAllAuthors() {
        return authorDao.findAll();
    }

    @Override
    public Author getAuthorById(int id) {
        return authorDao.findById(id);
    }

    @Override
    public Author getAuthorByUserId(int userId) {
        return authorDao.findByUserId(userId);
    }

    @Override
    public void createAuthor(Author author) throws Exception {
        authorDao.create(author);
    }

    @Override
    public void updateAuthor(Author author) throws Exception {
        authorDao.update(author);
    }

    @Override
    public void deleteAuthor(int id) throws Exception {
        authorDao.delete(id);
    }
}
