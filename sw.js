/* ARKA PWA shell cache. Supabase API/auth/storage responses are never cached. */
const CACHE_NAME = 'arka-shell-v20';
const SHELL = ['./', './index.html', './manifest.webmanifest', './arka-icon.svg', './arka-icon-192.png', './arka-icon-512.png'];
const CDN_ASSETS = [
  'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2.45.4/dist/umd/supabase.min.js',
  'https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js'
];

self.addEventListener('install', event => {
  event.waitUntil((async () => {
    const cache = await caches.open(CACHE_NAME);
    await cache.addAll(SHELL);
    await Promise.all(CDN_ASSETS.map(async url => {
      try {
        const response = await fetch(url, {mode: 'no-cors'});
        if (response && (response.ok || response.type === 'opaque')) await cache.put(url, response);
      } catch (_) {}
    }));
    await self.skipWaiting();
  })());
});

self.addEventListener('activate', event => {
  event.waitUntil((async () => {
    const keys = await caches.keys();
    await Promise.all(keys.filter(k => k.startsWith('arka-shell-') && k !== CACHE_NAME).map(k => caches.delete(k)));
    await self.clients.claim();
  })());
});

self.addEventListener('fetch', event => {
  const request = event.request;
  if (request.method !== 'GET') return;
  const url = new URL(request.url);

  // Never cache database, auth, storage, or function traffic.
  if (url.hostname.endsWith('.supabase.co') || url.pathname.includes('/rest/v1/') ||
      url.pathname.includes('/auth/v1/') || url.pathname.includes('/storage/v1/') ||
      url.pathname.includes('/functions/v1/')) return;

  const isShell = url.origin === self.location.origin;
  const isCdnScript = CDN_ASSETS.includes(request.url);
  if (!isShell && !isCdnScript) return;

  event.respondWith((async () => {
    const cache = await caches.open(CACHE_NAME);
    const cached = await cache.match(request, {ignoreSearch: true});
    if (cached) {
      // Refresh shell in background; never cache API responses.
      if (isShell) event.waitUntil(fetch(request).then(r => {
        if (r && r.ok) return cache.put(request, r.clone());
      }).catch(() => {}));
      return cached;
    }
    try {
      const response = await fetch(request);
      if (response && (response.ok || response.type === 'opaque')) await cache.put(request, response.clone());
      return response;
    } catch (error) {
      if (request.mode === 'navigate') {
        const fallback = await cache.match('./index.html');
        if (fallback) return fallback;
      }
      throw error;
    }
  })());
});
