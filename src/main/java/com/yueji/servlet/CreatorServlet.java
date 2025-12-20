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

@WebServlet("/creator/*")
public class CreatorServlet extends HttpServlet {
    private final NovelDao novelDao = new NovelDao();
    private final AuthorDao authorDao = new AuthorDao();
    private final ChapterDao chapterDao = new ChapterDao();

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "请先登录", null);
            return;
        }
        User user = (User) session.getAttribute("user");
        Author author = authorDao.findByUserId(user.getId());
        if (author == null) {
            ResponseUtils.writeJson(resp, 403, "您尚未开通作者权限，请联系管理员", null);
            return;
        }
        req.setAttribute("boundAuthor", author);
        super.service(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        Author author = (Author) req.getAttribute("boundAuthor");

        if ("/novel/list".equals(path)) {
            ResponseUtils.writeJson(resp, 200, "My Novels", novelDao.findByAuthorId(author.getId()));
        } else if ("/chapter/list".equals(path)) {
            int novelId = Integer.parseInt(req.getParameter("novelId"));
            if (checkNovelOwnership(novelId, author.getId())) {
                ResponseUtils.writeJson(resp, 200, "Chapters", chapterDao.findByNovelId(novelId));
            } else {
                ResponseUtils.writeJson(resp, 403, "越权访问", null);
            }
        } else if ("/chapter/detail".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Chapter chapter = chapterDao.findById(id);
            if (chapter != null && checkNovelOwnership(chapter.getNovelId(), author.getId())) {
                ResponseUtils.writeJson(resp, 200, "Detail", chapter);
            } else {
                ResponseUtils.writeJson(resp, 403, "无权访问", null);
            }
        } else {
            resp.sendError(404);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        Author author = (Author) req.getAttribute("boundAuthor");

        try {
            if ("/novel/create".equals(path)) {
                handleCreateNovel(req, resp, author.getId());
            } else if ("/novel/update".equals(path)) {
                handleUpdateNovel(req, resp, author.getId());
            } else if ("/chapter/create".equals(path)) {
                handleCreateChapter(req, resp, author.getId());
            } else if ("/chapter/update".equals(path)) {
                handleUpdateChapter(req, resp, author.getId());
            } else if ("/chapter/delete".equals(path)) {
                handleDeleteChapter(req, resp, author.getId());
            } else {
                resp.sendError(404);
            }
        } catch (SQLException e) {
            ResponseUtils.writeJson(resp, 500, "数据库异常", e.getMessage());
        }
    }

    private void handleCreateNovel(HttpServletRequest req, HttpServletResponse resp, int authorId) throws SQLException, IOException {
        Novel novel = new Novel();
        novel.setTitle(req.getParameter("title"));
        novel.setAuthorId(authorId); // Force bond to current author
        novel.setCategory(req.getParameter("category"));
        novel.setIntro(req.getParameter("intro"));
        novel.setCoverUrl(req.getParameter("coverUrl"));
        novel.setIsFree(Boolean.parseBoolean(req.getParameter("isFree")));
        novelDao.create(novel);
        ResponseUtils.writeJson(resp, 200, "作品已发布", null);
    }

    private void handleUpdateNovel(HttpServletRequest req, HttpServletResponse resp, int authorId) throws SQLException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        if (!checkNovelOwnership(id, authorId)) {
            ResponseUtils.writeJson(resp, 403, "非法操作", null);
            return;
        }
        Novel novel = new Novel();
        novel.setId(id);
        novel.setTitle(req.getParameter("title"));
        novel.setAuthorId(authorId);
        novel.setCategory(req.getParameter("category"));
        novel.setIntro(req.getParameter("intro"));
        novel.setCoverUrl(req.getParameter("coverUrl"));
        novel.setIsFree(Boolean.parseBoolean(req.getParameter("isFree")));
        novelDao.update(novel);
        ResponseUtils.writeJson(resp, 200, "作品已更新", null);
    }

    private void handleCreateChapter(HttpServletRequest req, HttpServletResponse resp, int authorId) throws SQLException, IOException {
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        if (!checkNovelOwnership(novelId, authorId)) {
            ResponseUtils.writeJson(resp, 403, "非法操作", null);
            return;
        }
        Chapter chapter = new Chapter();
        chapter.setNovelId(novelId);
        chapter.setTitle(req.getParameter("title"));
        chapter.setContent(req.getParameter("content"));
        chapter.setWordCount(req.getParameter("content").length());
        chapter.setPrice(Integer.parseInt(req.getParameter("price")));
        chapter.setSortOrder(Integer.parseInt(req.getParameter("sortOrder")));
        chapterDao.create(chapter);
        ResponseUtils.writeJson(resp, 200, "章节已同步", null);
    }

    private void handleUpdateChapter(HttpServletRequest req, HttpServletResponse resp, int authorId) throws SQLException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Chapter old = chapterDao.findById(id);
        if (old == null || !checkNovelOwnership(old.getNovelId(), authorId)) {
            ResponseUtils.writeJson(resp, 403, "非法操作", null);
            return;
        }
        Chapter chapter = new Chapter();
        chapter.setId(id);
        chapter.setTitle(req.getParameter("title"));
        chapter.setContent(req.getParameter("content"));
        chapter.setWordCount(req.getParameter("content").length());
        chapter.setPrice(Integer.parseInt(req.getParameter("price")));
        chapter.setSortOrder(Integer.parseInt(req.getParameter("sortOrder")));
        chapterDao.update(chapter);
        ResponseUtils.writeJson(resp, 200, "章节已更新", null);
    }

    private void handleDeleteChapter(HttpServletRequest req, HttpServletResponse resp, int authorId) throws SQLException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Chapter old = chapterDao.findById(id);
        if (old == null || !checkNovelOwnership(old.getNovelId(), authorId)) {
            ResponseUtils.writeJson(resp, 403, "非法操作", null);
            return;
        }
        chapterDao.delete(id);
        ResponseUtils.writeJson(resp, 200, "章节已抹除", null);
    }

    private boolean checkNovelOwnership(int novelId, int authorId) {
        Novel novel = novelDao.findById(novelId);
        return novel != null && novel.getAuthorId() == authorId;
    }
}
