package com.yueji.servlet;

import com.yueji.common.BeanFactory;
import com.yueji.common.ResponseUtils;
import com.yueji.model.Author;
import com.yueji.model.Chapter;
import com.yueji.model.Novel;
import com.yueji.model.User;
import com.yueji.service.AuthorService;
import com.yueji.service.NovelService;
import com.yueji.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {
    private final NovelService novelService;
    private final AuthorService authorService;
    private final UserService userService;

    public AdminServlet() {
        this.novelService = BeanFactory.getBean(NovelService.class);
        this.authorService = BeanFactory.getBean(AuthorService.class);
        this.userService = BeanFactory.getBean(UserService.class);
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check Admin Role
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "Not logged in", null);
            return;
        }
        User user = (User) session.getAttribute("user");
        if (user.getRole() != 1 && !"admin".equals(user.getUsername())) { 
            ResponseUtils.writeJson(resp, 403, "Forbidden", null);
            return;
        }
        super.service(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/novel/list".equals(path)) {
            ResponseUtils.writeJson(resp, 200, "Novels", novelService.getRecommendedNovels());
        } else if ("/author/list".equals(path)) {
            ResponseUtils.writeJson(resp, 200, "Authors", authorService.getAllAuthors());
        } else if ("/user/list".equals(path)) {
            ResponseUtils.writeJson(resp, 200, "Users", userService.getAllUsers());
        } else if ("/chapter/list".equals(path)) {
            int novelId = Integer.parseInt(req.getParameter("novelId"));
            ResponseUtils.writeJson(resp, 200, "Chapters", novelService.getChapterList(novelId));
        } else if ("/chapter/detail".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Chapter chapter = novelService.getChapterById(id);
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
            } else if ("/user/status".equals(path)) {
                handleUpdateUserStatus(req, resp);
            } else if ("/user/role".equals(path)) {
                handleUpdateUserRole(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Error: " + e.getMessage(), null);
        }
    }

    private void handleCreateNovel(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Novel novel = new Novel();
        novel.setName(req.getParameter("title"));
        novel.setAuthorId(Integer.parseInt(req.getParameter("authorId")));
        String catIdStr = req.getParameter("categoryId");
        if (catIdStr != null) novel.setCategoryId(Integer.parseInt(catIdStr));
        
        novel.setDescription(req.getParameter("intro")); 
        novel.setCover(req.getParameter("coverUrl")); 
        novelService.createNovel(novel);
        ResponseUtils.writeJson(resp, 200, "Novel created", null);
    }

    private void handleUpdateNovel(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Novel novel = new Novel();
        novel.setId(Integer.parseInt(req.getParameter("id")));
        novel.setName(req.getParameter("title"));
        novel.setAuthorId(Integer.parseInt(req.getParameter("authorId")));
        String catIdStr = req.getParameter("categoryId");
        if (catIdStr != null) novel.setCategoryId(Integer.parseInt(catIdStr));
        novel.setDescription(req.getParameter("intro"));
        novel.setCover(req.getParameter("coverUrl"));
        novelService.updateNovel(novel);
        ResponseUtils.writeJson(resp, 200, "Novel updated", null);
    }

    private void handleDeleteNovel(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        novelService.deleteNovel(id);
        ResponseUtils.writeJson(resp, 200, "Novel deleted", null);
    }

    private void handleCreateAuthor(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Author author = new Author();
        author.setPenname(req.getParameter("name")); 
        author.setIntroduction(req.getParameter("bio")); 
        String userIdStr = req.getParameter("userId");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            author.setUserId(Integer.parseInt(userIdStr));
        }
        authorService.createAuthor(author);
        ResponseUtils.writeJson(resp, 200, "Author created", null);
    }

    private void handleUpdateAuthor(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Author author = new Author();
        author.setId(Integer.parseInt(req.getParameter("id")));
        author.setPenname(req.getParameter("name"));
        author.setIntroduction(req.getParameter("bio"));
        String userIdStr = req.getParameter("userId");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            author.setUserId(Integer.parseInt(userIdStr));
        }
        authorService.updateAuthor(author);
        ResponseUtils.writeJson(resp, 200, "Author updated", null);
    }

    private void handleDeleteAuthor(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        authorService.deleteAuthor(id);
        ResponseUtils.writeJson(resp, 200, "Author deleted", null);
    }

    private void handleCreateChapter(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Chapter chapter = new Chapter();
        chapter.setNovelId(Integer.parseInt(req.getParameter("novelId")));
        chapter.setTitle(req.getParameter("title"));
        chapter.setContent(req.getParameter("content"));
        String priceStr = req.getParameter("price");
        if (priceStr != null) chapter.setPrice(new java.math.BigDecimal(priceStr));
        novelService.addChapter(chapter);
        ResponseUtils.writeJson(resp, 200, "Chapter created", null);
    }

    private void handleUpdateChapter(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        Chapter chapter = new Chapter();
        chapter.setId(Integer.parseInt(req.getParameter("id")));
        chapter.setTitle(req.getParameter("title"));
        chapter.setContent(req.getParameter("content"));
        String priceStr = req.getParameter("price");
        if (priceStr != null) chapter.setPrice(new java.math.BigDecimal(priceStr));
        novelService.updateChapter(chapter);
        ResponseUtils.writeJson(resp, 200, "Chapter updated", null);
    }

    private void handleDeleteChapter(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        novelService.deleteChapter(id);
        ResponseUtils.writeJson(resp, 200, "Chapter deleted", null);
    }

    private void handleUpdateUserStatus(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        int status = Integer.parseInt(req.getParameter("status")); 
        userService.updateUserStatus(id, status);
        ResponseUtils.writeJson(resp, 200, "User status updated", null);
    }

    private void handleUpdateUserRole(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        int role = Integer.parseInt(req.getParameter("role")); 
        userService.updateUserRole(id, role);
        ResponseUtils.writeJson(resp, 200, "User role updated", null);
    }
}
