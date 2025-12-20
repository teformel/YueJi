<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>开启旅程 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
    </head>

    <body class="bg-glow min-h-screen flex flex-col">
        <%@ include file="header.jsp" %>

            <main class="flex-1 flex items-center justify-center p-6 relative overflow-hidden">
                <!-- Abstract Background Orbs -->
                <div class="absolute -top-20 -right-20 w-80 h-80 bg-accent/10 blur-[120px] rounded-full animate-float">
                </div>
                <div class="absolute -bottom-20 -left-20 w-96 h-96 bg-primary/10 blur-[130px] rounded-full animate-float"
                    style="animation-delay: 1.5s;"></div>

                <div class="w-full max-w-[520px] reveal">
                    <div class="luminous-panel rounded-[3rem] p-12 lg:p-16 relative">
                        <div class="text-center mb-10">
                            <div
                                class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-accent/20 text-accent mb-6 shadow-xl shadow-accent/10">
                                <i data-lucide="sparkles" class="w-8 h-8"></i>
                            </div>
                            <h2 class="text-4xl font-black text-white tracking-tighter mb-3">开启新篇章</h2>
                            <p class="text-text-dim text-sm tracking-widest uppercase font-bold">注册您的阅己通行证</p>
                        </div>

                        <div class="space-y-6">
                            <div class="space-y-2.5">
                                <label
                                    class="text-[10px] font-black text-text-muted uppercase tracking-[0.2em] ml-1">身份账号</label>
                                <div class="relative group/input">
                                    <i data-lucide="at-sign"
                                        class="absolute left-5 top-1/2 -translate-y-1/2 w-5 h-5 text-text-dim group-focus-within/input:text-primary transition-colors"></i>
                                    <input type="text" id="username"
                                        class="w-full bg-surface-elevated border border-border-highlight rounded-[1.25rem] pl-14 pr-6 py-4 outline-none focus:border-primary transition-all text-white font-bold"
                                        placeholder="建议使用字母数字组合">
                                </div>
                            </div>

                            <div class="space-y-2.5">
                                <label
                                    class="text-[10px] font-black text-text-muted uppercase tracking-[0.2em] ml-1">个人昵称</label>
                                <div class="relative group/input">
                                    <i data-lucide="tag"
                                        class="absolute left-5 top-1/2 -translate-y-1/2 w-5 h-5 text-text-dim group-focus-within/input:text-primary transition-colors"></i>
                                    <input type="text" id="nickname"
                                        class="w-full bg-surface-elevated border border-border-highlight rounded-[1.25rem] pl-14 pr-6 py-4 outline-none focus:border-primary transition-all text-white font-bold"
                                        placeholder="大家如何称呼您?">
                                </div>
                            </div>

                            <div class="space-y-2.5">
                                <label
                                    class="text-[10px] font-black text-text-muted uppercase tracking-[0.2em] ml-1">进入密码</label>
                                <div class="relative group/input">
                                    <i data-lucide="shield-check"
                                        class="absolute left-5 top-1/2 -translate-y-1/2 w-5 h-5 text-text-dim group-focus-within/input:text-accent transition-colors"></i>
                                    <input type="password" id="password"
                                        class="w-full bg-surface-elevated border border-border-highlight rounded-[1.25rem] pl-14 pr-6 py-4 outline-none focus:border-accent transition-all text-white font-bold"
                                        placeholder="不少于 6 位强力密码">
                                </div>
                            </div>

                            <button onclick="register()"
                                class="btn-ultimate w-full py-5 text-lg shadow-2xl mt-6 bg-accent border-accent/20 hover:border-accent/40 shadow-accent/20">
                                开启阅读之旅
                            </button>

                            <div class="text-center mt-10">
                                <p class="text-sm text-text-dim font-bold">
                                    早已拥有通行证?
                                    <a href="login.jsp"
                                        class="text-accent hover:text-white transition-colors underline underline-offset-8 ml-2">立即登入归队</a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <%@ include file="footer.jsp" %>

                <script>
                    async function register() {
                        const user = document.getElementById('username').value.trim();
                        const nick = document.getElementById('nickname').value.trim();
                        const pass = document.getElementById('password').value.trim();

                        if (!user || !pass) return showToast("请完善必要注册信息", "error");

                        const params = new URLSearchParams();
                        params.append('username', user);
                        params.append('nickname', nick);
                        params.append('password', pass);

                        try {
                            const res = await fetchJson(`${pageContext.request.contextPath}/auth/register`, {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: params
                            });

                            if (res && res.status === 200) {
                                showToast("欢迎加入！正在为您开启门户...", "success");
                                setTimeout(() => location.href = 'login.jsp', 1500);
                            } else {
                                showToast(res ? res.data.msg : "账号可能已被占用", "error");
                            }
                        } catch (e) {
                            showToast("同步注册信息失败", "error");
                        }
                    }

                    lucide.createIcons();
                </script>
    </body>

    </html>