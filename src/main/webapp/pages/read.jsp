<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>阅读 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/css/style.css?v=3">
        <script src="../static/js/script.js"></script>
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
                <a href="javascript:history.back()"
                    class="flex items-center gap-2 text-slate-600 hover:text-blue-600 text-sm font-bold">
                    <i data-lucide="chevron-left" class="w-5 h-5"></i> 返回书页
                </a>
                <span id="chapterTitleHeader" class="text-sm font-bold text-slate-900 truncate max-w-xs">加载中...</span>
                <div class="flex items-center gap-4">
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

        <script>
            document.addEventListener('DOMContentLoaded', () => {
                lucide.createIcons();
                loadContent();

                // Auto Save Progress with Debounce
                window.addEventListener('scroll', debounce(() => {
                    if (novelId && chapterId) {
                        MockDB.saveProgress(novelId, chapterId, window.scrollY);
                    }
                }, 500));
            });

            const novelId = getQueryParam('novelId');
            const chapterId = getQueryParam('chapterId');
            let currentChapterIndex = -1;
            let allChapters = [];

            async function loadContent() {
                if (!novelId || !chapterId) return;

                // Load Chapter Detail
                try {
                    const res = await fetchJson(`../novel/chapter?novelId=\${novelId}&chapterId=\${chapterId}`);
                    if (res.code === 200) {
                        const ch = res.data;
                        document.title = `\${ch.title} - 阅读`;
                        document.getElementById('chapterTitle').innerText = ch.title;
                        document.getElementById('chapterTitleHeader').innerText = ch.title;
                        // Format content: convert newlines to paragraphs
                        const formatted = ch.content.split('\n').map(p => `<p>\${p}</p>`).join('');
                        document.getElementById('content').innerHTML = formatted;

                        // Setup Nav
                        await setupNavigation();

                        // RESTORE PROGRESS
                        // Retrieve saved progress
                        const saved = MockDB.getProgress(novelId);
                        if (saved && saved.chapterId === chapterId && saved.scrollY > 0) {
                            // Small delay to allow layout to settle
                            setTimeout(() => {
                                window.scrollTo({ top: saved.scrollY, behavior: 'smooth' });
                                showToast('已恢复阅读进度', 'success');
                            }, 300);
                        } else {
                            window.scrollTo(0, 0);
                        }
                    }
                } catch (e) {
                    console.error(e);
                }
            }

            async function setupNavigation() {
                // We need full list to know prev/next
                const res = await fetchJson(`../novel/detail?id=\${novelId}`);
                if (res.code === 200) {
                    allChapters = res.data.chapters;
                    currentChapterIndex = allChapters.findIndex(c => c.id == chapterId);

                    const prev = document.getElementById('prevBtn');
                    const next = document.getElementById('nextBtn');

                    if (currentChapterIndex >= 0) {
                        prev.disabled = currentChapterIndex <= 0;
                        next.disabled = currentChapterIndex >= allChapters.length - 1;
                    }
                }
            }

            function goPrev() {
                if (currentChapterIndex > 0) {
                    const prevId = allChapters[currentChapterIndex - 1].id;
                    location.href = `read.jsp?novelId=\${novelId}&chapterId=\${prevId}`;
                }
            }

            function goNext() {
                if (currentChapterIndex < allChapters.length - 1) {
                    const nextId = allChapters[currentChapterIndex + 1].id;
                    location.href = `read.jsp?novelId=\${novelId}&chapterId=\${nextId}`;
                }
            }

            function debounce(func, wait) {
                let timeout;
                return function (...args) {
                    clearTimeout(timeout);
                    timeout = setTimeout(() => func.apply(this, args), wait);
                };
            }
        </script>
    </body>

    </html>