function showToast(msg, type = 'info') {
    const toast = document.getElementById('toast');
    if (!toast) return;
    toast.textContent = msg;
    // Apply V2 Class System
    toast.className = 'luminous-panel fixed bottom-8 right-8 px-6 py-4 rounded-2xl z-[1000] text-sm font-bold ' +
        (type === 'error' ? 'text-red-400 border-red-500/30' : 'text-white border-primary/30');

    toast.classList.remove('invisible', 'translate-y-10');
    toast.classList.add('reveal');

    // Auto Hide
    if (window._toastTimer) clearTimeout(window._toastTimer);
    window._toastTimer = setTimeout(() => {
        toast.classList.add('invisible', 'translate-y-10');
        toast.classList.remove('reveal');
    }, 4000);
}

async function fetchJson(url, options = {}) {
    try {
        const resp = await fetch(url, options);
        if (resp.status === 401) {
            window.location.href = 'login.jsp'; // Redirect to login
            return null;
        }
        const data = await resp.json();
        return { status: resp.status, data: data };
    } catch (e) {
        console.error("Fetch error:", e);
        showToast("Network Error");
        return null;
    }
}

function getQueryParam(name) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(name);
}
