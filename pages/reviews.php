<?php
require_once __DIR__ . '/../includes/functions.php';

$page_title       = 'Reviews — Dublin Locksmith';
$page_description = 'Real reviews from Dublin households and businesses. PSA-licensed locksmith trusted across Dublin.';
$page_focus_kw    = 'locksmith dublin reviews';
$page_canonical   = build_canonical('/reviews');
$breadcrumbs      = [['label' => 'Home', 'url' => '/'], ['label' => 'Reviews', 'url' => null]];

$testimonials = get_testimonials(50);
$schema_blocks = [schema_reviews($testimonials)];

$hero = [
    'h1'      => 'Verified Customer Reviews',
    'eyebrow' => 'Why Dublin trusts us',
    'lede'    => 'Average rating 4.9/5 from 250+ verified reviews across Dublin.',
];

require __DIR__ . '/../includes/header.php';
require __DIR__ . '/../includes/hero.php';
?>

<section class="section">
  <div class="container">
    <div class="reviews-grid">
      <?php foreach ($testimonials as $t): ?>
      <article class="review">
        <div class="review__stars">
          <?php for ($i=0; $i<(int)$t['rating']; $i++): ?>★<?php endfor; ?>
        </div>
        <p class="review__body">&ldquo;<?= e($t['review_body']) ?>&rdquo;</p>
        <p class="review__author">
          <strong><?= e($t['customer_name']) ?></strong>
          <?php if ($t['customer_location']): ?><span>· <?= e($t['customer_location']) ?></span><?php endif; ?>
          <?php if ($t['review_date']): ?><time> · <?= e(date('M Y', strtotime($t['review_date']))) ?></time><?php endif; ?>
        </p>
      </article>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
