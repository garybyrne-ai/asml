<?php
require_once __DIR__ . '/../includes/functions.php';

/** @var array<string,mixed> $service */

$page_title       = $service['meta_title']       ?: ($service['title'] . ' Dublin');
$page_description = $service['meta_description'] ?: $service['short_description'];
$page_focus_kw    = $service['focus_keyword']    ?? '';
$page_canonical   = $service['canonical_url']    ?: build_canonical('/' . $service['slug']);

$faqs         = get_faqs((int)$service['id']);
$testimonials = get_testimonials(6);
$locations    = get_locations();

$breadcrumbs = [
    ['label' => 'Home',     'url' => '/'],
    ['label' => 'Services', 'url' => '/services'],
    ['label' => $service['title'], 'url' => null],
];

$schema_blocks = [
    schema_faq($faqs),
    schema_service($service),
];

$hero = [
    'h1'      => $service['title'] . ' — Dublin',
    'eyebrow' => 'PSA Licensed Locksmith',
    'lede'    => $service['short_description'],
];

require __DIR__ . '/../includes/header.php';
require __DIR__ . '/../includes/hero.php';
?>

<section class="section">
  <div class="container container--narrow content">
    <?= $service['body'] ?>

    <h2>Available across Dublin</h2>
    <p>We provide <strong><?= e(strtolower($service['title'])) ?></strong> across every Dublin district and the Greater Dublin Area:</p>
    <ul class="locations-grid">
      <?php foreach (array_slice($locations, 0, 12) as $l): ?>
        <li><a href="<?= e(url('/' . $l['slug'])) ?>"><?= e($l['name']) ?></a></li>
      <?php endforeach; ?>
    </ul>
  </div>
</section>

<?php if ($faqs): ?>
<section class="section section--alt">
  <div class="container container--narrow">
    <h2 class="section__title">FAQs — <?= e($service['title']) ?></h2>
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

<?php if ($testimonials): ?>
<section class="section">
  <div class="container">
    <h2 class="section__title">Reviews</h2>
    <div class="reviews-grid">
      <?php foreach ($testimonials as $t): ?>
      <article class="review">
        <div class="review__stars">★★★★★</div>
        <p class="review__body">&ldquo;<?= e($t['review_body']) ?>&rdquo;</p>
        <p class="review__author"><strong><?= e($t['customer_name']) ?></strong> · <?= e($t['customer_location']) ?></p>
      </article>
      <?php endforeach; ?>
    </div>
  </div>
</section>
<?php endif; ?>

<section class="section section--cta">
  <div class="container cta-banner">
    <div>
      <h2>Need <?= e(strtolower($service['title'])) ?> now?</h2>
      <p>PSA-licensed locksmith on-site in <?= e(setting('response_time')) ?>.</p>
    </div>
    <a class="btn btn--primary btn--lg" href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
