<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <script src="../static/js/lucide.js"></script>

        <header class="sticky top-0 z-50 w-full bg-white border-b border-gray-200">
            <div class="container flex h-16 items-center justify-between">
                <!-- Brand -->
                <a href="index.jsp" class="flex items-center gap-2 group">
                    <div class="flex items-center justify-center w-8 h-8 rounded-lg bg-blue-600 text-white">
                        <i data-lucide="book-open" class="w-5 h-5"></i>
                    </div>
                    <span class="text-xl font-bold tracking-tight text-slate-900">阅己</span>
                </a>

                <!-- Nav Links -->
                <nav class="hidden md:flex items-center gap-8">
                    <a href="index.jsp"
                        class="text-sm font-medium text-slate-600 hover:text-blue-600 transition-colors">首页</a>
                    <a href="index.jsp?category=玄幻"
                        class="text-sm font-medium text-slate-600 hover:text-blue-600 transition-colors">玄幻</a>
                    <a href="index.jsp?category=悬疑"
                        class="text-sm font-medium text-slate-600 hover:text-blue-600 transition-colors">悬疑</a>
                    <a href="index.jsp?category=都市"
                        class="text-sm font-medium text-slate-600 hover:text-blue-600 transition-colors">都市</a>

                    <c:if test="${sessionScope.user.role == 'admin'}">
                        <a href="admin_dashboard.jsp"
                            class="flex items-center gap-1.5 px-3 py-1 rounded-full bg-blue-50 text-blue-700 text-xs font-bold hover:bg-blue-100 transition-colors">
                            <i data-lucide="shield" class="w-3 h-3"></i>
                            管理台
                        </a>
                    </c:if>
                </nav>

                <!-- User Actions -->
                <div class="flex items-center gap-4">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="relative group">
                                <button class="flex items-center gap-3 focus:outline-none">
                                    <span
                                        class="hidden sm:block text-sm font-medium text-slate-700">${sessionScope.user.nickname}</span>
                                    <div
                                        class="w-9 h-9 rounded-full bg-slate-100 border border-slate-200 flex items-center justify-center overflow-hidden">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user.avatar}">
                                                <img src="${sessionScope.user.avatar}"
                                                    class="w-full h-full object-cover">
                                            </c:when>
                                            <c:otherwise>
                                                <i data-lucide="user" class="w-5 h-5 text-slate-400"></i>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </button>

                                <!-- Dropdown -->
                                <div
                                    class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-100 py-1 invisible opacity-0 group-hover:visible group-hover:opacity-100 transition-all transform origin-top-right">
                                    <a href="user_center.jsp"
                                        class="flex items-center gap-2 px-4 py-2 text-sm text-slate-700 hover:bg-slate-50">
                                        <i data-lucide="user" class="w-4 h-4"></i> 个人中心
                                    </a>
                                    <c:if test="${sessionScope.user.role == 'admin'}">
                                        <a href="admin_dashboard.jsp"
                                            class="flex items-center gap-2 px-4 py-2 text-sm text-slate-700 hover:bg-slate-50">
                                            <i data-lucide="layout-grid" class="w-4 h-4"></i> 管理后台
                                        </a>
                                    </c:if>
                                    <div class="h-px bg-gray-100 my-1"></div>
                                    <button onclick="logout()"
                                        class="w-full flex items-center gap-2 px-4 py-2 text-sm text-red-600 hover:bg-red-50 text-left">
                                        <i data-lucide="log-out" class="w-4 h-4"></i> 退出登录
                                    </button>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="login.jsp" class="text-sm font-medium text-slate-600 hover:text-slate-900">登录</a>
                            <a href="register.jsp" class="btn-primary text-sm px-5 py-2">注册</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </header>
        <div id="toast" class="invisible translate-y-4"></div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                lucide.createIcons();
            });

            async function logout() {
                try {
                    const response = await fetch('../auth/logout', { method: 'POST' });
                    if (response.ok) location.href = 'index.jsp';
                } catch (e) {
                    console.error(e);
                }
            }
        </script>