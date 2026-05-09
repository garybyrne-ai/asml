<?php
require_once __DIR__ . '/../includes/functions.php';
admin_require();

$admin_title = $admin_title ?? 'Dashboard';
$flash = $_SESSION['flash'] ?? null;
unset($_SESSION['flash']);

$current = basename(parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?? '');
if ($current === '' || $current === 'admin') $current = 'index.php';

/**
 * Sidebar nav definition. Each entry is [file, label, group, svg-paths].
 * Group: 'main' (top section), 'config' (middle), 'system' (bottom).
 */
$nav = [
    ['index.php',         'Dashboard',       'main',
     '<rect x="3" y="3" width="7" height="9" rx="1.5"/><rect x="14" y="3" width="7" height="5" rx="1.5"/><rect x="14" y="12" width="7" height="9" rx="1.5"/><rect x="3" y="16" width="7" height="5" rx="1.5"/>'],
    ['services.php',      'Services',        'main',
     '<circle cx="8" cy="15" r="3"/><path d="M10.5 12.5l8-8a2.83 2.83 0 1 1 4 4l-8 8"/><path d="M16.5 6.5l4 4"/>'],
    ['locations.php',     'Locations',       'main',
     '<path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>'],
    ['pricing.php',       'Pricing',         'main',
     '<line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>'],
    ['testimonials.php',  'Testimonials',    'main',
     '<polygon points="12,2 15.09,8.26 22,9.27 17,14.14 18.18,21.02 12,17.77 5.82,21.02 7,14.14 2,9.27 8.91,8.26"/>'],
    ['faqs.php',          'FAQs',            'main',
     '<circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><circle cx="12" cy="17" r="0.5" fill="currentColor"/>'],
    ['quotes.php',        'Quote Requests',  'main',
     '<path d="M4 4h16v12H5.17L4 17.17V4z"/><line x1="8" y1="9" x2="16" y2="9"/><line x1="8" y1="12" x2="13" y2="12"/>'],

    ['settings.php',      'Global Settings', 'config',
     '<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>'],
    ['logo.php',          'Logo',            'config',
     '<rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/>'],
    ['footer.php',        'Footer',          'config',
     '<rect x="3" y="3" width="18" height="18" rx="2"/><line x1="3" y1="15" x2="21" y2="15"/>'],
    ['custom-css.php',    'Custom CSS',      'config',
     '<polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/>'],

    ['smtp.php',          'SMTP / Mail',     'system',
     '<path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/>'],
    ['code-injection.php','Code Injection',  'system',
     '<polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/><line x1="14" y1="4" x2="10" y2="20"/>'],
    ['install.php',       'Database',        'system',
     '<ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M3 5v6c0 1.66 4 3 9 3s9-1.34 9-3V5"/><path d="M3 11v6c0 1.66 4 3 9 3s9-1.34 9-3v-6"/>'],
];

function ad_nav_icon(string $paths): string
{
    return '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' . $paths . '</svg>';
}

$groups = [
    'main'   => 'Manage',
    'config' => 'Appearance',
    'system' => 'System',
];
?>
<!doctype html>
<html lang="en-IE">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title><?= e($admin_title) ?> · Locksmiths.ie Admin</title>
<link rel="icon" href="<?= e(asset('images/favicon.svg')) ?>" type="image/svg+xml">
<link rel="stylesheet" href="<?= e(asset('css/admin.css?v=20260509h')) ?>">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap">
</head>
<body class="admin">

<aside class="admin-sidebar">
  <a href="<?= e(url('/admin/')) ?>" class="admin-brand">
    <span class="admin-brand__mark" aria-hidden="true">
      <svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <rect x="3" y="11" width="18" height="11" rx="2"/>
        <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
      </svg>
    </span>
    <span class="admin-brand__name">Locksmiths.ie</span>
  </a>

  <nav class="admin-nav">
    <?php foreach ($groups as $g => $glabel): ?>
      <div class="admin-nav__group">
        <span class="admin-nav__heading"><?= e($glabel) ?></span>
        <?php foreach ($nav as [$file, $label, $grp, $paths]):
          if ($grp !== $g) continue;
          $href = url('/admin/' . $file);
          $isActive = ($current === $file);
        ?>
          <a href="<?= e($href) ?>" class="admin-nav__link<?= $isActive ? ' is-active' : '' ?>">
            <?= ad_nav_icon($paths) ?>
            <span><?= e($label) ?></span>
          </a>
        <?php endforeach; ?>
      </div>
    <?php endforeach; ?>

    <a href="<?= e(url('/admin/logout.php')) ?>" class="admin-nav__link admin-nav__link--logout">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>
      </svg>
      <span>Log out</span>
    </a>
  </nav>

  <div class="admin-credit">
    Hand-coded by
    <a href="https://hihello.me/p/1e07b733-bcbc-4877-ba48-4d724305c91e" target="_blank" rel="noopener">Ankush Kalia</a>.
  </div>
</aside>

<main class="admin-main">
  <header class="admin-header">
    <div>
      <span class="admin-header__crumb">Admin</span>
      <h1><?= e($admin_title) ?></h1>
    </div>
    <div class="admin-header__user">
      <a href="<?= e(SITE_URL) ?>" target="_blank" rel="noopener" class="admin-header__view">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg>
        View site
      </a>
      <span class="admin-header__who">
        <span class="admin-header__avatar"><?= e(strtoupper(substr($_SESSION['admin_username'] ?? 'A', 0, 1))) ?></span>
        <span><?= e($_SESSION['admin_username'] ?? '') ?></span>
      </span>
    </div>
  </header>

  <?php if ($flash): ?>
    <div class="alert alert--<?= e($flash['type'] ?? 'info') ?>"><?= e($flash['msg'] ?? '') ?></div>
  <?php endif; ?>

  <div class="admin-content">
