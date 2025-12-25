package com.yueji.servlet;

import com.yueji.common.BeanFactory;
import com.yueji.common.ResponseUtils;
import com.yueji.model.User;
import com.yueji.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private final UserService userService;

    public AuthServlet() {
        this.userService = BeanFactory.getBean(UserService.class);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if ("/login".equals(path)) {
            handleLogin(req, resp);
        } else if ("/register".equals(path)) {
            handleRegister(req, resp);
        } else if ("/logout".equals(path)) {
            handleLogout(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password"); // Should be hashed in frontend or service. Service expects raw here or hash? Impl compared raw.

        User user = userService.login(username, password);
        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            userService.updateLastLoginTime(user.getId());
            ResponseUtils.writeJson(resp, 200, "登录成功", user);
        } else {
            ResponseUtils.writeJson(resp, 401, "用户名或密码错误", null);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String realname = req.getParameter("realname"); // Changed from nickname
        String phone = req.getParameter("phone");

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setRealname(realname != null ? realname : username);
        newUser.setPhone(phone);
        // Role and Balance set in Service

        try {
            userService.register(newUser);
            ResponseUtils.writeJson(resp, 200, "注册成功", null);
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 400, e.getMessage(), null); // 400 for business error
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.getSession().invalidate();
        ResponseUtils.writeJson(resp, 200, "已退出登录", null);
    }
}
