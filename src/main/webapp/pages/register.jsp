<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <title>阅己 - 注册</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
    </head>

    <body>
        <%@ include file="header.jsp" %>

            <div class="container">
                <div class="form-container">
                    <h2>注册</h2>
                    <div class="form-group">
                        <label>用户名</label>
                        <input type="text" id="username">
                    </div>
                    <div class="form-group">
                        <label>昵称</label>
                        <input type="text" id="nickname">
                    </div>
                    <div class="form-group">
                        <label>密码</label>
                        <input type="password" id="password">
                    </div>
                    <button class="btn" style="width: 100%;" onclick="register()">注册</button>
                    <p style="text-align: center; margin-top: 10px;">
                        已有账号? <a href="login.jsp">去登录</a>
                    </p>
                </div>
            </div>

            <%@ include file="footer.jsp" %>

                <script>
                    async function register() {
                        const username = document.getElementById('username').value;
                        const nickname = document.getElementById('nickname').value;
                        const password = document.getElementById('password').value;

                        if (!username || !password) {
                            showToast("请填写必填项");
                            return;
                        }

                        const params = new URLSearchParams();
                        params.append('username', username);
                        params.append('nickname', nickname);
                        params.append('password', password);

                        const result = await fetchJson('${pageContext.request.contextPath}/auth/register', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: params
                        });

                        if (result && result.status === 200) {
                            showToast("注册成功，请登录");
                            setTimeout(() => window.location.href = 'login.jsp', 1500);
                        } else {
                            showToast(result ? result.data.msg || "注册失败" : "Error");
                        }
                    }
                </script>
    </body>

    </html>