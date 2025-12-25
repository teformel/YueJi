
document.addEventListener('DOMContentLoaded', () => {
    lucide.createIcons();
    loadContent();
    initSettings();

    // Set back link
    if (novelId) {
        document.getElementById('backLink').href = `novel_detail.jsp?id=${novelId}`;
    }

    window.addEventListener('scroll', debounce(() => {
        if (novelId && chapterId && window.fetchJson) {
            const scrollY = window.scrollY || document.documentElement.scrollTop;
            // Silent POST
            fetchJson(`../interaction/progress/sync?novelId=${novelId}&chapterId=${chapterId}&scroll=${Math.floor(scrollY)}`, { method: 'POST' })
                .catch(e => { });
        }
    }, 2000));

    // Reading Duration Heartbeat (Every 30s)
    let startTime = Date.now();
    setInterval(() => {
        if (novelId && Auth.getUser()) {
            const elapsed = Math.floor((Date.now() - startTime) / 1000);
            if (elapsed >= 30) {
                fetchJson(`../interaction/progress/time/sync?novelId=${novelId}&seconds=${elapsed}`, { method: 'POST' })
                    .then(() => {
                        startTime = Date.now(); // Reset
                    }).catch(e => { });
            }
            updateReadingTimeDisplay(Math.floor((Date.now() - initTime) / 1000));
        }
    }, 1000);
});

const initTime = Date.now();
function updateReadingTimeDisplay(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    const display = document.getElementById('readingTimeDisplay');
    if (display) {
        display.innerText = `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
    }
}

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
                            <div class="text-2xl font-black text-slate-900">${ch.price} <span class="text-sm font-normal text-slate-500">书币</span></div>
                            <button onclick="purchaseChapter(${chapterId}, ${ch.price})" 
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
        } else if (res.code === 404) {
            document.getElementById('content').innerHTML = `
                <div class="text-center py-20">
                    <i data-lucide="alert-circle" class="w-16 h-16 text-slate-300 mx-auto mb-4"></i>
                    <h3 class="font-bold text-xl text-slate-900 mb-2">章节不存在或已删除</h3>
                    <p class="text-slate-500 mb-6">该章节可能已被作者删除或正在审核中。</p>
                    <a href="novel_detail.jsp?id=${novelId}" class="btn-primary px-8 py-3">返回作品详情</a>
                </div>
            `;
            lucide.createIcons();
        }
    } catch (e) {
        console.error(e);
        document.getElementById('content').innerHTML = '<p class="text-center text-red-500">加载失败，请重试</p>';
    }
}

async function purchaseChapter(cId, price) {
    if (!confirm(`确认花费 ${price} 书币购买此章节？`)) return;

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

// Settings Logic
let readerSettings = {
    fontSize: 1.25,
    theme: 'default'
};

function initSettings() {
    const saved = localStorage.getItem('yueji_reader_settings');
    if (saved) {
        readerSettings = JSON.parse(saved);
    }
    applySettings();
}

function applySettings() {
    const content = document.querySelector('.reader-content');
    if (content) {
        content.style.fontSize = `${readerSettings.fontSize}rem`;
    }
    document.getElementById('fontSizeDisplay').innerText = `${readerSettings.fontSize.toFixed(2)}rem`;

    // Apply Theme to body
    const body = document.body;
    body.classList.remove('theme-parchment', 'theme-green', 'theme-night');
    if (readerSettings.theme !== 'default') {
        body.classList.add(`theme-${readerSettings.theme}`);
    }

    // Update Theme Buttons
    document.querySelectorAll('[id^="theme-"]').forEach(btn => {
        btn.classList.remove('border-blue-500', 'border-2');
        btn.classList.add('border-gray-100', 'border');
    });
    const activeBtn = document.getElementById(`theme-${readerSettings.theme}`);
    if (activeBtn) {
        activeBtn.classList.add('border-blue-500', 'border-2');
        activeBtn.classList.remove('border-gray-100', 'border');
    }

    localStorage.setItem('yueji_reader_settings', JSON.stringify(readerSettings));
}

function toggleSettings() {
    const panel = document.getElementById('settingsPanel');
    panel.classList.toggle('translate-x-full');
}

function changeFontSize(delta) {
    readerSettings.fontSize = Math.max(0.8, Math.min(2.5, readerSettings.fontSize + delta));
    applySettings();
}

function setTheme(t) {
    readerSettings.theme = t;
    applySettings();
}
