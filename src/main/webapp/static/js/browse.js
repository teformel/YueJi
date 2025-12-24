
// Filter Logic
let currentFilters = {
    category: 'all',
    status: 'all'
};

document.addEventListener('DOMContentLoaded', () => {
    initFilters();
    loadBooks();
    lucide.createIcons();

    // Check URL param for initial category
    const catParam = getQueryParam('category');
    if (catParam) {
        setFilter('category', catParam);
    }
});

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
            // Backend returns category_id, frontend uses names. 
            // Mapping might be needed if n.category is ID. 
            // NovelDao maps category name to n.categoryName.
            // browse.jsp uses 'category' name matching.

            // Check data structure from NovelDaoImpl:
            // n.setCategoryName(rs.getString("category_name"));
            // Frontend expects n.category (from old MockDB).
            // We need to normalize this.
            const catName = n.categoryName || n.category || '其他';
            const statusVal = n.status === 2 ? '已完结' : '连载中'; // 1: Serial, 2: Finished (Assuming)

            if (currentFilters.category !== 'all' && catName !== currentFilters.category) return false;
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
