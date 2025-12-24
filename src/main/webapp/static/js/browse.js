
// Filter Logic
let currentFilters = {
    category: 'all',
    status: 'all'
};

document.addEventListener('DOMContentLoaded', () => {
    loadCategories();
    loadBooks();
    lucide.createIcons();

    // Check URL param for initial category (ID or Name)
    const catId = getQueryParam('categoryId');
    if (catId) {
        currentFilters.category = catId;
    }
});

async function loadCategories() {
    const container = document.getElementById('categoryFilter');
    if (!container) return;

    try {
        const res = await fetchJson('../novel/categories');
        if (res.code === 200) {
            const categories = res.data || [];
            const catId = getQueryParam('categoryId');

            let html = `
                <span class="text-sm font-bold text-slate-400 uppercase tracking-wide mr-2">分类</span>
                <button class="filter-btn ${(!catId || catId === 'all') ? 'active bg-slate-100 text-slate-900' : 'text-slate-600'} px-3 py-1 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                    data-type="category" data-val="all">全部</button>
            `;

            html += categories.map(c => `
                <button class="filter-btn ${catId == c.id ? 'active bg-slate-100 text-slate-900' : 'text-slate-600'} px-3 py-1 rounded-md text-sm font-bold hover:bg-slate-100 transition-colors"
                    data-type="category" data-val="${c.id}">${c.name}</button>
            `).join('');

            container.innerHTML = html;
            initFilters();
        }
    } catch (e) { console.error(e); }
}

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
    document.querySelectorAll(`.filter-btn[data-type="${type}"]`).forEach(b => {
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
            const statusVal = n.status === 2 ? '已完结' : '连载中';

            if (currentFilters.category !== 'all') {
                // n.categoryId is what backend returns
                if (String(n.categoryId) !== String(currentFilters.category)) return false;
            }
            if (currentFilters.status !== 'all' && statusVal !== currentFilters.status) return false;
            return true;
        });

        if (filtered.length === 0) {
            container.innerHTML = `<div class="col-span-full py-20 text-center text-slate-400">暂无符合条件的书籍</div>`;
            return;
        }

        container.innerHTML = filtered.map(n => `
<div class="standard-card group cursor-pointer" onclick="location.href='novel_detail.jsp?id=${n.id}'">
    <div class="aspect-[2/3] overflow-hidden bg-gray-100 relative rounded-t-lg">
        <img src="${n.cover || '../static/images/cover_placeholder.jpg'}" 
             class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
             onerror="this.src='../static/images/cover_placeholder.jpg'">
        <div class="absolute top-2 right-2 px-2 py-1 bg-black/60 backdrop-blur rounded text-[10px] text-white font-bold">
            ${n.status === 2 ? '已完结' : '连载中'}
        </div>
    </div>
    <div class="p-3">
        <h4 class="font-bold text-slate-900 truncate mb-1 text-sm group-hover:text-blue-600 transition-colors">${n.name}</h4>
        <div class="flex items-center justify-between text-xs text-slate-500">
             <span class="font-medium">${n.authorName || '佚名'}</span>
             <span class="text-slate-400">${n.categoryName || '综合'}</span>
        </div>
    </div>
</div>
`).join('');
        lucide.createIcons();
    } catch (e) {
        console.error(e);
        container.innerHTML = '<div class="col-span-full py-20 text-center text-red-500">加载出错</div>';
    }
}
