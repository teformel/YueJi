<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>个人中心 - 阅己 YueJi</title>
        <link rel="stylesheet" href="../static/css/style.css">
        <script src="../static/js/script.js"></script>
    </head>

    <body class="bg-glow">
        <%@ include file="header.jsp" %>

            <main class="container py-12 reveal">
                <div class="flex flex-col lg:flex-row gap-10">
                    <!-- Sidebar Navigation: Floating Panel -->
                    <aside class="w-full lg:w-80 space-y-6">
                        <!-- User Profile Card -->
                        <div class="luminous-panel rounded-[2.5rem] p-8 text-center relative overflow-hidden group">
                            <div class="absolute inset-0 bg-gradient-to-b from-primary/10 to-transparent"></div>
                            <div class="relative">
                                <div
                                    class="w-24 h-24 rounded-3xl bg-surface-elevated border-2 border-primary/30 mx-auto flex items-center justify-center mb-6 shadow-2xl relative group-hover:scale-105 transition-transform">
                                    <span id="avatarInitial" class="text-4xl font-black text-primary">U</span>
                                    <div
                                        class="absolute -bottom-2 -right-2 w-8 h-8 rounded-full bg-accent flex items-center justify-center border-4 border-canvas text-white">
                                        <i data-lucide="check" class="w-4 h-4"></i>
                                    </div>
                                </div>
                                <h2 id="sidebarNickname" class="text-2xl font-black text-white mb-1 truncate">加载中...
                                </h2>
                                <p id="sidebarUsername" class="text-text-dim text-xs tracking-widest uppercase mb-6">
                                    @username</p>

                                <div class="grid grid-cols-2 gap-3">
                                    <div class="bg-white/5 p-3 rounded-2xl border border-white/5">
                                        <div id="infoGoldSide" class="text-lg font-black text-primary">0</div>
                                        <div class="text-[10px] text-text-dim uppercase">金币余额</div>
                                    </div>
                                    <div class="bg-white/5 p-3 rounded-2xl border border-white/5">
                                        <div class="text-lg font-black text-accent">V1</div>
                                        <div class="text-[10px] text-text-dim uppercase">读者等级</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Nav Menu -->
                        <nav class="luminous-panel rounded-[2rem] p-3 space-y-1">
                            <button onclick="showTab('info')" id="btn-info" class="uc-nav-item active">
                                <i data-lucide="layout-dashboard" class="w-5 h-5"></i>
                                <span>个人控制台</span>
                            </button>
                            <button onclick="showTab('collection')" id="btn-collection" class="uc-nav-item">
                                <i data-lucide="library" class="w-5 h-5"></i>
                                <span>我的私人书库</span>
                            </button>
                            <button onclick="showTab('gold')" id="btn-gold" class="uc-nav-item">
                                <i data-lucide="zap" class="w-5 h-5"></i>
                                <span>财富充值</span>
                            </button>
                            <div class="my-4 border-t border-border-dim mx-3"></div>
                            <button onclick="logout()" class="uc-nav-item text-red-400/80 hover:bg-red-500/10">
                                <i data-lucide="power" class="w-5 h-5"></i>
                                <span>安全离线</span>
                            </button>

                            <div id="privileged-nav" class="mt-8 space-y-1 hidden">
                                <div
                                    class="px-5 py-3 text-[10px] font-black text-primary uppercase tracking-[0.3em] opacity-60">
                                    特权枢纽</div>
                                <button id="btn-creator" onclick="location.href='creator_dashboard.jsp'"
                                    class="uc-nav-item border border-primary/20 bg-primary/5 hover:bg-primary/10 text-primary !gap-4">
                                    <i data-lucide="pen-tool" class="w-5 h-5"></i>
                                    <span>创作者工作台</span>
                                </button>
                                <button id="btn-admin" onclick="location.href='admin_dashboard.jsp'"
                                    class="uc-nav-item border border-accent/20 bg-accent/5 hover:bg-accent/10 text-accent !gap-4 !hidden">
                                    <i data-lucide="shield-check" class="w-5 h-5"></i>
                                    <span>上帝模式 (后台)</span>
                                </button>
                            </div>
                        </nav>
                    </aside>

                    <!-- Main Content Area -->
                    <section class="flex-1 space-y-10 min-h-[700px]">

                        <!-- Tab: Profile Info -->
                        <div id="tab-info" class="tab-pane reveal space-y-10">
                            <div class="luminous-panel rounded-[3rem] p-10 lg:p-14 relative overflow-hidden">
                                <div
                                    class="absolute top-0 right-0 w-1/3 h-full bg-gradient-to-l from-primary/5 to-transparent pointer-events-none">
                                </div>
                                <div class="relative z-10">
                                    <h3 class="text-4xl font-black mb-2">个人资料设定</h3>
                                    <p class="text-text-muted mb-12">在这个数字化身的世界里，定义您的独特标识。</p>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-4xl">
                                        <div class="space-y-3">
                                            <label
                                                class="text-xs font-bold text-text-dim uppercase tracking-widest ml-1">身份账号</label>
                                            <div
                                                class="flex items-center gap-4 bg-black/20 border border-border-highlight rounded-2xl p-4 text-text-muted">
                                                <i data-lucide="hash" class="w-5 h-5 opacity-40"></i>
                                                <span id="infoUsername" class="font-bold">---</span>
                                            </div>
                                        </div>
                                        <div class="space-y-3">
                                            <label
                                                class="text-xs font-bold text-text-dim uppercase tracking-widest ml-1">当前余额</label>
                                            <div
                                                class="flex items-center gap-4 bg-primary/10 border border-primary/20 rounded-2xl p-4 text-primary">
                                                <i data-lucide="coins" class="w-5 h-5"></i>
                                                <span id="infoGold" class="text-xl font-black font-heading">0</span>
                                                <span class="text-xs font-bold">金币</span>
                                            </div>
                                        </div>
                                        <div class="space-y-3 md:col-span-2">
                                            <label
                                                class="text-xs font-bold text-text-dim uppercase tracking-widest ml-1">对外昵称</label>
                                            <div class="relative group/input">
                                                <input type="text" id="infoNickname"
                                                    class="w-full bg-surface-elevated border border-border-highlight rounded-2xl p-5 outline-none focus:border-primary transition-all text-white font-bold"
                                                    placeholder="输入您的新昵称...">
                                                <i data-lucide="edit-3"
                                                    class="absolute right-5 top-1/2 -translate-y-1/2 w-5 h-5 text-text-dim group-focus-within/input:text-primary transition-colors"></i>
                                            </div>
                                        </div>
                                    </div>

                                    <button onclick="updateProfile()"
                                        class="btn-ultimate px-12 py-5 mt-10 text-lg shadow-2xl">
                                        执行更新
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Tab: My Collection -->
                        <div id="tab-collection" class="tab-pane hidden space-y-8">
                            <div class="flex items-center justify-between mb-4">
                                <h3 class="text-3xl font-black flex items-center gap-3">
                                    <i data-lucide="library" class="w-8 h-8 text-primary"></i>
                                    私人书库
                                </h3>
                                <button onclick="loadCollection()"
                                    class="p-3 rounded-2xl bg-surface-elevated hover:text-primary transition-all">
                                    <i data-lucide="rotate-cw" class="w-5 h-5"></i>
                                </button>
                            </div>
                            <div id="collectionList" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                                <!-- Collection items loaded via JS -->
                                <div class="col-span-full py-24 text-center opacity-30 italic">
                                    正在同步云端书架资源...
                                </div>
                            </div>
                        </div>

                        <!-- Tab: Recharge Gold -->
                        <div id="tab-gold" class="tab-pane hidden space-y-8">
                            <div class="luminous-panel rounded-[3rem] p-12 overflow-hidden relative">
                                <div class="absolute -top-12 -right-12 w-64 h-64 bg-accent/20 blur-[80px] rounded-full">
                                </div>

                                <h3 class="text-3xl font-black mb-8">金币财富充值</h3>

                                <div
                                    class="bg-primary/10 border border-primary/20 rounded-3xl p-8 flex items-center gap-8 mb-12">
                                    <div
                                        class="w-20 h-20 bg-primary rounded-2xl flex items-center justify-center text-white shadow-2xl shadow-primary/40">
                                        <i data-lucide="gem" class="w-10 h-10"></i>
                                    </div>
                                    <div>
                                        <div class="text-xs font-black text-primary uppercase tracking-widest mb-1">
                                            全球标准汇率</div>
                                        <div class="text-3xl font-black font-heading text-white">1 CNY = 100 <span
                                                class="text-primary">G</span></div>
                                    </div>
                                </div>

                                <div class="space-y-8 max-w-2xl">
                                    <div class="grid grid-cols-2 gap-8">
                                        <div class="space-y-3">
                                            <label
                                                class="text-xs font-bold text-text-dim uppercase tracking-widest ml-1">投入金额
                                                (¥)</label>
                                            <input type="number" id="rechargePayment" value="10.00" step="0.01"
                                                oninput="updateGoldCalc()"
                                                class="w-full bg-black/20 border border-border-highlight rounded-2xl p-5 outline-none focus:border-accent transition-all text-white font-black text-2xl">
                                        </div>
                                        <div class="space-y-3">
                                            <label
                                                class="text-xs font-bold text-text-dim uppercase tracking-widest ml-1">获得金币
                                                (G)</label>
                                            <div
                                                class="w-full bg-accent/5 border border-accent/20 rounded-2xl p-5 text-accent font-black text-2xl flex items-center gap-3">
                                                <i data-lucide="zap" class="w-6 h-6"></i>
                                                <span id="rechargeAmountDisplay">1000</span>
                                            </div>
                                        </div>
                                    </div>

                                    <button onclick="recharge()"
                                        class="w-full py-6 bg-accent text-white rounded-[2rem] font-black text-xl shadow-2xl shadow-accent/20 hover:scale-[1.01] active:scale-95 transition-all flex items-center justify-center gap-4">
                                        <i data-lucide="credit-card" class="w-8 h-8"></i>
                                        开启极速支付
                                    </button>
                                    <p class="text-center text-xs text-text-dim leading-relaxed">
                                        充值即代表您已阅读并同意 <span
                                            class="text-white hover:underline cursor-pointer">《用户虚拟财富协议》</span><br>
                                        所有的充值金额将直接用于支持原创文学事业。
                                    </p>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </main>

            <%@ include file="footer.jsp" %>

                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        loadProfile();
                        lucide.createIcons();
                    });

                    function showTab(tabName) {
                        document.querySelectorAll('.tab-pane').forEach(el => {
                            el.classList.add('hidden');
                            el.classList.remove('reveal');
                        });
                        const target = document.getElementById('tab-' + tabName);
                        target.classList.remove('hidden');
                        setTimeout(() => target.classList.add('reveal'), 10);

                        document.querySelectorAll('.uc-nav-item').forEach(btn => btn.classList.remove('active'));
                        document.getElementById('btn-' + tabName).classList.add('active');

                        if (tabName === 'collection') loadCollection();
                        lucide.createIcons();
                    }

                    async function loadProfile() {
                        const result = await fetchJson("../user/info");
                        if (result && result.status === 200) {
                            const u = result.data.data;
                            document.getElementById('infoUsername').innerText = u.username;
                            document.getElementById('infoNickname').value = u.nickname || '';
                            document.getElementById('infoGold').innerText = u.goldBalance;
                            document.getElementById('infoGoldSide').innerText = u.goldBalance;

                            document.getElementById('sidebarNickname').innerText = u.nickname || '新启读者';
                            document.getElementById('sidebarUsername').innerText = '@' + u.username;
                            document.getElementById('avatarInitial').innerText = (u.nickname || u.username)[0].toUpperCase();

                            // Privileged checks
                            const privNav = document.getElementById('privileged-nav');
                            const creatorBtn = document.getElementById('btn-creator');
                            const adminBtn = document.getElementById('btn-admin');

                            if (u.isAuthor || u.role === 'admin') {
                                privNav.classList.remove('hidden');
                                if (u.isAuthor) creatorBtn.classList.remove('!hidden'); else creatorBtn.classList.add('!hidden');
                                if (u.role === 'admin') adminBtn.classList.remove('!hidden'); else adminBtn.classList.add('!hidden');
                            }
                            lucide.createIcons();
                        }
                    }

                    async function updateProfile() {
                        const nickname = document.getElementById('infoNickname').value.trim();
                        if (!nickname) return showToast("请输入有效的昵称", "error");

                        const params = new URLSearchParams();
                        params.append('nickname', nickname);

                        const result = await fetchJson("../user/update", {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: params
                        });
                        if (result && result.status === 200) {
                            showToast("标识更新完成", "success");
                            loadProfile();
                        } else {
                            showToast((result.data && result.data.msg) || "更新同步失败", "error");
                        }
                    }

                    async function loadCollection() {
                        const list = document.getElementById('collectionList');
                        const res = await fetchJson("../interaction/collection/list");
                        if (res && res.status === 200) {
                            const items = res.data.data;
                            if (!items || items.length === 0) {
                                list.innerHTML = `
                        <div class="col-span-full py-24 text-center luminous-panel rounded-3xl opacity-40">
                            <i data-lucide="book-dashed" class="w-16 h-16 mx-auto mb-4 opacity-20"></i>
                            <p class="text-sm">私人书库尚处于空白纪元</p>
                        </div>
                    `;
                                lucide.createIcons();
                                return;
                            }

                            list.innerHTML = items.map(item => `
                    <div class="theater-card reveal" onclick="location.href='novel_detail.jsp?id=\${item.novelId}'">
                         <div class="cover-wrapper aspect-[2/3]">
                             <img src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=300" alt="\${item.title}">
                         </div>
                         <div class="overlay p-4">
                             <h4 class="text-sm font-black text-white truncate">\${item.title}</h4>
                             <div class="flex items-center justify-between text-[10px] text-text-dim mt-2 tracking-tighter uppercase font-bold">
                                 <span>继续阅读之旅</span>
                                 <i data-lucide="arrow-right" class="w-3 h-3"></i>
                             </div>
                         </div>
                    </div>
                `).join('');
                            lucide.createIcons();
                        } else {
                            list.innerHTML = '<p class="col-span-full text-center text-red-400">书柜检索异常...</p>';
                        }
                    }

                    function updateGoldCalc() {
                        const pay = document.getElementById('rechargePayment').value;
                        document.getElementById('rechargeAmountDisplay').innerText = Math.floor(pay * 100);
                    }

                    async function recharge() {
                        const pay = document.getElementById('rechargePayment').value;
                        const gold = Math.floor(pay * 100);
                        if (gold <= 0) return showToast("金额无效", "error");

                        if (!confirm(`确认支付 ¥\${pay} 兑换 \${gold} 金币吗？`)) return;

                        const params = new URLSearchParams();
                        params.append('amount', gold);
                        params.append('payment', pay);

                        const result = await fetchJson("../pay/order/create", {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                            body: params
                        });
                        if (result && result.status === 200) {
                            showToast(`\${gold} 金币已存入您的账户`, "success");
                            loadProfile();
                        } else {
                            showToast((result.data && result.data.msg) || "支付渠道连接受阻", "error");
                        }
                    }
                </script>

                <style>
                    .tab-pane {
                        opacity: 0;
                        transform: translateY(20px);
                        transition: all 0.5s cubic-bezier(0.165, 0.84, 0.44, 1);
                    }

                    .tab-pane.reveal {
                        opacity: 1;
                        transform: translateY(0);
                    }

                    .uc-nav-item {
                        display: flex;
                        align-items: center;
                        gap: 1rem;
                        width: 100%;
                        padding: 1.25rem 1.5rem;
                        border-radius: 1.5rem;
                        font-weight: 700;
                        color: var(--text-muted);
                        transition: all 0.3s;
                        text-align: left;
                    }

                    .uc-nav-item:hover {
                        background: rgba(255, 255, 255, 0.05);
                        color: white;
                    }

                    .uc-nav-item.active {
                        background: var(--primary);
                        color: white;
                        box-shadow: 0 10px 30px -5px var(--primary-glow);
                    }
                </style>
    </body>

    </html>