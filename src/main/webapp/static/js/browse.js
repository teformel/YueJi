
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
    currentPage = 1; // Reset to first page

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

// Pagination State
let currentPage = 1;
const pageSize = 12; // 4x3 or 2x6 grid
let currentFilteredBooks = [];

async function loadBooks() {
    const container = document.getElementById('browseGrid');

    try {
        // Fetch all novels from backend
        let url = "../novel/list";
        const sort = getQueryParam('sort');
        if (sort) {
            url += `?sort=${encodeURIComponent(sort)}`;
        }
        const result = await fetchJson(url);
        if (!result || result.code !== 200) {
            container.innerHTML = '<div class="col-span-full py-20 text-center text-red-500">加载失败</div>';
            return;
        }

        const allNovels = result.data;

        // Filter
        currentFilteredBooks = allNovels.filter(n => {
            const statusVal = n.status === 2 ? '已完结' : '连载中';

            if (currentFilters.category !== 'all') {
                if (String(n.categoryId) !== String(currentFilters.category)) return false;
            }
            if (currentFilters.status !== 'all' && statusVal !== currentFilters.status) return false;
            return true;
        });

        if (currentFilteredBooks.length === 0) {
            container.innerHTML = `<div class="col-span-full py-20 text-center text-slate-400">暂无符合条件的书籍</div>`;
            renderPagination(0);
            return;
        }

        renderCurrentPage();

    } catch (e) {
        console.error(e);
        container.innerHTML = '<div class="col-span-full py-20 text-center text-red-500">加载出错</div>';
    }
}

function renderCurrentPage() {
    const container = document.getElementById('browseGrid');

    const start = (currentPage - 1) * pageSize;
    const end = start + pageSize;
    const pageData = currentFilteredBooks.slice(start, end);

    container.innerHTML = pageData.map(n => `
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
    const totalPages = Math.ceil(currentFilteredBooks.length / pageSize);
    renderPagination(totalPages);

    // Scroll to top of grid
    if (container.parentElement) {
        container.parentElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
}

function renderPagination(totalPages) {
    const container = document.getElementById('paginationContainer');
    if (!container) return;

    if (totalPages <= 1) {
        container.innerHTML = '';
        return;
    }

    let html = '';

    // Prev
    html += `<button onclick="changePage(${currentPage - 1})" 
        class="px-4 py-2 border border-gray-200 rounded-lg ${currentPage === 1 ? 'bg-gray-50 text-slate-300 cursor-not-allowed' : 'bg-white text-slate-600 hover:bg-gray-50'}">上一页</button>`;

    // Page Numbers (Simple: 1 ... current ... last)
    for (let i = 1; i <= totalPages; i++) {
        // Show first, last, current, and adjacent to current
        if (i === 1 || i === totalPages || (i >= currentPage - 1 && i <= currentPage + 1)) {
            const activeClass = i === currentPage ? 'bg-slate-900 text-white font-bold' : 'bg-white border border-gray-200 text-slate-600 hover:bg-gray-50';
            html += `<button onclick="changePage(${i})" class="px-4 py-2 rounded-lg ${activeClass}">${i}</button>`;
        } else if (i === currentPage - 2 || i === currentPage + 2) {
            html += `<span class="px-2 py-2 text-slate-400">...</span>`;
        }
    }

    // Next
    html += `<button onclick="changePage(${currentPage + 1})" 
        class="px-4 py-2 border border-gray-200 rounded-lg ${currentPage === totalPages ? 'bg-gray-50 text-slate-300 cursor-not-allowed' : 'bg-white text-slate-600 hover:bg-gray-50'}">下一页</button>`;

    container.innerHTML = html;
}

function changePage(page) {
    const totalPages = Math.ceil(currentFilteredBooks.length / pageSize);
    if (page < 1 || page > totalPages) return;
    currentPage = page;
    renderCurrentPage();
}
