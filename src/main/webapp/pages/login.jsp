<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>登录执笔 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
    </head>

    <body class="bg-glow min-h-screen flex flex-col">
        <%@ include file="header.jsp" %>

            <main class="flex-1 flex items-center justify-center p-6 relative overflow-hidden">
                <!-- Abstract Background Orbs -->
                <div class="absolute top-1/4 -left-20 w-80 h-80 bg-primary/10 blur-[120px] rounded-full animate-float">
                </div>
                <div class="absolute bottom-1/4 -right-20 w-96 h-96 bg-accent/10 blur-[130px] rounded-full animate-float"
                    style="animation-delay: 2s;"></div>

                <div class="w-full max-w-[480px] reveal">
                    <div class="luminous-panel rounded-[3rem] p-12 lg:p-16 relative">
                        <div class="text-center mb-12">
                            <div
                                class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-primary/20 text-primary mb-6 shadow-xl shadow-primary/10">
                                <i data-lucide="key-round" class="w-8 h-8"></i>
                            </div>
                            <h2 class="text-4xl font-black text-white tracking-tighter mb-3">欢迎归访</h2>
                            <p class="text-text-dim text-sm tracking-widest uppercase font-bold">阅见不一样的自己</p>
                        </div>

                        <div class="space-y-8">
                            <div class="space-y-3">
                                <label
                                    class="text-[10px] font-black text-text-muted uppercase tracking-[0.2em] ml-1">身份账号</label>
                                <div class="relative group/input">
                                    <i data-lucide="user"
                                        class="absolute left-5 top-1/2 -translate-y-1/2 w-5 h-5 text-text-dim group-focus-within/input:text-primary transition-colors"></i>
                                    <input type="text" id="username"
                                        class="w-full bg-surface-elevated border border-border-highlight rounded-[1.25rem] pl-14 pr-6 py-5 outline-none focus:border-primary transition-all text-white font-bold"
                                        placeholder="您的通行证账号">
                                </div>
                            </div>

                            <div class="space-y-3">
                                <label
                                    class="text-[10px] font-black text-text-muted uppercase tracking-[0.2em] ml-1">进入密码</label>
                                <div class="relative group/input">
                                    <i data-lucide="shield-ellipsis"
                                        class="absolute left-5 top-1/2 -translate-y-1/2 w-5 h-5 text-text-dim group-focus-within/input:text-accent transition-colors"></i>
                                    <input type="password" id="password"
                                        class="w-full bg-surface-elevated border border-border-highlight rounded-[1.25rem] pl-14 pr-6 py-5 outline-none focus:border-accent transition-all text-white font-bold"
                                        placeholder="••••••••">
                                </div>
                            </div>

                            <button onclick="login()" class="btn-ultimate w-full py-5 text-lg shadow-2xl mt-4">
                                立即登入
                            </button>

                            <div class="text-center mt-10">
                                <p class="text-sm text-text-dim font-bold">
                                    尚未解锁账号?
                                    <a href="register.jsp"
                                        class="text-primary hover:text-white transition-colors underline underline-offset-8 ml-2">即刻开启旅程</a>
                                </p>
                            </div>
                        </div>
                    </div>

                    <p
                        class="text-center text-[10px] text-text-dim mt-8 uppercase tracking-[0.3em] font-medium opacity-50">
                        Security encrypted & protected by YueJi Cloud
                    </p>
                </div>
            </main>

            <%@ include file="footer.jsp" %>

                <script>
                    async function login() {
                        const user = document.getElementById('username').value.trim();
                        const pass = document.getElementById('password').value.trim();

                        if (!user || !pass) return showToast("账号信息不完整", "error");

                        const params = new URLSearchParams();
                        params.append('username', user);
                        params.append('password', pass);

                        try {
                            const res = await fetchJson(`${pageContext.request.contextPath}/auth/login`, {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: params
                            });

                            if (res && res.status === 200) {
                                showToast("验证通过，正在同步空间...", "success");
                                setTimeout(() => location.href = 'index.jsp', 1200);
                            } else {
                                showToast(res ? res.data.msg : "验证链路异常", "error");
                            }
                        } catch (e) {
                            showToast("接入核心失败", "error");
                        }
                    }

                    document.addEventListener('keypress', (e) => { if (e.key === 'Enter') login(); });
                    lucide.createIcons();
                </script>
    </body>

    </html>