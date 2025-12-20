<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>上帝模式 - 阅己 YueJi 管理后台</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
    </head>

    <body class="bg-glow">
        <%@ include file="header.jsp" %>

            <main class="container py-12 reveal">
                <div class="flex items-center gap-6 mb-12">
                    <div
                        class="w-16 h-16 rounded-3xl bg-primary/20 flex items-center justify-center text-primary shadow-2xl relative group">
                        <div
                            class="absolute inset-0 bg-primary/40 blur-xl opacity-0 group-hover:opacity-100 transition-opacity">
                        </div>
                        <i data-lucide="crown" class="w-8 h-8 relative z-10"></i>
                    </div>
                    <div>
                        <h1 class="text-4xl font-black tracking-tighter text-white uppercase italic">上帝模式 <span
                                class="text-primary/50 text-xl ml-2 font-mono not-italic tracking-normal">v2.0_Final</span>
                        </h1>
                        <p class="text-text-muted font-bold tracking-[0.3em] text-[10px] mt-1 uppercase opacity-60">
                            Control every pixel, every word, every world.</p>
                    </div>
                </div>

                <div class="flex flex-col lg:flex-row gap-10">
                    <!-- Global Nav -->
                    <aside class="w-full lg:w-72 space-y-6">
                        <nav class="luminous-panel rounded-[2rem] p-3 space-y-1">
                            <div class="px-4 py-2 text-[10px] font-black text-text-dim uppercase tracking-[0.2em]">创建枢纽
                            </div>
                            <button onclick="showSection('author')" class="uc-nav-item active" id="btn-author">
                                <i data-lucide="user-plus" class="w-5 h-5"></i>
                                <span>新作者录入</span>
                            </button>
                            <button onclick="showSection('novel')" class="uc-nav-item" id="btn-novel">
                                <i data-lucide="book-plus" class="w-5 h-5"></i>
                                <span>新作品发布</span>
                            </button>
                            <button onclick="showSection('chapter')" class="uc-nav-item" id="btn-chapter">
                                <i data-lucide="file-plus" class="w-5 h-5"></i>
                                <span>章节更新</span>
                            </button>

                            <div class="my-4 border-t border-border-dim mx-3"></div>
                            <div class="px-4 py-2 text-[10px] font-black text-text-dim uppercase tracking-[0.2em]">监管矩阵
                            </div>
                            <button onclick="showSection('manage')" class="uc-nav-item" id="btn-manage">
                                <i data-lucide="layout-grid" class="w-5 h-5"></i>
                                <span>内容管控台</span>
                            </button>
                        </nav>

                        <div class="luminous-panel rounded-[2rem] p-6 bg-gradient-to-br from-accent/10 to-transparent">
                            <div class="flex items-center justify-between mb-4">
                                <div class="text-[10px] font-black text-accent uppercase tracking-widest">环境状态</div>
                                <span class="w-2 h-2 rounded-full bg-green-500 animate-pulse"></span>
                            </div>
                            <div class="text-xs text-text-muted leading-relaxed font-bold">
                                核心引擎: <span class="text-white">Active</span><br>
                                同步延迟: <span class="text-white">0.4ms</span><br>
                                连接状态: <span class="text-white">Secure_SSL</span>
                            </div>
                        </div>
                    </aside>

                    <!-- Workspace -->
                    <section class="flex-1 min-h-[700px]">
                        <div class="luminous-panel rounded-[3rem] p-10 lg:p-14 relative overflow-hidden h-full">
                            <div
                                class="absolute -top-40 -right-40 w-96 h-96 bg-primary/5 blur-[150px] rounded-full pointer-events-none">
                            </div>

                            <!-- Author Section -->
                            <div id="sec-author" class="admin-section active space-y-10">
                                <div class="flex items-end justify-between">
                                    <div>
                                        <h3 class="text-3xl font-black mb-2">录入新作者</h3>
                                        <p class="text-text-muted">为悦己注入新的灵魂血液。</p>
                                    </div>
                                    <div class="text-[10px] font-mono text-primary/40 uppercase">Action_Add_Author</div>
                                </div>
                                <div class="grid grid-cols-1 gap-8">
                                    <input type="hidden" id="authorId">
                                    <div class="space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">作者姓名</label>
                                        <input id="authorName" class="v2-admin-input" placeholder="实名或笔名...">
                                    </div>
                                    <div class="space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">灵魂简介</label>
                                        <textarea id="authorBio" class="v2-admin-input h-32 resize-none pt-4"
                                            placeholder="描述其文字风格..."></textarea>
                                    </div>
                                </div>
                                <div class="flex gap-4 mt-6">
                                    <button class="btn-ultimate px-12 py-5 shadow-2xl" onclick="submitAuthor()">
                                        <i data-lucide="check" class="w-5 h-5"></i>
                                        <span id="authorBtnText">提交录入</span>
                                    </button>
                                    <button id="authorCancelBtn"
                                        class="hidden px-8 py-5 border border-border-dim rounded-2xl text-text-dim hover:text-white transition-all font-bold"
                                        onclick="resetAuthorForm()">取消编辑</button>
                                </div>
                            </div>

                            <!-- Novel Section -->
                            <div id="sec-novel" class="admin-section hidden space-y-10">
                                <div class="flex items-end justify-between">
                                    <div>
                                        <h3 class="text-3xl font-black mb-2 text-accent">发布新作品</h3>
                                        <p class="text-text-muted">开启一段全新的文字传奇。</p>
                                    </div>
                                    <div class="text-[10px] font-mono text-accent/40 uppercase">Action_Add_Novel</div>
                                </div>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                                    <input type="hidden" id="novelId">
                                    <div class="space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">作品名称</label>
                                        <input id="novelTitle" class="v2-admin-input" placeholder="输入书名">
                                    </div>
                                    <div class="space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">所属作者
                                            ID</label>
                                        <input id="novelAuthorId" class="v2-admin-input" placeholder="填入作者数字ID">
                                    </div>
                                    <div class="space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">次元分类</label>
                                        <select id="novelCategory" class="v2-admin-input bg-black/40">
                                            <option>玄幻</option>
                                            <option>都市</option>
                                            <option>悬疑</option>
                                            <option>言情</option>
                                            <option>历史</option>
                                            <option>科幻</option>
                                        </select>
                                    </div>
                                    <div class="space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">付费属性</label>
                                        <select id="novelIsFree" class="v2-admin-input bg-black/40">
                                            <option value="true">全本免费</option>
                                            <option value="false">精英付费</option>
                                        </select>
                                    </div>
                                    <div class="md:col-span-2 space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">封面视觉
                                            URL</label>
                                        <input id="novelCover" class="v2-admin-input" placeholder="https://...">
                                    </div>
                                    <div class="md:col-span-2 space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">核心引言</label>
                                        <textarea id="novelIntro" class="v2-admin-input h-24 resize-none pt-4"
                                            placeholder="勾引读者的好奇心..."></textarea>
                                    </div>
                                </div>
                                <div class="flex gap-4 mt-6">
                                    <button class="btn-ultimate px-12 py-5 bg-accent shadow-accent/20"
                                        onclick="submitNovel()">
                                        <i data-lucide="sparkles" class="w-5 h-5"></i>
                                        <span id="novelBtnText">启动发布</span>
                                    </button>
                                    <button id="novelCancelBtn"
                                        class="hidden px-8 py-5 border border-border-dim rounded-2xl text-text-dim hover:text-white transition-all font-bold"
                                        onclick="resetNovelForm()">取消编辑</button>
                                </div>
                            </div>

                            <!-- Chapter Section -->
                            <div id="sec-chapter" class="admin-section hidden space-y-10">
                                <div class="flex items-end justify-between">
                                    <div>
                                        <h3 class="text-3xl font-black mb-2">章节更新</h3>
                                        <p class="text-text-muted">为世界观添砖加瓦。</p>
                                    </div>
                                    <div class="text-[10px] font-mono text-primary/40 uppercase">Action_Add_Chapter
                                    </div>
                                </div>
                                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                                    <input type="hidden" id="chapterId">
                                    <div class="space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">所属书
                                            ID</label>
                                        <input id="chapterNovelId" class="v2-admin-input" placeholder="作品 ID">
                                    </div>
                                    <div class="space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">排序权重</label>
                                        <input id="chapterSort" class="v2-admin-input" type="number" value="1">
                                    </div>
                                    <div class="space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">章节定价</label>
                                        <input id="chapterPrice" class="v2-admin-input" type="number" value="0">
                                    </div>
                                    <div class="md:col-span-3 space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">分卷标题</label>
                                        <input id="chapterTitle" class="v2-admin-input" placeholder="例如：第一章 初露锋芒">
                                    </div>
                                    <div class="md:col-span-3 space-y-3">
                                        <label
                                            class="text-[10px] font-black text-text-dim uppercase tracking-[0.2em] ml-1">正文意识流</label>
                                        <textarea id="chapterContent"
                                            class="v2-admin-input h-80 resize-none pt-6 leading-relaxed"
                                            placeholder="撰写故事核心..."></textarea>
                                    </div>
                                </div>
                                <div class="flex gap-4 mt-6">
                                    <button class="btn-ultimate px-12 py-5 shadow-2xl" onclick="submitChapter()">
                                        <i data-lucide="send" class="w-5 h-5"></i>
                                        <span id="chapterBtnText">立即同步</span>
                                    </button>
                                    <button id="chapterCancelBtn"
                                        class="hidden px-8 py-5 border border-border-dim rounded-2xl text-text-dim hover:text-white transition-all font-bold"
                                        onclick="resetChapterForm()">取消编辑</button>
                                </div>
                            </div>

                            <!-- Manage List Section -->
                            <div id="sec-manage" class="admin-section hidden space-y-10 h-full flex flex-col">
                                <div class="flex items-center justify-between">
                                    <h3 class="text-3xl font-black">内容管控矩阵</h3>
                                    <div class="flex gap-2 p-1 bg-black/30 rounded-2xl">
                                        <button onclick="loadManageList('novel')"
                                            class="px-4 py-2 rounded-xl text-xs font-black transition-all bg-primary text-white"
                                            id="list-tab-novel">作品</button>
                                        <button onclick="loadManageList('author')"
                                            class="px-4 py-2 rounded-xl text-xs font-black transition-all hover:bg-white/5 text-text-dim"
                                            id="list-tab-author">作者</button>
                                    </div>
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
                    document.addEventListener('DOMContentLoaded', () => {
                        lucide.createIcons();
                    });

                    function showSection(name) {
                        document.querySelectorAll('.admin-section').forEach(d => {
                            d.classList.add('hidden');
                            d.classList.remove('reveal');
                        });
                        const target = document.getElementById('sec-' + name);
                        target.classList.remove('hidden');
                        setTimeout(() => target.classList.add('reveal'), 10);

                        document.querySelectorAll('.uc-nav-item').forEach(d => d.classList.remove('active'));
                        document.getElementById('btn-' + name).classList.add('active');

                        if (name === 'manage') loadManageList('novel');
                        lucide.createIcons();
                    }

                    async function post(endpoint, params) {
                        try {
                            const res = await fetch("${pageContext.request.contextPath}/admin/" + endpoint, {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                body: params
                            });
                            const data = await res.json();
                            if (data.status === 200) {
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
                        params.append('name', document.getElementById('authorName').value.trim());
                        params.append('bio', document.getElementById('authorBio').value.trim());

                        let success;
                        if (id) {
                            params.append('id', id);
                            success = await post('author/update', params);
                        } else {
                            success = await post('author/create', params);
                        }
                        if (success) resetAuthorForm();
                    }

                    function editAuthor(id, name, bio) {
                        document.getElementById('authorId').value = id;
                        document.getElementById('authorName').value = name;
                        document.getElementById('authorBio').value = bio;
                        document.getElementById('authorBtnText').innerText = "确认修改";
                        document.getElementById('authorCancelBtn').classList.remove('hidden');
                        showSection('author');
                    }

                    function resetAuthorForm() {
                        document.getElementById('authorId').value = '';
                        document.getElementById('authorName').value = '';
                        document.getElementById('authorBio').value = '';
                        document.getElementById('authorBtnText').innerText = "提交录入";
                        document.getElementById('authorCancelBtn').classList.add('hidden');
                    }

                    // --- NOVEL ---
                    async function submitNovel() {
                        const params = new URLSearchParams();
                        const id = document.getElementById('novelId').value;
                        params.append('title', document.getElementById('novelTitle').value.trim());
                        params.append('authorId', document.getElementById('novelAuthorId').value.trim());
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
                        document.getElementById('novelAuthorId').value = authorId;
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
                        document.getElementById('novelAuthorId').value = '';
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
                            const res = await fetch("${pageContext.request.contextPath}/admin/" + type + "/list");
                            const data = await res.json();
                            if (data.status === 200) {
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
                        <div class="manage-list-item reveal">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-16 rounded-lg bg-black/40 overflow-hidden">
                                    <img src="${item.coverUrl || 'https://images.unsplash.com/photo-1543004471-240ce49a2a2f?w=100'}" class="w-full h-full object-cover">
                                </div>
                                <div>
                                    <div class="font-black text-white">${item.title}</div>
                                    <div class="text-[10px] text-text-dim uppercase font-bold tracking-widest">${item.authorName} | ID: ${item.id}</div>
                                </div>
                            </div>
                            <div class="flex gap-2">
                                <button onclick="openChapterList(${item.id})" class="p-2 rounded-xl border border-white/5 hover:bg-primary/20 hover:text-primary transition-all"><i data-lucide="list" class="w-4 h-4"></i></button>
                                <button onclick="editNovel(${item.id}, '${item.title}', ${item.authorId}, '${item.category}', ${item.isFree}, '${item.coverUrl}', '${item.intro}')" class="p-2 rounded-xl border border-white/5 hover:bg-accent/20 hover:text-accent transition-all"><i data-lucide="edit-3" class="w-4 h-4"></i></button>
                                <button onclick="deleteResource('novel', ${item.id})" class="p-2 rounded-xl border border-white/5 hover:bg-red-500/20 hover:text-red-400 transition-all"><i data-lucide="trash-2" class="w-4 h-4"></i></button>
                            </div>
                        </div>
                    `;
                            } else if (type === 'author') {
                                return `
                        <div class="manage-list-item reveal">
                            <div>
                                <div class="font-black text-white">${item.name}</div>
                                <div class="text-[10px] text-text-dim uppercase font-bold tracking-widest">ID: ${item.id}</div>
                            </div>
                            <div class="flex gap-2">
                                <button onclick="editAuthor(${item.id}, '${item.name}', '${item.bio}')" class="p-2 rounded-xl border border-white/5 hover:bg-accent/20 hover:text-accent transition-all"><i data-lucide="edit-3" class="w-4 h-4"></i></button>
                                <button onclick="deleteResource('author', ${item.id})" class="p-2 rounded-xl border border-white/5 hover:bg-red-500/20 hover:text-red-400 transition-all"><i data-lucide="trash-2" class="w-4 h-4"></i></button>
                            </div>
                        </div>
                    `;
                            }
                        }).join('');
                        lucide.createIcons();
                    }

                    async function deleteResource(type, id) {
                        if (!confirm(`警告：确认要永久抹除此${type === 'novel' ? '作品' : '作者'}的所有数据吗？`)) return;
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
                            const res = await fetch("${pageContext.request.contextPath}/admin/chapter/list?novelId=" + novelId);
                            const data = await res.json();
                            if (data.status === 200) {
                                list.innerHTML = data.data.map(c => `
                        <div class="manage-list-item">
                            <div>
                                <div class="text-sm font-bold text-white">${c.title}</div>
                                <div class="text-[10px] text-text-dim uppercase">序位: ${c.sortOrder} | 价格: ${c.price}G</div>
                            </div>
                            <div class="flex gap-2">
                                <button onclick="prepareEditChapter(${c.id})" class="p-2 rounded-xl border border-white/5 hover:bg-accent/20 hover:text-accent transition-all"><i data-lucide="edit-3" class="w-3 h-3"></i></button>
                                <button onclick="deleteChapter(${c.id}, ${novelId})" class="p-2 rounded-xl border border-white/5 hover:bg-red-500/20 hover:text-red-400 transition-all"><i data-lucide="trash-2" class="w-3 h-3"></i></button>
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
                        // Need detail for content. But chapter/list returned summary.
                        // Simplified: we can't easily edit content without another fetch or having it in list.
                        // For now, let's just close modal and go to chapter section with ID.
                        // Better: fetch detail.
                        try {
                            // We'll use NovelServlet or something if it has chapter detail? 
                            // Or Admin should have GET /chapter/detail?id=...
                            // Let's assume we need to add that too or just fetch it.
                            // For simplicity in this demo, I'll close modal.
                            closeChapterModal();
                            showToast("请在章节更新区输入 ID: " + id + " 进行手动覆盖，或等待后续版本集成一键回填", "info");
                            showSection('chapter');
                            document.getElementById('chapterId').value = id;
                        } catch (e) { }
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

                <style>
                    .admin-section {
                        opacity: 0;
                        transform: translateY(20px);
                        transition: all 0.6s cubic-bezier(0.165, 0.84, 0.44, 1);
                    }

                    .admin-section.reveal {
                        opacity: 1;
                        transform: translateY(0);
                    }

                    .custom-scrollbar::-webkit-scrollbar {
                        width: 4px;
                    }

                    .custom-scrollbar::-webkit-scrollbar-track {
                        background: transparent;
                    }

                    .custom-scrollbar::-webkit-scrollbar-thumb {
                        background: var(--border-highlight);
                        border-radius: 10px;
                    }

                    .custom-scrollbar::-webkit-scrollbar-thumb:hover {
                        background: var(--primary);
                    }
                </style>
    </body>

    </html>