<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>上帝模式 - 阅己 YueJi 管理后台</title>

        <link rel="stylesheet" href="../static/css/style.css?v=2">
        <script src="../static/js/script.js"></script>
        <style>
            /* Override Tailwind Preflight collisions if necessary */
            /* Ensuring hidden works is key first step */
            .hidden {
                display: none !important;
            }
        </style>
    </head>

    <body class="bg-glow text-slate-100">
        <%@ include file="header.jsp" %>

            <main class="container py-12 reveal mx-auto px-4">
                <div class="flex items-center gap-6 mb-12">
                    <div
                        class="w-16 h-16 rounded-3xl bg-primary/20 flex items-center justify-center text-primary shadow-2xl relative group shrink-0">
                        <div
                            class="absolute inset-0 bg-primary/40 blur-xl opacity-0 group-hover:opacity-100 transition-opacity">
                        </div>
                        <i data-lucide="crown" class="w-8 h-8 relative z-10"></i>
                    </div>
                    <div>
                        <h1
                            class="text-3xl md:text-5xl font-black tracking-tighter text-white uppercase italic flex items-baseline gap-3">
                            <span style="font-family: var(--font-serif);"
                                class="not-italic font-black text-white/90">上帝模式</span>
                            <span class="text-primary text-xl font-mono not-italic tracking-normal opacity-50">v2.1
                                商业版</span>
                        </h1>
                        <p class="text-text-muted font-bold tracking-[0.3em] text-[10px] mt-1 uppercase opacity-60">
                            掌控每一像素，每一文字，每一世界。</p>
                    </div>
                </div>

                <div class="flex flex-col lg:flex-row gap-8">
                    <!-- 全局导航 -->
                    <aside class="w-full lg:w-80 space-y-8 shrink-0">
                        <nav class="luminous-panel rounded-[2.5rem] p-4 space-y-2">
                            <div
                                class="px-5 py-3 text-[10px] font-black text-primary uppercase tracking-[0.3em] opacity-80">
                                导航枢纽
                            </div>
                            <button onclick="showSection('author')"
                                class="uc-nav-item active flex items-center gap-4 w-full" id="btn-author">
                                <div
                                    class="w-10 h-10 rounded-2xl bg-white/5 flex items-center justify-center group-hover:bg-primary/20 transition-colors">
                                    <i data-lucide="user-plus" class="w-5 h-5"></i>
                                </div>
                                <span class="font-bold">新作者录入</span>
                            </button>
                            <button onclick="showSection('novel')" class="uc-nav-item flex items-center gap-4 w-full"
                                id="btn-novel">
                                <div
                                    class="w-10 h-10 rounded-2xl bg-white/5 flex items-center justify-center group-hover:bg-primary/20 transition-colors">
                                    <i data-lucide="book-plus" class="w-5 h-5"></i>
                                </div>
                                <span class="font-bold">新作品发布</span>
                            </button>
                            <button onclick="showSection('chapter')" class="uc-nav-item flex items-center gap-4 w-full"
                                id="btn-chapter">
                                <div
                                    class="w-10 h-10 rounded-2xl bg-white/5 flex items-center justify-center group-hover:bg-primary/20 transition-colors">
                                    <i data-lucide="file-plus" class="w-5 h-5"></i>
                                </div>
                                <span class="font-bold">章节更新</span>
                            </button>

                            <div class="my-6 border-t border-white/5 mx-4"></div>

                            <button onclick="showSection('manage')" class="uc-nav-item flex items-center gap-4 w-full"
                                id="btn-manage">
                                <div
                                    class="w-10 h-10 rounded-2xl bg-white/5 flex items-center justify-center group-hover:bg-accent/20 transition-colors">
                                    <i data-lucide="layout-grid" class="w-5 h-5"></i>
                                </div>
                                <span class="font-bold">内容管控台</span>
                            </button>
                        </nav>

                        <div
                            class="luminous-panel rounded-[2.5rem] p-8 bg-gradient-to-br from-primary/10 via-transparent to-accent/5 relative overflow-hidden group">
                            <div
                                class="absolute -right-8 -bottom-8 w-24 h-24 bg-primary/20 blur-3xl rounded-full group-hover:scale-150 transition-transform">
                            </div>
                            <div class="relative z-10">
                                <div class="flex items-center justify-between mb-6">
                                    <div class="text-[10px] font-black text-white/40 uppercase tracking-[0.2em]">系统环境监测
                                    </div>
                                    <span class="flex h-2 w-2 relative">
                                        <span
                                            class="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-400 opacity-75"></span>
                                        <span class="relative inline-flex rounded-full h-2 w-2 bg-green-500"></span>
                                    </span>
                                </div>
                                <div class="space-y-4">
                                    <div class="flex justify-between items-center text-xs">
                                        <span class="text-text-dim">核心引擎</span>
                                        <span class="font-mono text-white">运行中</span>
                                    </div>
                                    <div class="flex justify-between items-center text-xs">
                                        <span class="text-text-dim">同步延迟</span>
                                        <span class="font-mono text-primary">0.42毫秒</span>
                                    </div>
                                    <div class="flex justify-between items-center text-xs">
                                        <span class="text-text-dim">安全等级</span>
                                        <span class="font-mono text-accent">5级防护</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </aside>

                    <!-- 工作区 -->
                    <section class="flex-1 min-h-[700px]">
                        <div class="luminous-panel rounded-[3rem] p-6 md:p-14 relative overflow-hidden h-full">
                            <div
                                class="absolute -top-40 -right-40 w-96 h-96 bg-primary/5 blur-[150px] rounded-full pointer-events-none">
                            </div>

                            <!-- 作者板块 -->
                            <div id="sec-author" class="admin-section active space-y-12">
                                <div class="relative">
                                    <div class="flex items-center gap-4 mb-2">
                                        <div class="w-1.5 h-10 bg-primary rounded-full"></div>
                                        <h3 class="text-4xl font-black text-white tracking-tighter"
                                            style="font-family: var(--font-serif);">录入新作者</h3>
                                    </div>
                                    <p class="text-text-muted ml-6 font-medium">定义文学世界的创造者，记录他们的精神印记。</p>
                                </div>

                                <div
                                    class="grid grid-cols-1 md:grid-cols-2 gap-10 bg-white/5 p-8 md:p-12 rounded-[2.5rem] border border-white/5 relative group">
                                    <div
                                        class="absolute inset-x-0 -bottom-px h-px bg-gradient-to-r from-transparent via-primary/30 to-transparent">
                                    </div>
                                    <input type="hidden" id="authorId">

                                    <div class="space-y-4">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-primary uppercase tracking-[0.2em]">
                                            <i data-lucide="at-sign" class="w-4 h-4"></i>
                                            作者姓名
                                        </label>
                                        <input id="authorName"
                                            class="v2-admin-input bg-black/40 border-white/5 focus:bg-black/60 transition-all text-lg font-bold"
                                            placeholder="实名或笔名...">
                                    </div>

                                    <div class="space-y-4">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-primary uppercase tracking-[0.2em]">
                                            <i data-lucide="user-circle" class="w-4 h-4"></i>
                                            关联系统账号
                                        </label>
                                        <div class="relative">
                                            <select id="authorUserId"
                                                class="v2-admin-input bg-black/40 border-white/5 appearance-none cursor-pointer pr-10 focus:bg-black/60 transition-all font-bold">
                                                <option value="">不关联账号 (仅展示名义作者)</option>
                                            </select>
                                            <i data-lucide="chevron-down"
                                                class="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-text-dim pointer-events-none"></i>
                                        </div>
                                    </div>

                                    <div class="space-y-4 md:col-span-2">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-primary uppercase tracking-[0.2em]">
                                            <i data-lucide="quote" class="w-4 h-4"></i>
                                            灵魂简介
                                        </label>
                                        <textarea id="authorBio"
                                            class="v2-admin-input bg-black/40 border-white/5 focus:bg-black/60 transition-all h-40 resize-none pt-5 text-base"
                                            placeholder="描述其文字风格、创作理念..."></textarea>
                                    </div>
                                </div>

                                <div class="flex items-center gap-6 mt-10">
                                    <button
                                        class="btn-ultimate px-16 py-6 text-lg shadow-[0_20px_50px_rgba(139,92,246,0.3)]"
                                        onclick="submitAuthor()">
                                        <i data-lucide="zap" class="w-6 h-6"></i>
                                        <span id="authorBtnText">执行录入程序</span>
                                    </button>
                                    <button id="authorCancelBtn"
                                        class="hidden px-10 py-6 border border-white/10 rounded-2xl text-text-dim hover:text-white hover:bg-white/5 transition-all font-bold"
                                        onclick="resetAuthorForm()">终止当前任务</button>
                                </div>
                            </div>

                            <!-- 作品板块 -->
                            <div id="sec-novel" class="admin-section hidden space-y-12">
                                <div class="relative">
                                    <div class="flex items-center gap-4 mb-2">
                                        <div class="w-1.5 h-10 bg-accent rounded-full"></div>
                                        <h3 class="text-4xl font-black text-white tracking-tighter"
                                            style="font-family: var(--font-serif);">发布新作品</h3>
                                    </div>
                                    <p class="text-text-muted ml-6 font-medium">开启一段全新的数字传奇，让世界通过文字链接。</p>
                                </div>

                                <div
                                    class="grid grid-cols-1 md:grid-cols-2 gap-8 bg-white/5 p-8 md:p-12 rounded-[2.5rem] border border-white/5 relative group">
                                    <div
                                        class="absolute inset-x-0 -bottom-px h-px bg-gradient-to-r from-transparent via-accent/30 to-transparent">
                                    </div>
                                    <input type="hidden" id="novelId">

                                    <div class="space-y-4">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-accent uppercase tracking-[0.2em] opacity-80">
                                            <i data-lucide="type" class="w-4 h-4"></i>
                                            作品标题
                                        </label>
                                        <input id="novelTitle"
                                            class="v2-admin-input bg-black/40 border-white/5 focus:bg-black/60 transition-all font-bold"
                                            placeholder="吸引目光的项目代号...">
                                    </div>

                                    <div class="space-y-4">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-accent uppercase tracking-[0.2em] opacity-80">
                                            <i data-lucide="users" class="w-4 h-4"></i>
                                            创建者绑定
                                        </label>
                                        <div class="relative">
                                            <select id="novelAuthor"
                                                class="v2-admin-input bg-black/40 border-white/5 appearance-none cursor-pointer pr-10 focus:bg-black/60 transition-all font-bold">
                                                <option value="">选择核心作者...</option>
                                            </select>
                                            <i data-lucide="chevron-down"
                                                class="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-text-dim pointer-events-none"></i>
                                        </div>
                                    </div>

                                    <div class="space-y-4">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-accent uppercase tracking-[0.2em] opacity-80">
                                            <i data-lucide="layers" class="w-4 h-4"></i>
                                            分法协议 (分类)
                                        </label>
                                        <div class="relative">
                                            <select id="novelCategory"
                                                class="v2-admin-input bg-black/40 border-white/5 appearance-none cursor-pointer pr-10 focus:bg-black/60 transition-all font-bold">
                                                <option value="玄幻">玄幻</option>
                                                <option value="悬疑">悬疑</option>
                                                <option value="都市">都市</option>
                                            </select>
                                            <i data-lucide="chevron-down"
                                                class="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-text-dim pointer-events-none"></i>
                                        </div>
                                    </div>

                                    <div class="space-y-4">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-accent uppercase tracking-[0.2em] opacity-80">
                                            <i data-lucide="shield" class="w-4 h-4"></i>
                                            访问许可
                                        </label>
                                        <div class="relative">
                                            <select id="novelIsFree"
                                                class="v2-admin-input bg-black/40 border-white/5 appearance-none cursor-pointer pr-10 focus:bg-black/60 transition-all font-bold">
                                                <option value="1">公开分发 (免费)</option>
                                                <option value="0">加密分发 (金币订阅)</option>
                                            </select>
                                            <i data-lucide="chevron-down"
                                                class="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-text-dim pointer-events-none"></i>
                                        </div>
                                    </div>

                                    <div class="space-y-4 md:col-span-2">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-accent uppercase tracking-[0.2em] opacity-80">
                                            <i data-lucide="image" class="w-4 h-4"></i>
                                            视觉载荷 (封面 URL)
                                        </label>
                                        <input id="novelCover"
                                            class="v2-admin-input bg-black/40 border-white/5 focus:bg-black/60 transition-all"
                                            placeholder="HTTPS://图片资源链接">
                                    </div>

                                    <div class="space-y-4 md:col-span-2">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-accent uppercase tracking-[0.2em] opacity-80">
                                            <i data-lucide="text-quote" class="w-4 h-4"></i>
                                            核心世界观简介
                                        </label>
                                        <textarea id="novelIntro"
                                            class="v2-admin-input bg-black/40 border-white/5 h-40 resize-none pt-5 text-base focus:bg-black/60 transition-all"
                                            placeholder="简述此世界的底层运作逻辑与矛盾核心..."></textarea>
                                    </div>
                                </div>

                                <div class="flex items-center gap-6 mt-10">
                                    <button
                                        class="btn-ultimate bg-accent border-accent/20 hover:border-accent/40 shadow-[0_20px_50px_rgba(14,165,233,0.3)] px-16 py-6 text-lg"
                                        onclick="submitNovel()">
                                        <i data-lucide="rocket" class="w-6 h-6"></i>
                                        <span id="novelBtnText">同步至矩阵</span>
                                    </button>
                                    <button id="novelCancelBtn"
                                        class="hidden px-10 py-6 border border-white/10 rounded-2xl text-text-dim hover:text-white hover:bg-white/5 transition-all font-bold"
                                        onclick="resetNovelForm()">撤销当前操作</button>
                                </div>
                            </div>

                            <!-- 章节板块 -->
                            <div id="sec-chapter" class="admin-section hidden space-y-12">
                                <div class="relative">
                                    <div class="flex items-center gap-4 mb-2">
                                        <div class="w-1.5 h-10 bg-emerald-500 rounded-full"></div>
                                        <h3 class="text-4xl font-black text-white tracking-tighter"
                                            style="font-family: var(--font-serif);">更新后续章节</h3>
                                    </div>
                                    <p class="text-text-muted ml-6 font-medium">延续故事的脉络，为矩阵注入鲜活的一章。</p>
                                </div>

                                <div
                                    class="grid grid-cols-1 md:grid-cols-3 gap-8 bg-white/5 p-8 md:p-12 rounded-[2.5rem] border border-white/5 relative group">
                                    <div
                                        class="absolute inset-x-0 -bottom-px h-px bg-gradient-to-r from-transparent via-primary/30 to-transparent">
                                    </div>
                                    <input type="hidden" id="chapterId">

                                    <div class="space-y-4">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-primary uppercase tracking-[0.2em] opacity-80">目标作品
                                            ID</label>
                                        <input id="chapterNovelId"
                                            class="v2-admin-input bg-black/40 border-white/5 focus:bg-black/60 transition-all font-bold"
                                            placeholder="作品ID">
                                    </div>

                                    <div class="space-y-4">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-primary uppercase tracking-[0.2em] opacity-80">逻辑位序</label>
                                        <input id="chapterSort"
                                            class="v2-admin-input bg-black/40 border-white/5 focus:bg-black/60 transition-all font-bold"
                                            type="number" value="1">
                                    </div>

                                    <div class="space-y-4">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-primary uppercase tracking-[0.2em] opacity-80">消费金币</label>
                                        <input id="chapterPrice"
                                            class="v2-admin-input bg-black/40 border-white/5 focus:bg-black/60 transition-all font-bold"
                                            type="number" value="0">
                                    </div>

                                    <div class="md:col-span-3 space-y-4">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-primary uppercase tracking-[0.2em] opacity-80">章节意志
                                            (标题)</label>
                                        <input id="chapterTitle"
                                            class="v2-admin-input bg-black/40 border-white/5 focus:bg-black/60 transition-all font-black text-xl"
                                            placeholder="例如：第一章 通往未知的阶梯">
                                    </div>

                                    <div class="md:col-span-3 space-y-4">
                                        <label
                                            class="flex items-center gap-3 text-xs font-black text-primary uppercase tracking-[0.2em] opacity-80">意识流正文</label>
                                        <textarea id="chapterContent"
                                            class="v2-admin-input bg-black/40 border-white/5 h-[500px] resize-none pt-8 leading-[2] text-lg font-serif"
                                            placeholder="在此撰写故事的灵魂..."></textarea>
                                    </div>
                                </div>

                                <div class="flex items-center gap-6 mt-10">
                                    <button
                                        class="btn-ultimate px-16 py-6 text-lg shadow-[0_20px_50px_rgba(139,92,246,0.3)]"
                                        onclick="submitChapter()">
                                        <i data-lucide="send" class="w-6 h-6"></i>
                                        <span id="chapterBtnText">播种文字灵魂</span>
                                    </button>
                                    <button id="chapterCancelBtn"
                                        class="hidden px-10 py-6 border border-white/10 rounded-2xl text-text-dim hover:text-white hover:bg-white/5 transition-all font-bold"
                                        onclick="resetChapterForm()">销毁当前草案</button>
                                </div>
                            </div>

                            <div id="sec-manage" class="admin-section hidden space-y-12">
                                <div class="relative">
                                    <div class="flex items-center justify-between mb-8">
                                        <div class="flex items-center gap-4">
                                            <div class="w-1.5 h-10 bg-rose-500 rounded-full"></div>
                                            <h3 class="text-4xl font-black text-white tracking-tighter"
                                                style="font-family: var(--font-serif);">内容管控矩阵</h3>
                                        </div>
                                        <div class="flex gap-2 p-1 bg-black/30 rounded-2xl">
                                            <button onclick="loadManageList('novel')"
                                                class="px-4 py-2 rounded-xl text-xs font-black transition-all bg-primary text-white"
                                                id="list-tab-novel">作品</button>
                                            <button onclick="loadManageList('author')"
                                                class="px-4 py-2 rounded-xl text-xs font-black transition-all hover:bg-white/5 text-text-dim"
                                                id="list-tab-author">作者</button>
                                        </div>
                                    </div>
                                    <p class="text-text-muted ml-6 font-medium">审视、修补或抹除现存的数字节点，确保生态平衡。</p>
                                </div>

                                <div id="manageGrid"
                                    class="flex-1 space-y-4 overflow-y-auto max-h-[600px] pr-2 custom-scrollbar">
                                    <!-- List items injected here -->
                                    <div class="py-20 text-center opacity-20 italic">正在扫描数字资产...</div>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </main>

            <%@ include file="footer.jsp" %>

                <!-- Modal for Chapter Management in specific novel -->
                <div id="chapterModal"
                    class="fixed inset-0 z-[200] hidden items-center justify-center p-6 bg-black/80 backdrop-blur-sm">
                    <div class="luminous-panel rounded-[2rem] w-full max-w-4xl max-h-[80vh] flex flex-col p-10 reveal">
                        <div class="flex items-center justify-between mb-8">
                            <h4 class="text-2xl font-black">章节目录管控</h4>
                            <button onclick="closeChapterModal()" class="text-text-dim hover:text-white"><i
                                    data-lucide="x" class="w-6 h-6"></i></button>
                        </div>
                        <div id="modalChapterList" class="flex-1 space-y-3 overflow-y-auto pr-2 custom-scrollbar">
                            <!-- Chapters injected here -->
                        </div>
                    </div>
                </div>

                <script>
                    function showSection(name) {
                        console.log("Switching to section:", name);
                        document.querySelectorAll('.admin-section').forEach(d => {
                            d.classList.add('hidden');
                            d.classList.remove('reveal');
                        });
                        const target = document.getElementById('sec-' + name);
                        if (target) {
                            target.classList.remove('hidden');
                            setTimeout(() => target.classList.add('reveal'), 10);
                        }

                        document.querySelectorAll('.uc-nav-item').forEach(d => d.classList.remove('active'));
                        const btn = document.getElementById('btn-' + name);
                        if (btn) btn.classList.add('active');

                        if (name === 'manage') loadManageList('novel');

                        try {
                            if (typeof lucide !== 'undefined') lucide.createIcons();
                        } catch (e) { console.warn("Lucide icons failed:", e); }
                    }

                    document.addEventListener('DOMContentLoaded', () => {
                        try {
                            if (typeof lucide !== 'undefined') lucide.createIcons();
                            loadAuthors(); // Pre-load authors for the select dropdown
                            loadUsers();   // Pre-load users for the account binding select
                        } catch (e) { console.warn("Lucide init failed"); }
                    });

                    async function loadUsers() {
                        try {
                            const res = await fetch("../admin/user/list");
                            const data = await res.json();
                            if (data.code === 200) {
                                const select = document.getElementById('authorUserId');
                                select.innerHTML = '<option value="">不关联账号 (仅展示名义作者)</option>' +
                                    data.data.map(u => `<option value="\${u.id}">\${u.username} (\${u.nickname || '无昵称'})</option>`).join('');
                            }
                        } catch (e) { console.error("Failed to load users", e); }
                    }

                    async function loadAuthors() {
                        try {
                            const res = await fetch("../admin/author/list");
                            const data = await res.json();
                            if (data.code === 200) {
                                const select = document.getElementById('novelAuthor');
                                select.innerHTML = '<option value="">选择核心作者...</option>' +
                                    data.data.map(a => `<option value="${a.id}">${a.name} (ID: ${a.id})</option>`).join('');
                            }
                        } catch (e) { console.error("Failed to load authors", e); }
                    }

                    async function post(endpoint, params) {
                        try {
                            const res = await fetch("../admin/" + endpoint, {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: params
                            });
                            const data = await res.json();
                            if (data.code === 200) {
                                showToast(data.msg, "success");
                                return true;
                            } else {
                                showToast(data.msg || "指令执行受阻", "error");
                                return false;
                            }
                        } catch (e) {
                            showToast("连接指挥中心失败", "error");
                            return false;
                        }
                    }

                    // --- AUTHOR ---
                    async function submitAuthor() {
                        const params = new URLSearchParams();
                        const id = document.getElementById('authorId').value;
                        const userId = document.getElementById('authorUserId').value;
                        params.append('name', document.getElementById('authorName').value.trim());
                        params.append('bio', document.getElementById('authorBio').value.trim());
                        params.append('userId', userId);

                        let success;
                        if (id) {
                            params.append('id', id);
                            success = await post('author/update', params);
                        } else {
                            success = await post('author/create', params);
                        }
                        if (success) resetAuthorForm();
                    }

                    function editAuthor(id, name, bio, userId) {
                        document.getElementById('authorId').value = id;
                        document.getElementById('authorName').value = name;
                        document.getElementById('authorBio').value = bio;
                        document.getElementById('authorUserId').value = userId || '';
                        document.getElementById('authorBtnText').innerText = "确认修改";
                        document.getElementById('authorCancelBtn').classList.remove('hidden');
                        showSection('author');
                    }

                    function resetAuthorForm() {
                        document.getElementById('authorId').value = '';
                        document.getElementById('authorName').value = '';
                        document.getElementById('authorBio').value = '';
                        document.getElementById('authorUserId').value = '';
                        document.getElementById('authorBtnText').innerText = "提交录入";
                        document.getElementById('authorCancelBtn').classList.add('hidden');
                    }

                    // --- NOVEL ---
                    async function submitNovel() {
                        const params = new URLSearchParams();
                        const id = document.getElementById('novelId').value;
                        params.append('title', document.getElementById('novelTitle').value.trim());
                        params.append('authorId', document.getElementById('novelAuthor').value);
                        params.append('category', document.getElementById('novelCategory').value);
                        params.append('isFree', document.getElementById('novelIsFree').value);
                        params.append('coverUrl', document.getElementById('novelCover').value.trim());
                        params.append('intro', document.getElementById('novelIntro').value.trim());

                        let success;
                        if (id) {
                            params.append('id', id);
                            success = await post('novel/update', params);
                        } else {
                            success = await post('novel/create', params);
                        }
                        if (success) resetNovelForm();
                    }

                    function editNovel(id, title, authorId, category, isFree, cover, intro) {
                        document.getElementById('novelId').value = id;
                        document.getElementById('novelTitle').value = title;
                        document.getElementById('novelAuthor').value = authorId;
                        document.getElementById('novelCategory').value = category;
                        document.getElementById('novelIsFree').value = isFree;
                        document.getElementById('novelCover').value = cover;
                        document.getElementById('novelIntro').value = intro;
                        document.getElementById('novelBtnText').innerText = "确认修改";
                        document.getElementById('novelCancelBtn').classList.remove('hidden');
                        showSection('novel');
                    }

                    function resetNovelForm() {
                        document.getElementById('novelId').value = '';
                        document.getElementById('novelTitle').value = '';
                        document.getElementById('novelAuthor').value = '';
                        document.getElementById('novelCover').value = '';
                        document.getElementById('novelIntro').value = '';
                        document.getElementById('novelBtnText').innerText = "启动发布";
                        document.getElementById('novelCancelBtn').classList.add('hidden');
                    }

                    // --- CHAPTER ---
                    async function submitChapter() {
                        const params = new URLSearchParams();
                        const id = document.getElementById('chapterId').value;
                        params.append('novelId', document.getElementById('chapterNovelId').value.trim());
                        params.append('sortOrder', document.getElementById('chapterSort').value);
                        params.append('price', document.getElementById('chapterPrice').value);
                        params.append('title', document.getElementById('chapterTitle').value.trim());
                        params.append('content', document.getElementById('chapterContent').value.trim());

                        let success;
                        if (id) {
                            params.append('id', id);
                            success = await post('chapter/update', params);
                        } else {
                            success = await post('chapter/create', params);
                        }
                        if (success) resetChapterForm();
                    }

                    function editChapter(id, novelId, sort, price, title, content) {
                        document.getElementById('chapterId').value = id;
                        document.getElementById('chapterNovelId').value = novelId;
                        document.getElementById('chapterSort').value = sort;
                        document.getElementById('chapterPrice').value = price;
                        document.getElementById('chapterTitle').value = title;
                        document.getElementById('chapterContent').value = content;
                        document.getElementById('chapterBtnText').innerText = "确认修改";
                        document.getElementById('chapterCancelBtn').classList.remove('hidden');
                        showSection('chapter');
                    }

                    function resetChapterForm() {
                        document.getElementById('chapterId').value = '';
                        document.getElementById('chapterNovelId').value = '';
                        document.getElementById('chapterSort').value = '1';
                        document.getElementById('chapterPrice').value = '0';
                        document.getElementById('chapterTitle').value = '';
                        document.getElementById('chapterContent').value = '';
                        document.getElementById('chapterBtnText').innerText = "立即同步";
                        document.getElementById('chapterCancelBtn').classList.add('hidden');
                    }

                    // --- MANAGE LIST ---
                    async function loadManageList(type) {
                        const grid = document.getElementById('manageGrid');
                        grid.innerHTML = '<div class="py-20 text-center opacity-20 italic">正在扫描数字资产...</div>';

                        document.querySelectorAll('[id^="list-tab-"]').forEach(b => b.classList.remove('bg-primary', 'text-white'));
                        document.getElementById('list-tab-' + type).classList.add('bg-primary', 'text-white');

                        try {
                            const res = await fetch("../admin/" + type + "/list");
                            const data = await res.json();
                            if (data.code === 200) {
                                renderManageList(type, data.data);
                            }
                        } catch (e) {
                            grid.innerHTML = '<div class="py-20 text-center text-red-400">资源索引失败</div>';
                        }
                    }

                    function renderManageList(type, items) {
                        const grid = document.getElementById('manageGrid');
                        if (!items || items.length === 0) {
                            grid.innerHTML = '<div class="py-20 text-center opacity-20">暂无任何数据记录</div>';
                            return;
                        }

                        grid.innerHTML = items.map(item => {
                            if (type === 'novel') {
                                return `
                                    <div class="p-6 rounded-3xl bg-white/5 border border-white/5 flex items-center justify-between group hover:bg-white/10 transition-all reveal">
                                        <div class="flex items-center gap-6">
                                            <div class="w-16 h-20 rounded-xl bg-black/40 overflow-hidden shadow-2xl relative">
                                                <img src="\${item.coverUrl || '../static/images/cover_placeholder.jpg'}" class="w-full h-full object-cover">
                                                <div class="absolute inset-0 ring-1 ring-inset ring-white/10 rounded-xl"></div>
                                            </div>
                                            <div class="space-y-1">
                                                <div class="text-lg font-black text-white group-hover:text-primary transition-colors">\${item.title}</div>
                                                <div class="flex items-center gap-3">
                                                    <span class="px-2 py-0.5 rounded bg-primary/20 text-[10px] font-bold text-primary uppercase">\${item.category}</span>
                                                    <span class="text-[10px] text-text-dim uppercase font-bold tracking-widest">\${item.authorName} | ID: \${item.id}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="flex gap-3 opacity-40 group-hover:opacity-100 transition-opacity">
                                            <button onclick="openChapterList(\${item.id})" class="w-12 h-12 rounded-2xl bg-black/40 border border-white/5 flex items-center justify-center hover:bg-primary/20 hover:text-primary transition-all" title="查看章节"><i data-lucide="list" class="w-5 h-5"></i></button>
                                            <button onclick="editNovel(\${item.id}, '\${item.title.replace(/'/g, "\\'")}', \${item.authorId}, '\${item.category}', \${item.isFree}, '\${item.coverUrl}', '\${item.intro.replace(/'/g, "\\'")}')" class="w-12 h-12 rounded-2xl bg-black/40 border border-white/5 flex items-center justify-center hover:bg-accent/20 hover:text-accent transition-all" title="编辑作品"><i data-lucide="edit-3" class="w-5 h-5"></i></button>
                                            <button onclick="deleteResource('novel', \${item.id})" class="w-12 h-12 rounded-2xl bg-black/40 border border-white/5 flex items-center justify-center hover:bg-red-500/20 hover:text-red-400 transition-all" title="抹除数据"><i data-lucide="trash-2" class="w-5 h-5"></i></button>
                                        </div>
                                    </div>
                                `;
                            } else if (type === 'author') {
                                const userIdTag = item.userId ? `<span class="px-2 py-0.5 rounded bg-primary/20 text-[10px] font-bold text-primary uppercase">UID关联: \${item.userId}</span>` : '';
                                return `
                                    <div class="p-6 rounded-3xl bg-white/5 border border-white/5 flex items-center justify-between group hover:bg-white/10 transition-all reveal">
                                        <div class="flex items-center gap-6">
                                            <div class="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center text-primary group-hover:scale-110 transition-transform">
                                                <i data-lucide="user" class="w-8 h-8"></i>
                                            </div>
                                            <div class="space-y-1">
                                                <div class="flex items-center gap-2">
                                                    <div class="text-lg font-black text-white group-hover:text-primary transition-colors">\${item.name}</div>
                                                    \${userIdTag}
                                                </div>
                                                <div class="text-[10px] text-text-dim uppercase font-bold tracking-widest">ID: \${item.id}</div>
                                            </div>
                                        </div>
                                        <div class="flex gap-3 opacity-40 group-hover:opacity-100 transition-opacity">
                                            <button onclick="editAuthor('\${item.id}', '\${item.name.replace(/'/g, "\\'")}', '\${item.bio.replace(/'/g, "\\'")}', '\${item.userId || ''}')" class="w-12 h-12 rounded-2xl bg-black/40 border border-white/5 flex items-center justify-center hover:bg-accent/20 hover:text-accent transition-all" title="修改档案"><i data-lucide="edit-3" class="w-5 h-5"></i></button>
                                            <button onclick="deleteResource('author', '\${item.id}')" class="w-12 h-12 rounded-2xl bg-black/40 border border-white/5 flex items-center justify-center hover:bg-red-500/20 hover:text-red-400 transition-all" title="终结创造者项"><i data-lucide="trash-2" class="w-5 h-5"></i></button>
                                        </div>
                                    </div>
                                `;
                            }
                        }).join('');
                        lucide.createIcons();
                    }

                    async function deleteResource(type, id) {
                        const msg = "警告：确认要永久抹除此" + (type === 'novel' ? '作品' : '作者') + "的所有数据吗？";
                        if (!confirm(msg)) return;
                        const params = new URLSearchParams();
                        params.append('id', id);
                        if (await post(type + '/delete', params)) {
                            loadManageList(type);
                        }
                    }

                    // --- CHAPTER MODAL ---
                    async function openChapterList(novelId) {
                        const modal = document.getElementById('chapterModal');
                        const list = document.getElementById('modalChapterList');
                        modal.classList.remove('hidden');
                        modal.classList.add('flex');
                        list.innerHTML = '<div class="py-10 text-center opacity-20">正在调档...</div>';

                        try {
                            const res = await fetch("../admin/chapter/list?novelId=" + novelId);
                            const data = await res.json();
                            if (data.code === 200) {
                                list.innerHTML = data.data.map(c => `
                                    <div class="p-5 rounded-2xl bg-white/5 border border-white/5 flex items-center justify-between group hover:bg-white/10 transition-all">
                                        <div>
                                            <div class="text-sm font-bold text-white group-hover:text-primary transition-colors">\${c.title}</div>
                                            <div class="text-[10px] text-text-dim uppercase mt-1">序位: \${c.sortOrder} | 价格: \${c.price}G</div>
                                        </div>
                                        <div class="flex gap-2">
                                            <button onclick="prepareEditChapter(\${c.id})" class="w-10 h-10 rounded-xl bg-black/40 border border-white/5 flex items-center justify-center hover:bg-accent/20 hover:text-accent transition-all"><i data-lucide="edit-3" class="w-4 h-4"></i></button>
                                            <button onclick="deleteChapter(\${c.id}, \${novelId})" class="w-10 h-10 rounded-xl bg-black/40 border border-white/5 flex items-center justify-center hover:bg-red-500/20 hover:text-red-400 transition-all"><i data-lucide="trash-2" class="w-4 h-4"></i></button>
                                        </div>
                                    </div>
                            `).join('');
                                if (data.data.length === 0) list.innerHTML = '<div class="py-10 text-center opacity-20">该矩阵尚无章节记录</div>';
                            }
                        } catch (e) {
                            list.innerHTML = '<div class="py-10 text-center text-red-400">调档失败</div>';
                        }
                        lucide.createIcons();
                    }

                    async function prepareEditChapter(id) {
                        try {
                            closeChapterModal();
                            showToast("正在同步云端档案...", "info");
                            const res = await fetch("../admin/chapter/detail?id=" + id);
                            const data = await res.json();
                            if (data.code === 200 && data.data) {
                                const c = data.data;
                                editChapter(c.id, c.novelId, c.sortOrder, c.price, c.title, c.content);
                                showToast("档案调取成功", "success");
                            } else {
                                showToast("档案损毁或遗失", "error");
                            }
                        } catch (e) {
                            showToast("连接中断", "error");
                        }
                    }

                    async function deleteChapter(id, novelId) {
                        if (!confirm("确认删除此章节？")) return;
                        const params = new URLSearchParams();
                        params.append('id', id);
                        if (await post('chapter/delete', params)) {
                            openChapterList(novelId);
                        }
                    }

                    function closeChapterModal() {
                        const modal = document.getElementById('chapterModal');
                        modal.classList.add('hidden');
                        modal.classList.remove('flex');
                    }
                </script>

    </body>

    </html>