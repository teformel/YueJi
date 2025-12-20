package com.yueji.servlet;

import com.yueji.common.ResponseUtils;
import com.yueji.dao.TransactionDao;
import com.yueji.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/pay/*")
public class PayServlet extends HttpServlet {
    private final TransactionDao transactionDao = new TransactionDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        try {
            if ("/order/create".equals(path)) {
                handleRecharge(req, resp);
            } else if ("/chapter/purchase".equals(path)) {
                handlePurchaseChapter(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Database Error", null);
        }
    }

    private void handleRecharge(HttpServletRequest req, HttpServletResponse resp) throws IOException, SQLException {
        User user = getUser(req, resp);
        if (user == null)
            return;

        int amount = Integer.parseInt(req.getParameter("amount"));
        double payment = Double.parseDouble(req.getParameter("payment"));

        // In real world, integrate with Payment Gateway (Alipay/WeChat).
        // Here we simulate success explicitly.
        transactionDao.createOrder(user.getId(), amount, payment);

        // Update session user balance
        user.setGoldBalance(user.getGoldBalance() + amount);

        ResponseUtils.writeJson(resp, 200, "Recharge successful", null);
    }

    private void handlePurchaseChapter(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, SQLException {
        User user = getUser(req, resp);
        if (user == null)
            return;

        int chapterId = Integer.parseInt(req.getParameter("chapterId"));
        int price = Integer.parseInt(req.getParameter("price")); // Should verify price from DB in real app

        boolean success = transactionDao.purchaseChapter(user.getId(), chapterId, price);
        if (success) {
            user.setGoldBalance(user.getGoldBalance() - price);
            ResponseUtils.writeJson(resp, 200, "Purchase successful", null);
        } else {
            ResponseUtils.writeJson(resp, 400, "Insufficient balance", null);
        }
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
