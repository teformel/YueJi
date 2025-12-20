<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>正在阅读 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/style.css">
        <script src="../static/script.js"></script>
        <style>
            /* Immersive Themes */
            .theme-paper {
                --bg: #f4ecd8;
                --text: #332b1d;
                --panel: rgba(51, 43, 29, 0.05);
                --shadow: rgba(0, 0, 0, 0.1);
            }

            .theme-midnight {
                --bg: #020617;
                --text: #94a3b8;
                --panel: rgba(255, 255, 255, 0.05);
                --shadow: rgba(0, 0, 0, 0.5);
            }

            .theme-ocean {
                --bg: #0f172a;
                --text: #cbd5e1;
                --panel: rgba(255, 255, 255, 0.08);
                --shadow: rgba(0, 0, 0, 0.4);
            }

            .theme-eye {
                --bg: #ceddcd;
                --text: #2d3e2d;
                --panel: rgba(45, 62, 45, 0.05);
                --shadow: rgba(0, 0, 0, 0.05);
            }

            body.reading-mode {
                background-color: var(--bg);
                color: var(--text);
                transition: all 0.5s ease;
            }

            .read-container {
                max-width: 860px;
                margin: 0 auto;
                padding: 8rem 2rem;
                min-height: 100vh;
            }

            .reading-content {
                font-size: 20px;
                line-height: 2.1;
                letter-spacing: 0.02em;
                text-align: justify;
            }

            /* V2 Floating Hub */
            .floating-hub {
                position: fixed;
                left: 2rem;
                bottom: 2rem;
                display: flex;
                flex-direction: column;
                gap: 1rem;
                z-index: 100;
            }

            .hub-btn {
                width: 3.5rem;
                height: 3.5rem;
                border-radius: 1.25rem;
                background: var(--panel);
                backdrop-filter: blur(12px);
                border: 1px solid rgba(0, 0, 0, 0.05);
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                color: var(--text);
                box-shadow: 0 8px 24px var(--shadow);
            }

            .hub-btn:hover {
                transform: scale(1.1) translateY(-5px);
                background: var(--primary);
                color: white;
                border-color: transparent;
            }
        </style>
    </head>

    <body class="reading-mode theme-ocean">
        <!-- Immersive Header -->
        <header
            class="fixed top-0 left-0 right-0 py-6 px-10 flex items-center justify-between z-50 bg-transparent pointer-events-none">
            <button onclick="goBack()" class="hub-btn pointer-events-auto shadow-xl">
                <i data-lucide="arrow-left" class="w-5 h-5"></i>
            </button>
            <div class="pointer-events-auto flex flex-col items-center">
                <span id="chapterTitleHeader"
                    class="text-xs font-bold tracking-widest uppercase opacity-40">阅己阅读空间</span>
                <div class="w-12 h-0.5 bg-primary/30 mt-1 rounded-full"></div>
            </div>
            <button onclick="location.href='index.jsp'" class="hub-btn pointer-events-auto shadow-xl">
                <i data-lucide="home" class="w-5 h-5"></i>
            </button>
        </header>

        <!-- Reading Stage -->
        <main class="read-container reveal">
            <article class="space-y-12">
                <div class="text-center mb-16">
                    <h1 id="chapterTitle" class="text-4xl lg:text-5xl font-black mb-6">正在翻开书页...</h1>
                    <div class="w-24 h-1 bg-primary mx-auto rounded-full opacity-30"></div>
                </div>

                <div id="textContent" class="reading-content serif-content">
                    <!-- Content will be injected here -->
                </div>

                <!-- Paywall Interceptor -->
                <div id="paywall"
                    class="hidden py-20 px-8 rounded-[3rem] border-2 border-dashed border-primary/20 text-center space-y-8 bg-black/5 backdrop-blur-md">
                    <div
                        class="w-20 h-20 bg-primary/20 rounded-full flex items-center justify-center mx-auto text-primary">
                        <i data-lucide="lock" class="w-10 h-10"></i>
                    </div>
                    <h3 class="text-3xl font-black">支付 <span id="chapterPrice" class="text-primary">--</span> 金币以续读</h3>
                    <p class="text-text-muted max-w-sm mx-auto">
                        每一段精彩的故事都值得被珍视。支持原创，让阅读更有温度。
                    </p>
                    <div class="flex items-center justify-center gap-4">
                        <button class="btn-ultimate px-12 py-4" onclick="buyChapter()">立即开启</button>
                        <button onclick="location.href='user_center.jsp'"
                            class="font-bold text-accent px-6 py-4 hover:underline">充值金币</button>
                    </div>
                </div>
            </article>
        </main>

        <!-- Controls Hub -->
        <div class="floating-hub">
            <button class="hub-btn" onclick="toggleTheme('theme-paper')" title="经典纸感">
                <i data-lucide="book" class="w-5 h-5"></i>
            </button>
            <button class="hub-btn" onclick="toggleTheme('theme-midnight')" title="深夜静读">
                <i data-lucide="moon" class="w-5 h-5"></i>
            </button>
            <button class="hub-btn" onclick="toggleTheme('theme-eye')" title="舒爽护眼">
                <i data-lucide="leaf" class="w-5 h-5"></i>
            </button>
            <button class="hub-btn" onclick="scrollToTop()">
                <i data-lucide="chevron-up" class="w-5 h-5"></i>
            </button>
        </div>

        <script>
            const chapterId = getQueryParam('id') || getQueryParam('chapterId');
            let currentNovelId = null;

            document.addEventListener('DOMContentLoaded', () => {
                if (chapterId) {
                    loadContent();
                }
                lucide.createIcons();
            });

            async function loadContent() {
                const data = await fetchJson("${pageContext.request.contextPath}/chapter/content?id=" + chapterId);
                if (data && data.status === 200) {
                    const ch = data.data;
                    currentNovelId = ch.novelId;
                    document.getElementById('chapterTitle').innerText = ch.title;
                    document.getElementById('chapterTitleHeader').innerText = ch.title;
                    document.title = ch.title + " - 阅己 YueJi";

                    if (ch.isLocked) {
                        document.getElementById('paywall').classList.remove('hidden');
                        document.getElementById('chapterPrice').innerText = ch.price;
                    } else {
                        document.getElementById('textContent').innerHTML = ch.content ? ch.content.split('\n').map(p => `<p class="mb-8">${p}</p>`).join('') : '正文内容暂不翼而飞...';
                    }
                    lucide.createIcons();
                } else {
                    showToast("未找到此章节内容", "error");
                }
            }

            function toggleTheme(theme) {
                document.body.className = 'reading-mode ' + theme;
                showToast("场景已切换", "success");
            }

            function scrollToTop() {
                window.scrollTo({ top: 0, behavior: 'smooth' });
            }

            function goBack() {
                if (currentNovelId) {
                    location.href = "novel_detail.jsp?id=" + currentNovelId;
                } else {
                    history.back();
                }
            }

            async function buyChapter() {
                const result = await fetchJson("${pageContext.request.contextPath}/chapter/buy?id=" + chapterId, { method: 'POST' });
                if (result && result.status === 200) {
                    showToast("解锁成功", "success");
                    setTimeout(() => location.reload(), 800);
                } else {
                    showToast(result ? result.data.msg : "尝试开启失败", "error");
                }
            }
        </script>
    </body>

    </html>