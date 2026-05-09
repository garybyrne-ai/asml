<?php
require_once __DIR__ . '/../includes/functions.php';

/** @var array<string,mixed> $location */

$landmark1 = $location['landmark']           ?? '';
$landmark2 = $location['landmark_secondary'] ?? '';
$lname     = $location['name'];

$page_title       = $location['meta_title']       ?: ('Locksmith ' . $lname . ' | 20-Min Response');
$page_description = $location['meta_description'] ?: ('PSA licensed locksmith covering ' . $lname . ($landmark1 ? ' near ' . $landmark1 : '') . '. 20-minute response, fixed-price quotes, 24/7.');
$page_focus_kw    = $location['focus_keyword']    ?? '';
$page_canonical   = $location['canonical_url']    ?: build_canonical('/' . $location['slug']);

$services     = get_services();
$faqs         = get_faqs(null, (int)$location['id']);
$testimonials = get_testimonials(6);

$breadcrumbs = [
    ['label' => 'Home',      'url' => '/'],
    ['label' => 'Locations', 'url' => '/locations'],
    ['label' => 'Locksmith ' . $lname, 'url' => null],
];

$schema_blocks = [
    schema_faq($faqs),
    schema_location_business($location),
];

// Dynamic landmark sentence
$landmark_line = '';
if ($landmark1) {
    $landmark_line = 'Emergency Locksmith near ' . $landmark1
        . ($landmark2 ? ' and ' . $landmark2 : '')
        . ' — PSA licensed, ' . setting('response_time') . ' response.';
}

$hero = [
    'h1'      => 'Locksmith ' . $lname . ($location['district_code'] ? ' (' . $location['district_code'] . ')' : ''),
    'eyebrow' => '24/7 Emergency Locksmith',
    'lede'    => $landmark_line ?: ($location['intro'] ?? ''),
    'kicker'  => $landmark1 ? ('Right next to ' . $landmark1) : null,
];

require __DIR__ . '/../includes/header.php';
require __DIR__ . '/../includes/hero.php';
?>

<section class="section">
  <div class="container container--narrow content">
    <?php if (!empty($location['intro'])): ?>
      <p class="lead"><?= e($location['intro']) ?></p>
    <?php endif; ?>

    <?php if ($landmark1): ?>
      <p>If you&rsquo;re locked out near <strong><?= e($landmark1) ?></strong><?= $landmark2 ? ' or <strong>' . e($landmark2) . '</strong>' : '' ?>, our nearest van is typically less than <?= e(setting('response_time')) ?> away. Call <a href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a> and we&rsquo;ll dispatch a PSA-licensed technician immediately.</p>
    <?php endif; ?>

    <?= $location['body'] ?>

    <?php
    if (!empty($location['latitude']) && !empty($location['longitude'])):
        $place = $lname . ', Dublin, Ireland';
        echo '<h2>Find us in ' . e($lname) . '</h2>';
        echo google_map_iframe(
            (float) $location['latitude'],
            (float) $location['longitude'],
            $place,
            14
        );
    endif;
    ?>

    <h2>Locksmith services in <?= e($lname) ?></h2>
    <div class="services-grid services-grid--compact">
      <?php foreach ($services as $s): ?>
      <a class="service-card" href="<?= e(url('/' . $s['slug'])) ?>">
        <h3><?= e($s['title']) ?> — <?= e($lname) ?></h3>
        <p><?= e($s['short_description']) ?></p>
      </a>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<?php if ($faqs): ?>
<section class="section section--alt">
  <div class="container container--narrow">
    <h2 class="section__title">FAQs — Locksmith <?= e($lname) ?></h2>
    <div class="faqs">
      <?php foreach ($faqs as $f): ?>
      <details class="faq">
        <summary><?= e($f['question']) ?></summary>
        <div class="faq__a"><?= $f['answer'] ?></div>
      </details>
      <?php endforeach; ?>
    </div>
  </div>
</section>
<?php endif; ?>

<section class="section section--cta">
  <div class="container cta-banner">
    <div>
      <h2>Locksmith <?= e($lname) ?> — call now</h2>
      <p>On-site in <?= e(setting('response_time')) ?>. PSA Licensed <?= e(setting('psa_license')) ?>.</p>
    </div>
    <a class="btn btn--primary btn--lg" href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
