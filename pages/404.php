<?php
require_once __DIR__ . '/../includes/functions.php';
$page_title = 'Page Not Found';
$page_description = 'The page you requested could not be found. Call our 24/7 Dublin locksmith.';
$page_canonical = build_canonical($_SERVER['REQUEST_URI'] ?? '/');
require __DIR__ . '/../includes/header.php';
?>
<section class="section">
  <div class="container container--narrow content text-center">
    <h1>404 — Page not found</h1>
    <p>Looks like the page you wanted has moved. Need a locksmith now?</p>
    <p><a class="btn btn--primary btn--lg" href="tel:<?= e(setting('phone_e164')) ?>">Call <?= e(setting('phone')) ?></a></p>
    <p><a href="<?= e(url('/')) ?>">← Back to home</a></p>
  </div>
</section>
<?php require __DIR__ . '/../includes/footer.php'; ?>
