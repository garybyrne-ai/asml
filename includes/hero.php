<?php
/**
 * Reusable above-the-fold hero. Pass an array of overrides via $hero before include.
 *
 * Available keys:
 *   h1, eyebrow, lede, kicker
 */
require_once __DIR__ . '/functions.php';

$hero = $hero ?? [];
$h1      = $hero['h1']      ?? setting('hero_title', 'Dublin\'s Fastest Emergency Locksmith');
$eyebrow = $hero['eyebrow'] ?? '24/7 PSA Licensed Locksmith';
$lede    = $hero['lede']    ?? setting('hero_subtitle');
$kicker  = $hero['kicker']  ?? null;

$phone   = setting('phone');
$phoneE  = setting('phone_e164');
$response= setting('response_time', '20-30 minutes');
?>
<section class="hero">
  <div class="container hero__grid">
    <div class="hero__copy">
      <span class="hero__eyebrow"><?= e($eyebrow) ?></span>
      <h1 class="hero__h1"><?= e($h1) ?></h1>
      <?php if ($kicker): ?><p class="hero__kicker"><?= e($kicker) ?></p><?php endif; ?>
      <p class="hero__lede"><?= e($lede) ?></p>

      <div class="hero__badges">
        <span class="badge badge--gold"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M12 2 4 5v6c0 5 3.4 9.5 8 11 4.6-1.5 8-6 8-11V5l-8-3z"/></svg> PSA Licensed</span>
        <span class="badge"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg> <?= e($response) ?> arrival</span>
        <span class="badge">Fixed prices</span>
        <span class="badge">12-month guarantee</span>
      </div>

      <a class="cta-call" href="tel:<?= e($phoneE) ?>" data-call>
        <span class="cta-call__pulse"></span>
        <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
          <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
        </svg>
        <span class="cta-call__label">
          <small>Call now — 24 hours</small>
          <strong><?= e($phone) ?></strong>
        </span>
      </a>

      <p class="hero__trust">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="#ffb300"><polygon points="12,2 15.09,8.26 22,9.27 17,14.14 18.18,21.02 12,17.77 5.82,21.02 7,14.14 2,9.27 8.91,8.26"/></svg>
        <strong>4.9/5</strong> from 250+ verified Dublin reviews
      </p>
    </div>

    <aside class="quote-card" id="quote">
      <h2 class="quote-card__title">Get a fixed price now</h2>
      <p class="quote-card__sub">No hidden fees. We&rsquo;ll call you back within 5 minutes.</p>

      <form id="quote-form" class="quote-form" novalidate>
        <?= csrf_field() ?>
        <input type="hidden" name="source_page" value="<?= e($_SERVER['REQUEST_URI'] ?? '/') ?>">

        <label>
          <span>Name</span>
          <input type="text" name="name" required autocomplete="name" placeholder="e.g. Sarah O'Brien">
        </label>

        <label>
          <span>Phone</span>
          <input type="tel" name="phone" required autocomplete="tel" inputmode="tel" placeholder="087 123 4567">
        </label>

        <div class="quote-form__row">
          <label>
            <span>Location</span>
            <input type="text" name="area" required autocomplete="address-level2"
                   placeholder="e.g. Tallaght, Dublin 6, Swords">
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
        </div>

        <label>
          <span>Message <small style="font-weight:500;color:var(--c-muted)">(optional)</small></span>
          <textarea name="message" rows="3" maxlength="800"
                    placeholder="Anything else we should know? (e.g. brand of lock, type of door)"></textarea>
        </label>

        <!-- Honeypot -->
        <label style="position:absolute;left:-9999px" aria-hidden="true">
          Website <input type="text" name="website" tabindex="-1" autocomplete="off">
        </label>

        <button type="submit" class="btn btn--primary btn--block">
          Get my quote →
        </button>
        <div class="quote-form__msg" role="status" aria-live="polite"></div>
      </form>
    </aside>
  </div>
</section>
