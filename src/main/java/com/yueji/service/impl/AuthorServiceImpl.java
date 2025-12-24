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

    @Override
    public List<Author> getPendingAuthors() {
        return authorDao.findByStatus(0);
    }

    @Override
    public void applyAuthor(int userId, String penname, String intro) throws Exception {
        Author existing = authorDao.findByUserId(userId);
        if (existing != null) {
            if (existing.getStatus() == 0) throw new Exception("Already applied, please wait for approval.");
            if (existing.getStatus() == 1) throw new Exception("You are already an author.");
            // If rejected (2), allow re-apply: update
            existing.setPenname(penname);
            existing.setIntroduction(intro);
            existing.setStatus(0);
            authorDao.update(existing);
        } else {
            Author author = new Author();
            author.setUserId(userId);
            author.setPenname(penname);
            author.setIntroduction(intro);
            author.setStatus(0); // Pending
            authorDao.create(author);
        }
    }

    @Override
    public void approveAuthor(int authorId) throws Exception {
        Author author = authorDao.findById(authorId);
        if (author == null) throw new Exception("Author not found");
        
        author.setStatus(1);
        authorDao.update(author);
        
        // Update User Role to Creator (2)
        com.yueji.service.UserService userService = BeanFactory.getBean(com.yueji.service.UserService.class);
        if (author.getUserId() != null) {
            userService.updateUserRole(author.getUserId(), 2);
        }
    }

    @Override
    public void rejectAuthor(int authorId) throws Exception {
        Author author = authorDao.findById(authorId);
        if (author == null) throw new Exception("Author not found");
        
        author.setStatus(2);
        authorDao.update(author);

        // Undo: Demote back to Reader (0) if they were Creator (2)
        com.yueji.service.UserService userService = BeanFactory.getBean(com.yueji.service.UserService.class);
        if (author.getUserId() != null) {
            com.yueji.model.User u = userService.getUserById(author.getUserId());
            if (u != null && u.getRole() == 2) {
                userService.updateUserRole(author.getUserId(), 0);
            }
        }
    }
}
