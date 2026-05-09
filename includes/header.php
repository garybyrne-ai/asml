<?php
require_once __DIR__ . '/functions.php';

$page_title       = $page_title       ?? null;
$page_description = $page_description ?? 'PSA-licensed Dublin locksmith. 20-minute response, 24/7 emergency lockouts, fixed-price quotes, 12-month guarantee.';
$page_canonical   = $page_canonical   ?? build_canonical($_SERVER['REQUEST_URI'] ?? '/');
$page_focus_kw    = $page_focus_kw    ?? '';
$schema_blocks    = $schema_blocks    ?? [];
$breadcrumbs      = $breadcrumbs      ?? [];

$phone   = setting('phone');
$phoneE  = setting('phone_e164');
$wa      = setting('whatsapp');
$logo    = setting('logo', '/assets/images/locksmiths-ie-logo-horizontal.svg');
$psa     = setting('psa_license');
$response = setting('response_time', '20-30 minutes');

$nav_services  = array_slice(get_services(), 0, 14);
$nav_locations = array_slice(get_locations(), 0, 18);

/** Tiny inline-SVG icon helper for the menu */
function nav_icon(string $name): string
{
    $base = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">';
    $paths = [
        'home'      => '<path d="M3 11l9-8 9 8"/><path d="M5 10v10h14V10"/>',
        'services'  => '<circle cx="8" cy="15" r="3"/><path d="M10.5 12.5l8-8a2.83 2.83 0 1 1 4 4l-8 8"/><path d="M16.5 6.5l4 4"/>',
        'locations' => '<path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>',
        'pricing'   => '<line x1="12" y1="1" x2="12" y2="23"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>',
        'about'     => '<circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><circle cx="12" cy="8" r="1.2" fill="currentColor"/>',
        'reviews'   => '<polygon points="12,2 15.09,8.26 22,9.27 17,14.14 18.18,21.02 12,17.77 5.82,21.02 7,14.14 2,9.27 8.91,8.26"/>',
        'contact'   => '<path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>',
    ];
    return $base . ($paths[$name] ?? '') . '</svg>';
}

$asset_v = '20260509f';   // cache-bust
?>
<!doctype html>
<html lang="en-IE">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="theme-color" content="#0e1f4a">

<title><?= e(meta_title($page_title)) ?></title>
<meta name="description" content="<?= e($page_description) ?>">
<?php if ($page_focus_kw): ?>
<meta name="keywords" content="<?= e($page_focus_kw) ?>">
<?php endif; ?>
<link rel="canonical" href="<?= e($page_canonical) ?>">

<meta property="og:type" content="website">
<meta property="og:title" content="<?= e(meta_title($page_title)) ?>">
<meta property="og:description" content="<?= e($page_description) ?>">
<meta property="og:url" content="<?= e($page_canonical) ?>">
<meta property="og:image" content="<?= e(SITE_URL . $logo) ?>">
<meta property="og:locale" content="en_IE">
<meta property="og:site_name" content="<?= e(setting('business_name', 'Locksmiths.ie')) ?>">
<meta name="geo.region" content="IE-D">
<meta name="geo.placename" content="Dublin, Ireland">
<meta name="geo.position" content="<?= e(setting('latitude')) ?>;<?= e(setting('longitude')) ?>">
<meta name="ICBM" content="<?= e(setting('latitude')) ?>, <?= e(setting('longitude')) ?>">
<link rel="alternate" hreflang="en-ie" href="<?= e($page_canonical) ?>">
<link rel="alternate" hreflang="x-default" href="<?= e($page_canonical) ?>">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Share+Tech&family=Public+Sans:wght@400;500;600;700&display=swap">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Share+Tech&family=Public+Sans:wght@400;500;600;700&display=swap">
<link rel="stylesheet" href="<?= e(asset('css/style.css?v=' . $asset_v)) ?>">
<link rel="icon" href="<?= e(asset('images/favicon.svg?v=' . $asset_v)) ?>" type="image/svg+xml">
<link rel="apple-touch-icon" href="<?= e(asset('images/apple-touch-icon.png?v=' . $asset_v)) ?>">
<?php $custom_css = trim(setting('custom_css')); if ($custom_css !== ''): ?>
<style id="lk-custom-css">
<?= $custom_css /* trusted: admin-only input */ ?>
</style>
<?php endif; ?>

