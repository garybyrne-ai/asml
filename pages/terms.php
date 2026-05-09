<?php
require_once __DIR__ . '/../includes/functions.php';
$page_title = 'Terms of Service';
$page_description = 'Terms of service for Locksmiths.ie';
$page_canonical = build_canonical('/terms');
$breadcrumbs = [['label' => 'Home', 'url' => '/'], ['label' => 'Terms', 'url' => null]];
require __DIR__ . '/../includes/header.php';
?>
<section class="section">
  <div class="container container--narrow content">
    <h1>Terms of Service</h1>
    <p>All works are quoted at a fixed price prior to commencement. Workmanship and parts are guaranteed for 12 months. Locksmiths.ie operates under PSA license <?= e(setting('psa_license')) ?>.</p>
  </div>
</section>
<?php require __DIR__ . '/../includes/footer.php'; ?>
