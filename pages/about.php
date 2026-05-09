<?php
require_once __DIR__ . '/../includes/functions.php';

$page_title       = 'About — PSA Licensed Dublin Locksmith';
$page_description = 'About Locksmiths.ie — a PSA-licensed Dublin locksmith specialising in emergency lockouts, lock changes and smart-lock installation.';
$page_focus_kw    = 'about locksmiths.ie';
$page_canonical   = build_canonical('/about');
$breadcrumbs = [['label' => 'Home', 'url' => '/'], ['label' => 'About', 'url' => null]];

$hero = [
    'h1'      => 'About Locksmiths.ie',
    'eyebrow' => 'Our story',
    'lede'    => 'Dublin-born, PSA-licensed and trusted by thousands. We do one thing — locks — and we do it fast.',
];

require __DIR__ . '/../includes/header.php';
require __DIR__ . '/../includes/hero.php';
?>

<section class="section">
  <div class="container container--narrow content">
    <p class="lead">Locksmiths.ie is a PSA-licensed Dublin locksmith specialising in emergency lockouts, lock changes, burglary repairs, smart-lock installation, master-key suites and on-site car-key cutting. We have been securing Dublin homes and businesses for over fifteen years from a single Dublin base, and we answer a single Dublin landline — <a href="tel:<?= e(setting('phone_e164')) ?>"><?= e(setting('phone')) ?></a> — twenty-four hours a day, every day of the year.</p>

    <h2>A real local Dublin business</h2>
    <p>Search for a locksmith on Google and you will find dozens of websites that <em>look</em> local — Dublin map pins, Irish-sounding company names, fake addresses on Camden Street or O''Connell Street. Most of them are lead-generation sites that auction your call to the highest bidder, often a sub-contractor an hour away who has never met the team. That is why prices come in three times higher than the original phone quote, and why your insurance company sometimes refuses the invoice.</p>
    <p>We are different. <strong>(01) 878 2720</strong> rings a phone in Dublin and is answered by a member of our team — never a call centre, never a divert, never a third-party. Calls cost the same as any other 01 number — there are no premium-rate surcharges, no overseas redirects, and no auctioned leads. The same technician you spoke to on the phone is the one who arrives at your door.</p>

    <h2>Our promises</h2>
    <ul>
      <li><strong>20-minute response</strong> across Dublin city &amp; county. Our average on-site arrival time inside the M50 is fifteen minutes.</li>
      <li><strong>Fixed-price quotes</strong> — agreed up front before any work starts. The minimum job price is €90 and there is no separate call-out fee added on top. See our <a href="<?= e(url('/pricing')) ?>">price list</a> for every common job.</li>
      <li><strong>12-month written guarantee</strong> on all parts and labour, backed by a real Dublin business with a real address.</li>
      <li><strong>Insurance-approved reports</strong> for every burglary repair — the kind your insurance handler actually accepts.</li>
      <li><strong>British Standard everything</strong> — BS3621 5-lever mortices, TS007 3-star anti-snap cylinders, IS EN 1125 panic hardware. We carry every common one on the van.</li>
    </ul>

    <h2>Who we are</h2>
    <p>Our technicians are PSA-licensed (license number <strong><?= e(setting('psa_license')) ?></strong>) and trained in non-destructive entry, anti-snap cylinder upgrades, smart-lock fitting, master-key system design and on-site automotive key programming. The Private Security Authority licence is the legal requirement for working as a locksmith in Ireland — anyone operating without one is breaking the law, and any lock fitted by an unlicensed operator may not be honoured by your home insurance policy.</p>

    <h2>Where we work</h2>
    <p>We cover every Dublin postcode — D1 through D24 — and the wider Greater Dublin Area: Tallaght, Swords, Blanchardstown, Lucan, Clondalkin, Dundrum, Sandyford, Stillorgan, Malahide, Howth, Castleknock, Saggart and Citywest. Beyond the M50 we also cover the Kildare, Meath and Wicklow border towns. <a href="<?= e(url('/locations')) ?>">See the full coverage list →</a></p>

    <h2>Our pricing in plain English</h2>
    <p>Every quote is fixed before any work begins. The minimum job price is <strong>€90</strong>, which covers a non-destructive entry to a locked door — that is the call-out and the work combined, not the call-out on its own. We do not charge a separate call-out fee bolted on top. We do not charge a night-time, weekend or bank-holiday surcharge. The price you hear on the phone is the price you pay when the job is done. <a href="<?= e(url('/pricing')) ?>">Full price list →</a></p>

    <h2>Why we are open 24/7</h2>
    <p>About forty per cent of our calls happen between 10pm and 6am. Lockouts don''t respect office hours, and a broken-into door at 2am isn''t something that can wait. We have technicians on call every minute of every day, including Christmas Day and St. Patrick''s Day. The phone is answered by a real person within three rings — usually one.</p>
  </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
