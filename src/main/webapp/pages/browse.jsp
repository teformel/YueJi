<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>分类浏览 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/css/style.css?v=3">
        <script src="../static/js/lucide.js"></script>
        <script src="../static/js/script.js"></script>
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

                <script>
                    // Filter Logic
                    let currentFilters = {
                        category: 'all',
                        status: 'all'
                    };

                    document.addEventListener('DOMContentLoaded', () => {
                        initFilters();
                        loadBooks();
                        lucide.createIcons();

                        // Check URL param for initial category
                        const catParam = getQueryParam('category');
                        if (catParam) {
                            setFilter('category', catParam);
                        }
                    });

                    function initFilters() {
                        document.querySelectorAll('.filter-btn').forEach(btn => {
                            btn.addEventListener('click', () => {
                                const type = btn.dataset.type;
                                const val = btn.dataset.val;
                                setFilter(type, val);
                            });
                        });
                    }

                    function setFilter(type, val) {
                        currentFilters[type] = val;

                        // Update UI
                        document.querySelectorAll(`.filter-btn[data-type="\${type}"]`).forEach(b => {
                            if (b.dataset.val === val) {
                                b.classList.add('active', 'bg-slate-100', 'text-slate-900');
                                b.classList.remove('text-slate-600');
                            } else {
                                b.classList.remove('active', 'bg-slate-100', 'text-slate-900');
                                b.classList.add('text-slate-600');
                            }
                        });

                        loadBooks();
                    }

                    async function loadBooks() {
                        const container = document.getElementById('browseGrid');

                        try {
                            // Fetch all novels from backend
                            // Note: Production apps should filter on backend, but for this scale client-side is fine or we can pass params
                            const result = await fetchJson("../novel/list");
                            if (!result || result.code !== 200) {
                                container.innerHTML = '<div class="col-span-full py-20 text-center text-red-500">加载失败</div>';
                                return;
                            }

                            const allNovels = result.data;

                            let filtered = allNovels.filter(n => {
                                // Backend returns category_id, frontend uses names. 
                                // Mapping might be needed if n.category is ID. 
                                // NovelDao maps category name to n.categoryName.
                                // browse.jsp uses 'category' name matching.

                                // Check data structure from NovelDaoImpl:
                                // n.setCategoryName(rs.getString("category_name"));
                                // Frontend expects n.category (from old MockDB).
                                // We need to normalize this.
                                const catName = n.categoryName || n.category || '其他';
                                const statusVal = n.status === 2 ? '已完结' : '连载中'; // 1: Serial, 2: Finished (Assuming)

                                if (currentFilters.category !== 'all' && catName !== currentFilters.category) return false;
                                if (currentFilters.status !== 'all' && statusVal !== currentFilters.status) return false;
                                return true;
                            });

                            if (filtered.length === 0) {
                                container.innerHTML = `<div class="col-span-full py-20 text-center text-slate-400">暂无符合条件的书籍</div>`;
                                return;
                            }

                            container.innerHTML = filtered.map(n => `
                <div class="standard-card group cursor-pointer" onclick="location.href='novel_detail.jsp?id=\${n.id}'">
                    <div class="aspect-[2/3] overflow-hidden bg-gray-100 relative rounded-t-lg">
                        <img src="\${n.cover || '../static/images/cover_placeholder.jpg'}" 
                             class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                             onerror="this.src='../static/images/cover_placeholder.jpg'">
                        <div class="absolute top-2 right-2 px-2 py-1 bg-black/60 backdrop-blur rounded text-[10px] text-white font-bold">
                            \${n.status === 2 ? '已完结' : '连载中'}
                        </div>
                    </div>
                    <div class="p-3">
                        <h4 class="font-bold text-slate-900 truncate mb-1 text-sm group-hover:text-blue-600 transition-colors">\${n.name}</h4>
                        <div class="flex items-center justify-between text-xs text-slate-500">
                             <span class="font-medium">\${n.authorName || '佚名'}</span>
                             <span class="text-slate-400">\${n.categoryName || '综合'}</span>
                        </div>
                    </div>
                </div>
            `).join('');
                        } catch (e) {
                            console.error(e);
                            container.innerHTML = '<div class="col-span-full py-20 text-center text-red-500">加载出错</div>';
                        }
                    }
                </script>
    </body>

    </html>