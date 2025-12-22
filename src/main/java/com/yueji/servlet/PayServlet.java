package com.yueji.servlet;

import com.yueji.common.BeanFactory;
import com.yueji.common.ResponseUtils;
import com.yueji.model.User;
import com.yueji.service.AssetService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/pay/*")
public class PayServlet extends HttpServlet {
    private final AssetService assetService;

    public PayServlet() {
        this.assetService = BeanFactory.getBean(AssetService.class);
    }

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
        } catch (Exception e) {
            e.printStackTrace();
            ResponseUtils.writeJson(resp, 500, "Error: " + e.getMessage(), null);
        }
    }

    private void handleRecharge(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;

        String amountStr = req.getParameter("amount");
        BigDecimal amount = new BigDecimal(amountStr);

        // Simulate payment success
        assetService.recharge(user.getId(), amount);

        // Update session
        user.setCoinBalance(user.getCoinBalance().add(amount));
        
        ResponseUtils.writeJson(resp, 200, "Recharge successful", null);
    }

    private void handlePurchaseChapter(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        User user = getUser(req, resp);
        if (user == null) return;

        int chapterId = Integer.parseInt(req.getParameter("chapterId"));
        // Price should be determined by Service, not passed by client securely.
        
        boolean success = assetService.purchaseChapter(user.getId(), chapterId);
        if (success) {
            // Refresh balance in session roughly, or better: reload user
            // We can decrement if we knew price, but easiest is just to proceed.
            // Client should reload user info.
            ResponseUtils.writeJson(resp, 200, "Purchase successful", null);
        } else {
            ResponseUtils.writeJson(resp, 400, "Purchase failed (Insufficient balance or other)", null);
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
