<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!-- V2 Global Dependencies -->

        <script src="../static/js/lucide.js"></script>

        <header class="sticky top-0 z-[100] w-full border-b border-border-highlight bg-canvas/60 backdrop-blur-xl">
            <div class="container flex h-20 items-center justify-between">
                <!-- Brand Section -->
                <div class="flex items-center gap-10">
                    <a href="index.jsp" class="group flex items-center gap-2.5">
                        <div
                            class="relative w-10 h-10 rounded-xl bg-gradient-to-br from-primary to-accent flex items-center justify-center shadow-lg shadow-primary/20 group-hover:scale-110 transition-transform">
                            <i data-lucide="zap" class="w-6 h-6 text-white fill-white/20"></i>
                        </div>
                        <span class="text-2xl font-black font-heading tracking-tighter text-white">阅己</span>
                    </a>

                    <!-- Navigation Links -->
                    <nav class="hidden lg:flex items-center gap-8">
                        <a href="index.jsp"
                            class="text-sm font-bold text-text-muted hover:text-white transition-colors relative group">
                            首页 <span
                                class="absolute -bottom-1 left-0 w-0 h-0.5 bg-primary transition-all group-hover:w-full"></span>
                        </a>
                        <a href="index.jsp?category=玄幻"
                            class="text-sm font-bold text-text-muted hover:text-white transition-colors">玄幻</a>
                        <a href="index.jsp?category=悬疑"
                            class="text-sm font-bold text-text-muted hover:text-white transition-colors">悬疑</a>
                        <a href="index.jsp?category=都市"
                            class="text-sm font-bold text-text-muted hover:text-white transition-colors">都市</a>

                        <c:if test="${sessionScope.user.role == 'admin'}">
                            <a href="admin_dashboard.jsp"
                                class="ml-2 flex items-center gap-2 px-4 py-1.5 rounded-full border border-primary/30 bg-primary/10 text-xs font-black text-primary hover:bg-primary hover:text-white transition-all">
                                <i data-lucide="shield-check" class="w-3.5 h-3.5"></i>
                                管理工作台
                            </a>
                        </c:if>
                    </nav>
                </div>

                <!-- User Actions -->
                <div class="flex items-center gap-5">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="flex items-center gap-4 group/user relative">
                                <!-- User Meta -->
                                <div class="hidden sm:flex flex-col items-end text-right">
                                    <span
                                        class="text-sm font-black text-white leading-none mb-1">${sessionScope.user.nickname}</span>
                                    <div class="flex items-center gap-1.5">
                                        <i data-lucide="star" class="w-3 h-3 text-primary fill-primary"></i>
                                        <span class="text-[10px] font-bold text-text-dim uppercase tracking-widest">
                                            <c:choose>
                                                <c:when test="${sessionScope.user.role == 'admin'}">总管理员</c:when>
                                                <c:otherwise>资深读者</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>

                                <!-- Avatar & Dropdown Trigger -->
                                <div class="relative">
                                    <div
                                        class="w-11 h-11 rounded-2xl bg-surface-elevated border border-border-highlight flex items-center justify-center cursor-pointer group-hover/user:border-primary transition-all overflow-hidden shadow-inner">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user.avatar}">
                                                <img src="${sessionScope.user.avatar}"
                                                    class="w-full h-full object-cover">
                                            </c:when>
                                            <c:otherwise>
                                                <i data-lucide="smile" class="w-6 h-6 text-text-muted"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Dropdown Menu V2 -->
                                    <div
                                        class="absolute right-0 mt-4 w-56 luminous-panel rounded-2xl p-2 opacity-0 invisible group-hover/user:opacity-100 group-hover/user:visible transition-all duration-300 translate-y-2 group-hover/user:translate-y-0 z-50">
                                        <a href="user_center.jsp"
                                            class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-primary/10 group/item transition-colors">
                                            <div
                                                class="w-8 h-8 rounded-lg bg-primary/20 flex items-center justify-center text-primary transition-transform group-hover/item:scale-110">
                                                <i data-lucide="user" class="w-4 h-4"></i>
                                            </div>
                                            <span class="text-sm font-bold text-white">个人中心</span>
                                        </a>
                                        <c:if test="${sessionScope.user.role == 'admin'}">
                                            <a href="admin_dashboard.jsp"
                                                class="flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-accent/10 group/item transition-colors">
                                                <div
                                                    class="w-8 h-8 rounded-lg bg-accent/20 flex items-center justify-center text-accent transition-transform group-hover/item:scale-110">
                                                    <i data-lucide="layout-grid" class="w-4 h-4"></i>
                                                </div>
                                                <span class="text-sm font-bold text-white">管理后台</span>
                                            </a>
                                        </c:if>
                                        <div class="my-2 border-t border-border-dim mx-2"></div>
                                        <button onclick="logout()"
                                            class="w-full flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-red-500/10 text-red-400 group/item transition-colors text-left">
                                            <div
                                                class="w-8 h-8 rounded-lg bg-red-500/10 flex items-center justify-center">
                                                <i data-lucide="power" class="w-4 h-4"></i>
                                            </div>
                                            <span class="text-sm font-bold">登出阅己</span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="flex items-center gap-4">
                                <a href="login.jsp"
                                    class="text-sm font-bold text-text-muted hover:text-white transition-colors">
                                    登录
                                </a>
                                <button onclick="location.href='register.jsp'" class="btn-ultimate px-6 py-2.5 text-xs">
                                    开启旅程
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </header>

        <div id="toast"
            class="luminous-panel fixed bottom-8 right-8 px-6 py-4 rounded-2xl z-[1000] invisible translate-y-10 transition-all duration-300">
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                lucide.createIcons();
            });

            async function logout() {
                showToast('正在结束会话...', 'info');
                try {
                    const response = await fetch('../auth/logout', { method: 'POST' });
                    if (response.ok) {
                        location.href = 'index.jsp';
                    }
                } catch (e) {
                    console.error(e);
                }
            }
        </script>