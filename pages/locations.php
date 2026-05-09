<?php
require_once __DIR__ . '/../includes/functions.php';

$page_title       = 'Locksmith Areas Covered — Dublin & Greater Dublin';
$page_description = 'PSA-licensed locksmith covering all Dublin districts (D1–D24), the Greater Dublin Area, Kildare, Meath and Wicklow.';
$page_focus_kw    = 'locksmith dublin areas';
$page_canonical   = build_canonical('/locations');

$breadcrumbs = [['label' => 'Home', 'url' => '/'], ['label' => 'Locations', 'url' => null]];

$regions = [
    'dublin_city'   => 'Dublin City Districts',
    'dublin_county' => 'Greater Dublin Area',
    'kildare'       => 'County Kildare',
    'meath'         => 'County Meath',
    'wicklow'       => 'County Wicklow',
];

$hero = [
    'h1'      => 'Locksmith Areas We Cover',
    'eyebrow' => 'Dublin & Greater Dublin',
    'lede'    => 'Choose your area to see services, landmarks and direct dispatch numbers.',
];

require __DIR__ . '/../includes/header.php';
require __DIR__ . '/../includes/hero.php';
?>

<section class="section">
  <div class="container container--narrow content">
    <p class="lead">Locksmiths.ie covers every Dublin postcode — <strong>D1 through D24</strong> — and the wider Greater Dublin Area. From the Liffey quays in Dublin City Centre out to Tallaght, Swords, Blanchardstown, Lucan, Dundrum, Sandyford, Malahide and Howth, our PSA-licensed technicians are typically the closest locksmith to your door at any hour of the day or night.</p>
    <p>Pick your area below to read about the typical jobs we do there, the local landmarks our vans pass on the way, and the average response time. Or simply call our Dublin 01 landline <a href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a> — answered by a real person, twenty-four hours a day.</p>
  </div>
</section>

<section class="section section--alt">
  <div class="container container--narrow">
    <h2 class="section__title">Dublin Coverage Map</h2>
    <?= google_map_iframe(53.349805, -6.260310, 'Dublin, Ireland', 11) ?>
    <p style="text-align:center;color:var(--c-muted);font-size:.95rem">
      Our vans cover everywhere shown on this map and beyond — call <a href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a> for a fixed-price quote.
    </p>
  </div>
</section>

<?php foreach ($regions as $key => $label):
    $items = get_locations($key);
    if (!$items) continue; ?>
<section class="section">
  <div class="container">
    <h2 class="section__title"><?= e($label) ?></h2>

    <?php $regionIntros = [
      'dublin_city'   => 'Every Dublin city postcode is covered. Average response time inside the M50 is fifteen minutes. We work daily across D1 (IFSC, North Wall), D2 (Grafton Street, Grand Canal Dock), D4 (Ballsbridge, Sandymount), D6 (Rathmines, Ranelagh), D8 (Liberties, Kilmainham) and every other inner-Dublin district.',
      'dublin_county' => 'Beyond the city centre we cover the entire Greater Dublin Area — every county-Dublin town, village and estate. Vans are stationed across north, west and south Dublin so the typical response time even out beyond the M50 is twenty minutes or less.',
      'kildare'       => 'We cover the Dublin border towns of north Kildare — Maynooth, Leixlip, Celbridge, Naas — for emergency lockouts, lock changes and burglary repair. Average arrival time is 30–40 minutes from our west-Dublin van.',
      'meath'         => 'We cover the south-Meath border — Dunshaughlin, Dunboyne, Ashbourne, Ratoath — from our north-Dublin and north-west Dublin vans. Average arrival is 30–40 minutes.',
      'wicklow'       => 'We cover the north-Wicklow border — Bray, Greystones, Kilcoole — from our south-Dublin van. Average arrival is 30–40 minutes.',
    ]; if (!empty($regionIntros[$key])): ?>
      <p class="section__lede"><?= e($regionIntros[$key]) ?></p>
    <?php endif; ?>

    <ul class="locations-grid">
      <?php foreach ($items as $l): ?>
        <li>
          <a href="<?= e(url('/' . $l['slug'])) ?>">
            <strong>Locksmith <?= e($l['name']) ?></strong>
            <?php if (!empty($l['landmark'])): ?>
              <small>near <?= e($l['landmark']) ?></small>
            <?php endif; ?>
          </a>
        </li>
      <?php endforeach; ?>
    </ul>
  </div>
</section>
<?php endforeach; ?>

<section class="section">
  <div class="container container--narrow content">
    <h2>Same fast response everywhere we work</h2>
    <p>Whichever Dublin area you''re calling from, you ring the same Dublin 01 landline — <a href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a> — and reach the same Dublin team. There are no different numbers for different areas, no premium-rate diverts and no auctioned leads. The technician you speak to on the phone is the technician who arrives at your door, in a fully-stocked van, usually within twenty minutes.</p>

    <h2>Dublin postcode quick-reference</h2>
    <p>Not sure which postcode you''re in? Here''s the rough north-to-south layout: <strong>D1</strong> (north city centre), <strong>D2</strong> (south city centre), <strong>D3</strong> (Clontarf, East Wall), <strong>D4</strong> (Ballsbridge, Sandymount), <strong>D5</strong> (Raheny, Artane), <strong>D6</strong> (Rathmines, Ranelagh), <strong>D7</strong> (Cabra, Stoneybatter), <strong>D8</strong> (Liberties, Kilmainham), <strong>D9</strong> (Drumcondra, Glasnevin), <strong>D10</strong> (Ballyfermot), <strong>D11</strong> (Finglas), <strong>D12</strong> (Crumlin), <strong>D13</strong> (Sutton, Baldoyle), <strong>D14</strong> (Dundrum, Churchtown), <strong>D15</strong> (Blanchardstown, Castleknock), <strong>D16</strong> (Knocklyon, Ballinteer), <strong>D17</strong> (Coolock, Belcamp), <strong>D18</strong> (Sandyford, Foxrock), <strong>D20</strong> (Palmerstown), <strong>D22</strong> (Clondalkin, Liffey Valley), <strong>D24</strong> (Tallaght, Firhouse). Whichever one you''re in, we cover it.</p>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
