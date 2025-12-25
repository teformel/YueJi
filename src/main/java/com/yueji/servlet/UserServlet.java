package com.yueji.servlet;

import com.yueji.common.BeanFactory;
import com.yueji.common.ResponseUtils;
import com.yueji.dao.AuthorDao;
import com.yueji.model.User;
import com.yueji.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {
    private final UserService userService;
    private final AuthorDao authorDao;

    public UserServlet() {
        this.userService = BeanFactory.getBean(UserService.class);
        this.authorDao = BeanFactory.getBean(AuthorDao.class);
    }

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
            ResponseUtils.writeJson(resp, 401, "未登录", null);
            return;
        }
        User sessionUser = (User) session.getAttribute("user");
        // Refresh from DB
        User user = userService.getUserById(sessionUser.getId());
        user.setPassword(null); // Don't send password
        
        com.google.gson.JsonObject json = new com.google.gson.Gson().toJsonTree(user).getAsJsonObject();
        boolean isAuthor = authorDao.findByUserId(user.getId()) != null;
        json.addProperty("isAuthor", isAuthor);
        
        ResponseUtils.writeJson(resp, 200, "获取成功", json);
    }

    private void handleUpdateInfo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "未登录", null);
            return;
        }
        User sessionUser = (User) session.getAttribute("user");

        String realname = req.getParameter("realname");
        String phone = req.getParameter("phone");
        // Avatar removed from t_user in strict schema? 
        // Checked t_user in init.sql: id, username, password, realname, phone, coin_balance, role, status. 
        // NO AVATAR.
        // So I should remove avatar update.

        // Refresh and update
        User user = userService.getUserById(sessionUser.getId());
        if (realname != null) user.setRealname(realname);
        if (phone != null) user.setPhone(phone);

        try {
            userService.updateProfile(user);
            session.setAttribute("user", user); // Update session
            ResponseUtils.writeJson(resp, 200, "资料已更新", null);
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "更新资料失败", null);
        }
    }

    private void handleUpdatePassword(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            ResponseUtils.writeJson(resp, 401, "未登录", null);
            return;
        }
        User sessionUser = (User) session.getAttribute("user");

        String oldPassword = req.getParameter("oldPassword");
        String newPassword = req.getParameter("newPassword");

        try {
            userService.updatePassword(sessionUser.getId(), oldPassword, newPassword);
            ResponseUtils.writeJson(resp, 200, "密码已修改", null);
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 400, e.getMessage(), null); // "Wrong old password" etc
        }
    }
}
