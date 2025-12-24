
document.addEventListener('DOMContentLoaded', () => {
    lucide.createIcons();
    loadContent();

    // Set back link
    if (novelId) {
        document.getElementById('backLink').href = `novel_detail.jsp?id=${novelId}`;
    }

    // Auto Save Progress with Debounce
    // Auto Save Progress with Debounce
    window.addEventListener('scroll', debounce(() => {
        if (novelId && chapterId && window.fetchJson) {
            const scrollY = window.scrollY || document.documentElement.scrollTop;
            // Silent POST
            fetchJson(`../interaction/progress/sync?novelId=${novelId}&chapterId=${chapterId}&scroll=${Math.floor(scrollY)}`, { method: 'POST' })
                .catch(e => { });
        }
    }, 2000));
});

const novelId = getQueryParam('novelId');
const chapterId = getQueryParam('chapterId');
let currentChapterIndex = -1;
let allChapters = [];

async function loadContent() {
    if (!novelId || !chapterId) return;

    // Load Chapter Detail (Real Backend)
    try {
        const res = await fetchJson(`../read/content?chapterId=${chapterId}`);
        if (res.code === 200) {
            const ch = res.data;
            document.title = `${ch.title} - 阅读`;
            document.getElementById('chapterTitle').innerText = ch.title;
            document.getElementById('chapterTitleHeader').innerText = ch.title;

            const content = ch.content || '内容为空';

            // Check for Paid & Unpurchased state (Backend returns specific message)
            // Or if we had isPaid flag. The java code says: 
            // if (!purchased) chapter.setContent("此章节为付费章节，请购买后阅读。");

            if (content.includes("此章节为付费章节") && content.length < 50) {
                document.getElementById('content').innerHTML = `
                    <div class="text-center py-20 bg-gray-50 rounded-lg border border-dashed border-gray-300">
                        <div class="mb-6">
                            <i data-lucide="lock" class="w-12 h-12 text-yellow-500 mx-auto mb-2"></i>
                            <h3 class="font-bold text-xl text-slate-900">付费章节</h3>
                            <p class="text-slate-500 text-sm">解锁后即可继续阅读精彩内容</p>
                        </div>
                        <div class="space-y-4">
                            <div class="text-2xl font-black text-slate-900">10 <span class="text-sm font-normal text-slate-500">阅币</span></div>
                            <button onclick="purchaseChapter(${chapterId})" 
                                class="px-8 py-3 bg-yellow-500 hover:bg-yellow-600 text-white font-bold rounded-lg shadow-lg shadow-yellow-500/20 transition-all active:scale-95">
                                立即购买
                            </button>
                            <p class="text-xs text-slate-400">余额不足？<a href="user_center.jsp" class="text-blue-600 hover:underline">去充值</a></p>
                        </div>
                    </div>
                 `;
                lucide.createIcons();
            } else {
                const formatted = content.split('\n').map(p => `<p>${p}</p>`).join('');
                document.getElementById('content').innerHTML = formatted;
            }

            // Setup Nav
            await setupNavigation();

            // RESTORE PROGRESS (Optional logic)
            // ...
        } else if (res.code === 402) {
            // Fallback if backend was updated to return 402
            document.getElementById('content').innerHTML = `
                <div class="text-center py-20">
                    <h3 class="font-bold text-xl text-slate-900 mb-4">本章为付费章节</h3>
                    <button class="btn-primary" onclick="purchaseChapter(${chapterId})">立即购买</button>
                </div>
             `;
        }
    } catch (e) {
        console.error(e);
        document.getElementById('content').innerHTML = '<p class="text-center text-red-500">加载失败，请重试</p>';
    }
}

async function purchaseChapter(cId) {
    if (!confirm('确认花费 10 阅币购买此章节？')) return;

    try {
        const formData = new URLSearchParams();
        formData.append('chapterId', cId);

        const res = await fetchJson('../pay/chapter/purchase', {
            method: 'POST',
            body: formData
        });

        if (res.code === 200) {
            showToast('购买成功！', 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            if (res.msg && res.msg.includes("Insufficient")) {
                if (confirm('余额不足，是否前往充值？')) {
                    location.href = "user_center.jsp";
                }
            } else {
                showToast(res.msg || '购买失败', 'error');
            }
        }
    } catch (e) {
        console.error(e);
        showToast('请求出错', 'error');
    }
}

async function setupNavigation() {
    // Need novel detail to get chapter list for nav
    const res = await fetchJson(`../novel/detail?id=${novelId}`);
    if (res.code === 200) {
        allChapters = res.data.chapters;
        // Chapters from backend might be object list
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
        location.href = `read.jsp?novelId=${novelId}&chapterId=${prevId}`;
    }
}

function goNext() {
    if (currentChapterIndex < allChapters.length - 1) {
        const nextId = allChapters[currentChapterIndex + 1].id;
        location.href = `read.jsp?novelId=${novelId}&chapterId=${nextId}`;
    }
}

function debounce(func, wait) {
    let timeout;
    return function (...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), wait);
    };
}
