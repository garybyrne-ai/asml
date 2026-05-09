<?php
require_once __DIR__ . '/../includes/functions.php';

$page_title       = 'Emergency Locksmith Dublin — 20-Min Response, PSA Licensed';
$page_description = 'Locked out in Dublin? PSA-licensed emergency locksmith on-site in 20 minutes. Fixed prices from ' . setting('minimum_price', '€90') . '. 24/7. ' . setting('phone');
$page_focus_kw    = 'emergency locksmith dublin';
$page_canonical   = build_canonical('/');

$services     = get_services();
$locations    = get_locations();
$testimonials = get_testimonials(8, true);
$faqs         = get_faqs();

$schema_blocks = [
    schema_faq($faqs),
    schema_reviews($testimonials),
];

require __DIR__ . '/../includes/header.php';
require __DIR__ . '/../includes/hero.php';
?>

<section class="section section--why">
  <div class="container">
    <h2 class="section__title">Why Dublin chooses Locksmiths.ie</h2>
    <p class="section__lede">Hundreds of households and businesses trust us every month — here&rsquo;s why.</p>

    <div class="why-grid">
      <article class="why-card">
        <div class="why-card__icon">🛡️</div>
        <h3>PSA Licensed</h3>
        <p>License <?= e(setting('psa_license')) ?>. Operating legally as a locksmith in Ireland — your insurance demands it.</p>
      </article>
      <article class="why-card">
        <div class="why-card__icon">⏱️</div>
        <h3>20-Minute Response</h3>
        <p>City-wide network of vans. Average on-site arrival is <?= e(setting('response_time')) ?>, 24 hours a day.</p>
      </article>
      <article class="why-card">
        <div class="why-card__icon">€</div>
        <h3>Fixed Price Quotes</h3>
        <p>Transparent <a href="<?= e(url('/pricing')) ?>">price list</a>. Fixed quote agreed before we start — no surprises.</p>
      </article>
      <article class="why-card">
        <div class="why-card__icon">✓</div>
        <h3>12-Month Guarantee</h3>
        <p>All workmanship and parts guaranteed for a full year — in writing.</p>
      </article>
    </div>
  </div>
</section>

<section class="section section--alt">
  <div class="container">
    <h2 class="section__title">Locksmith services across Dublin</h2>
    <div class="services-grid">
      <?php foreach ($services as $s): ?>
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

<section class="section">
  <div class="container">
    <h2 class="section__title">Areas we cover in Dublin</h2>
    <p class="section__lede">PSA-licensed locksmiths covering every Dublin district and the Greater Dublin Area.</p>
    <ul class="locations-grid">
      <?php foreach ($locations as $l): ?>
        <li><a href="<?= e(url('/' . $l['slug'])) ?>">Locksmith <?= e($l['name']) ?></a></li>
      <?php endforeach; ?>
    </ul>
  </div>
</section>

<section class="section section--reviews">
  <div class="container">
    <h2 class="section__title">What our Dublin customers say</h2>
    <div class="reviews-grid">
      <?php foreach ($testimonials as $t): ?>
      <article class="review">
        <div class="review__stars" aria-label="<?= (int)$t['rating'] ?> stars">
          <?php for ($i=0; $i<(int)$t['rating']; $i++): ?>★<?php endfor; ?>
        </div>
        <p class="review__body">&ldquo;<?= e($t['review_body']) ?>&rdquo;</p>
        <p class="review__author">
          <strong><?= e($t['customer_name']) ?></strong>
          <?php if ($t['customer_location']): ?><span>· <?= e($t['customer_location']) ?></span><?php endif; ?>
        </p>
      </article>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section class="section section--faq">
  <div class="container container--narrow">
    <h2 class="section__title">Frequently asked questions</h2>
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

<section class="section section--cta">
  <div class="container cta-banner">
    <div>
      <h2>Locked out? Call us now.</h2>
      <p>PSA-licensed locksmith. <?= e(setting('response_time')) ?> response across Dublin.</p>
    </div>
    <a class="btn btn--primary btn--lg" href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
