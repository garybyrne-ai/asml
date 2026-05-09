<?php
require_once __DIR__ . '/functions.php';

$page_title       = $page_title       ?? null;
$page_description = $page_description ?? 'PSA-licensed Dublin locksmith. 20-minute response, 24/7 emergency lockouts, no call-out fee, 12-month guarantee.';
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
?>
<!doctype html>
<html lang="en-IE">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="theme-color" content="#0b1d3a">

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

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Outfit:wght@600;700;800;900&family=Inter:wght@400;500;600&display=swap">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Outfit:wght@600;700;800;900&family=Inter:wght@400;500;600&display=swap">
<link rel="stylesheet" href="<?= e(asset('css/style.css')) ?>">
<link rel="icon" href="<?= e(asset('images/favicon.svg')) ?>" type="image/svg+xml">
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
        <li><a href="<?= e(url('/')) ?>">Home</a></li>

        <li class="has-dropdown">
          <a href="<?= e(url('/services')) ?>" aria-haspopup="true" aria-expanded="false">Services <span class="caret" aria-hidden="true">▾</span></a>
          <div class="dropdown" role="menu">
            <div class="dropdown__grid">
              <?php foreach ($nav_services as $s): ?>
                <a role="menuitem" href="<?= e(url('/' . $s['slug'])) ?>"><?= e($s['title']) ?></a>
              <?php endforeach; ?>
            </div>
            <a class="dropdown__more" href="<?= e(url('/services')) ?>">View all services →</a>
          </div>
        </li>

        <li class="has-dropdown">
          <a href="<?= e(url('/locations')) ?>" aria-haspopup="true" aria-expanded="false">Locations <span class="caret" aria-hidden="true">▾</span></a>
          <div class="dropdown" role="menu">
            <div class="dropdown__grid dropdown__grid--locations">
              <?php foreach ($nav_locations as $l): ?>
                <a role="menuitem" href="<?= e(url('/' . $l['slug'])) ?>"><?= e($l['name']) ?></a>
              <?php endforeach; ?>
            </div>
            <a class="dropdown__more" href="<?= e(url('/locations')) ?>">View all locations →</a>
          </div>
        </li>

        <li><a href="<?= e(url('/about')) ?>">About</a></li>
        <li><a href="<?= e(url('/reviews')) ?>">Reviews</a></li>
        <li><a href="<?= e(url('/contact')) ?>">Contact</a></li>
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
      <span><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg> No call-out fee</span>
      <span><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg> 12-month guarantee</span>
    </div>
  </div>
</header>

<main id="main">
