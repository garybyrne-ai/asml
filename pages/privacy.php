<?php
require_once __DIR__ . '/../includes/functions.php';
$page_title = 'Privacy Policy';
$page_description = 'Privacy policy for Locksmiths.ie';
$page_canonical = build_canonical('/privacy');
$breadcrumbs = [['label' => 'Home', 'url' => '/'], ['label' => 'Privacy', 'url' => null]];
require __DIR__ . '/../includes/header.php';
?>
<section class="section">
  <div class="container container--narrow content">
    <h1>Privacy Policy</h1>
    <p>Locksmiths.ie collects only the information you submit (name, phone, email, area, service request) for the sole purpose of providing locksmith services. Data is stored securely and never sold.</p>
    <p>You may request deletion of your data at any time by emailing <a href="mailto:<?= e(setting('email')) ?>"><?= e(setting('email')) ?></a>.</p>
  </div>
</section>
<?php require __DIR__ . '/../includes/footer.php'; ?>
