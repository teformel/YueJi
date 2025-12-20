package com.yueji.servlet;

import com.yueji.common.ResponseUtils;
import com.yueji.dao.UserDao;
import com.yueji.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {
    private final UserDao userDao = new UserDao();
    private final com.yueji.dao.AuthorDao authorDao = new com.yueji.dao.AuthorDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/info".equals(path)) {
            handleGetInfo(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/update".equals(path)) {
            handleUpdateInfo(req, resp);
        } else if ("/password".equals(path)) {
            handleUpdatePassword(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleGetInfo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "Not logged in", null);
            return;
        }
        User sessionUser = (User) session.getAttribute("user");
        // Refresh from DB
        User user = userDao.findByUsername(sessionUser.getUsername());
        user.setPassword(null); // Don't send password
        
        com.google.gson.JsonObject json = new com.google.gson.Gson().toJsonTree(user).getAsJsonObject();
        boolean isAuthor = authorDao.findByUserId(user.getId()) != null;
        json.addProperty("isAuthor", isAuthor);
        
        ResponseUtils.writeJson(resp, 200, "User info", json);
    }

    private void handleUpdateInfo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "Not logged in", null);
            return;
        }
        User sessionUser = (User) session.getAttribute("user");

        String nickname = req.getParameter("nickname");
        String avatar = req.getParameter("avatar");

        // Refresh and update
        User user = userDao.findByUsername(sessionUser.getUsername());
        if (nickname != null)
            user.setNickname(nickname);
        if (avatar != null)
            user.setAvatar(avatar);

        try {
            userDao.update(user);
            session.setAttribute("user", user); // Update session
            ResponseUtils.writeJson(resp, 200, "Profile updated", null);
        } catch (SQLException e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Error updating profile", null);
        }
    }

    private void handleUpdatePassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "Not logged in", null);
            return;
        }
        User sessionUser = (User) session.getAttribute("user");

        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");

        User user = userDao.findByUsername(sessionUser.getUsername());
        if (!user.getPassword().equals(oldPassword)) {
            ResponseUtils.writeJson(resp, 400, "Incorrect old password", null);
            return;
        }

        try {
            userDao.updatePassword(user.getId(), newPassword);
            ResponseUtils.writeJson(resp, 200, "Password updated", null);
        } catch (SQLException e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Error updating password", null);
        }
    }
}
