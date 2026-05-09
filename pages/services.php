<?php
require_once __DIR__ . '/../includes/functions.php';

$page_title       = 'Locksmith Services Dublin';
$page_description = 'Full locksmith services across Dublin — emergency lockouts, lock changes, burglary repairs, smart locks, car keys, safes and commercial. PSA Licensed.';
$page_focus_kw    = 'locksmith services dublin';
$page_canonical   = build_canonical('/services');

$breadcrumbs = [['label' => 'Home', 'url' => '/'], ['label' => 'Services', 'url' => null]];

$categories = [
    'emergency'   => 'Emergency Services',
    'residential' => 'Residential',
    'commercial'  => 'Commercial',
    'automotive'  => 'Automotive (Car Keys)',
    'safe'        => 'Safe Services',
];

$hero = [
    'h1'      => 'Locksmith Services Across Dublin',
    'eyebrow' => 'PSA Licensed · 24/7',
    'lede'    => 'From emergency lockouts to smart-lock installs — every service backed by our 12-month guarantee.',
];

require __DIR__ . '/../includes/header.php';
require __DIR__ . '/../includes/hero.php';
?>

<section class="section">
  <div class="container container--narrow content">
    <p class="lead">Locksmiths.ie covers every common locksmith job a Dublin home, business or driver might need — from a 3am lockout to a master-key system across multiple offices. Every job is quoted at a fixed price before we start, every part fitted is to British Standard or higher, and every job carries a 12-month guarantee.</p>
    <p>The list below is grouped by category. Click any service to read details, see typical pricing and book online — or just call our local 01 landline <a href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a> for a fixed price over the phone.</p>
  </div>
</section>

<?php foreach ($categories as $key => $label):
    $items = get_services($key);
    if (!$items) continue; ?>
<section class="section section--alt" id="<?= e($key) ?>">
  <div class="container">
    <h2 class="section__title"><?= e($label) ?></h2>

    <?php
    $intros = [
      'emergency'   => 'When you are locked out, broken into or staring at a snapped key, ten minutes feels like an hour. Our emergency lines are answered around the clock and a fully-stocked van is dispatched the moment the call ends. PSA-licensed, fixed price, no after-hours surcharge.',
      'residential' => 'Lock changes, anti-snap upgrades, multipoint repair, smart-lock fitting, BS3621 deadlocks for insurance compliance — all the day-to-day work that keeps a Dublin home secure. We carry every common cylinder profile, mortice and night latch on the van.',
      'commercial'  => 'Master-key suites, access control, panic hardware, fire-rated locks and CCTV — designed, installed and serviced for Dublin offices, retail units, hotels, schools and apartment blocks. Compliant to IS EN 1125 / EN 1154 / EN 1303 standards.',
      'automotive'  => 'Lost car keys cut and coded on-site for almost every make from 1995 onwards. Faster than a tow to the dealer, half the price, and we travel to wherever your car is parked — at home, at work, at the airport long-stay or in IKEA Ballymun.',
      'safe'        => 'Non-destructive safe opening, lock repair, combination resets and new safe installation. We work on Chubb, Burton, Phoenix, Yale, Securikey and most other common Dublin safes, including older pre-2000 floor and wall safes.',
    ];
    if (!empty($intros[$key])): ?>
      <p class="section__lede"><?= e($intros[$key]) ?></p>
    <?php endif; ?>

    <div class="services-grid">
      <?php foreach ($items as $s): ?>
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
<?php endforeach; ?>

<section class="section">
  <div class="container container--narrow content">
    <h2>Why we''re Dublin''s go-to locksmith</h2>
    <p>We are a small Dublin team — not a national franchise and not a lead-auction site dressed up to look local. Every call is answered by a member of our team on a Dublin 01 landline, every quote is fixed before we leave the depot, and every job is carried out by the same technician you spoke to on the phone. We don''t do bait-and-switch pricing, we don''t do "the job turned out bigger than expected" surprises, and we don''t add weekend or after-hours surcharges. The minimum job price is <strong>€90</strong>, fixed up front, with no separate call-out fee added on top. <a href="<?= e(url('/pricing')) ?>">See the full price list →</a></p>

    <h2>British Standards and insurance compliance</h2>
    <p>Most Irish home insurance policies require locks to be certified to BS3621 (5-lever mortice deadlocks) or TS007 3-star (anti-snap euro cylinders). When we fit a lock to your door we leave the certification mark visible, name the standard on the written invoice, and provide a separate insurance-claim report on request. That is what claims handlers actually look for in the event of a future incident.</p>

    <h2>Areas we cover</h2>
    <p>Every Dublin postcode — D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16, D17, D18, D20, D22, D24 — plus Tallaght, Swords, Blanchardstown, Lucan, Clondalkin, Dundrum, Sandyford, Stillorgan, Malahide, Howth, Castleknock, Saggart, Citywest, Rathfarnham, Blackrock and the Kildare / Meath / Wicklow border towns. <a href="<?= e(url('/locations')) ?>">See full coverage →</a></p>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
