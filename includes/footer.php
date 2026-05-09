<?php require_once __DIR__ . '/functions.php'; ?>
</main>

<footer class="site-footer">
  <div class="container site-footer__grid">
    <div>
      <img src="<?= e(asset('images/locksmiths-ie-logo-white.svg')) ?>" alt="Locksmiths.ie" class="site-footer__logo" width="180" height="44">
      <p>PSA-licensed Dublin locksmith. Emergency lockouts, lock changes, burglary repairs and smart-lock installation across Dublin and the Greater Dublin Area.</p>
      <p class="psa-badge">
        <strong>PSA License:</strong> <?= e(setting('psa_license')) ?>
      </p>
    </div>

    <div>
      <h4>Services</h4>
      <ul class="link-list">
        <?php foreach (get_services() as $s): ?>
          <li><a href="<?= e(url('/' . $s['slug'])) ?>"><?= e($s['title']) ?></a></li>
        <?php endforeach; ?>
      </ul>
    </div>

    <div>
      <h4>Popular Locations</h4>
      <ul class="link-list">
        <?php foreach (array_slice(get_locations(), 0, 9) as $l): ?>
          <li><a href="<?= e(url('/' . $l['slug'])) ?>">Locksmith <?= e($l['name']) ?></a></li>
        <?php endforeach; ?>
        <li><a href="<?= e(url('/locations')) ?>"><strong>View all locations →</strong></a></li>
      </ul>
    </div>

    <div>
      <h4>Contact</h4>
      <ul class="link-list contact-list">
        <li><a href="tel:<?= e(setting('phone_e164')) ?>"><strong><?= e(setting('phone')) ?></strong></a></li>
        <li><a href="mailto:<?= e(setting('email')) ?>"><?= e(setting('email')) ?></a></li>
        <li><?= e(setting('address_street')) ?>, <?= e(setting('address_city')) ?>, <?= e(setting('address_postcode')) ?></li>
        <li>Open 24 hours · 7 days</li>
      </ul>

      <?php
      $socials = [
        'twitter'   => ['label' => 'Twitter',   'url' => setting('social_twitter')],
        'pinterest' => ['label' => 'Pinterest', 'url' => setting('social_pinterest')],
        'facebook'  => ['label' => 'Facebook',  'url' => setting('social_facebook')],
        'instagram' => ['label' => 'Instagram', 'url' => setting('social_instagram')],
        'linkedin'  => ['label' => 'LinkedIn',  'url' => setting('social_linkedin')],
        'youtube'   => ['label' => 'YouTube',   'url' => setting('social_youtube')],
      ];
      $socials = array_filter($socials, fn($s) => !empty($s['url']));
      if ($socials): ?>
        <h4 style="margin-top:1.2rem;font-size:.95rem">Follow us</h4>
        <ul class="social-list">
          <?php foreach ($socials as $key => $s): ?>
            <li><a href="<?= e($s['url']) ?>" target="_blank" rel="noopener me"
                   aria-label="<?= e($s['label']) ?>"><?= e($s['label']) ?></a></li>
          <?php endforeach; ?>
        </ul>
      <?php endif; ?>
    </div>
  </div>

  <div class="site-footer__bottom">
    <div class="container">
      <p>&copy; <?= date('Y') ?> <?= e(setting('business_name')) ?> · PSA License <?= e(setting('psa_license')) ?> · All rights reserved.</p>
      <p><a href="<?= e(url('/privacy')) ?>">Privacy</a> · <a href="<?= e(url('/terms')) ?>">Terms</a></p>
    </div>
  </div>
</footer>

<a href="tel:<?= e(setting('phone_e164')) ?>" class="float-call" aria-label="Call locksmith now">
  <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round">
    <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
  </svg>
</a>

<a href="https://wa.me/<?= e(preg_replace('~[^0-9]~', '', setting('whatsapp'))) ?>" class="float-wa" target="_blank" rel="noopener" aria-label="WhatsApp us">
  <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M20.52 3.48A11.94 11.94 0 0 0 12.04 0C5.5 0 .19 5.31.19 11.85a11.78 11.78 0 0 0 1.6 5.94L0 24l6.36-1.66a11.85 11.85 0 0 0 5.68 1.45h.01c6.54 0 11.85-5.31 11.85-11.85a11.77 11.77 0 0 0-3.38-8.46zM12.04 21.5a9.66 9.66 0 0 1-4.92-1.34l-.35-.21-3.77.99 1.01-3.67-.23-.38a9.62 9.62 0 0 1-1.48-5.04c0-5.34 4.34-9.69 9.74-9.69a9.66 9.66 0 0 1 6.88 2.85 9.65 9.65 0 0 1 2.85 6.85c0 5.34-4.34 9.64-9.73 9.64zm5.31-7.24c-.29-.15-1.72-.85-1.99-.94-.27-.1-.46-.15-.66.15-.2.29-.76.94-.93 1.13-.17.2-.34.22-.63.07-.29-.15-1.23-.45-2.34-1.45-.86-.77-1.45-1.72-1.62-2.01-.17-.29-.02-.45.13-.6.13-.13.29-.34.44-.51.15-.17.2-.29.29-.49.1-.2.05-.37-.02-.51-.07-.15-.66-1.59-.9-2.18-.24-.57-.48-.5-.66-.51-.17-.01-.37-.01-.56-.01-.2 0-.51.07-.78.37-.27.29-1.02.99-1.02 2.42 0 1.43 1.04 2.81 1.18 3 .15.2 2.05 3.13 4.97 4.39.69.3 1.23.48 1.65.61.69.22 1.32.19 1.82.11.55-.08 1.72-.7 1.96-1.38.24-.68.24-1.27.17-1.38-.07-.12-.27-.2-.56-.34z"/></svg>
</a>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"
        integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
        crossorigin="anonymous"></script>
<script src="<?= e(asset('js/main.js')) ?>" defer></script>

<?= setting('inject_footer') ?>
</body>
</html>
