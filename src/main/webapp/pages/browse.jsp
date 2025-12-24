<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>分类浏览 - 阅己 YueJi</title>
        <link rel="stylesheet"
            href="${pageContext.request.contextPath}/static/css/style.css?v=${System.currentTimeMillis()}">
        <script src="${pageContext.request.contextPath}/static/js/lucide.js"></script>
        <script src="${pageContext.request.contextPath}/static/js/script.js?v=${System.currentTimeMillis()}"></script>
    </head>

    <body class="bg-gray-50 min-h-screen flex flex-col">
        <%@ include file="header.jsp" %>

            <main class="flex-1 py-8">
                <div class="container">

                    <!-- Filter Bar -->
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-6 mb-8 space-y-6">
                        <!-- Categories -->
                        <div class="flex flex-wrap items-center gap-3">
                            <span class="text-sm font-bold text-slate-400 uppercase tracking-wide mr-2">分类</span>
                            <button
                                class="filter-btn active px-3 py-1 bg-slate-100 text-slate-900 rounded-md text-sm font-bold hover:bg-slate-200 transition-colors"
                                data-type="category" data-val="all">全部</button>
                            <button
                                class="filter-btn px-3 py-1 text-slate-600 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                                data-type="category" data-val="玄幻">玄幻</button>
                            <button
                                class="filter-btn px-3 py-1 text-slate-600 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                                data-type="category" data-val="都市">都市</button>
                            <button
                                class="filter-btn px-3 py-1 text-slate-600 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                                data-type="category" data-val="仙侠">仙侠</button>
                            <button
                                class="filter-btn px-3 py-1 text-slate-600 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                                data-type="category" data-val="科幻">科幻</button>
                            <button
                                class="filter-btn px-3 py-1 text-slate-600 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                                data-type="category" data-val="历史">历史</button>
                            <button
                                class="filter-btn px-3 py-1 text-slate-600 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                                data-type="category" data-val="游戏">游戏</button>
                            <button
                                class="filter-btn px-3 py-1 text-slate-600 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                                data-type="category" data-val="奇幻">奇幻</button>
                            <button
                                class="filter-btn px-3 py-1 text-slate-600 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                                data-type="category" data-val="悬疑">悬疑</button>
                        </div>

                        <!-- Status -->
                        <div class="flex flex-wrap items-center gap-3 border-t border-gray-100 pt-4">
                            <span class="text-sm font-bold text-slate-400 uppercase tracking-wide mr-2">状态</span>
                            <button
                                class="filter-btn active px-3 py-1 bg-slate-100 text-slate-900 rounded-md text-sm font-bold hover:bg-slate-200 transition-colors"
                                data-type="status" data-val="all">全部</button>
                            <button
                                class="filter-btn px-3 py-1 text-slate-600 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                                data-type="status" data-val="连载中">连载中</button>
                            <button
                                class="filter-btn px-3 py-1 text-slate-600 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                                data-type="status" data-val="已完结">已完结</button>
                        </div>
                    </div>

                    <!-- Novel Grid -->
                    <div id="browseGrid" class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-6">
                        <!-- Data Injected -->
                    </div>

                    <!-- Pagination (Mock) -->
                    <div class="flex justify-center mt-12 gap-2">
                        <button
                            class="px-4 py-2 bg-white border border-gray-200 rounded-lg text-slate-400 cursor-not-allowed">上一页</button>
                        <button class="px-4 py-2 bg-slate-900 text-white rounded-lg font-bold">1</button>
                        <button
                            class="px-4 py-2 bg-white border border-gray-200 rounded-lg text-slate-600 hover:bg-gray-50">2</button>
                        <button
                            class="px-4 py-2 bg-white border border-gray-200 rounded-lg text-slate-600 hover:bg-gray-50">3</button>
                        <span class="px-2 py-2 text-slate-400">...</span>
                        <button
                            class="px-4 py-2 bg-white border border-gray-200 rounded-lg text-slate-600 hover:bg-gray-50">下一页</button>
                    </div>

                </div>
            </main>
            <div id="toast"></div>

            <%@ include file="footer.jsp" %>

                <script
                    src="${pageContext.request.contextPath}/static/js/browse.js?v=${System.currentTimeMillis()}"></script>
    </body>

    </html>