<?php
require_once __DIR__ . '/../includes/functions.php';

$page_title       = 'Locksmith Services Dublin';
$page_description = 'Full locksmith services across Dublin — emergency lockouts, lock changes, burglary repairs, smart locks, car keys, safes and commercial. PSA Licensed.';
$page_focus_kw    = 'locksmith services dublin';
$page_canonical   = build_canonical('/services');

$breadcrumbs = [['label' => 'Home', 'url' => '/'], ['label' => 'Services', 'url' => null]];

$categories = [
    'emergency'   => 'Emergency Services',
    'residential' => 'Residential',
    'commercial'  => 'Commercial',
    'automotive'  => 'Automotive (Car Keys)',
    'safe'        => 'Safe Services',
];

$hero = [
    'h1'      => 'Locksmith Services Across Dublin',
    'eyebrow' => 'PSA Licensed · 24/7',
    'lede'    => 'From emergency lockouts to smart-lock installs — every service backed by our 12-month guarantee.',
];

require __DIR__ . '/../includes/header.php';
require __DIR__ . '/../includes/hero.php';
?>

<?php foreach ($categories as $key => $label):
    $items = get_services($key);
    if (!$items) continue; ?>
<section class="section">
  <div class="container">
    <h2 class="section__title"><?= e($label) ?></h2>
    <div class="services-grid">
      <?php foreach ($items as $s): ?>
      <a class="service-card" href="<?= e(url('/' . $s['slug'])) ?>">
        <h3><?= e($s['title']) ?></h3>
        <p><?= e($s['short_description']) ?></p>
        <?php if (!empty($s['price_from'])): ?>
          <span class="service-card__price">From €<?= e(number_format((float)$s['price_from'], 0)) ?></span>
        <?php endif; ?>
        <span class="service-card__more">Learn more →</span>
      </a>
      <?php endforeach; ?>
    </div>
  </div>
</section>
<?php endforeach; ?>

<?php require __DIR__ . '/../includes/footer.php'; ?>
