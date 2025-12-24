document.addEventListener('DOMContentLoaded', () => {
    loadNovels();
    lucide.createIcons();
});

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
            if (!keyword) renderRankings(novels.slice(0, 5));
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