<?= schema_local_business() ?>
<?php
foreach ($schema_blocks as $b) echo $b;
if ($breadcrumbs) echo schema_breadcrumbs($breadcrumbs);
?>

<?= setting('inject_head') ?>
</head>
<body>
<?= setting('inject_body_start') ?>

<a class="skip-link" href="#main">Skip to content</a>

<header class="site-header">
  <div class="container site-header__inner">
    <a href="<?= e(SITE_URL) ?>" class="brand">
      <?php
      $logoPath = $logo ?: '/assets/images/locksmiths-ie-logo-horizontal.svg';
      $logoExt  = strtolower(pathinfo(parse_url($logoPath, PHP_URL_PATH) ?? $logoPath, PATHINFO_EXTENSION));
      $logoSrc  = SITE_URL . $logoPath;
      ?>
      <img src="<?= e($logoSrc) ?>" alt="Locksmiths.ie - PSA Licensed Dublin Locksmith"
           width="250" height="55" decoding="async"
           <?= $logoExt === 'svg' ? '' : 'loading="eager"' ?>>
    </a>

    <nav class="primary-nav" aria-label="Primary">
      <button class="nav-toggle" aria-controls="primary-menu" aria-expanded="false">
        <span></span><span></span><span></span><span class="sr-only">Menu</span>
      </button>
      <ul id="primary-menu">
        <li><a href="<?= e(url('/')) ?>"><?= nav_icon('home') ?><span>Home</span></a></li>

        <li class="has-dropdown">
          <a href="<?= e(url('/services')) ?>" class="has-dropdown__toggle" aria-haspopup="true" aria-expanded="false">
            <?= nav_icon('services') ?><span>Services</span>
            <span class="caret" aria-hidden="true">▾</span>
          </a>
          <div class="dropdown" role="menu" hidden>
            <div class="dropdown__grid">
              <?php foreach ($nav_services as $s): ?>
                <a role="menuitem" href="<?= e(url('/' . $s['slug'])) ?>"><?= e($s['title']) ?></a>
              <?php endforeach; ?>
            </div>
            <a class="dropdown__more" href="<?= e(url('/services')) ?>">View all services →</a>
          </div>
        </li>

        <li class="has-dropdown">
          <a href="<?= e(url('/locations')) ?>" class="has-dropdown__toggle" aria-haspopup="true" aria-expanded="false">
            <?= nav_icon('locations') ?><span>Locations</span>
            <span class="caret" aria-hidden="true">▾</span>
          </a>
          <div class="dropdown" role="menu" hidden>
            <div class="dropdown__grid dropdown__grid--locations">
              <?php foreach ($nav_locations as $l): ?>
                <a role="menuitem" href="<?= e(url('/' . $l['slug'])) ?>"><?= e($l['name']) ?></a>
              <?php endforeach; ?>
            </div>
            <a class="dropdown__more" href="<?= e(url('/locations')) ?>">View all locations →</a>
          </div>
        </li>

        <li><a href="<?= e(url('/pricing')) ?>"><?= nav_icon('pricing') ?><span>Pricing</span></a></li>
        <li><a href="<?= e(url('/about')) ?>"><?= nav_icon('about') ?><span>About</span></a></li>
        <li><a href="<?= e(url('/reviews')) ?>"><?= nav_icon('reviews') ?><span>Reviews</span></a></li>
        <li><a href="<?= e(url('/contact')) ?>"><?= nav_icon('contact') ?><span>Contact</span></a></li>
      </ul>
    </nav>

    <a href="tel:<?= e($phoneE) ?>" class="header-call" aria-label="Call <?= e($phone) ?>">
      <span class="header-call__label">Call 24/7</span>
      <strong><?= e($phone) ?></strong>
    </a>
  </div>
  <div class="site-header__strip">
    <div class="container">
      <span><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg> PSA Licensed <?= e($psa) ?></span>
      <span><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg> <?= e($response) ?> arrival</span>
      <span><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg> Fixed prices from <?= e(setting('minimum_price', '€90')) ?></span>
      <span><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg> 12-month guarantee</span>
    </div>
  </div>
</header>

<main id="main">
