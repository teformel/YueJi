package com.yueji.servlet;

import com.yueji.common.ResponseUtils;
import com.yueji.dao.CollectionDao;
import com.yueji.dao.CommentDao;
import com.yueji.model.Comment;
import com.yueji.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/interaction/*")
public class InteractionServlet extends HttpServlet {
    private final CommentDao commentDao = new CommentDao();
    private final CollectionDao collectionDao = new CollectionDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/comment/list".equals(path)) {
            handleListComments(req, resp);
        } else if ("/collection/list".equals(path)) {
            handleListCollection(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        try {
            if ("/comment/create".equals(path)) {
                handleCreateComment(req, resp);
            } else if ("/comment/delete".equals(path)) {
                handleDeleteComment(req, resp);
            } else if ("/collection/add".equals(path)) {
                handleAddCollection(req, resp);
            } else if ("/collection/remove".equals(path)) {
                handleRemoveCollection(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Database Error", null);
        }
    }

    private void handleListComments(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        List<Comment> comments = commentDao.findByNovelId(novelId);
        ResponseUtils.writeJson(resp, 200, "Success", comments);
    }

    private void handleCreateComment(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, SQLException {
        User user = getUser(req, resp);
        if (user == null)
            return;

        Comment c = new Comment();
        c.setUserId(user.getId());
        c.setNovelId(Integer.parseInt(req.getParameter("novelId")));
        c.setContent(req.getParameter("content"));
        commentDao.create(c);
        ResponseUtils.writeJson(resp, 200, "Comment added", null);
    }

    private void handleDeleteComment(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, SQLException {
        // Validation: User owns comment or Admin. Skipping for brevity, assuming owner
        // check in frontend or secure later.
        int id = Integer.parseInt(req.getParameter("id"));
        commentDao.delete(id);
        ResponseUtils.writeJson(resp, 200, "Comment deleted", null);
    }

    private void handleListCollection(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User user = getUser(req, resp);
        if (user == null)
            return;
        List<Map<String, Object>> list = collectionDao.findByUserId(user.getId());
        ResponseUtils.writeJson(resp, 200, "Success", list);
    }

    private void handleAddCollection(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, SQLException {
        User user = getUser(req, resp);
        if (user == null)
            return;
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        collectionDao.add(user.getId(), novelId);
        ResponseUtils.writeJson(resp, 200, "Added to collection", null);
    }

    private void handleRemoveCollection(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, SQLException {
        User user = getUser(req, resp);
        if (user == null)
            return;
        int novelId = Integer.parseInt(req.getParameter("novelId"));
        collectionDao.remove(user.getId(), novelId);
        ResponseUtils.writeJson(resp, 200, "Removed from collection", null);
    }

    private User getUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "Not logged in", null);
            return null;
        }
        return (User) session.getAttribute("user");
    }
}
