<?php
require_once __DIR__ . '/../includes/functions.php';

$page_title       = 'About — PSA Licensed Dublin Locksmith';
$page_description = 'About Locksmiths.ie — a PSA-licensed Dublin locksmith specialising in emergency lockouts, lock changes and smart-lock installation.';
$page_focus_kw    = 'about locksmiths.ie';
$page_canonical   = build_canonical('/about');
$breadcrumbs = [['label' => 'Home', 'url' => '/'], ['label' => 'About', 'url' => null]];

$hero = [
    'h1'      => 'About Locksmiths.ie',
    'eyebrow' => 'Our story',
    'lede'    => 'Dublin-born, PSA-licensed and trusted by thousands. We do one thing — locks — and we do it fast.',
];

require __DIR__ . '/../includes/header.php';
require __DIR__ . '/../includes/hero.php';
?>

<section class="section">
  <div class="container container--narrow content">
    <p>Locksmiths.ie has been securing Dublin homes and businesses for over 15 years. Every technician on our team is fully PSA licensed (license <?= e(setting('psa_license')) ?>) and trained in non-destructive entry, anti-snap cylinder upgrades, smart-lock fitting and master-key system design.</p>
    <h2>Our promises</h2>
    <ul>
      <li><strong>20-minute response</strong> across Dublin city &amp; county.</li>
      <li><strong>No call-out fee</strong> — fixed price quoted up front.</li>
      <li><strong>12-month guarantee</strong> on all parts and labour.</li>
      <li><strong>Insurance-approved</strong> reports for burglary repair work.</li>
    </ul>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
