<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>作品详情 - 阅己 YueJi</title>
        <link rel="stylesheet"
            href="${pageContext.request.contextPath}/static/css/style.css?v=${System.currentTimeMillis()}">
        <script src="${pageContext.request.contextPath}/static/js/lucide.js"></script>
        <script src="${pageContext.request.contextPath}/static/js/script.js?v=${System.currentTimeMillis()}"></script>
    </head>

    <body class="bg-gray-50 min-h-screen flex flex-col">
        <%@ include file="header.jsp" %>

            <main class="flex-1 py-12">
                <div class="container max-w-5xl">

                    <!-- Book Header Info -->
                    <div class="bg-white rounded-xl border border-gray-200 p-8 shadow-sm mb-10">
                        <div class="flex flex-col md:flex-row gap-10">
                            <!-- Cover -->
                            <div class="w-full md:w-56 flex-shrink-0">
                                <div class="aspect-[3/4] rounded-lg overflow-hidden shadow-lg border border-gray-100">
                                    <img id="coverImg"
                                        src="${pageContext.request.contextPath}/static/images/cover_placeholder.jpg"
                                        class="w-full h-full object-cover">
                                </div>
                            </div>

                            <!-- Info -->
                            <div class="flex-1 flex flex-col justify-center">
                                <div class="mb-6">
                                    <div class="flex items-center gap-3 mb-2">
                                        <span id="categoryBadge"
                                            class="px-3 py-1 bg-gray-100 text-slate-600 rounded-full text-xs font-bold uppercase tracking-wide">未分类</span>
                                        <span id="statusBadge"
                                            class="text-xs font-bold text-green-600 flex items-center gap-1">
                                            <i data-lucide="check-circle-2" class="w-3 h-3"></i> 连载中
                                        </span>
                                    </div>
                                    <h1 id="novelTitle" class="text-4xl font-black text-slate-900 mb-2">加载中...</h1>
                                    <p id="authorName" class="text-lg text-slate-500 font-medium">佚名 · 著</p>
                                </div>

                                <div class="flex items-center gap-4 mb-8">
                                    <button onclick="startReading()" id="btnStartRead"
                                        class="btn-primary px-8 py-3 text-lg shadow-lg shadow-blue-500/20 active:scale-95 transition-transform">
                                        <i data-lucide="book-open" class="w-5 h-5"></i> 立即阅读
                                    </button>
                                    <button id="btnAddShelf" onclick="toggleShelf()"
                                        class="px-6 py-3 bg-white border border-gray-200 text-slate-700 font-bold rounded-lg hover:bg-gray-50 transition-colors">
                                        加入书架
                                    </button>
                                </div>

                                <div class="grid grid-cols-3 gap-6 border-t border-gray-100 pt-6">
                                    <div>
                                        <div id="novelRating" class="text-2xl font-black text-slate-900">4.8</div>
                                        <div class="text-xs text-slate-400 font-bold uppercase">评分</div>
                                    </div>
                                    <div>
                                        <div id="statChapterCount" class="text-2xl font-black text-slate-900">0</div>
                                        <div class="text-xs text-slate-400 font-bold uppercase">章回</div>
                                    </div>
                                    <div>
                                        <div id="statViewCount" class="text-2xl font-black text-slate-900">0</div>
                                        <div class="text-xs text-slate-400 font-bold uppercase">人气</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Description & Chapters -->
                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-10">

                        <!-- Left: Synopsis -->
                        <div class="lg:col-span-2 space-y-10">
                            <section>
                                <h3 class="text-xl font-bold text-slate-900 mb-4 flex items-center gap-2">
                                    <i data-lucide="info" class="w-5 h-5 text-blue-600"></i> 作品简介
                                </h3>
                                <div id="description"
                                    class="prose prose-slate max-w-none text-slate-600 leading-relaxed">
                                    <div class="h-4 bg-gray-200 rounded w-3/4 animate-pulse"></div>
                                    <div class="h-4 bg-gray-200 rounded w-1/2 mt-2 animate-pulse"></div>
                                </div>
                            </section>

                            <section>
                                <h3 class="text-xl font-bold text-slate-900 mb-6 flex items-center gap-2">
                                    <i data-lucide="list" class="w-5 h-5 text-blue-600"></i> 目录正文
                                    <span id="chapterCount"
                                        class="ml-2 px-2 py-0.5 bg-gray-100 text-gray-500 text-xs rounded-full">0
                                        章</span>
                                </h3>
                                <div id="chapterList" class="grid grid-cols-1 md:grid-cols-2 gap-3">
                                    <!-- Injected -->
                                </div>
                            </section>
                        </div>

                        <!-- Right: Side Panel -->
                        <aside class="space-y-6">
                            <div class="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
                                <h4 class="font-bold text-slate-900 mb-4">共鸣讨论区</h4>
                                <div id="discussionArea" class="text-center py-10">
                                    <i data-lucide="message-square" class="w-10 h-10 text-gray-300 mx-auto mb-3"></i>
                                    <p class="text-sm text-slate-400">登录后即可参与讨论</p>
                                </div>
                            </div>
                        </aside>
                    </div>
                </div>
            </main>

            <%@ include file="footer.jsp" %>
                <script
                    src="${pageContext.request.contextPath}/static/js/novel_detail.js?v=${System.currentTimeMillis()}"></script>
                <script>
                    // Any JSP variable injection if needed in future can go here
                </script>
    </body>

    </html>