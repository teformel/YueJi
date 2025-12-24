<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>作家工作台 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/css/style.css?v=3">
        <script src="../static/js/lucide.js"></script>
        <script src="../static/js/script.js"></script>
    </head>

    <body class="bg-gray-50 min-h-screen flex flex-col">
        <!-- Simple Header for Creator -->
        <header class="bg-white border-b border-gray-200">
            <div class="container h-16 flex items-center justify-between">
                <div class="flex items-center gap-2 font-bold text-xl text-slate-900">
                    <i data-lucide="pen-tool" class="w-6 h-6 text-blue-600"></i>
                    作家工作台
                </div>
                <div class="flex items-center gap-4 text-sm">
                    <span id="welcomeMsg">Welcome</span>
                    <a href="index.jsp" class="hover:text-blue-600">返回首页</a>
                </div>
            </div>
        </header>

        <main class="flex-1 py-10">
            <div class="container">

                <div class="grid grid-cols-1 lg:grid-cols-4 gap-8">
                    <!-- Sidebar -->
                    <aside class="space-y-2">
                        <button onclick="switchTab('novels')"
                            class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all active-tab bg-white shadow-sm border-l-4 border-blue-600">
                            <i data-lucide="book" class="w-5 h-5"></i> 我的作品
                        </button>
                        <button onclick="switchTab('create')"
                            class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all border-l-4 border-transparent">
                            <i data-lucide="plus-circle" class="w-5 h-5"></i> 发布新书
                        </button>
                        <button onclick="switchTab('income')"
                            class="nav-item w-full flex items-center gap-3 px-4 py-3 rounded-lg text-left font-bold text-slate-700 hover:bg-white hover:shadow-sm transition-all border-l-4 border-transparent">
                            <i data-lucide="banknote" class="w-5 h-5"></i> 稿费收入
                        </button>
                    </aside>

                    <!-- Content -->
                    <div class="lg:col-span-3 space-y-6">

                        <!-- Tab: Novel List -->
                        <div id="tab-novels" class="tab-content animate-fade-in">
                            <div class="flex justify-between items-center mb-6">
                                <h2 class="text-2xl font-bold text-slate-900">作品管理</h2>
                                <button onclick="switchTab('create')"
                                    class="btn-primary px-4 py-2 text-sm flex items-center gap-2">
                                    <i data-lucide="plus" class="w-4 h-4"></i> 新建作品
                                </button>
                            </div>

                            <div class="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden min-h-[300px]"
                                id="novelListContainer">
                                <!-- Injected -->
                                <div class="flex flex-col items-center justify-center h-full py-20 text-slate-400">
                                    <i data-lucide="file-x" class="w-12 h-12 mb-4 opacity-50"></i>
                                    <p>暂无作品，开始创作吧</p>
                                </div>
                            </div>
                        </div>

                        <!-- Tab: Create Novel -->
                        <div id="tab-create" class="tab-content hidden animate-fade-in">
                            <h2 class="text-2xl font-bold text-slate-900 mb-6">发布新书</h2>
                            <div class="bg-white p-8 rounded-xl border border-gray-200 shadow-sm max-w-2xl">
                                <div class="space-y-6">
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">作品名称</label>
                                        <input type="text" id="newTitle" class="form-input" placeholder="给作品起个响亮的名字">
                                    </div>
                                    <div class="grid grid-cols-2 gap-6">
                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">作品分类</label>
                                            <select id="newCategory" class="form-input">
                                                <option>玄幻</option>
                                                <option>都市</option>
                                                <option>仙侠</option>
                                                <option>科幻</option>
                                                <option>历史</option>
                                                <option>悬疑</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">封面链接 (可选)</label>
                                            <input type="text" id="newCover" class="form-input" placeholder="图片 URL">
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">作品简介</label>
                                        <textarea id="newDesc" class="form-input h-32"
                                            placeholder="这是一本关于..."></textarea>
                                    </div>
                                    <div class="pt-4 border-t border-gray-100 flex justify-end">
                                        <button onclick="createNovel()"
                                            class="btn-primary px-8 py-3 shadow-lg shadow-blue-500/20">立即创建</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Tab: Chapter Editor (Hidden by default, shown when editing) -->
                        <div id="tab-editor" class="tab-content hidden animate-fade-in">
                            <div class="flex items-center gap-4 mb-6">
                                <button onclick="switchTab('novels')" class="text-slate-500 hover:text-slate-900"><i
                                        data-lucide="arrow-left" class="w-6 h-6"></i></button>
                                <h2 class="text-2xl font-bold text-slate-900">更新章节 <span id="editorNovelTitle"
                                        class="text-base text-slate-500 font-normal ml-2"></span></h2>
                            </div>

                            <div class="bg-white p-8 rounded-xl border border-gray-200 shadow-sm">
                                <input type="hidden" id="editorNovelId">
                                <div class="space-y-6">
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">章节标题</label>
                                        <input type="text" id="chapterTitle" class="form-input" placeholder="例如：第一章 重生">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">正文内容</label>
                                        <textarea id="chapterContent"
                                            class="form-input h-96 font-serif text-lg leading-relaxed"
                                            placeholder="开始您的创作..."></textarea>
                                    </div>
                                    <div class="flex justify-between items-center pt-4">
                                        <div class="text-sm text-slate-400">请保持创作热情</div>
                                        <button onclick="publishChapter()" class="btn-primary px-8 py-3">发布章节</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Tab: Income -->
                        <div id="tab-income" class="tab-content hidden animate-fade-in">
                            <h2 class="text-2xl font-bold text-slate-900 mb-6">稿费收入</h2>
                            <div class="bg-white p-8 rounded-xl border border-gray-200 shadow-sm text-center py-20">
                                <div class="text-4xl font-black text-slate-900 mb-2">¥ 0.00</div>
                                <p class="text-slate-400">暂无收益，请继续努力创作</p>
                            </div>
                        </div>

                        <!-- Tab: Edit Novel -->
                        <div id="tab-edit-novel" class="tab-content hidden animate-fade-in">
                            <h2 class="text-2xl font-bold text-slate-900 mb-6">编辑作品信息</h2>
                            <div class="bg-white p-8 rounded-xl border border-gray-200 shadow-sm max-w-2xl">
                                <input type="hidden" id="editNovelId">
                                <div class="space-y-6">
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">作品名称</label>
                                        <input type="text" id="editTitle" class="form-input">
                                    </div>
                                    <div class="grid grid-cols-2 gap-6">
                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">作品分类</label>
                                            <select id="editCategory" class="form-input">
                                                <option>玄幻</option>
                                                <option>都市</option>
                                                <option>仙侠</option>
                                                <option>科幻</option>
                                                <option>历史</option>
                                                <option>悬疑</option>
                                            </select>
                                        </div>
                                        <div>
                                            <label class="block text-sm font-bold text-slate-700 mb-2">封面链接 (可选)</label>
                                            <input type="text" id="editCover" class="form-input">
                                        </div>
                                    </div>
                                    <div>
                                        <label class="block text-sm font-bold text-slate-700 mb-2">作品简介</label>
                                        <textarea id="editDesc" class="form-input h-32"></textarea>
                                    </div>
                                    <div class="pt-4 border-t border-gray-100 flex justify-end gap-4">
                                        <button onclick="switchTab('novels')" class="btn-secondary">取消</button>
                                        <button onclick="updateNovel()"
                                            class="btn-primary px-8 py-3 shadow-lg shadow-blue-500/20">保存修改</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </main>
        <div id="toast"></div>

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                checkAuth();
                lucide.createIcons();
            });

            let currentUser = null;

            async function checkAuth() {
                // 1. LocalStorage
                const stored = localStorage.getItem('user');
                if (stored) {
                    currentUser = JSON.parse(stored);
                }

                if (!currentUser || (currentUser.role !== 2 && currentUser.role !== 1)) {
                    // location.href = 'index.jsp';
                }
                if (currentUser) {
                    document.getElementById('welcomeMsg').innerText = `你好，\${currentUser.realname || currentUser.username}`;
                    loadMyNovels();
                }
            }

            function switchTab(tab) {
                document.querySelectorAll('.tab-content').forEach(el => el.classList.add('hidden'));
                document.getElementById(`tab-\${tab}`).classList.remove('hidden');

                document.querySelectorAll('.nav-item').forEach(el => {
                    el.classList.remove('border-blue-600');
                    el.classList.add('border-transparent');
                });

                if (tab === 'novels') loadMyNovels();
            }

            async function loadMyNovels() {
                try {
                    const res = await fetchJson('../creator/novel/list');
                    let myNovels = [];
                    if (res.code === 200) {
                        myNovels = res.data;
                    }

                    const container = document.getElementById('novelListContainer');
                    if (!myNovels || myNovels.length === 0) {
                        container.innerHTML = `<div class="flex flex-col items-center justify-center h-full py-20 text-slate-400">
                                    <i data-lucide="file-x" class="w-12 h-12 mb-4 opacity-50"></i>
                                    <p>暂无作品，开始创作吧</p>
                                 </div>`;
                    } else {
                        container.innerHTML = myNovels.map(n => `
                        <div class="flex items-center gap-6 p-6 border-b border-gray-100 last:border-0 hover:bg-gray-50 transition-colors">
                            <img src="\${n.cover || '../static/images/cover_placeholder.jpg'}" class="w-16 h-20 object-cover rounded shadow-sm bg-gray-200">
                            <div class="flex-1">
                                <h4 class="font-bold text-slate-900 text-lg">\${n.name || n.title}</h4>
                                <div class="text-sm text-slate-500 mt-1">
                                    <span class="bg-blue-100 text-blue-700 px-2 py-0.5 rounded text-xs font-bold mr-2">\${n.categoryName || '默认'}</span>
                                    \${n.totalChapters || 0} 章 · \${n.viewCount || 0} 热度 · \${n.status === 1 ? '连载中' : '已完结'}
                                </div>
                            </div>
                            <div class="flex gap-3">
                                 <button onclick="openEditor('\${n.id}', '\${n.name || n.title}')" class="btn-primary px-3 py-1.5 text-xs">更新章节</button>
                                 <button onclick="openEditNovel('\${n.id}')" class="px-3 py-1.5 border border-gray-200 rounded text-slate-600 hover:text-blue-600 hover:border-blue-200 text-xs transition-colors">编辑</button>
                                 <button onclick="deleteNovel('\${n.id}')" class="px-3 py-1.5 border border-gray-200 rounded text-slate-600 hover:text-red-600 hover:border-red-200 text-xs transition-colors">删除</button>
                            </div>
                        </div>
                    `).join('');
                        lucide.createIcons();
                    }
                } catch (e) {
                    console.error(e);
                }
            }

            async function createNovel() {
                const title = document.getElementById('newTitle').value;
                const category = document.getElementById('newCategory').value;
                const desc = document.getElementById('newDesc').value;
                const cover = document.getElementById('newCover').value;

                if (!title || !desc) {
                    showToast('请填写完整信息', 'error');
                    return;
                }

                const catMap = { '玄幻': 1, '都市': 2, '仙侠': 3, '科幻': 4, '历史': 5, '悬疑': 6 };
                const catId = catMap[category] || 1;

                const formData = new URLSearchParams();
                formData.append('title', title);
                formData.append('categoryId', catId);
                formData.append('intro', desc);
                formData.append('coverUrl', cover);

                try {
                    const res = await fetchJson('../creator/novel/create', { method: 'POST', body: formData });
                    if (res.code === 200) {
                        showToast('新书创建成功', 'success');
                        setTimeout(() => switchTab('novels'), 1000);
                    } else {
                        showToast(res.msg, 'error');
                    }
                } catch (e) {
                    showToast('创建失败', 'error');
                }
            }

            async function openEditNovel(id) {
                // Find novel data from loaded list or fetch details. 
                // We don't have global list, let's just fetch details or iterate if we stored it.
                // Re-fetching list to get details is okay but slightly wasteful. 
                // Let's assume we can find it in DOM or just fetch detail.
                // For simplicity, I'll fetch list again implicitly or just fetch detail?
                // Actually I don't have a 'fetch detail' for creator exposed easily without ID.
                // Let's modify loadMyNovels to store list globally.

                // Hack: Pass data via params in render? Too messy.
                // Better: fetch('../creator/novel/list') and find.
                try {
                    const res = await fetchJson('../creator/novel/list');
                    if (res.code === 200) {
                        const n = res.data.find(x => x.id == id);
                        if (n) {
                            document.getElementById('editNovelId').value = n.id;
                            document.getElementById('editTitle').value = n.name || n.title;
                            document.getElementById('editCategory').value = n.categoryName || '玄幻'; // Needs mapping back if names differ, assuming names match options.
                            document.getElementById('editCover').value = n.cover;
                            document.getElementById('editDesc').value = n.description;
                            switchTab('edit-novel');
                        }
                    }
                } catch (e) { }
            }

            async function updateNovel() {
                const id = document.getElementById('editNovelId').value;
                const title = document.getElementById('editTitle').value;
                const category = document.getElementById('editCategory').value;
                const desc = document.getElementById('editDesc').value;
                const cover = document.getElementById('editCover').value;

                const catMap = { '玄幻': 1, '都市': 2, '仙侠': 3, '科幻': 4, '历史': 5, '悬疑': 6 };
                const catId = catMap[category] || 1;

                const formData = new URLSearchParams();
                formData.append('id', id);
                formData.append('title', title);
                formData.append('categoryId', catId);
                formData.append('intro', desc);
                formData.append('coverUrl', cover);

                try {
                    const res = await fetchJson('../creator/novel/update', { method: 'POST', body: formData });
                    if (res.code === 200) {
                        showToast('修改成功', 'success');
                        switchTab('novels');
                    } else {
                        showToast(res.msg, 'error');
                    }
                } catch (e) {
                    showToast('操作失败', 'error');
                }
            }

            async function deleteNovel(id) {
                if (!confirm('确定要删除这部作品吗？操作不可恢复！')) return;
                try {
                    const formData = new URLSearchParams();
                    formData.append('id', id);
                    const res = await fetchJson('../creator/novel/delete', { method: 'POST', body: formData });
                    if (res.code === 200) {
                        showToast('删除成功', 'success');
                        loadMyNovels();
                    } else {
                        showToast(res.msg, 'error');
                    }
                } catch (e) {
                    showToast('操作失败', 'error');
                }
            }

            function openEditor(id, title) {
                document.getElementById('editorNovelId').value = id;
                document.getElementById('editorNovelTitle').innerText = `《\${title}》`;
                document.getElementById('chapterTitle').value = '';
                document.getElementById('chapterContent').value = '';
                switchTab('editor');
            }

            async function publishChapter() {
                const novelId = document.getElementById('editorNovelId').value;
                const title = document.getElementById('chapterTitle').value;
                const content = document.getElementById('chapterContent').value;

                if (!title || !content) {
                    showToast('章节标题和内容不能为空', 'error');
                    return;
                }

                const formData = new URLSearchParams();
                formData.append('novelId', novelId);
                formData.append('title', title);
                formData.append('content', content);
                formData.append('price', '0');

                try {
                    const res = await fetchJson('../creator/chapter/create', { method: 'POST', body: formData });
                    if (res.code === 200) {
                        showToast('章节发布成功', 'success');
                        setTimeout(() => switchTab('novels'), 1000);
                    } else {
                        showToast(res.msg, 'error');
                    }
                } catch (e) {
                    showToast('发布失败', 'error');
                }
            }
        </script>
    </body>

    </html>