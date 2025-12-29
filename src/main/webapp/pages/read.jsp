<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <jsp:useBean id="now" class="java.util.Date" />
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>阅读 - 阅己 YueJi</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css?v=${now.time}">
        <script src="${pageContext.request.contextPath}/static/js/lucide.js"></script>
        <script src="${pageContext.request.contextPath}/static/js/script.js?v=${now.time}"></script>
        <style>
            /* Specific Reader Tweaks */
            .reader-content {
                font-family: "Noto Serif SC", serif;
                font-size: 1.25rem;
                line-height: 2;
                text-align: justify;
            }

            .reader-content p {
                margin-bottom: 1.5rem;
                text-indent: 2em;
            }
        </style>
    </head>

    <body class="bg-[#f0f2f5] min-h-screen text-[#2c3e50]">

        <!-- Reader Header (Float/Fixed) -->
        <header class="fixed top-0 w-full bg-white/95 backdrop-blur shadow-sm z-50 transition-transform duration-300"
            id="readerHeader">
            <div class="container h-14 flex items-center justify-between">
                <a href="#" id="backLink"
                    class="flex items-center gap-2 text-slate-600 hover:text-blue-600 text-sm font-bold">
                    <i data-lucide="chevron-left" class="w-5 h-5"></i> 返回书页
                </a>
                <span id="chapterTitleHeader" class="text-sm font-bold text-slate-900 truncate max-w-xs">加载中...</span>
                <div class="flex items-center gap-4">
                    <button onclick="toggleSettings()" class="text-slate-400 hover:text-slate-900 transition-colors"
                        title="阅读设置">
                        <i data-lucide="settings-2" class="w-5 h-5"></i>
                    </button>
                    <a href="index.jsp" class="text-slate-400 hover:text-slate-900"><i data-lucide="home"
                            class="w-5 h-5"></i></a>
                </div>
            </div>
        </header>

        <div class="pt-24 pb-32 container max-w-3xl">
            <article class="bg-white rounded-xl shadow-sm px-8 py-12 md:px-16 md:py-20 min-h-[80vh]">
                <h1 id="chapterTitle" class="text-3xl font-black text-slate-900 mb-12 text-center leading-tight">...
                </h1>

                <div id="content" class="reader-content text-slate-700">
                    <div class="space-y-6 animate-pulse">
                        <div class="h-4 bg-gray-100 rounded"></div>
                        <div class="h-4 bg-gray-100 rounded w-11/12"></div>
                        <div class="h-4 bg-gray-100 rounded w-10/12"></div>
                    </div>
                </div>
            </article>

            <!-- Floating Sidebar Settings (Hidden by default) -->
            <div id="settingsPanel"
                class="fixed right-0 top-1/2 -translate-y-1/2 bg-white/95 backdrop-blur-md shadow-2xl border-l border-y border-gray-100 rounded-l-2xl p-6 z-50 translate-x-full transition-transform duration-300 w-64">
                <h4 class="text-sm font-black text-slate-900 mb-6 flex items-center gap-2">
                    <i data-lucide="settings-2" class="w-4 h-4"></i> 阅读设置
                </h4>

                <div class="space-y-8">
                    <!-- Font Size -->
                    <div>
                        <label
                            class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">字号大小</label>
                        <div class="flex items-center justify-between gap-4">
                            <button onclick="changeFontSize(-0.1)"
                                class="w-10 h-10 rounded-lg bg-gray-50 flex items-center justify-center text-slate-600 hover:bg-blue-50 hover:text-blue-600 transition-colors">
                                <i data-lucide="minus" class="w-4 h-4"></i>
                            </button>
                            <span id="fontSizeDisplay" class="text-sm font-bold text-slate-700">1.25rem</span>
                            <button onclick="changeFontSize(0.1)"
                                class="w-10 h-10 rounded-lg bg-gray-50 flex items-center justify-center text-slate-600 hover:bg-blue-50 hover:text-blue-600 transition-colors">
                                <i data-lucide="plus" class="w-4 h-4"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Themes -->
                    <div>
                        <label
                            class="block text-[10px] font-black text-slate-400 uppercase tracking-widest mb-3">阅读背景</label>
                        <div class="grid grid-cols-4 gap-2">
                            <button onclick="setTheme('default')" id="theme-default"
                                class="w-full aspect-square rounded-full border-2 border-blue-500 bg-[#f0f2f5]"
                                title="默认"></button>
                            <button onclick="setTheme('parchment')" id="theme-parchment"
                                class="w-full aspect-square rounded-full border border-gray-100 bg-[#f4ecd8]"
                                title="雅致"></button>
                            <button onclick="setTheme('green')" id="theme-green"
                                class="w-full aspect-square rounded-full border border-gray-100 bg-[#c7edcc]"
                                title="护眼"></button>
                            <button onclick="setTheme('night')" id="theme-night"
                                class="w-full aspect-square rounded-full border border-gray-100 bg-[#1a1c1e]"
                                title="夜间"></button>
                        </div>
                    </div>

                    <!-- Stats -->
                    <div class="pt-4 border-t border-gray-100">
                        <div class="flex items-center justify-between text-[10px] font-bold text-slate-400">
                            <span>阅读时长</span>
                            <span id="readingTimeDisplay" class="text-blue-600">00:00</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Navigation -->
            <div class="mt-10 grid grid-cols-2 gap-4">
                <button id="prevBtn" onclick="goPrev()"
                    class="p-4 bg-white rounded-lg border border-gray-200 text-slate-600 font-bold hover:bg-blue-50 hover:text-blue-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                    上一章
                </button>
                <button id="nextBtn" onclick="goNext()"
                    class="p-4 bg-blue-600 rounded-lg shadow-lg shadow-blue-500/20 text-white font-bold hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                    下一章
                </button>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/static/js/read.js?v=${now.time}"></script>

    </body>

    </html>