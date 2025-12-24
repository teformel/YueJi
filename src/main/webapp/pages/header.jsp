<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <header class="sticky top-0 z-50 w-full bg-white border-b border-gray-200">
        <div class="container flex h-16 items-center justify-between">
            <!-- Brand -->
            <a href="${pageContext.request.contextPath}/pages/index.jsp" class="flex items-center gap-2 group">
                <div class="flex items-center justify-center w-8 h-8 rounded-lg bg-blue-600 text-white">
                    <i data-lucide="book-open" class="w-5 h-5"></i>
                </div>
                <span class="text-xl font-bold tracking-tight text-slate-900">阅己</span>
            </a>

            <!-- Nav Links -->
            <nav class="hidden md:flex items-center gap-6">
                <a href="${pageContext.request.contextPath}/pages/index.jsp" class="nav-link" data-nav="index">首页</a>

                <!-- Category Dropdown -->
                <div class="relative group py-5">
                    <button class="nav-link flex items-center gap-1 group-hover:text-blue-600 transition-colors">
                        分类 <i data-lucide="chevron-down"
                            class="w-4 h-4 transition-transform group-hover:rotate-180"></i>
                    </button>
                    <!-- Dropdown Content -->
                    <div
                        class="absolute left-0 top-full hidden group-hover:block w-[480px] bg-white border border-gray-100 rounded-2xl shadow-xl p-6 animate-in fade-in slide-in-from-top-2 duration-200">
                        <div class="grid grid-cols-3 gap-6">
                            <div>
                                <h5 class="text-[11px] font-bold text-slate-400 uppercase tracking-widest mb-4">热门推荐
                                </h5>
                                <div class="space-y-3" id="headerCategoryHot">
                                    <!-- Dynamic -->
                                </div>
                            </div>
                            <div>
                                <h5 class="text-[11px] font-bold text-slate-400 uppercase tracking-widest mb-4">核心分类
                                </h5>
                                <div class="space-y-3" id="headerCategoryMore">
                                    <!-- Dynamic -->
                                </div>
                            </div>
                            <div class="bg-blue-50/50 rounded-xl p-4">
                                <h5 class="text-[11px] font-bold text-blue-600 uppercase tracking-widest mb-3">全景书库</h5>
                                <p class="text-[11px] text-slate-500 mb-4 leading-relaxed">发现万千世界的奥秘，找到你心灵的归宿。</p>
                                <a href="${pageContext.request.contextPath}/pages/browse.jsp"
                                    class="inline-flex items-center text-xs font-bold text-blue-600 hover:gap-2 transition-all">
                                    进入书库 <i data-lucide="arrow-right" class="w-3 h-3 ml-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/pages/browse.jsp" class="nav-link" data-nav="browse">书库</a>
                <a href="${pageContext.request.contextPath}/pages/browse.jsp?sort=hot"
                    class="nav-link flex items-center gap-1" data-nav="rank">
                    排行榜 <span class="w-1.5 h-1.5 rounded-full bg-red-500 animate-pulse"></span>
                </a>
            </nav>

            <!-- User Actions -->
            <div class="flex items-center gap-4">
                <!-- Checking session via JS in script.js to toggle this would be better, but JSP is server side. 
                 Since we are doing full client-side mock auth, we will toggle this class via JS in common script -->
                <div id="authLinks" class="flex items-center gap-4">
                    <a href="${pageContext.request.contextPath}/pages/login.jsp"
                        class="text-sm font-medium text-slate-600 hover:text-slate-900">登录</a>
                    <a href="${pageContext.request.contextPath}/pages/register.jsp"
                        class="btn-primary text-sm px-5 py-2">注册</a>
                </div>

                <div id="userMenu" class="hidden items-center gap-3">
                    <a href="${pageContext.request.contextPath}/pages/creator_dashboard.jsp" id="creatorLink"
                        class="hidden text-sm font-bold text-slate-500 hover:text-blue-600">作家后台</a>
                    <a href="${pageContext.request.contextPath}/pages/admin_dashboard.jsp" id="adminLink"
                        class="hidden text-sm font-bold text-slate-500 hover:text-red-500">管理后台</a>
                    <a href="${pageContext.request.contextPath}/pages/user_center.jsp"
                        class="flex items-center gap-2 hover:bg-gray-50 p-1 pr-3 rounded-full border border-transparent hover:border-gray-200 transition-all">
                        <div class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center text-blue-600">
                            <i data-lucide="user" class="w-4 h-4"></i>
                        </div>
                        <span id="headerUsername" class="text-sm font-bold text-slate-700">User</span>
                    </a>
                </div>
            </div>
        </div>
    </header>