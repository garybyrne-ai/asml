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

<section class="section">
  <div class="container container--narrow content">
    <p class="lead">If you''re locked out in Dublin right now, the fastest way to get back inside is to ring our <strong>local 01 landline (01) 878 2720</strong> — answered every minute of every day by a real member of our Dublin team. PSA-licensed, fixed price agreed before we leave the depot, average on-site arrival of fifteen to twenty minutes inside the M50.</p>
    <p>We do everything a Dublin household, business or driver might need from a locksmith — emergency lockouts, lock changes, anti-snap upgrades, UPVC mechanism repair, smart-lock installation, on-site car-key cutting, master-key suites and burglary repair with insurance reports. Every job carries a 12-month guarantee on parts and labour.</p>
  </div>
</section>

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
        <p>All workmanship and parts guaranteed for a full year.</p>
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

<section class="section">
  <div class="container container--narrow content">
    <h2>A real local Dublin locksmith — not a call-centre redirect</h2>
    <p>Search for "locksmith Dublin" online and most of the top results aren''t Dublin businesses at all — they''re lead-auction sites that route your call to a UK call-centre, then auction the job to the highest-bidding sub-contractor. That''s why so many people end up with a "fixed price" of €95 on the phone and a €280 invoice on the doorstep.</p>
    <p>We are a small Dublin team operating from a single Dublin base. Our number — <strong><a href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a></strong> — is a real Dublin <strong>01 landline</strong>. Calls cost the same as ringing any other Irish landline; from most modern mobile plans they're included or free. There is no premium-rate surcharge, no overseas redirect and no third-party sub-contractor.</p>
    <p>The technician you speak to on the phone is the technician who arrives at your door, in a fully-stocked van, with the parts on board to finish over 95% of jobs on the first visit. The fixed price you hear on the phone is the price you pay when the work is done.</p>

    <h2>How our pricing works</h2>
    <p>Every quote is fixed before any work begins. The minimum job price is <strong>€90</strong>, which covers a non-destructive entry into a locked door — that is the call-out and the work combined, not the call-out on its own. We do not charge a separate call-out fee bolted on top, we don''t add late-night, weekend or bank-holiday surcharges, and we don''t do "actually it turned out bigger than I thought" surprise invoicing. <a href="<?= e(url('/pricing')) ?>">See the full price list →</a></p>

    <h2>British Standard locks &amp; insurance compliance</h2>
    <p>Most Irish home insurance policies specify locks rated to <strong>BS3621</strong> (5-lever mortice deadlocks) or <strong>TS007 3-star</strong> (anti-snap euro cylinders). When we fit a lock to your door we leave the certification mark visible, name the standard on the written invoice, and provide a separate insurance-claim report on request. That is what claims handlers actually look for in the event of a future incident — a generic "lock changed" line on a receipt is not enough.</p>
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
