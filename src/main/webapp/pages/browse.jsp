<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <jsp:useBean id="now" class="java.util.Date" />
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>分类浏览 - 阅己 YueJi</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css?v=${now.time}">
        <script src="${pageContext.request.contextPath}/static/js/lucide.js"></script>
        <script src="${pageContext.request.contextPath}/static/js/script.js?v=${now.time}"></script>
    </head>

    <body class="bg-gray-50 min-h-screen flex flex-col">
        <%@ include file="header.jsp" %>

            <main class="flex-1 py-8">
                <div class="container">

                    <!-- Filter Bar -->
                    <div class="bg-white rounded-xl border border-gray-200 shadow-sm p-6 mb-8 space-y-6">
                        <!-- Categories -->
                        <div class="flex flex-wrap items-center gap-3" id="categoryFilter">
                            <span class="text-sm font-bold text-slate-400 uppercase tracking-wide mr-2">分类</span>
                            <button
                                class="filter-btn active px-3 py-1 bg-slate-100 text-slate-900 rounded-md text-sm font-bold hover:bg-slate-200 transition-colors"
                                data-type="category" data-val="all">全部</button>
                            <!-- Dynamic -->
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
                    <!-- Pagination (Dynamic) -->
                    <div id="paginationContainer" class="flex justify-center mt-12 gap-2">
                        <!-- Injected by JS -->
                    </div>

                </div>
            </main>
            <div id="toast"></div>

            <%@ include file="footer.jsp" %>

                <script src="${pageContext.request.contextPath}/static/js/browse.js?v=${now.time}"></script>
    </body>

    </html>