loadNovels();
loadRankings();
loadAnnouncements();
lucide.createIcons();

// Bind search counter
bindCharCounter('searchInput', 'count-searchInput', 50);

async function loadAnnouncements() {
    try {
        const res = await fetchJson('../novel/announcements');
        if (res.code === 200 && res.data && res.data.length > 0) {
            const bar = document.getElementById('announcementBar');
            const scroll = document.getElementById('announcementScroll');
            bar.classList.remove('hidden');

            // Render announcements
            scroll.innerHTML = res.data.map(a => `
                <div class="flex items-center gap-2 cursor-pointer hover:underline" onclick="showAnnouncementDetail(${JSON.stringify(a).replace(/"/g, '&quot;')})">
                    <span class="text-blue-900 font-bold"># ${a.title}</span>
                    <span class="text-blue-600/70 text-xs">|</span>
                    <span class="text-blue-700/80 max-w-[300px] truncate">${a.content}</span>
                </div>
            `).join('<div class="w-4"></div>'); // Gap between items

            // Simple marquee effect if multiple items or long text
            startMarquee(scroll);
        }
    } catch (e) {
        console.error("加载公告失败:", e);
    }
}

function startMarquee(el) {
    let pos = 0;
    const scroll = () => {
        pos -= 0.5; // slow scroll
        if (Math.abs(pos) > el.scrollWidth / 2 && el.scrollWidth > el.parentElement.offsetWidth) {
            pos = 0;
        }
        el.style.transform = `translateX(${pos}px)`;
        requestAnimationFrame(scroll);
    };

    // Duplicate content for seamless loop if content is wider than container
    if (el.scrollWidth > el.parentElement.offsetWidth) {
        el.innerHTML += el.innerHTML;
        scroll();
    }
}

function showAnnouncementDetail(a) {
    // Simple window alert for now, or could use a modal
    alert(`【${a.title}】\n\n${a.content}\n\n发布时间：${new Date(a.createTime).toLocaleString()}`);
}

async function loadNovels() {
    const grid = document.getElementById('novelGrid');
    const title = document.getElementById('sectionTitle');
    const keyword = getQueryParam('keyword');
    const searchInput = document.getElementById('searchInput');

    if (keyword && searchInput) {
        searchInput.value = keyword;
    }

    if (title) {
        if (keyword) {
            title.innerHTML = `<i data-lucide="search" class="w-6 h-6 text-blue-600"></i> 搜索结果：${keyword}`;
            title.parentElement.innerHTML += `
                <button onclick="clearSearch()" id="btnClearSearch" class="ml-auto text-sm text-blue-600 font-bold hover:underline flex items-center gap-1">
                    <i data-lucide="x-circle" class="w-4 h-4"></i> 清除搜索
                </button>
            `;
        } else {
            title.innerHTML = `<i data-lucide="sparkles" class="w-6 h-6 text-yellow-500"></i> 精选推荐`;
            const btn = document.getElementById('btnClearSearch');
            if (btn) btn.remove();
        }
        lucide.createIcons();
    }

    try {
        const url = keyword ? `../novel/list?keyword=${encodeURIComponent(keyword)}` : "../novel/list";
        const result = await fetchJson(url);
        if (result && result.code === 200) {
            const novels = result.data;
            renderGrid(novels.slice(0, 9));
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
<div class="standard-card group cursor-pointer" onclick="location.href='novel_detail.jsp?id=${n.id}'">
    <div class="aspect-[2/3] overflow-hidden bg-gray-100 relative">
        <img src="${n.cover || '../static/images/cover_placeholder.jpg'}" 
             class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
             onerror="this.src='../static/images/cover_placeholder.jpg'">
    </div>
    <div class="p-4">
        <h4 class="font-bold text-slate-900 truncate mb-1 group-hover:text-blue-600 transition-colors">${n.name}</h4>
        <p class="text-xs text-slate-500 font-medium uppercase tracking-wide">${n.authorName || '佚名'}</p>
    </div>
</div>
`).join('');
    lucide.createIcons();
}

async function loadRankings() {
    try {
        const result = await fetchJson("../novel/list?sort=hot");
        if (result && result.code === 200) {
            renderRankings(result.data.slice(0, 5));
        }
    } catch (e) {
        console.error("加载排行榜失败:", e);
    }
}

function renderRankings(novels) {
    const container = document.getElementById('rankingList');
    container.innerHTML = novels.map((n, i) => `
<div class="flex items-center gap-4 p-3 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors" onclick="location.href='novel_detail.jsp?id=${n.id}'">
    <span class="text-lg font-black w-6 text-center ${i < 3 ? 'text-orange-500' : 'text-slate-300'}">${i + 1}</span>
    <div class="flex-1 min-w-0">
        <div class="text-sm font-bold text-slate-700 truncate hover:text-blue-600 transition-colors">${n.name}</div>
        <div class="text-xs text-slate-400">${n.categoryName || '综合'}</div>
    </div>
</div>
`).join('');
}

async function handleSearch() {
    const q = document.getElementById('searchInput').value.trim();
    if (!q) return;
    location.href = `index.jsp?keyword=${encodeURIComponent(q)}`;
}

document.getElementById('searchInput').addEventListener('keypress', (e) => {
    if (e.key === 'Enter') handleSearch();
});

function clearSearch() {
    location.href = 'index.jsp';
}

async function handleContribute() {
    const user = Auth.getUser();
    if (!user) {
        location.href = 'login.jsp';
        return;
    }
    const role = user.role === 'admin' ? 1 : parseInt(user.role);
    if (role === 2 || role === 1) {
        location.href = 'creator_dashboard.jsp';
    } else {
        location.href = 'user_center.jsp';
    }
}
