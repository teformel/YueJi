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
}
