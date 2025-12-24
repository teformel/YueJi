<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>作家工作台 - 阅己 YueJi</title>
        <link rel="stylesheet"
            href="${pageContext.request.contextPath}/static/css/style.css?v=${System.currentTimeMillis()}">
        <script src="${pageContext.request.contextPath}/static/js/lucide.js"></script>
        <script src="${pageContext.request.contextPath}/static/js/script.js?v=${System.currentTimeMillis()}"></script>
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

        <script
            src="${pageContext.request.contextPath}/static/js/creator_dashboard.js?v=${System.currentTimeMillis()}"></script>

    </body>

    </html>