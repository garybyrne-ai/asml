<?php
require_once __DIR__ . '/../includes/functions.php';
admin_require();
$admin_title = $admin_title ?? 'Dashboard';
$flash = $_SESSION['flash'] ?? null;
unset($_SESSION['flash']);
?>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title><?= e($admin_title) ?> · Locksmiths.ie Admin</title>
<link rel="stylesheet" href="<?= e(asset('css/admin.css')) ?>">
</head>
<body class="admin">
<aside class="admin-sidebar">
  <a href="<?= e(url('/admin/')) ?>" class="admin-brand">Locksmiths.ie</a>
  <nav>
    <a href="<?= e(url('/admin/index.php')) ?>">Dashboard</a>
    <a href="<?= e(url('/admin/services.php')) ?>">Services</a>
    <a href="<?= e(url('/admin/locations.php')) ?>">Locations</a>
    <a href="<?= e(url('/admin/pricing.php')) ?>">Pricing</a>
    <a href="<?= e(url('/admin/testimonials.php')) ?>">Testimonials</a>
    <a href="<?= e(url('/admin/faqs.php')) ?>">FAQs</a>
    <a href="<?= e(url('/admin/quotes.php')) ?>">Quote Requests</a>
    <a href="<?= e(url('/admin/settings.php')) ?>">Global Settings</a>
    <a href="<?= e(url('/admin/logo.php')) ?>">Logo</a>
    <a href="<?= e(url('/admin/custom-css.php')) ?>">Custom CSS</a>
    <a href="<?= e(url('/admin/smtp.php')) ?>">SMTP / Mail</a>
    <a href="<?= e(url('/admin/code-injection.php')) ?>">Code Injection</a>
    <a href="<?= e(url('/admin/logout.php')) ?>" class="admin-logout">Log out</a>
  </nav>
</aside>
<main class="admin-main">
  <header class="admin-header">
    <h1><?= e($admin_title) ?></h1>
    <span>Logged in as <strong><?= e($_SESSION['admin_username'] ?? '') ?></strong></span>
  </header>
  <?php if ($flash): ?>
    <div class="alert alert--<?= e($flash['type'] ?? 'info') ?>"><?= e($flash['msg'] ?? '') ?></div>
  <?php endif; ?>
  <div class="admin-content">
