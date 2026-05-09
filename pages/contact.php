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

<?php require __DIR__ . '/../includes/footer.php'; ?>
