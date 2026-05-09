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

    <div class="content">
      <h2>How our pricing works</h2>
      <p>Every quote is fixed before we leave the depot. The minimum job price is <strong>€90</strong> — that covers a non-destructive entry into a locked door, including the visit. There is no separate call-out fee bolted on top, no after-hours surcharge, no weekend or bank-holiday premium. The price you hear on the phone is the price you pay when the work is done.</p>
      <p>For specialist work — multipoint mechanism replacement, master-key suites, smart-lock installation, on-site car-key programming — we agree the fixed price on the phone before we travel, based on the door type and brand. We''ll never ask you to pay anything extra at the door.</p>
      <p>The list below covers the most common Dublin locksmith jobs. Anything not listed is quoted on the phone — call <a href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a>.</p>
    </div>

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

    <div class="content" style="margin-top:3rem">
      <h2>What you''re paying for</h2>
      <p>Behind every price on this list is a fully PSA-licensed technician with a fully-stocked van — not a sub-contractor bid via an online lead-auction. Every cylinder we fit is certified to British Standard (BS3621 5-lever, TS007 3-star anti-snap), every part is sourced from a recognised supplier and every job carries a written 12-month guarantee on parts and labour.</p>

      <h2>Why we don''t do "free call-outs"</h2>
      <p>You will see ads from other companies advertising "no call-out fee — pay only for the work". In practice the work then arrives priced 2–3× higher than market rate to absorb the call-out cost. We prefer to be honest: the minimum price for any job is €90, that includes the visit, and the price for everything else on the list is exactly what you''ll pay.</p>

      <h2>Discounts</h2>
      <p>We offer a small discount for: (a) bulk window-lock fittings on a whole house (more than five), (b) full-property cylinder replacements (front, back, side and patio doors at the same time), and (c) regular landlords doing tenant changeovers. Just ask on the phone.</p>
    </div>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
