package com.yueji.servlet;

import com.yueji.common.ResponseUtils;
import com.yueji.dao.AuthorDao;
import com.yueji.dao.ChapterDao;
import com.yueji.dao.NovelDao;
import com.yueji.model.Author;
import com.yueji.model.Chapter;
import com.yueji.model.Novel;
import com.yueji.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private final NovelDao novelDao = new NovelDao();
    private final AuthorDao authorDao = new AuthorDao();
    private final ChapterDao chapterDao = new ChapterDao();
    private final com.yueji.dao.UserDao userDao = new com.yueji.dao.UserDao();

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check Admin Role
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "Not logged in", null);
            return;
        }
        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            ResponseUtils.writeJson(resp, 403, "Forbidden", null);
            return;
        }
        super.service(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/novel/list".equals(path)) {
            ResponseUtils.writeJson(resp, 200, "Novels", novelDao.findAll());
        } else if ("/author/list".equals(path)) {
            ResponseUtils.writeJson(resp, 200, "Authors", authorDao.findAll());
        } else if ("/user/list".equals(path)) {
            ResponseUtils.writeJson(resp, 200, "Users", userDao.findAll());
        } else if ("/chapter/list".equals(path)) {
            int novelId = Integer.parseInt(req.getParameter("novelId"));
            ResponseUtils.writeJson(resp, 200, "Chapters", chapterDao.findByNovelId(novelId));
        } else if ("/chapter/detail".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Chapter chapter = chapterDao.findById(id);
            if (chapter != null) {
                ResponseUtils.writeJson(resp, 200, "Chapter Detail", chapter);
            } else {
                ResponseUtils.writeJson(resp, 404, "Chapter not found", null);
            }
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        try {
            if ("/novel/create".equals(path)) {
                handleCreateNovel(req, resp);
            } else if ("/novel/update".equals(path)) {
                handleUpdateNovel(req, resp);
            } else if ("/novel/delete".equals(path)) {
                handleDeleteNovel(req, resp);
            } else if ("/author/create".equals(path)) {
                handleCreateAuthor(req, resp);
            } else if ("/author/update".equals(path)) {
                handleUpdateAuthor(req, resp);
            } else if ("/author/delete".equals(path)) {
                handleDeleteAuthor(req, resp);
            } else if ("/chapter/create".equals(path)) {
                handleCreateChapter(req, resp);
            } else if ("/chapter/update".equals(path)) {
                handleUpdateChapter(req, resp);
            } else if ("/chapter/delete".equals(path)) {
                handleDeleteChapter(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Database Error", e.getMessage());
        }
    }

    private void handleCreateNovel(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        Novel novel = new Novel();
        novel.setTitle(req.getParameter("title"));
        novel.setAuthorId(Integer.parseInt(req.getParameter("authorId")));
        novel.setCategory(req.getParameter("category"));
        novel.setIntro(req.getParameter("intro"));
        novel.setCoverUrl(req.getParameter("coverUrl"));
        novel.setIsFree(Boolean.parseBoolean(req.getParameter("isFree")));
        novelDao.create(novel);
        ResponseUtils.writeJson(resp, 200, "Novel created", null);
    }

    private void handleUpdateNovel(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        Novel novel = new Novel();
        novel.setId(Integer.parseInt(req.getParameter("id")));
        novel.setTitle(req.getParameter("title"));
        novel.setAuthorId(Integer.parseInt(req.getParameter("authorId")));
        novel.setCategory(req.getParameter("category"));
        novel.setIntro(req.getParameter("intro"));
        novel.setCoverUrl(req.getParameter("coverUrl"));
        novel.setIsFree(Boolean.parseBoolean(req.getParameter("isFree")));
        novelDao.update(novel);
        ResponseUtils.writeJson(resp, 200, "Novel updated", null);
    }

    private void handleDeleteNovel(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        int id = Integer.parseInt(req.getParameter("id"));
        novelDao.delete(id);
        ResponseUtils.writeJson(resp, 200, "Novel deleted", null);
    }

    private void handleCreateAuthor(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        Author author = new Author();
        author.setName(req.getParameter("name"));
        author.setBio(req.getParameter("bio"));
        String userIdStr = req.getParameter("userId");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            author.setUserId(Integer.parseInt(userIdStr));
        }
        authorDao.create(author);
        ResponseUtils.writeJson(resp, 200, "Author created", null);
    }

    private void handleUpdateAuthor(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        Author author = new Author();
        author.setId(Integer.parseInt(req.getParameter("id")));
        author.setName(req.getParameter("name"));
        author.setBio(req.getParameter("bio"));
        String userIdStr = req.getParameter("userId");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            author.setUserId(Integer.parseInt(userIdStr));
        }
        authorDao.update(author);
        ResponseUtils.writeJson(resp, 200, "Author updated", null);
    }

    private void handleDeleteAuthor(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        int id = Integer.parseInt(req.getParameter("id"));
        authorDao.delete(id);
        ResponseUtils.writeJson(resp, 200, "Author deleted", null);
    }

    private void handleCreateChapter(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        Chapter chapter = new Chapter();
        chapter.setNovelId(Integer.parseInt(req.getParameter("novelId")));
        chapter.setTitle(req.getParameter("title"));
        chapter.setContent(req.getParameter("content"));
        chapter.setWordCount(req.getParameter("content").length());
        chapter.setPrice(Integer.parseInt(req.getParameter("price")));
        chapter.setSortOrder(Integer.parseInt(req.getParameter("sortOrder")));
        chapterDao.create(chapter);
        ResponseUtils.writeJson(resp, 200, "Chapter created", null);
    }

    private void handleUpdateChapter(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        Chapter chapter = new Chapter();
        chapter.setId(Integer.parseInt(req.getParameter("id")));
        chapter.setTitle(req.getParameter("title"));
        chapter.setContent(req.getParameter("content"));
        chapter.setWordCount(req.getParameter("content").length());
        chapter.setPrice(Integer.parseInt(req.getParameter("price")));
        chapter.setSortOrder(Integer.parseInt(req.getParameter("sortOrder")));
        chapterDao.update(chapter);
        ResponseUtils.writeJson(resp, 200, "Chapter updated", null);
    }

    private void handleDeleteChapter(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        int id = Integer.parseInt(req.getParameter("id"));
        chapterDao.delete(id);
        ResponseUtils.writeJson(resp, 200, "Chapter deleted", null);
    }
}
