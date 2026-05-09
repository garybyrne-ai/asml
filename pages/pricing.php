<?php
require_once __DIR__ . '/../includes/functions.php';

$page_title       = 'Locksmith Prices Dublin — Fixed-Price List';
$page_description = 'Transparent fixed-price locksmith services in Dublin: lockouts from €95, anti-snap cylinders €115, 5-lever deadlocks €125, multipoint locks €175–€245.';
$page_focus_kw    = 'locksmith prices dublin';
$page_canonical   = build_canonical('/pricing');

$hero = [
    'h1'      => 'Locksmith Prices — Dublin',
    'eyebrow' => 'Fixed Price Quotes',
    'lede'    => 'Transparent pricing on the most common Dublin locksmith jobs. Final price is agreed before any work begins.',
];

$items   = get_pricing_items();
$min     = setting('minimum_price', '€90');
$policy  = setting('callout_policy', 'Minimum job price €90. We do not offer free call-outs.');
$intro   = setting('pricing_intro', '');

require __DIR__ . '/../includes/header.php';
?>

<section class="hero hero--compact">
  <div class="container">
    <span class="hero__eyebrow"><?= e($hero['eyebrow']) ?></span>
    <h1 class="hero__h1"><?= e($hero['h1']) ?></h1>
    <p class="hero__lede"><?= e($hero['lede']) ?></p>
  </div>
</section>

<section class="section">
  <div class="container container--narrow">
    <?php if ($intro !== ''): ?>
      <p class="lead"><?= e($intro) ?></p>
    <?php endif; ?>

    <div class="pricing-table" role="table" aria-label="Locksmith prices">
      <div class="pricing-table__head" role="row">
        <div role="columnheader">Service</div>
        <div role="columnheader">Price</div>
        <div role="columnheader" class="pricing-table__cta">&nbsp;</div>
      </div>

      <?php foreach ($items as $row): ?>
        <div class="pricing-table__row" role="row">
          <div role="cell">
            <strong><?= e($row['label']) ?></strong>
            <?php if (!empty($row['note'])): ?>
              <small><?= e($row['note']) ?></small>
            <?php endif; ?>
          </div>
          <div role="cell" class="pricing-table__price"><?= e($row['price_text']) ?></div>
          <div role="cell" class="pricing-table__cta">
            <a class="btn btn--primary btn--sm"
               href="<?= e(url('/contact?service=' . urlencode($row['label']))) ?>">Get Quote</a>
          </div>
        </div>
      <?php endforeach; ?>
    </div>

    <p class="pricing-callout">
      <strong>Minimum price <?= e($min) ?>.</strong> <?= e($policy) ?>
    </p>

    <p style="text-align:center;margin-top:2rem">
      <a href="tel:<?= e(setting('phone_e164')) ?>" class="btn btn--primary btn--lg">
        Call <?= e(setting('phone')) ?> for a quote
      </a>
    </p>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
