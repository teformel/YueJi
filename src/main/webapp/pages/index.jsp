<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>阅己 YueJi - 探索无限故事</title>
        <link rel="stylesheet" href="../static/css/style.css?v=3">
        <script src="../static/js/lucide.js"></script>
        <script src="../static/js/script.js"></script>
    </head>

    <body class="bg-gray-50 min-h-screen">
        <%@ include file="header.jsp" %>

            <main class="py-10">
                <div class="container space-y-16">

                    <!-- Standard Hero Section -->
                    <section class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
                        <div class="space-y-8">
                            <div class="space-y-4">
                                <span
                                    class="inline-block px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-xs font-bold tracking-wide uppercase">本周精选</span>
                                <h1 class="text-4xl lg:text-6xl font-black text-slate-900 leading-tight">
                                    阅见<span class="text-blue-600">新世界</span>
                                </h1>
                                <p class="text-lg text-slate-600 leading-relaxed max-w-lg">
                                    在这个被文字编织的故事之城，每一页都是通往异世界的门扉。我们精选了本周最受瞩目的佳作，邀您共同开启一段波澜壮阔的旅程。
                                </p>
                            </div>

                            <!-- Search Box (Integrated in Hero) -->
                            <div
                                class="flex items-center p-2 bg-white border border-gray-200 rounded-lg shadow-sm max-w-md focus-within:ring-2 focus-within:ring-blue-500/20 focus-within:border-blue-500 transition-all">
                                <i data-lucide="search" class="ml-3 w-5 h-5 text-gray-400"></i>
                                <input type="text" id="searchInput"
                                    class="flex-1 px-4 py-2 outline-none text-slate-700 placeholder-gray-400 bg-transparent"
                                    placeholder="搜索书名、作者...">
                                <button onclick="handleSearch()"
                                    class="px-6 py-2 bg-slate-900 text-white font-medium rounded-md hover:bg-slate-800 transition-colors">
                                    搜索
                                </button>
                            </div>
                        </div>

                        <!-- Hero Image -->
                        <div
                            class="relative rounded-2xl overflow-hidden shadow-2xl aspect-[4/3] lg:aspect-auto lg:h-[500px]">
                            <img src="../static/images/hero.jpg" class="w-full h-full object-cover">
                            <!-- Gradient Overlay for lower text contrast if needed, strictly subtle -->
                            <div class="absolute inset-0 bg-gradient-to-t from-slate-900/20 to-transparent"></div>
                        </div>
                    </section>

                    <!-- Main Content Grid -->
                    <div class="grid grid-cols-1 lg:grid-cols-12 gap-10">

                        <!-- Novel Grid (8 cols) -->
                        <div class="lg:col-span-8 space-y-8">
                            <div class="flex items-center justify-between border-b border-gray-200 pb-4">
                                <h2 class="text-2xl font-bold text-slate-900 flex items-center gap-2">
                                    <i data-lucide="sparkles" class="w-6 h-6 text-yellow-500"></i> 精选推荐
                                </h2>
                                <button onclick="loadNovels()"
                                    class="p-2 text-slate-400 hover:text-blue-600 transition-colors">
                                    <i data-lucide="refresh-cw" class="w-5 h-5"></i>
                                </button>
                            </div>

                            <div id="novelGrid" class="grid grid-cols-2 md:grid-cols-3 gap-6">
                                <!-- Loading State -->
                                <div class="col-span-full py-12 text-center text-slate-400">正在加载书库资源...</div>
                            </div>
                        </div>

                        <!-- Sidebar (4 cols) -->
                        <aside class="lg:col-span-4 space-y-10">
                            <!-- Rankings -->
                            <div class="bg-white rounded-xl border border-gray-200 p-6 shadow-sm">
                                <h3 class="text-lg font-bold text-slate-900 mb-6 flex items-center gap-2">
                                    <i data-lucide="trophy" class="w-5 h-5 text-orange-500"></i> 风云榜
                                </h3>
                                <div id="rankingList" class="space-y-1">
                                    <!-- Skeleton -->
                                    <div class="h-10 bg-gray-100 rounded animate-pulse"></div>
                                    <div class="h-10 bg-gray-100 rounded animate-pulse"></div>
                                    <div class="h-10 bg-gray-100 rounded animate-pulse"></div>
                                </div>
                            </div>

                            <!-- CTA -->
                            <div class="bg-slate-900 rounded-xl p-8 text-center text-white shadow-lg">
                                <h4 class="text-xl font-bold mb-2">成为创作者</h4>
                                <p class="text-slate-300 text-sm mb-6">让您的想象力绽放。每一位伟大的作者都始于第一行文字。</p>
                                <button
                                    class="w-full py-3 bg-white text-slate-900 font-bold rounded-lg hover:bg-gray-100 transition-colors">
                                    立即投稿
                                </button>
                            </div>
                        </aside>
                    </div>

                </div>
            </main>

            <%@ include file="footer.jsp" %>

                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        loadNovels();
                        lucide.createIcons();
                    });

                    async function loadNovels() {
                        const grid = document.getElementById('novelGrid');
                        try {
                            const result = await fetchJson("../novel/list");
                            if (result && result.status === 200 && result.data.code === 200) {
                                const novels = result.data.data;
                                renderGrid(novels.slice(0, 9));
                                renderRankings(novels.slice(0, 5));
                            } else {
                                grid.innerHTML = '<p class="col-span-full text-center text-slate-500">暂无数据</p>';
                            }
                        } catch (e) {
                            console.error("加载失败:", e);
                            grid.innerHTML = '<p class="col-span-full text-center text-red-500">连接服务器失败</p>';
                        }
                    }

                    function renderGrid(novels) {
                        const container = document.getElementById('novelGrid');
                        if (!novels.length) {
                            container.innerHTML = '<div class="col-span-full py-12 text-center text-slate-400">暂无书籍</div>';
                            return;
                        }
                        container.innerHTML = novels.map(n => `
                <div class="standard-card group cursor-pointer" onclick="location.href='novel_detail.jsp?id=\${n.id}'">
                    <div class="aspect-[2/3] overflow-hidden bg-gray-100 relative">
                        <img src="\${n.coverUrl || '../static/images/cover_placeholder.jpg'}" 
                             class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                             onerror="this.src='../static/images/cover_placeholder.jpg'">
                    </div>
                    <div class="p-4">
                        <h4 class="font-bold text-slate-900 truncate mb-1 group-hover:text-blue-600 transition-colors">\${n.title}</h4>
                        <p class="text-xs text-slate-500 font-medium uppercase tracking-wide">\${n.authorName || '佚名'}</p>
                    </div>
                </div>
            `).join('');
                        lucide.createIcons();
                    }

                    function renderRankings(novels) {
                        const container = document.getElementById('rankingList');
                        container.innerHTML = novels.map((n, i) => `
                <div class="flex items-center gap-4 p-3 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors" onclick="location.href='novel_detail.jsp?id=\${n.id}'">
                    <span class="text-lg font-black w-6 text-center \${i < 3 ? 'text-orange-500' : 'text-slate-300'}">\${i + 1}</span>
                    <div class="flex-1 min-w-0">
                        <div class="text-sm font-bold text-slate-700 truncate hover:text-blue-600 transition-colors">\${n.title}</div>
                        <div class="text-xs text-slate-400">\${n.category || '综合'}</div>
                    </div>
                </div>
            `).join('');
                    }

                    async function handleSearch() {
                        const q = document.getElementById('searchInput').value.trim();
                        if (!q) return;
                        location.href = `index.jsp?keyword=\${encodeURIComponent(q)}`;
                    }

                    document.getElementById('searchInput').addEventListener('keypress', (e) => {
                        if (e.key === 'Enter') handleSearch();
                    });
                </script>
    </body>

    </html>