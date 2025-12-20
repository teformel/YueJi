<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>阅己 YueJi - 探索无限故事</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
    </head>

    <body class="bg-glow">
        <%@ include file="header.jsp" %>

            <main class="container py-8 reveal">
                <!-- V2 Theater Hero Spotlight -->
                <section class="mb-16">
                    <div class="luminous-panel rounded-[3rem] p-1 overflow-hidden relative group">
                        <div class="flex flex-col lg:flex-row items-stretch min-h-[460px]">
                            <!-- Spotlight Image -->
                            <div class="lg:w-1/2 relative overflow-hidden">
                                <img src="https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&q=80&w=1200"
                                    class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
                                    alt="Feature">
                                <div
                                    class="absolute inset-0 bg-gradient-to-r from-canvas via-transparent to-transparent hidden lg:block">
                                </div>
                            </div>
                            <!-- Spotlight Content -->
                            <div
                                class="lg:w-1/2 p-10 lg:p-16 flex flex-col justify-center relative bg-canvas/40 backdrop-blur-sm lg:backdrop-blur-0">
                                <div class="flex items-center gap-3 mb-6">
                                    <span
                                        class="px-3 py-1 rounded-full bg-primary/20 text-primary text-xs font-bold tracking-widest uppercase">今日聚焦</span>
                                    <span class="text-text-dim text-xs">• 1.2w 人在读</span>
                                </div>
                                <h1 class="text-5xl lg:text-7xl font-black mb-6 leading-[1.1]">阅见<span
                                        class="text-primary">新境</span></h1>
                                <p class="text-text-muted text-lg mb-10 max-w-lg leading-relaxed">
                                    在这个被光影编织的故事之城，每一页都是通往异世界的门扉。我们精选了本周最受瞩目的文字，邀您共同开启一段波澜壮阔的旅程。
                                </p>
                                <div class="flex items-center gap-4">
                                    <button class="btn-ultimate px-10 py-4 text-lg">开启阅读</button>
                                    <button
                                        class="w-14 h-14 rounded-full border border-border-dim flex items-center justify-center hover:bg-white/5 transition-all text-text-muted hover:text-white">
                                        <i data-lucide="bookmark-plus" class="w-6 h-6"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <!-- Search Floating bar -->
                        <div class="absolute bottom-10 right-10 left-10 lg:left-auto lg:right-16 lg:w-[450px]">
                            <div class="relative group/search">
                                <div
                                    class="absolute -inset-1 bg-gradient-to-r from-primary/30 to-accent/30 rounded-2xl blur opacity-0 group-focus-within/search:opacity-100 transition-opacity">
                                </div>
                                <div
                                    class="relative flex items-center bg-surface-elevated border border-border-highlight rounded-2xl overflow-hidden shadow-2xl">
                                    <i data-lucide="search" class="ml-5 w-5 h-5 text-text-dim"></i>
                                    <input type="text" id="searchInput" placeholder="搜索书名、作者或关键词..."
                                        class="flex-1 bg-transparent px-4 py-5 outline-none text-white text-base">
                                    <button onclick="handleSearch()"
                                        class="px-6 py-5 bg-white/5 hover:bg-white/10 text-white font-bold border-l border-border-highlight transition-all">
                                        寻找
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Multi-Dimensional Content Matrix -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-12">
                    <!-- Left: Curated Masterpieces (Grid) -->
                    <div class="lg:col-span-8">
                        <div class="flex items-center justify-between mb-8">
                            <h2 class="text-3xl font-black flex items-center gap-3">
                                <i data-lucide="sparkles" class="w-8 h-8 text-primary"></i>
                                精选作品
                            </h2>
                            <div class="flex gap-2">
                                <button onclick="loadNovels()"
                                    class="p-2 rounded-xl bg-surface-elevated hover:bg-slate-700 transition-all text-text-dim">
                                    <i data-lucide="refresh-cw" class="w-5 h-5"></i>
                                </button>
                            </div>
                        </div>
                        <div id="novelGrid" class="grid grid-cols-2 md:grid-cols-3 gap-6">
                            <!-- Cards will be injected here -->
                            <div class="col-span-full py-20 text-center opacity-30">正在同步书卷资源...</div>
                        </div>
                    </div>

                    <!-- Right: Rankings -->
                    <div class="lg:col-span-4 space-y-12">
                        <section>
                            <h2 class="text-2xl font-black mb-8 flex items-center gap-3">
                                <i data-lucide="crown" class="w-6 h-6 text-accent"></i>
                                风云榜单
                            </h2>
                            <div id="rankingList" class="space-y-4">
                                <!-- Rankings injected here -->
                                <div class="py-10 text-center opacity-20 italic">正在排位中...</div>
                            </div>
                        </section>

                        <div
                            class="luminous-panel rounded-3xl p-8 bg-gradient-to-br from-accent/10 to-transparent border border-accent/20">
                            <h4 class="text-lg font-black text-white mb-2">加入创作者行列</h4>
                            <p class="text-sm text-text-dim mb-6">让您的想象力在悦己的空间绽放。每一位伟大的作者都始于第一行文字。</p>
                            <button
                                class="w-full py-3 bg-white/5 hover:bg-white/10 border border-white/10 rounded-xl text-white font-bold transition-all">
                                立即投稿
                            </button>
                        </div>
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
                        const rank = document.getElementById('rankingList');

                        try {
                            const data = await fetchJson("${pageContext.request.contextPath}/novel/list");
                            if (data && data.status === 200) {
                                const novels = data.data;
                                renderGrid(novels.slice(0, 9));
                                renderRankings(novels.slice(0, 5));
                            }
                        } catch (e) {
                            grid.innerHTML = '<p class="col-span-full text-center text-text-dim">云端连接受阻，请刷新重试</p>';
                        }
                    }

                    function renderGrid(novels) {
                        const container = document.getElementById('novelGrid');
                        if (!novels.length) {
                            container.innerHTML = '<p class="col-span-full text-center opacity-30">这里暂时是一片荒野...</p>';
                            return;
                        }
                        container.innerHTML = novels.map(n => `
                <div class="theater-card reveal" onclick="location.href='novel_detail.jsp?id=\${n.id}'">
                     <div class="cover-wrapper aspect-[3/4]">
                         <img src="https://images.unsplash.com/photo-1543004471-240ce49a2a2f?w=400" alt="\${n.title}">
                     </div>
                     <div class="overlay p-4">
                         <h4 class="text-sm font-black text-white truncate">\${n.title}</h4>
                         <p class="text-[10px] text-text-dim mt-1 font-bold tracking-widest uppercase">\${n.authorName || '佚名'}</p>
                     </div>
                </div>
            `).join('');
                        lucide.createIcons();
                    }

                    function renderRankings(novels) {
                        const container = document.getElementById('rankingList');
                        container.innerHTML = novels.map((n, i) => `
                <div class="v2-ranking-item group cursor-pointer" onclick="location.href='novel_detail.jsp?id=\${n.id}'">
                    <div class="rank-num \${i < 3 ? 'text-accent' : 'text-text-dim'}">\${i + 1}</div>
                    <div class="rank-info flex-1">
                        <div class="text-sm font-black text-white group-hover:text-primary transition-colors">\${n.title}</div>
                        <div class="text-[10px] text-text-muted font-bold">\${n.category || '通俗文采'}</div>
                    </div>
                </div>
            `).join('');
                    }

                    async function handleSearch() {
                        const q = document.getElementById('searchInput').value.trim();
                        if (!q) return;
                        location.href = "${pageContext.request.contextPath}/pages/index.jsp?keyword=" + encodeURIComponent(q);
                    }

                    document.getElementById('searchInput').addEventListener('keypress', (e) => {
                        if (e.key === 'Enter') handleSearch();
                    });
                </script>
    </body>

    </html>