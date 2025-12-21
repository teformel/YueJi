/**
 * Global Script for YueJi Novel System
 * Includes: Toast, Utilities, and MOCK DATABASE (localStorage based)
 */

document.addEventListener('DOMContentLoaded', () => {
    // Check & Init Mock Data
    MockDB.init();

    // Global Lucide Icons
    if (window.lucide) {
        lucide.createIcons();
    }
});

/**
 * Toast Notification
 * @param {string} message 
 * @param {string} type 'success' | 'error' | 'info'
 */
function showToast(message, type = 'info') {
    const container = document.getElementById('toast');
    if (!container) return; // Should exist in all pages

    const colors = {
        success: 'bg-green-600',
        error: 'bg-red-600',
        info: 'bg-slate-800'
    };

    // Create toast element
    const toast = document.createElement('div');
    toast.className = `fixed bottom-10 left-1/2 -translate-x-1/2 px-6 py-3 rounded-full text-white shadow-xl z-50 flex items-center gap-2 animate-bounce-in \${colors[type] || colors.info}`;
    toast.innerHTML = `
        <span class="font-bold text-sm">\${message}</span>
    `;

    document.body.appendChild(toast);

    // Remove after 3s
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translate(-50%, 20px)';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

/**
 * URL Parameter Helper
 */
function getQueryParam(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}

/**
 * Fetch Helper (Intercepts requests to use MockDB if local mode)
 * In a real app, this would just be fetch.
 */
async function fetchJson(url, options = {}) {
    // Simulated Network Delay
    await new Promise(r => setTimeout(r, 300));

    // MOCK ROUTING
    if (url.includes('/novel/list')) {
        return { code: 200, status: 200, data: { code: 200, data: MockDB.getNovels() } };
    }
    if (url.includes('/novel/detail')) {
        const id = url.split('id=')[1];
        const novel = MockDB.getNovelById(id);
        return novel ? { code: 200, data: novel } : { code: 404, msg: '未找到该作品' };
    }
    if (url.includes('/novel/chapter')) {
        const params = new URLSearchParams(url.split('?')[1]);
        const novelId = params.get('novelId');
        const chapterId = params.get('chapterId');
        const chapter = MockDB.getChapter(novelId, chapterId);
        return chapter ? { code: 200, data: chapter } : { code: 404, msg: '章节不存在' };
    }

    // Fallback to actual fetch if we had a real backend (but here we just return mock error for unknown routes)
    console.warn('Unknown Mock Route:', url);
    return { code: 404, msg: '接口未定义' };
}

/**
 * ==========================================
 * MOCK DATABASE ENGINE (LocalStorage Based)
 * ==========================================
 */
const MockDB = {
    KEYS: {
        NOVELS: 'yueji_novels_v1',
        USERS: 'yueji_users_v1',
        PROGRESS: 'yueji_progress_v1',
        USER_SESSION: 'yueji_session_v1',
        INIT_FLAG: 'yueji_initialized_v2' // Change v2 to force reset if needed
    },

    init() {
        if (!localStorage.getItem(this.KEYS.INIT_FLAG)) {
            console.log('Initializing Mock DB...');
            localStorage.setItem(this.KEYS.NOVELS, JSON.stringify(this.initialNovels()));
            localStorage.setItem(this.KEYS.USERS, JSON.stringify(this.initialUsers()));
            localStorage.setItem(this.KEYS.PROGRESS, JSON.stringify({}));
            localStorage.setItem(this.KEYS.INIT_FLAG, 'true');
        }
        // Always ensuring Test Novel exists for stress testing
        this.ensureTestNovel();
    },

    // --- Novels ---
    getNovels() {
        return JSON.parse(localStorage.getItem(this.KEYS.NOVELS) || '[]');
    },

    getNovelById(id) {
        const novels = this.getNovels();
        return novels.find(n => n.id == id);
    },

    saveNovel(novel) {
        const novels = this.getNovels();
        const existingIdx = novels.findIndex(n => n.id == novel.id);
        if (existingIdx >= 0) {
            novels[existingIdx] = novel;
        } else {
            novels.push(novel);
        }
        localStorage.setItem(this.KEYS.NOVELS, JSON.stringify(novels));
        return true;
    },

    addChapter(novelId, chapter) {
        const novels = this.getNovels();
        const novel = novels.find(n => n.id == novelId);
        if (!novel) return false;

        if (!novel.chapters) novel.chapters = [];
        // Auto ID if not provided
        if (!chapter.id) chapter.id = Date.now().toString();

        novel.chapters.push(chapter);
        // Update updated_at
        novel.updatedAt = new Date().toISOString();

        localStorage.setItem(this.KEYS.NOVELS, JSON.stringify(novels));
        return true;
    },

    getChapter(novelId, chapterId) {
        const novel = this.getNovelById(novelId);
        if (!novel || !novel.chapters) return null;
        return novel.chapters.find(c => c.id == chapterId);
    },

    // --- Users ---
    // Simplified User Session Management
    login(username, password) {
        // Mock Login: Accept admin/admin or any valid user in DB
        const users = JSON.parse(localStorage.getItem(this.KEYS.USERS) || '[]');
        const user = users.find(u => u.username === username && u.password === password);
        if (user) {
            if (user.status === 'banned') return { success: false, msg: '账号已被封禁' };
            localStorage.setItem(this.KEYS.USER_SESSION, JSON.stringify(user));
            return { success: true, user };
        }
        return { success: false, msg: '用户名或密码错误' };
    },

    getCurrentUser() {
        // Try getting from local storage, if fails return null
        try {
            return JSON.parse(localStorage.getItem(this.KEYS.USER_SESSION) || 'null');
        } catch (e) {
            return null;
        }
    },

    logout() {
        localStorage.removeItem(this.KEYS.USER_SESSION);
    },

    getUsers() {
        return JSON.parse(localStorage.getItem(this.KEYS.USERS) || '[]');
    },

    updateUserProfile(profile) {
        let user = this.getCurrentUser();
        if (!user) return false;

        // If updating other user (admin case), profile should contain id
        const targetId = profile.id || user.id;

        // Update DB
        const users = JSON.parse(localStorage.getItem(this.KEYS.USERS) || '[]');
        const idx = users.findIndex(u => u.id === targetId);

        if (idx >= 0) {
            users[idx] = { ...users[idx], ...profile };
            localStorage.setItem(this.KEYS.USERS, JSON.stringify(users));

            // If self update, update session
            if (targetId === user.id) {
                localStorage.setItem(this.KEYS.USER_SESSION, JSON.stringify(users[idx]));
            }
        }
        return true;
    },

    // --- Reading Progress ---
    saveProgress(novelId, chapterId, scrollY) {
        const progress = JSON.parse(localStorage.getItem(this.KEYS.PROGRESS) || '{}');
        progress[novelId] = {
            chapterId,
            scrollY,
            timestamp: Date.now()
        };
        localStorage.setItem(this.KEYS.PROGRESS, JSON.stringify(progress));
    },

    getProgress(novelId) {
        const progress = JSON.parse(localStorage.getItem(this.KEYS.PROGRESS) || '{}');
        return progress[novelId];
    },

    // --- Private: Initial Data ---
    initialNovels() {
        return [
            {
                id: '1',
                title: '笑傲江湖',
                authorName: '金庸',
                category: '武侠',
                description: '主要通过福建林远图一家七十二口被青城派灭门这一起灭门血案，展现了武林霸权争夺的残酷和人性贪婪的本质。',
                coverUrl: 'https://images.unsplash.com/photo-1541963463532-d68292c34b19?w=400&q=80',
                status: '已完结',
                chapters: [
                    { id: '101', title: '第一章 灭门', content: '和风熏柳，花香醉人，正是南国春光漫烂季节...' },
                    { id: '102', title: '第二章 聆秘', content: '林平之大吃一惊，向后急退...' }
                ]
            },
            {
                id: '2',
                title: '三体',
                authorName: '刘慈欣',
                category: '科幻',
                description: '文化大革命如火如荼进行的同时，军方探寻外星文明的绝秘计划“红岸工程”取得了突破性进展。',
                coverUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400&q=80',
                status: '已完结',
                chapters: [
                    { id: '201', title: '第一章 科学边界', content: '汪淼觉得，来找他的这两个人有些面熟...' }
                ]
            }
        ];
    },

    initialUsers() {
        return [
            { id: 'u1', username: 'admin', password: '123', nickname: '系统管理员', role: 'admin', balance: 9999, status: 'active' },
            { id: 'u2', username: 'author', password: '123', nickname: '签约作家', role: 'creator', balance: 100, status: 'active' },
            { id: 'u3', username: 'user', password: '123', nickname: '普通读者', role: 'user', balance: 0, status: 'active' }
        ];
    },

    // --- Test Data Generator ---
    ensureTestNovel() {
        const novels = this.getNovels();
        if (novels.find(n => n.id === 'test-9999')) return;

        console.log('Generating Long Test Novel...');
        const testNovel = {
            id: 'test-9999',
            title: '星河彼岸 [测试长篇]',
            authorName: '压力测试员',
            category: '科幻',
            description: '这是一本由系统自动生成的长篇测试小说，包含200个章节，旨在测试阅读进度保存功能与长列表性能。',
            coverUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400&q=80',
            status: '连载中',
            chapters: []
        };

        for (let i = 1; i <= 200; i++) {
            testNovel.chapters.push({
                id: `ch-\${i}`,
                title: `第 \${i} 章：星河深处的测试信号`,
                content: this.generateContent(i)
            });
        }

        this.saveNovel(testNovel);
    },

    generateContent(seed) {
        const para = `这是第 \${seed} 章的内容。在此处，我们模拟了大量的文本内容以测试滚动性能和阅读体验。
        
        星河流转，岁月如梭。在遥远的彼岸，无数文明兴起又衰落。测试数据，不仅是冰冷的字节，更是系统健壮性的基石。
        
        测试段落：
        昔者庄周梦为胡蝶，栩栩然胡蝶也，自喻适志与！不知周也。俄然觉，则蘧蘧然周也。不知周之梦为胡蝶与，胡蝶之梦为周与？周与胡蝶，则必有分矣。此之谓物化。
        
        (此处省略2000字，以下为填充内容...)
        
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        `.repeat(10); // Repeat to make it long
        return para;
    }
};
