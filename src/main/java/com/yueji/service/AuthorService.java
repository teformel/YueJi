package com.yueji.service;

import com.yueji.model.Author;
import java.util.List;

public interface AuthorService {
    List<Author> getAllAuthors();
    Author getAuthorById(int id);
    Author getAuthorByUserId(int userId);
    void createAuthor(Author author) throws Exception;
    void updateAuthor(Author author) throws Exception;
    void deleteAuthor(int id) throws Exception;
    
    // Application Flow
    List<Author> getPendingAuthors();
    void applyAuthor(int userId, String penname, String intro) throws Exception;
    void approveAuthor(int authorId) throws Exception;
    void rejectAuthor(int authorId) throws Exception;
}
