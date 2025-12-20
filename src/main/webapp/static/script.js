function showToast(message) {
    const toast = document.getElementById('toast');
    toast.innerText = message;
    toast.style.display = 'block';
    setTimeout(() => {
        toast.style.display = 'none';
    }, 3000);
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
