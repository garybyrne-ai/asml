<?php
require_once __DIR__ . '/../includes/functions.php';

$page_title       = 'Locksmith Areas Covered — Dublin & Greater Dublin';
$page_description = 'PSA-licensed locksmith covering all Dublin districts (D1–D24), the Greater Dublin Area, Kildare, Meath and Wicklow.';
$page_focus_kw    = 'locksmith dublin areas';
$page_canonical   = build_canonical('/locations');

$breadcrumbs = [['label' => 'Home', 'url' => '/'], ['label' => 'Locations', 'url' => null]];

$regions = [
    'dublin_city'   => 'Dublin City Districts',
    'dublin_county' => 'Greater Dublin Area',
    'kildare'       => 'County Kildare',
    'meath'         => 'County Meath',
    'wicklow'       => 'County Wicklow',
];

$hero = [
    'h1'      => 'Locksmith Areas We Cover',
    'eyebrow' => 'Dublin & Greater Dublin',
    'lede'    => 'Choose your area to see services, landmarks and direct dispatch numbers.',
];

require __DIR__ . '/../includes/header.php';
require __DIR__ . '/../includes/hero.php';
?>

<?php foreach ($regions as $key => $label):
    $items = get_locations($key);
    if (!$items) continue; ?>
<section class="section">
  <div class="container">
    <h2 class="section__title"><?= e($label) ?></h2>
    <ul class="locations-grid">
      <?php foreach ($items as $l): ?>
        <li>
          <a href="<?= e(url('/' . $l['slug'])) ?>">
            <strong>Locksmith <?= e($l['name']) ?></strong>
            <?php if (!empty($l['landmark'])): ?>
              <small>near <?= e($l['landmark']) ?></small>
            <?php endif; ?>
          </a>
        </li>
      <?php endforeach; ?>
    </ul>
  </div>
</section>
<?php endforeach; ?>

<?php require __DIR__ . '/../includes/footer.php'; ?>
