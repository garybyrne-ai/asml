<?php
require_once __DIR__ . '/../includes/functions.php';

$page_title       = 'Contact a Dublin Locksmith — 24/7';
$page_description = 'Contact our PSA-licensed Dublin locksmiths. Phone, WhatsApp or quick quote form. 20-minute response, 24 hours a day.';
$page_focus_kw    = 'contact locksmith dublin';
$page_canonical   = build_canonical('/contact');

$breadcrumbs = [['label' => 'Home', 'url' => '/'], ['label' => 'Contact', 'url' => null]];

$hero = [
    'h1'      => 'Contact a Dublin Locksmith',
    'eyebrow' => '24/7 PSA Licensed',
    'lede'    => 'Call, WhatsApp or fill in the form — fastest response is by phone.',
];

require __DIR__ . '/../includes/header.php';
require __DIR__ . '/../includes/hero.php';
?>

<section class="section">
  <div class="container container--narrow content">
    <h2>Direct contact</h2>
    <ul class="contact-list--lg">
      <li><strong>Phone (24/7):</strong> <a href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a></li>
      <li><strong>WhatsApp:</strong> <a href="https://wa.me/<?= e(preg_replace('~[^0-9]~', '', setting('whatsapp'))) ?>" target="_blank" rel="noopener"><?= e(setting('whatsapp')) ?></a></li>
      <li><strong>Email:</strong> <a href="mailto:<?= e(setting('email')) ?>"><?= e(setting('email')) ?></a></li>
      <li><strong>Address:</strong> <?= e(setting('address_street')) ?>, <?= e(setting('address_city')) ?>, <?= e(setting('address_postcode')) ?></li>
      <li><strong>PSA License:</strong> <?= e(setting('psa_license')) ?></li>
    </ul>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
