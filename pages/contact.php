<?php
require_once __DIR__ . '/../includes/functions.php';

$page_title       = 'Contact a Dublin Locksmith — 24/7';
$page_description = 'Contact our PSA-licensed Dublin locksmiths. Phone, WhatsApp or quick quote form. 20-minute response, 24 hours a day.';
$page_focus_kw    = 'contact locksmith dublin';
$page_canonical   = build_canonical('/contact');

$hero = [
    'h1'      => 'Contact a Dublin Locksmith',
    'eyebrow' => '24/7 PSA Licensed',
    'lede'    => 'Call, WhatsApp or fill in the form — fastest response is by phone.',
];

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
  <div class="container container--narrow content">
    <p class="lead">The fastest way to reach us is the phone — we answer twenty-four hours a day, seven days a week, on a real Dublin <strong>01 landline</strong>. Calls cost the same as any other local number. No premium rate, no overseas redirect, no auctioned leads. Or fill in the form below and we will call you back within minutes during the day, or first thing in the morning if it isn''t an emergency.</p>
    <p>If you are locked out right now, please call rather than emailing or messaging — voice is always faster, and we can have a van rolling before you even hang up.</p>
  </div>
</section>

<section class="section">
  <div class="container contact-grid">

    <div class="contact-grid__info">
      <h2>Direct contact</h2>
      <ul class="contact-list--lg">
        <li><strong>Phone (24/7):</strong><br>
          <a href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a></li>
        <li><strong>WhatsApp:</strong><br>
          <a href="https://wa.me/<?= e(preg_replace('~[^0-9]~', '', setting('whatsapp'))) ?>" target="_blank" rel="noopener"><?= e(setting('whatsapp')) ?></a></li>
        <li><strong>Email:</strong><br>
          <a href="mailto:<?= e(setting('email')) ?>"><?= e(setting('email')) ?></a></li>
        <li><strong>Address:</strong><br>
          <?= e(setting('address_street')) ?>, <?= e(setting('address_city')) ?>, <?= e(setting('address_postcode')) ?>, Ireland</li>
        <li><strong>PSA License:</strong> <?= e(setting('psa_license')) ?></li>
      </ul>

      <h3>Follow us</h3>
      <ul class="social-list">
        <?php $tw = setting('social_twitter');     if ($tw): ?>
          <li><a href="<?= e($tw) ?>" target="_blank" rel="noopener">Twitter</a></li>
        <?php endif; ?>
        <?php $pin = setting('social_pinterest'); if ($pin): ?>
          <li><a href="<?= e($pin) ?>" target="_blank" rel="noopener">Pinterest</a></li>
        <?php endif; ?>
      </ul>
    </div>

    <aside class="quote-card contact-grid__form" id="quote">
      <h2 class="quote-card__title">Send us a message</h2>
      <p class="quote-card__sub">We answer all enquiries within 20 minutes during the day.</p>

      <form id="quote-form" class="quote-form" novalidate>
        <?= csrf_field() ?>
        <input type="hidden" name="source_page" value="/contact">

        <label>
          <span>Name</span>
          <input type="text" name="name" required autocomplete="name" placeholder="Your full name">
        </label>

        <div class="quote-form__row">
          <label>
            <span>Phone</span>
            <input type="tel" name="phone" required autocomplete="tel" inputmode="tel" placeholder="087 123 4567">
          </label>
          <label>
            <span>Email <small style="font-weight:500;color:var(--c-muted)">(optional)</small></span>
            <input type="email" name="email" autocomplete="email" placeholder="you@example.com">
          </label>
        </div>

        <label>
          <span>Location</span>
          <input type="text" name="area" required autocomplete="address-level2"
                 placeholder="Town / area, e.g. Tallaght, Dublin 6, Swords">
        </label>

        <label>
          <span>Service</span>
          <select name="service_needed" required>
            <option value="">Select…</option>
            <option>Emergency Lockout</option>
            <option>Lock Change / Repair</option>
            <option>Burglary Damage</option>
            <option>Smart Lock Install</option>
            <option>Car Key / Programming</option>
            <option>Safe Opening</option>
            <option>Commercial</option>
            <option>Other</option>
          </select>
        </label>

        <label>
          <span>Message <small style="font-weight:500;color:var(--c-muted)">(optional)</small></span>
          <textarea name="message" rows="3" maxlength="800"
                    placeholder="Tell us a bit more — door type, lock brand, etc."></textarea>
        </label>

        <!-- Honeypot -->
        <label style="position:absolute;left:-9999px" aria-hidden="true">
          Website <input type="text" name="website" tabindex="-1" autocomplete="off">
        </label>

        <button type="submit" class="btn btn--primary btn--block">Send message →</button>
        <div class="quote-form__msg" role="status" aria-live="polite"></div>
      </form>
    </aside>
  </div>
</section>

<section class="section section--alt">
  <div class="container container--narrow">
    <h2 class="section__title">Find us &amp; our coverage</h2>
    <?= google_map_iframe(53.349805, -6.260310, 'North City, Dublin 1, D01 F297, Ireland', 12) ?>
    <p style="text-align:center;color:var(--c-muted);font-size:.95rem">
      Office address: <strong><?= e(setting('address_street')) ?>, <?= e(setting('address_city')) ?>, <?= e(setting('address_postcode')) ?></strong>.
      Vans dispatched 24 hours a day across all Dublin postcodes.
    </p>
  </div>
</section>

<section class="section">
  <div class="container container--narrow content">
    <h2>Frequently asked contact questions</h2>
    <h3>Are you really open at 3am?</h3>
    <p>Yes. Around 40% of our calls happen between 10pm and 6am. Someone is always rostered on the phone, and a fully-stocked van is on the road within minutes of the call ending.</p>

    <h3>Is the (01) 878 2720 number free to call?</h3>
    <p>It''s a standard Dublin landline. From a mobile or another landline it costs whatever your plan charges for an Irish 01 number — for most modern bill-pay and bundled mobile plans that is free or pennies per minute. There is no premium-rate surcharge regardless of when you call.</p>

    <h3>Can I get a quote by email or WhatsApp?</h3>
    <p>Yes — message us with the door type (timber / UPVC / composite), the lock brand if you can see it, and a quick photo if possible, and we''ll send back a fixed quote. For lockouts and other emergencies the phone is far faster.</p>

    <h3>Where are you based?</h3>
    <p>Our office is in <strong><?= e(setting('address_city')) ?>, <?= e(setting('address_postcode')) ?></strong>. The vans are spread across the city — north, south and west — so wherever you''re calling from, the closest one is dispatched.</p>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
