package com.yueji.servlet;

import com.yueji.common.BeanFactory;
import com.yueji.common.ResponseUtils;
import com.yueji.model.Author;
import com.yueji.model.Chapter;
import com.yueji.model.Novel;
import com.yueji.model.User;
import com.yueji.service.AuthorService;
import com.yueji.service.NovelService;
import com.yueji.service.InteractionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/creator/*")
public class CreatorServlet extends HttpServlet {
    private final NovelService novelService;
    private final AuthorService authorService;

    public CreatorServlet() {
        this.novelService = BeanFactory.getBean(NovelService.class);
        this.authorService = BeanFactory.getBean(AuthorService.class);
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "请先登录", null);
            return;
        }
        User user = (User) session.getAttribute("user");
        Author author = authorService.getAuthorByUserId(user.getId());
        
        // [FIX] Auto-sync admin as author if record missing
        if (author == null && (user.getRole() == 1 || "admin".equals(user.getUsername()))) {
            author = new Author();
            author.setUserId(user.getId());
            author.setPenname(user.getRealname() != null ? user.getRealname() : user.getUsername());
            author.setIntroduction("系统管理员 (自动授权)");
            author.setStatus(1); // Approved
            try {
                authorService.createAuthor(author);
                // Re-fetch to get generated ID and full data
                author = authorService.getAuthorByUserId(user.getId());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

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
            try {
                com.yueji.dao.NovelDao novelDao = BeanFactory.getBean(com.yueji.dao.NovelDao.class);
                ResponseUtils.writeJson(resp, 200, "My Novels", novelDao.findByAuthorId(author.getId()));
            } catch (Exception e) {
                 ResponseUtils.writeJson(resp, 500, "Error", null);
            }
        } else if ("/chapter/list".equals(path)) {
            int novelId = Integer.parseInt(req.getParameter("novelId"));
            if (checkNovelOwnership(novelId, author.getId())) {
                ResponseUtils.writeJson(resp, 200, "Chapters", novelService.getChapterList(novelId));
            } else {
                ResponseUtils.writeJson(resp, 403, "越权访问", null);
            }
        } else if ("/chapter/detail".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Chapter chapter = novelService.getChapterById(id);
            if (chapter != null && checkNovelOwnership(chapter.getNovelId(), author.getId())) {
                ResponseUtils.writeJson(resp, 200, "Detail", chapter);
            } else {
                ResponseUtils.writeJson(resp, 403, "无权访问", null);
            }
        } else if ("/stats".equals(path)) {
            User user = (User) req.getSession().getAttribute("user");
            com.yueji.dao.CoinLogDao coinLogDao = BeanFactory.getBean(com.yueji.dao.CoinLogDao.class);
            java.util.Map<String, Object> stats = new java.util.HashMap<>();
            stats.put("totalIncome", coinLogDao.sumAmountByType(user.getId(), 2));
            ResponseUtils.writeJson(resp, 200, "Stats", stats);
        } else if ("/comment/list".equals(path)) {
             InteractionService interactionService = BeanFactory.getBean(InteractionService.class);
             ResponseUtils.writeJson(resp, 200, "Comments", interactionService.getAuthorReceivedComments(author.getId()));
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
            } else if ("/novel/delete".equals(path)) {
                handleDeleteNovel(req, resp, author.getId());
            } else if ("/chapter/create".equals(path)) {
                handleCreateChapter(req, resp, author.getId());
            } else if ("/chapter/update".equals(path)) {
                handleUpdateChapter(req, resp, author.getId());
            } else if ("/chapter/delete".equals(path)) {
                handleDeleteChapter(req, resp, author.getId());
            } else {
                resp.sendError(404);
            }
        } catch (Exception e) {
            ResponseUtils.writeJson(resp, 500, "数据库异常", e.getMessage());
        }
    }

    private void handleCreateNovel(HttpServletRequest req, HttpServletResponse resp, int authorId) throws Exception {
        Novel novel = new Novel();
        novel.setName(req.getParameter("title"));
        novel.setAuthorId(authorId);
        String catIdStr = req.getParameter("categoryId");
        if (catIdStr != null) novel.setCategoryId(Integer.parseInt(catIdStr));
        novel.setDescription(req.getParameter("intro"));
        String cover = req.getParameter("coverUrl");
        if (cover == null || cover.trim().isEmpty()) {
            cover = "/static/images/covers/default.jpg";
        }
        novel.setCover(cover);
        novelService.createNovel(novel);
        ResponseUtils.writeJson(resp, 200, "作品已发布", null);
    }

    private void handleUpdateNovel(HttpServletRequest req, HttpServletResponse resp, int authorId) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        if (!checkNovelOwnership(id, authorId)) {
            ResponseUtils.writeJson(resp, 403, "非法操作", null);
            return;
        }
        Novel novel = novelService.getNovelDetails(id);
        if (novel == null) {
             ResponseUtils.writeJson(resp, 404, "作品不存在", null);
             return;
        }
        novel.setName(req.getParameter("title"));
        String catIdStr = req.getParameter("categoryId");
        if (catIdStr != null) novel.setCategoryId(Integer.parseInt(catIdStr));
        novel.setDescription(req.getParameter("intro"));
        novel.setCover(req.getParameter("coverUrl"));
        
        String statusStr = req.getParameter("status");
        if (statusStr != null) novel.setStatus(Integer.parseInt(statusStr));
        
        novelService.updateNovel(novel);
        ResponseUtils.writeJson(resp, 200, "作品已更新", null);
    }

    private void handleDeleteNovel(HttpServletRequest req, HttpServletResponse resp, int authorId) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        if (!checkNovelOwnership(id, authorId)) {
            ResponseUtils.writeJson(resp, 403, "非法操作", null);
            return;
        }
        novelService.deleteNovel(id);
        ResponseUtils.writeJson(resp, 200, "作品已下架", null);
    }

    private void handleCreateChapter(HttpServletRequest req, HttpServletResponse resp, int authorId) throws Exception {
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        if (!checkNovelOwnership(novelId, authorId)) {
            ResponseUtils.writeJson(resp, 403, "非法操作", null);
            return;
        }
        Chapter chapter = new Chapter();
        chapter.setNovelId(novelId);
        chapter.setTitle(req.getParameter("title"));
        chapter.setContent(req.getParameter("content"));
        
        String isPaidStr = req.getParameter("isPaid");
        if (isPaidStr != null) chapter.setIsPaid(Integer.parseInt(isPaidStr));
        
        String priceStr = req.getParameter("price");
        if (priceStr != null) chapter.setPrice(new java.math.BigDecimal(priceStr));
        
        novelService.addChapter(chapter);
        ResponseUtils.writeJson(resp, 200, "章节已同步", null);
    }

    private void handleUpdateChapter(HttpServletRequest req, HttpServletResponse resp, int authorId) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        Chapter chapter = novelService.getChapterById(id);
        if (chapter == null || !checkNovelOwnership(chapter.getNovelId(), authorId)) {
            ResponseUtils.writeJson(resp, 403, "非法操作", null);
            return;
        }
        chapter.setTitle(req.getParameter("title"));
        chapter.setContent(req.getParameter("content"));
        
        String isPaidStr = req.getParameter("isPaid");
        if (isPaidStr != null) chapter.setIsPaid(Integer.parseInt(isPaidStr));
        
        String priceStr = req.getParameter("price");
        if (priceStr != null) chapter.setPrice(new java.math.BigDecimal(priceStr));
        
        novelService.updateChapter(chapter);
        ResponseUtils.writeJson(resp, 200, "章节已更新", null);
    }

    private void handleDeleteChapter(HttpServletRequest req, HttpServletResponse resp, int authorId) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        Chapter old = novelService.getChapterById(id);
        if (old == null || !checkNovelOwnership(old.getNovelId(), authorId)) {
            ResponseUtils.writeJson(resp, 403, "非法操作", null);
            return;
        }
        novelService.deleteChapter(id);
        ResponseUtils.writeJson(resp, 200, "章节已抹除", null);
    }

    private boolean checkNovelOwnership(int novelId, int authorId) {
        Novel novel = novelService.getNovelDetails(novelId);
        return novel != null && novel.getAuthorId() == authorId;
    }
}
