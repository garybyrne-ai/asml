-- =====================================================================
-- Locksmiths.ie — Content migration #2
--
-- Adds long-form unique body copy to every remaining service that did
-- not get expanded in content-1. Each service gets ~250-450 words of
-- structured content (intro + H3 sections + pricing + CTA).
--
-- Apply: phpMyAdmin → eqdueglqgt → Import → upload this file.
-- Safe to re-run (UPDATE statements).
-- =====================================================================

-- ---------------------------------------------------------------------
-- Group A: General lock & key services
-- ---------------------------------------------------------------------

UPDATE `services` SET `body` = '
<p>Lock not turning, sticking or jamming? Most "broken" locks aren''t broken at all — they''re misaligned doors, worn cylinder pins or stiff multipoint gearboxes that just need a service. Our techs diagnose the actual root cause on the first visit and repair it in place wherever possible, rather than going straight to a full replacement.</p>

<h3>Common faults we see</h3>
<ul>
  <li><strong>Door drops</strong> — hinges sag over time and the door no longer aligns to the strike plate. We adjust hinges and strike position and the lock works again.</li>
  <li><strong>Stiff cylinder</strong> — pins worn down, key turning hard. A clean and re-pin restores it; a worn-out cylinder gets replaced.</li>
  <li><strong>Sticky multipoint</strong> — gearbox is on the way out. We diagnose and replace just the gearbox in most cases (rather than the full strip).</li>
  <li><strong>Yale-style night latch</strong> — cam wear means the key turns but the latch won''t pull back. Repair takes 20 minutes.</li>
  <li><strong>Mortice lock</strong> — broken spring or worn lever. Often repairable.</li>
</ul>

<h3>Diagnose-first, repair-when-possible policy</h3>
<p>We don''t replace what we can repair. A cylinder swap is €115 fitted; a re-pin to fix a sticky cylinder is €70. A multipoint gearbox swap is €175 vs €245 for a full strip. We''ll always quote you the cheapest option that solves the problem permanently.</p>

<h3>Pricing</h3>
<p>Standard lock repair: from <strong>€90</strong>. Cylinder re-pin: <strong>€70</strong>. Multipoint gearbox: <strong>€175</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> — local Dublin landline, fixed price agreed before we leave.</p>
'
WHERE `slug` IN ('lock-repair','yale-lock-repair');

UPDATE `services` SET `body` = '
<p>Rekeying changes the pins inside an existing cylinder so old keys no longer work, while keeping the lock body in place. It is significantly cheaper than fitting a new lock, and is the right answer if you''ve lost a key, ended a tenancy, bought a property or had a partner move out and want certainty that no old key can ever open the door again.</p>

<h3>When rekeying is the right call</h3>
<ul>
  <li>You''ve <strong>lost a key</strong> and want to be sure the finder can''t use it</li>
  <li>You''ve <strong>moved into a new home</strong> and don''t know who has copies</li>
  <li>A <strong>tenant has moved out</strong> and the cylinder is otherwise fine</li>
  <li>A <strong>relationship has ended</strong> and you want to invalidate old keys</li>
  <li>A <strong>former employee or cleaner</strong> had a key</li>
</ul>

<h3>How rekeying works</h3>
<p>We pull the cylinder, replace the pin stack with a new pattern, cut a fresh set of keys to match and refit it. The whole process takes 20–40 minutes per cylinder. The new keys won''t open the lock until we''ve done the swap; the old keys will never open it again.</p>

<h3>Rekey vs replace</h3>
<p>If your cylinder is already TS007 3-star anti-snap, rekeying is much cheaper. If it''s an older cylinder without modern security ratings, this is a great moment to upgrade — for €115 you get an anti-snap cylinder fitted plus three new keys, vs €70 to rekey the existing one. We''ll explain both options and let you choose.</p>

<h3>Pricing</h3>
<p>Cylinder rekey: <strong>from €70</strong> per cylinder, three keys included. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a same-day rekey across Dublin.</p>
'
WHERE `slug` IN ('lock-rekeying');

UPDATE `services` SET `body` = '
<p>The Locksmiths.ie residential service handles every common lock-and-key job a Dublin household will ever need — from a Yale stuck on the front door to a full security upgrade after a break-in attempt. PSA-licensed, fixed price agreed before we start, every job backed by a 12-month guarantee.</p>

<h3>What we do for Dublin homes</h3>
<ul>
  <li>Emergency lockouts — keys lost, broken or locked inside</li>
  <li>Lock changes after losing keys, ending a tenancy or moving in</li>
  <li>Anti-snap TS007 3-star cylinder upgrades (Brisant Ultion, Mul-T-Lock, ABS)</li>
  <li>BS3621 5-lever mortice deadlock fitting for insurance compliance</li>
  <li>UPVC and composite multipoint mechanism repair</li>
  <li>Smart-lock installation (Yale Conexis L2, Nuki, August)</li>
  <li>Window locks and patio-door restrictor bolts</li>
  <li>Burglary repair with insurance-approved reports</li>
</ul>

<h3>The Dublin housing types we work on every day</h3>
<p>Original Georgian timber doors, post-1970s council-stock UPVC, post-2000 composite doors, modern apartment cores with restricted suites — we carry parts and tooling for every common Dublin door type. Most jobs are completed on the first visit.</p>

<h3>Pricing</h3>
<p>Lockout: <strong>€95</strong>. Anti-snap cylinder fitted: <strong>€115</strong>. 5-lever BS3621 mortice deadlock fitted: <strong>€125</strong>. <a href="/pricing">See the full price list →</a></p>

<p>Call our local 01 landline <a href="tel:+35318782720">(01) 878 2720</a> — answered 24/7 by a real Dublin team.</p>
'
WHERE `slug` IN ('residential-locksmith');

UPDATE `services` SET `body` = '
<p>Mobile key cutting for home, office and most car keys — done on-site at your door, in your car park or at your office. Our vans carry blank keys for every common domestic lock brand and most common 1995-onwards car keys, so we can usually cut and code on the spot rather than asking you to come to a key-cutting kiosk.</p>

<h3>Domestic keys we cut on the van</h3>
<p>Yale, Mul-T-Lock, ABS Avocet, ERA, Era Fortress, Chubb, Banham, Ingersoll, Union, Garrison, Federal, Squire, Asec — most generic 5-lever and Yale-style cylinders. Three keys typically takes under five minutes once the blank is identified.</p>

<h3>Car keys we cut on the van</h3>
<p>Most Ford, VW Group (VW, Audi, Skoda, Seat), BMW, Toyota, Hyundai, Kia, Nissan, Renault, Peugeot, Citroën, Vauxhall and Mazda blanks from 1995 onwards. Programming the chip into the car immobiliser is a separate step — we carry the right OBD2 tooling on the van for that too.</p>

<h3>Restricted suites and master keys</h3>
<p>If your apartment uses a restricted profile (Mul-T-Lock, ISEO, Cisa) we can usually cut spare keys against your security card or letter of authority from the management company. Bring proof of ownership and the original key.</p>

<h3>Pricing</h3>
<p>Domestic key cutting: <strong>from €8</strong> per key. Restricted apartment keys: <strong>from €25</strong>. Basic car keys (no chip): <strong>€20</strong>. Chipped / transponder car keys: <strong>€150 – €180</strong> cut and programmed. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> with the make and model — we''ll quote on the phone.</p>
'
WHERE `slug` IN ('key-cutting');

UPDATE `services` SET `body` = '
<p>Lost the only key to your front door? Don''t panic — we open the door without damage, generate a brand-new key, and rekey the cylinder so the lost one (if it ever surfaces) can no longer be used. All in a single visit, usually under an hour, for a fixed €110 across Dublin.</p>

<h3>What we do on the visit</h3>
<ol>
  <li><strong>Open the door</strong> using non-destructive bypass tools — no damage to lock, frame or door in 95% of cases.</li>
  <li><strong>Cut a new key</strong> by reading the cylinder pins or impressioning a fresh blank.</li>
  <li><strong>Rekey the cylinder</strong> so the lost key is permanently invalidated.</li>
  <li><strong>Hand over three working keys</strong> and a written invoice for your insurance.</li>
</ol>

<h3>How long it takes</h3>
<p>Most lost-key calls are finished in 45–75 minutes from when we arrive. Apartment doors with restricted profiles can take a little longer — we''ll quote a fixed price on the phone before we travel.</p>

<h3>If you find the lost key later</h3>
<p>It will no longer open the door — that''s the point of the rekey. If you want to keep using the original key (e.g. you find it in a coat pocket the next day), call us back and we can rekey again to match — but most people choose the security of starting fresh.</p>

<h3>Pricing</h3>
<p>Lost key — open, generate, rekey: <strong>€110</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> any hour, day or night.</p>
'
WHERE `slug` IN ('lost-keys');

UPDATE `services` SET `body` = '
<p>Snapped a key in the lock? Don''t try to fish it out with tweezers — you''ll usually push it deeper and damage the cylinder. We extract broken keys without harming the lock body in over 95% of cases, using a specialist extractor tool that grips the broken stub and slides it cleanly out.</p>

<h3>How extraction works</h3>
<p>We probe the cylinder to identify how far the snapped piece has gone in, slide a small extractor tool past the stub, hook it from behind and pull it out. The cylinder almost never has to be replaced — the original key was just worn or fatigued.</p>

<h3>Why keys snap</h3>
<ul>
  <li>Worn cylinder pins putting more torque on the key than it can take</li>
  <li>Bent or fatigued key (the tell-tale sign is a slight curve)</li>
  <li>Door dropped on its hinges, locking under load</li>
  <li>Cheap copy keys cut from worn originals</li>
</ul>

<p>Once we extract the broken stub, we can usually cut a fresh key on the spot from the head of the snapped piece. We''ll also identify <em>why</em> it snapped — if the cylinder is worn, replacing it for €115 will save you another callout in six months.</p>

<h3>Pricing</h3>
<p>Broken key extraction: <strong>€75</strong>. Plus optional new key cut: <strong>€8</strong>. Plus optional cylinder replacement if worn: <strong>€115</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for same-day extraction across Dublin.</p>
'
WHERE `slug` IN ('broken-key-extraction');

-- ---------------------------------------------------------------------
-- Group B: Door hardware
-- ---------------------------------------------------------------------

UPDATE `services` SET `body` = '
<p>Door handle gone loose, broken or seized? We supply and fit lever-on-rose, lever-on-backplate and pull handles for residential, commercial and apartment-block doors. Most common brands kept on the van — replacement is usually 30–45 minutes from arrival.</p>

<h3>Common handle issues</h3>
<ul>
  <li><strong>Floppy handle</strong> — often the multipoint gearbox underneath, not the handle itself. We diagnose first.</li>
  <li><strong>Stiff handle</strong> — door alignment or worn cassette. We adjust and lubricate.</li>
  <li><strong>Snapped handle</strong> — replacement supplied and fitted same visit.</li>
  <li><strong>Loose handle on a UPVC door</strong> — usually fixing screws stripped; we re-fix or replace.</li>
</ul>

<h3>Brands we stock</h3>
<p>UAP, ERA, Yale, Avocet, Mila, Hoppe, Trojan, Carlisle Brass, Heritage Brass — for both UPVC and timber doors. Coloured finishes (chrome, satin, brass, black) all in stock.</p>

<h3>Pricing</h3>
<p>Door handle replacement: <strong>from €75</strong> supplied and fitted. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> with the door type and we''ll quote on the phone.</p>
'
WHERE `slug` IN ('door-handle-repair');

UPDATE `services` SET `body` = '
<p>Overhead and concealed door closers fitted to commercial, fire, hotel and apartment-block doors. Britton, Dorma, Geze, Yale and Cisa kept in stock. All installations are to IS EN 1154 fire-rated standard where required and come with a 12-month guarantee on parts and labour.</p>

<h3>Where door closers are required</h3>
<ul>
  <li>Commercial premises with fire-rated doors (FD30, FD60)</li>
  <li>Apartment blocks — communal doors and fire-escape doors</li>
  <li>Hotels and hostels — between rooms and corridors</li>
  <li>Schools — classroom and corridor doors</li>
  <li>Hospitals and care homes — controlled-flow doors</li>
</ul>

<h3>Closer types we install</h3>
<p>Overhead surface-mounted (most common, easiest to service), concealed (architrave or door-edge), floor-springs (for heavy commercial / glass doors). We''ll specify the right model based on door weight, frequency of use and fire rating.</p>

<h3>Servicing existing closers</h3>
<p>Most closers fail because the hydraulic seal has gone — door slams or won''t pull closed. We carry replacement valves and seals for every major brand and can service in place rather than replacing the whole unit.</p>

<h3>Pricing</h3>
<p>Door closer supplied and fitted: <strong>from €130</strong>. Service of existing closer: <strong>€90</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a fixed quote on commercial and apartment-block work.</p>
'
WHERE `slug` IN ('door-closer-installation');

UPDATE `services` SET `body` = '
<p>Repairs to electric strikes, magnetic locks, electronic deadlocks and access-control front-end hardware across Dublin. Most common faults are power-supply, request-to-exit buttons, releases or worn strike plates — diagnosed on-site, repaired the same visit where possible.</p>

<h3>Brands we work with</h3>
<p>Adams Rite, Effeff, Trimec, Fermax, Paxton, Salto, HID, Suprema, Securefast, ICS, Codelocks, Borg, Lockey.</p>

<h3>Common electronic-lock faults</h3>
<ul>
  <li><strong>Strike doesn''t release</strong> — usually a blown fuse on the power supply or a sticking mechanical latch</li>
  <li><strong>Mag-lock won''t hold</strong> — armature plate alignment or power output dropping</li>
  <li><strong>Access controller won''t recognise cards / fobs</strong> — reader-controller wiring or firmware</li>
  <li><strong>Door doesn''t latch after release</strong> — strike or door-frame alignment</li>
  <li><strong>Battery-backup not working</strong> — replacement battery or charger circuit</li>
</ul>

<h3>Pricing</h3>
<p>Electronic lock repair: <strong>from €140</strong> on-site labour, plus parts at trade cost (we don''t mark up parts). <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for emergency commercial electronic-lock callouts 24/7.</p>
'
WHERE `slug` IN ('electronic-lock-repair');

-- ---------------------------------------------------------------------
-- Group C: Commercial
-- ---------------------------------------------------------------------

UPDATE `services` SET `body` = '
<p>End-to-end commercial locksmith services for Dublin offices, retail units, hotels, restaurants, schools, apartment blocks and warehouses. From a single rekey to a multi-site master-key suite with hundreds of doors, we design, install and service to insurance and fire-regulation standards.</p>

<h3>What we do for commercial Dublin</h3>
<ul>
  <li><strong>Master-key suites</strong> — one key for the manager, area keys for supervisors, individual keys for staff. Designed using Mul-T-Lock, Abloy, ISEO, Cisa restricted platforms.</li>
  <li><strong>Access control systems</strong> — Paxton Net2, Salto KS, HID and Suprema. Cards, fobs, PIN, biometric.</li>
  <li><strong>Panic hardware</strong> — push-pads and crash bars on fire-exit doors to IS EN 1125.</li>
  <li><strong>Fire-rated locks</strong> — IS EN 1634 mortices and panic furniture for FD30 / FD60 doors.</li>
  <li><strong>Door closers</strong> — IS EN 1154 fire-rated overhead and concealed closers.</li>
  <li><strong>Mag-locks &amp; electric strikes</strong> — for access-controlled main entrances.</li>
  <li><strong>End-of-day lockouts</strong> — staff locked out after hours, urgent re-keys after key losses.</li>
  <li><strong>Insurance compliance audits</strong> — we''ll survey your premises and report on what your insurer requires.</li>
</ul>

<h3>Standards we work to</h3>
<p>BS3621, TS007 3-star, IS EN 1125 (panic), IS EN 1154 (closers), IS EN 1303 (cylinders), IS EN 1634 (fire). All paperwork supplied with installation invoice.</p>

<h3>Pricing</h3>
<p>Commercial locksmith from <strong>€200</strong>; master-key suites from <strong>€350</strong>; access-control systems from <strong>€600</strong>. All quoted as a fixed price after a free site survey. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> to book a survey or for emergency commercial response 24/7.</p>
'
WHERE `slug` IN ('commercial-locksmith','commercial-locks');

UPDATE `services` SET `body` = '
<p>Master-key systems mean one key opens many doors at appropriate access levels — designed for offices, schools, hotels, apartment blocks, warehouses and any environment where individual keys per door would be unmanageable. We design, install and service master-key suites across Dublin using Mul-T-Lock, Abloy, ISEO and Cisa restricted-profile platforms.</p>

<h3>How a master-key suite works</h3>
<ul>
  <li><strong>Master key</strong> opens every cylinder in the suite (manager / facilities)</li>
  <li><strong>Sub-master keys</strong> open all cylinders in a section (e.g. floor manager opens their floor only)</li>
  <li><strong>Individual keys</strong> open only one cylinder (staff / tenants)</li>
  <li><strong>Restricted profile</strong> means keys cannot be copied at a high-street cutter — only by us, with a security card.</li>
</ul>

<h3>Designing the suite</h3>
<p>We start with a free site survey: count the doors, list who needs access where, agree the hierarchy. We then design the keying chart, source the cylinders, and install in a planned sweep — usually one day for an office of 20–40 doors. Every keyed cylinder comes with a unique security number and is logged against your account.</p>

<h3>Adding to or changing the suite later</h3>
<p>Once the suite is built, additions and replacements take days, not weeks — we hold the keying chart and can dispatch new keyed cylinders cut to match. Lost master keys can trigger a full rekey of the relevant level only — not the whole building.</p>

<h3>Pricing</h3>
<p>Master-key suite design + installation: <strong>from €350</strong> for a small office, scaling with the number of cylinders. Site survey is free. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> to book a survey.</p>
'
WHERE `slug` IN ('master-key-systems');

UPDATE `services` SET `body` = '
<p>Card, fob, PIN and biometric access-control systems designed, installed and serviced for Dublin offices, apartment blocks, gyms, schools, warehouses and retail. We work with the four major platforms — Paxton Net2, Salto KS, HID and Suprema — so we can recommend the right one for your size and budget rather than pushing one brand.</p>

<h3>Which platform fits which use case</h3>
<ul>
  <li><strong>Paxton Net2</strong> — most common Irish SME platform. Card / fob, on-premise software, scales from one door to hundreds.</li>
  <li><strong>Salto KS</strong> — wireless, cloud-managed, ideal for landlords and Airbnbs that need to grant temporary access remotely.</li>
  <li><strong>HID</strong> — the enterprise standard. Best for multi-site, high-security deployments.</li>
  <li><strong>Suprema</strong> — biometric (fingerprint, face) for sensitive areas like data centres and labs.</li>
</ul>

<h3>What''s involved</h3>
<p>We survey, recommend, install the controllers and readers, configure the software, train your staff, and service the system over its life. Integration with door closers, mag-locks, electric strikes and panic hardware is included.</p>

<h3>Pricing</h3>
<p>Single-door access control system: <strong>from €600</strong> supplied, installed and configured. Multi-door systems quoted after free site survey. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> to book an access-control survey.</p>
'
WHERE `slug` IN ('access-control-systems');

UPDATE `services` SET `body` = '
<p>Standalone keypad locks for staff entrances, back doors, side gates, communal areas and small businesses where a full access-control system would be overkill. Codelocks, Borg and Lockey kept in stock — supplied, fitted and programmed in a single visit.</p>

<h3>Why standalone keypads</h3>
<ul>
  <li>No keys to lose, no cards to manage</li>
  <li>Codes are easily changed — when a staff member leaves, change the code in 30 seconds</li>
  <li>No cabling required — battery-powered models available</li>
  <li>Cheap to deploy and maintain compared to networked access control</li>
</ul>

<h3>Models we recommend</h3>
<p>Codelocks CL400 (light commercial), CL410 (heavy duty), CL5000 (electronic with audit trail). Borg BL series (mechanical only — no batteries). Lockey 2900 (medium duty mechanical).</p>

<h3>Pricing</h3>
<p>Keypad lock supplied and fitted: <strong>from €200</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a fixed quote.</p>
'
WHERE `slug` IN ('access-keypad-systems');

UPDATE `services` SET `body` = '
<p>Push-pad and crash-bar panic hardware fitted to fire-exit doors. Compulsory under Irish building regulations on most fire-exit routes in commercial and public-access premises. We supply and fit IS EN 1125-rated single-, two- and three-point panic hardware.</p>

<h3>Where panic hardware is required</h3>
<ul>
  <li>Fire-exit doors in offices, retail and hospitality</li>
  <li>Schools, hospitals, public buildings</li>
  <li>Apartment-block fire escapes</li>
  <li>Cinemas, theatres, churches and assembly buildings</li>
</ul>

<h3>What we install</h3>
<p>Briton 376, Yale Doorman, Adams Rite 8000-series, Securefast SBL — all IS EN 1125 certified. Single-point bolt for narrow doors, two-point for standard fire doors, three-point for double doors. All come with matching outside access devices (knob or lever) where staff need to re-enter.</p>

<h3>Pricing</h3>
<p>Panic bar / push-pad supplied and fitted: <strong>from €220</strong>. Multi-point on double doors quoted on survey. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a free panic-hardware compliance survey.</p>
'
WHERE `slug` IN ('panic-bar');

UPDATE `services` SET `body` = '
<p>Steel and reinforced security doors fitted to homes and businesses across Dublin. Multi-point locking, anti-drill cylinders, reinforced frames, anti-jemmy plates — sourced from European manufacturers and fitted to your existing opening (no structural work in most cases).</p>

<h3>When a security door makes sense</h3>
<ul>
  <li>Repeat break-in target (some Dublin areas are hit more than others)</li>
  <li>Holiday home or property left empty for long periods</li>
  <li>Commercial premises with overnight stock</li>
  <li>Apartment blocks where the front door is the only barrier</li>
  <li>Insurance requirement for high-value contents</li>
</ul>

<h3>What you get</h3>
<p>European-manufactured steel door (Erreti, Dierre, Securemme), multi-point hookbolt lock, anti-drill cylinder to TS007 3-star, reinforced frame, anti-jemmy plate, peephole, weather seals. Available in finishes that look like a normal timber door from the outside.</p>

<h3>Pricing</h3>
<p>Security door supplied and fitted: <strong>from €1,200</strong>. Free survey and fixed quote in advance. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> to book a survey.</p>
'
WHERE `slug` IN ('security-door-installation');

UPDATE `services` SET `body` = '
<p>Fire-rated locks, panic furniture and mortices fitted to FD30 and FD60 fire doors. All hardware certified to IS EN 1634 — the only standard your fire-safety inspector will accept on a commercial or public-access premises.</p>

<h3>What we install</h3>
<ul>
  <li>IS EN 1634 mortice deadlocks and sashlocks</li>
  <li>Panic-escape locks (lever inside, key outside)</li>
  <li>Fire-rated panic bars and push-pads</li>
  <li>Heat-activated intumescent strips and smoke seals</li>
  <li>IS EN 1154 fire-rated door closers</li>
</ul>

<h3>Why it matters</h3>
<p>A fire door is only fire-rated if every component on it — lock, hinge, closer, seal — is also rated. A standard household mortice lock fitted to an FD30 door makes the door <em>not</em> compliant, even if everything else is correct. Insurers and fire inspectors check.</p>

<h3>Pricing</h3>
<p>Fire-rated lock supplied and fitted: <strong>from €170</strong>. Full fire-door overhaul (lock + closer + seals) quoted after survey. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a fire-door compliance survey.</p>
'
WHERE `slug` IN ('fire-door-lock-installation');

-- ---------------------------------------------------------------------
-- Group D: CCTV / alarm / smart home
-- ---------------------------------------------------------------------

UPDATE `services` SET `body` = '
<p>IP and analogue CCTV systems supplied, installed and serviced for Dublin homes and businesses. HikVision and Dahua — the two market-leading platforms, with full remote viewing on iOS and Android, motion detection, night-vision and cloud or NVR storage.</p>

<h3>What we install</h3>
<ul>
  <li>4-, 8- and 16-channel NVR / DVR systems</li>
  <li>2MP, 4MP and 8MP (4K) cameras</li>
  <li>Bullet, dome, turret and PTZ camera options</li>
  <li>Indoor and outdoor IP67-rated cameras</li>
  <li>Wired (Cat6 PoE) and wireless options</li>
  <li>Cloud or local NVR storage</li>
  <li>Remote viewing via HikConnect / DMSS / SmartPSS apps</li>
</ul>

<h3>Why HikVision / Dahua</h3>
<p>They are the two largest CCTV manufacturers in the world. Replacement parts, firmware updates and integrator support are available from any installer. Cheaper imports look the same on the box but quality, reliability and warranty are not comparable.</p>

<h3>Pricing</h3>
<p>4-camera IP CCTV system supplied, installed and configured: <strong>from €450</strong>. Larger systems quoted after free site survey. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> to book a free CCTV survey across Dublin.</p>
'
WHERE `slug` IN ('cctv-installation');

UPDATE `services` SET `body` = '
<p>Wired and wireless intruder alarms supplied, installed and maintained across Dublin. We work with the three main Irish-market platforms — HKC, Texecom and Honeywell — and install to EN 50131 grade 2 / 3 standards as required for insurance compliance.</p>

<h3>What we install</h3>
<ul>
  <li>Wired and wireless intruder alarm panels</li>
  <li>PIR (motion) and dual-tech sensors</li>
  <li>Door and window contacts</li>
  <li>External sirens with strobe</li>
  <li>Smart-phone notifications via the manufacturer''s app</li>
  <li>Optional 24/7 ARC monitoring (with separate monthly contract)</li>
  <li>Pet-friendly sensor options for households with cats / dogs</li>
</ul>

<h3>Insurance compliance</h3>
<p>Most Irish home insurance policies that include "alarm discount" require an EN 50131 grade-2 system installed by a registered installer. We provide installation paperwork that names the standard for your insurer.</p>

<h3>Pricing</h3>
<p>Standard wireless alarm supplied and fitted: <strong>from €550</strong>. Multi-zone wired systems quoted after survey. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for an alarm survey.</p>
'
WHERE `slug` IN ('alarm-installation');

UPDATE `services` SET `body` = '
<p>Audio and video intercom systems for apartment blocks, businesses and private homes across Dublin. Comelit, Aiphone and Fermax — supplied, installed and integrated with smart-phones via 4G or wifi gateway so you can answer the door from anywhere.</p>

<h3>System types</h3>
<ul>
  <li><strong>Audio only</strong> — a basic call-and-release system, ideal for apartment blocks already with door-release wiring.</li>
  <li><strong>Video</strong> — colour or B/W camera at the entry panel, monitor at each apartment.</li>
  <li><strong>Smart-phone integration</strong> — call routes to a phone app instead of a physical handset; ideal for landlords managing remote properties.</li>
  <li><strong>Multi-tenant blocks</strong> — single entry panel calling 2 to 200 individual handsets.</li>
</ul>

<h3>Common upgrades</h3>
<p>Older audio-only systems can usually be upgraded to video without re-wiring (if the existing cable run supports it). We''ll diagnose on a free survey.</p>

<h3>Pricing</h3>
<p>Single-tenant video intercom: <strong>from €380</strong>. Multi-tenant systems quoted after survey. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> to book an intercom survey.</p>
'
WHERE `slug` IN ('intercom-systems');

UPDATE `services` SET `body` = '
<p>Smart home security combines smart locks, cameras, sensors and alarms into a single system you can monitor and control from your phone. We design, install and integrate Aqara, eufy, Ring and Yale ecosystems with Apple HomeKit and Google Home so everything talks to everything else.</p>

<h3>A typical Dublin smart home setup</h3>
<ul>
  <li>Smart lock on the front door (Yale Conexis L2 or Nuki 4.0)</li>
  <li>Video doorbell (Ring or eufy)</li>
  <li>2–4 outdoor cameras (eufy or Ring)</li>
  <li>Door / window sensors on key entry points</li>
  <li>Motion sensors in hallways</li>
  <li>HomeKit / Google Home hub for centralised control and automation</li>
  <li>Optional smart smoke / CO detectors</li>
</ul>

<h3>Why integrate</h3>
<p>Standalone smart products are convenient. An <em>integrated</em> system can do useful things — auto-lock the front door when the last person leaves, turn on outdoor lights when motion is detected after dark, send a single notification when something unusual happens. That requires careful setup, which is what we do.</p>

<h3>Pricing</h3>
<p>Smart-home security starter package: <strong>from €350</strong>. Bigger systems quoted after consultation. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a smart-home consultation.</p>
'
WHERE `slug` IN ('smart-home-security');

-- ---------------------------------------------------------------------
-- Group E: Specialty doors and openings
-- ---------------------------------------------------------------------

UPDATE `services` SET `body` = '
<p>Garage door locks supplied, repaired and replaced. Up-and-over, sectional and roller-shutter garage doors all have lock or T-handle hardware that wears out — we carry replacements for the most common Henderson, Hörmann, Garador and Cardale models.</p>

<h3>Common garage-door issues</h3>
<ul>
  <li><strong>T-handle won''t turn</strong> — internal cassette worn or rusted</li>
  <li><strong>Cable from handle to side latches snapped</strong></li>
  <li><strong>Side latches no longer engage</strong> — alignment issue</li>
  <li><strong>Roller-shutter floor lock damaged</strong> after attempted break-in</li>
  <li><strong>Old garage door with no lock at all</strong> — we can retrofit</li>
</ul>

<h3>Anti-snap T-handle upgrades</h3>
<p>Older T-handles can be opened with a basic flat-head screwdriver — a 5-minute job for a thief. Modern anti-snap T-handles are €60 fitted and remove this risk.</p>

<h3>Pricing</h3>
<p>Garage-door lock repair / replacement: <strong>from €110</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a fixed quote.</p>
'
WHERE `slug` IN ('garage-door-locks');

UPDATE `services` SET `body` = '
<p>Window locks supplied, fitted and repaired across Dublin — for UPVC, aluminium and timber windows. Insurance-compliant key-locking versions available, plus restrictor stays for child safety.</p>

<h3>What we fit</h3>
<ul>
  <li><strong>Espagnolette</strong> — full-height locking strip on UPVC windows. Most common Dublin window-lock.</li>
  <li><strong>Shootbolt</strong> — bolts at top and bottom of the window. Used on tall sash windows.</li>
  <li><strong>Cockspur</strong> — older UPVC with single-point latch. Often replaced rather than repaired.</li>
  <li><strong>Sash window locks</strong> — for older Georgian / Victorian timber windows.</li>
  <li><strong>Restrictor stays</strong> — limit how far the window opens, child-safe.</li>
</ul>

<h3>Insurance and child safety</h3>
<p>Most Irish home insurance policies require ground-floor windows to have key-operated locks. We''ll fit them at €15 each and provide an invoice naming the standard. Restrictor stays cost the same and reduce child-fall risk on upper floors.</p>

<h3>Pricing</h3>
<p>Window lock supplied and fitted: <strong>€15</strong> per lock. Bulk discount on whole-house jobs. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a quote.</p>
'
WHERE `slug` IN ('window-lock-repair');

UPDATE `services` SET `body` = '
<p>Sliding patio door locks repaired, replaced and upgraded. Hookbolt and shootbolt patio mechanisms on Yale, Mila, Maco, Saracen and Avocet doors — replacement parts kept on the van for most common Dublin homes.</p>

<h3>Common patio door issues</h3>
<ul>
  <li><strong>Won''t lock at all</strong> — gearbox failed</li>
  <li><strong>Locks but won''t unlock</strong> — internal hookbolt jammed</li>
  <li><strong>Door drags on the bottom track</strong> — rollers worn</li>
  <li><strong>Anti-lift restrictor not engaging</strong> — alignment</li>
  <li><strong>Key turns but the door slides open</strong> — hookbolt not engaging the strike</li>
</ul>

<h3>Anti-lift bolts</h3>
<p>Older patio doors can be lifted out of the track from the outside, even when locked. A €105 anti-lift restrictor bolt eliminates this — it''s the single biggest security upgrade you can make to a sliding patio.</p>

<h3>Pricing</h3>
<p>Patio door lock repair / replacement: <strong>from €130</strong>. Anti-lift restrictor fitted: <strong>€105</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a fixed quote.</p>
'
WHERE `slug` IN ('patio-door-lock-repair','sliding-door-lock-repair');

UPDATE `services` SET `body` = '
<p>French door multipoint mechanisms repaired and replaced. Active and inactive leaf gearboxes, shootbolts and flush bolts — the four most common French-door problems we see across Dublin.</p>

<h3>Common French-door issues</h3>
<ul>
  <li><strong>Active leaf won''t lock</strong> — gearbox or hookbolts failed</li>
  <li><strong>Inactive leaf won''t hold closed</strong> — shootbolts or flush bolts worn</li>
  <li><strong>Doors don''t meet flush</strong> — hinge alignment, common after 5+ years</li>
  <li><strong>Top or bottom shootbolt won''t engage</strong> — rod or housing</li>
  <li><strong>Anti-lift restrictor required</strong> — rare but increasing</li>
</ul>

<h3>Repair vs replace</h3>
<p>French door problems are usually fixable rather than full-replacement jobs. Even when the multipoint mechanism has failed, we replace just the mechanism, not the doors. Cost is typically a fraction of a full door replacement.</p>

<h3>Pricing</h3>
<p>French door lock repair: <strong>from €140</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a fixed quote.</p>
'
WHERE `slug` IN ('french-door-lock-repair');

UPDATE `services` SET `body` = '
<p>Pedestrian and driveway gate locks fitted across Dublin. Steel, wrought-iron, timber and composite gates — Locinox, AMF, Adler and bespoke padlocks for everything from a 1-metre side gate to a 3-metre electric driveway gate.</p>

<h3>What we fit</h3>
<ul>
  <li><strong>Locinox surface-mounted gate locks</strong> — the standard for steel gates</li>
  <li><strong>AMF mortice gate locks</strong> — for solid timber gates</li>
  <li><strong>Sold-Secure padlocks</strong> — Squire, Abus, Yale</li>
  <li><strong>Electric-strike gate releases</strong> — for intercom-controlled access</li>
  <li><strong>Anti-snap cylinders for gate locks</strong> — same TS007 3-star ratings as front doors</li>
</ul>

<h3>Pricing</h3>
<p>Gate lock supplied and fitted: <strong>from €140</strong>. Sold-Secure padlock supplied: <strong>from €60</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a fixed quote.</p>
'
WHERE `slug` IN ('gate-lock-installation');

UPDATE `services` SET `body` = '
<p>Roller-shutter locks repaired across Dublin retail and warehouse premises. Floor sockets, T-handles and slam locks — the three most common shutter-lock failures we see — kept in stock and replaced on first visit.</p>

<h3>Common shutter-lock issues</h3>
<ul>
  <li><strong>Floor socket bent or rusted</strong> — replacement is the only fix</li>
  <li><strong>T-handle won''t engage</strong> — internal cassette worn</li>
  <li><strong>Slam lock won''t latch</strong> — alignment or worn striker</li>
  <li><strong>Key won''t turn the cylinder</strong> — usually a worn cylinder, replaceable</li>
</ul>

<h3>Out-of-hours response</h3>
<p>If a shutter won''t lock at end of business and you need to leave it overnight, we provide an emergency response — most retail premises in Dublin can be made secure within an hour.</p>

<h3>Pricing</h3>
<p>Shutter lock repair: <strong>from €150</strong>. Out-of-hours response same price as standard. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for emergency commercial shutter response 24/7.</p>
'
WHERE `slug` IN ('shutter-lock-repair');

UPDATE `services` SET `body` = '
<p>Mailbox lock replacement for apartment blocks, post boxes and communal mail enclosures across Dublin. Cam locks fitted with two keys per box — block-wide replacements available where management companies want a uniform key suite.</p>

<h3>What we replace</h3>
<ul>
  <li>Apartment-block letterbox cam locks</li>
  <li>Post-box cylinder locks</li>
  <li>Outdoor mail enclosure locks</li>
  <li>Communal parcel-locker locks</li>
</ul>

<h3>Block-wide replacements</h3>
<p>Most Dublin apartment blocks have 20–80 letterbox locks of the same type. We can re-key all of them to a master suite (one master key for the management company, individual keys for tenants) at a discount over individual replacements.</p>

<h3>Pricing</h3>
<p>Mailbox lock supplied and fitted: <strong>€60</strong>. Block-wide rekey discount available. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a fixed quote.</p>
'
WHERE `slug` IN ('mailbox-lock');

-- ---------------------------------------------------------------------
-- Group F: Safe services
-- ---------------------------------------------------------------------

UPDATE `services` SET `body` = '
<p>Locked out of your safe? We open Chubb, Burton, Phoenix, Yale, Securikey, John Tann, Ratner and most other common Dublin safes — non-destructively in over 90% of cases. We also reset combinations, replace electronic locks and supply new safes.</p>

<h3>How non-destructive opening works</h3>
<p>For mechanical-dial safes, we manipulate the wheel pack to find the combination — no drilling, no damage, the safe continues to function as before. For electronic safes, we usually have access to manufacturer override codes or can reset via the override key. Drilling is a last-resort option only when manipulation fails, and we drill in a position that allows the lock to be replaced without compromising the safe body.</p>

<h3>What you''ll need</h3>
<ul>
  <li>Proof of ownership (purchase receipt, insurance schedule, photo from a previous opening)</li>
  <li>The safe make and model (we''ll quote the right price up front)</li>
  <li>Garda incident number if the safe is part of a stolen-property report</li>
</ul>

<h3>Pricing</h3>
<p>Non-destructive safe opening: <strong>from €180</strong>. Combination reset: <strong>€90</strong>. Drilled-and-repaired opening: <strong>from €280</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> with the make and model — we''ll quote on the phone.</p>
'
WHERE `slug` IN ('safe-opening');

UPDATE `services` SET `body` = '
<p>Domestic and commercial safes supplied, installed and bolted into place across Dublin. Burton, Phoenix, Chubb, Securikey, Yale and Master Lock — sold-secure rated for cash, jewellery, documents and firearms.</p>

<h3>Choosing the right safe</h3>
<ul>
  <li><strong>Document safes</strong> — fire-rated, lower theft rating, ideal for paperwork and passports</li>
  <li><strong>Cash / jewellery safes</strong> — higher theft rating, sold-secure certified</li>
  <li><strong>Firearm safes</strong> — Garda-approved cabinets to required standard</li>
  <li><strong>Floor safes</strong> — bolted into concrete, almost impossible to remove</li>
  <li><strong>Wall safes</strong> — concealed behind a picture or fitted cabinet</li>
</ul>

<h3>Installation</h3>
<p>We bolt every safe into a solid floor or wall using high-tensile concrete bolts. A free-standing safe is much easier for a thief to remove than to crack — bolting it in is the single biggest security upgrade.</p>

<h3>Pricing</h3>
<p>Safe supplied, installed and bolted in: <strong>from €280</strong> depending on size and model. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> to discuss the right safe for you.</p>
'
WHERE `slug` IN ('safe-installation');

UPDATE `services` SET `body` = '
<p>Mechanical and electronic safe locks repaired across Dublin. Sargent &amp; Greenleaf, La Gard, Mauer, Tecnosicurezza, Securam, Stuv — we hold parts and tooling for every major safe-lock manufacturer.</p>

<h3>Common safe-lock failures</h3>
<ul>
  <li>Electronic keypad battery dead — rarely needs lock replacement, just a battery and reset</li>
  <li>Mechanical dial slipping or sticking — wheel pack worn, replaceable</li>
  <li>Override key seized — cylinder replacement</li>
  <li>Time-lock not opening on schedule — internal motor or controller</li>
  <li>Forgotten combination — manipulation reset, not a replacement</li>
</ul>

<h3>Pricing</h3>
<p>Safe lock repair: <strong>from €220</strong> on-site. Replacement parts at trade cost. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> with the safe make and lock model — we''ll quote on the phone.</p>
'
WHERE `slug` IN ('safe-lock-repair');

-- ---------------------------------------------------------------------
-- Group G: Auto specialty
-- ---------------------------------------------------------------------

UPDATE `services` SET `body` = '
<p>Stuck or seized car ignition cylinders repaired or replaced on-site. Common Ford, VW, BMW, Renault and Peugeot ignition lock failures fixed in under 90 minutes, usually for half what the dealer charges.</p>

<h3>Common ignition issues</h3>
<ul>
  <li><strong>Key won''t turn</strong> — wear on the ignition wafers, or the steering lock is engaged. Often fixed by jiggling the wheel; if not, the cylinder needs work.</li>
  <li><strong>Key turns part-way then stops</strong> — anti-theft pin engaged, common on older Fords</li>
  <li><strong>Ignition won''t release the key</strong> — internal cassette worn</li>
  <li><strong>Key snapped in the ignition</strong> — extracted same visit, no dealer trip required</li>
  <li><strong>Ignition turns but car won''t start</strong> — usually transponder / immobiliser, not the ignition itself</li>
</ul>

<h3>What we do on the call</h3>
<p>Diagnose first — many "broken ignition" calls are actually steering-lock or transponder issues that need a different fix. If it is the ignition, we either repair in place (worn wafers) or replace the cylinder and re-code your existing key to it.</p>

<h3>Pricing</h3>
<p>Ignition repair / replacement: <strong>from €200</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> with your car''s make / model / year.</p>
'
WHERE `slug` IN ('ignition-repair');

UPDATE `services` SET `body` = '
<p>Sprinter, Transit, Crafter, Master, Movano, Trafic, Vivaro, Caddy, Berlingo and Partner vans serviced across Dublin. Slam locks, hooks, deadlocks and replacement keys for tradesmen and delivery drivers — usually finished in under 90 minutes on-site.</p>

<h3>Why van security matters more</h3>
<p>Tradesman vans carry tools and stock that can total tens of thousands of euro. Standard factory van locks are easily defeated — slam-lock retrofits, hooks and deadlocks add layers that buy time and put off opportunist theft.</p>

<h3>What we fit</h3>
<ul>
  <li><strong>Slam locks</strong> — engage automatically when you close the door</li>
  <li><strong>Hooks &amp; deadlocks</strong> — additional locking points beyond the factory lock</li>
  <li><strong>Replacement keys and fobs</strong> — cut and programmed on-site</li>
  <li><strong>Internal partition locks</strong> — to separate cab from cargo</li>
  <li><strong>Anti-peel plates</strong> — reinforce the door edge against jemmy attacks</li>
</ul>

<h3>Pricing</h3>
<p>Van slam-lock supplied and fitted: <strong>from €180</strong>. Replacement van key cut and programmed: <strong>from €180</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> with the van make / model / year.</p>
'
WHERE `slug` IN ('van-locksmith');

UPDATE `services` SET `body` = '
<p>Replacement motorbike keys for Honda, Yamaha, Kawasaki, Suzuki, BMW, Ducati and most other common makes. Cut and coded for both the ignition and the seat / fuel-cap lock — usually finished in under an hour on-site.</p>

<h3>What we cover</h3>
<ul>
  <li>Standard mechanical bike keys</li>
  <li>Chipped transponder bike keys (HISS, Immobiliser)</li>
  <li>Honda HISS keys</li>
  <li>BMW EWS / CAS keys</li>
  <li>Seat / fuel-cap key replacement (often a separate cylinder)</li>
</ul>

<h3>What we need from you</h3>
<p>Proof of ownership (V5 / log-book), the bike''s VIN, and access to the bike (we travel to it). For chipped keys we may need a known good key or the dealer pin code — we''ll check on the phone before we travel.</p>

<h3>Pricing</h3>
<p>Motorbike key replacement: <strong>from €140</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> with the bike make / model / year.</p>
'
WHERE `slug` IN ('motorbike-key');

-- ---------------------------------------------------------------------
-- Group H: Vertical specialists
-- ---------------------------------------------------------------------

UPDATE `services` SET `body` = '
<p>Apartment-block locksmith specialist work across Dublin — communal entry doors, individual apartment cylinders, restricted master suites, mailbox locks, intercom systems and bike-store locks. We work with most major Dublin management companies and hold the cylinder profiles each block requires.</p>

<h3>Where management-company approval matters</h3>
<p>Most Dublin apartment blocks specify a particular cylinder profile (Mul-T-Lock, ISEO, Cisa restricted) so that all keys belong to a single security suite. Replacing a tenant''s cylinder with the wrong profile breaks the suite. We hold the right profiles for the most common Dublin blocks and provide the management company with the security card on every replacement.</p>

<h3>Common apartment-block jobs</h3>
<ul>
  <li>Apartment lockout and tenant lock change</li>
  <li>Replacement keys for residents (with management company authority)</li>
  <li>Communal door cylinder replacement</li>
  <li>Mailbox lock replacement (single or block-wide)</li>
  <li>Intercom system service or upgrade</li>
  <li>Bike-store and bin-store lock replacement</li>
  <li>Insurance-compliant lock changes after tenant changeover</li>
</ul>

<h3>Pricing</h3>
<p>Apartment lockout: <strong>€95</strong>. Apartment cylinder replacement (restricted profile): <strong>from €110</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> 24/7.</p>
'
WHERE `slug` IN ('apartment-locksmith');

UPDATE `services` SET `body` = '
<p>Hotel locksmith services across Dublin — Salto, VingCard / Assa Abloy, Onity, Kaba and Yale Doorman card systems serviced and repaired. Card encoding, lock servicing, master suites and emergency override.</p>

<h3>What we do for Dublin hotels</h3>
<ul>
  <li>Card encoder repair and replacement</li>
  <li>Door-lock servicing and battery replacement</li>
  <li>Master / emergency-override card programming</li>
  <li>Audit-trail recovery from lock memory</li>
  <li>Out-of-hours guest lockouts (emergency override)</li>
  <li>Lost-card replacement</li>
  <li>Front-of-house mechanical lock repair (back-of-house, kitchen, store rooms)</li>
  <li>Insurance and fire-compliance audits</li>
</ul>

<h3>Why specialist matters</h3>
<p>Hotel card systems are not the same as office access control. They have specific failure modes (low battery, encoding-data corruption, magnetic-stripe wear) that require dedicated tooling. We carry the right tools for all four major systems and work with most Dublin city-centre hotels.</p>

<h3>Pricing</h3>
<p>Hotel locksmith service: <strong>from €220</strong> on-site. Larger projects quoted after survey. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for hotel emergency response 24/7.</p>
'
WHERE `slug` IN ('hotel-locksmith');

UPDATE `services` SET `body` = '
<p>Retail and shop-front locksmith services across Dublin. Roller-shutter mechanisms, door locks, till and back-room locks, end-of-day lockouts and post-incident security upgrades.</p>

<h3>What we do for Dublin retailers</h3>
<ul>
  <li><strong>Shop-front shutter locks</strong> — floor sockets, T-handles, slam locks</li>
  <li><strong>End-of-day lock changes</strong> — when keys are lost or staff leave</li>
  <li><strong>Till locks</strong> — replaced or rekeyed</li>
  <li><strong>Back-room and stock-room locks</strong> — restricted-key suites</li>
  <li><strong>Post-incident security upgrades</strong> — anti-snap cylinders, reinforced strikers, anti-jemmy plates</li>
  <li><strong>Out-of-hours emergency response</strong> — for shutters that won''t lock at closing time</li>
</ul>

<h3>Out-of-hours response</h3>
<p>If a shop-front shutter won''t lock at closing time, you can''t leave the premises unsecured. We''ll be on-site within 30 minutes to most Dublin city-centre and suburban retail addresses.</p>

<h3>Pricing</h3>
<p>Retail locksmith service: <strong>from €130</strong>. Out-of-hours emergency response: same price as standard. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for emergency retail response 24/7.</p>
'
WHERE `slug` IN ('retail-locksmith');

UPDATE `services` SET `body` = '
<p>Warehouse and industrial locksmith services across Dublin. Roller-shutter, sliding and personnel-door locks for loading bays, stock rooms and fenced compounds. Sold-Secure rated padlocks, anti-snap cylinders and reinforced cylinders for high-value stock.</p>

<h3>Common warehouse jobs</h3>
<ul>
  <li>Loading-bay shutter lock repair / replacement</li>
  <li>Sliding warehouse-door tracks and locks</li>
  <li>Personnel-door anti-snap cylinder upgrades</li>
  <li>Sold-Secure padlocks for compound gates</li>
  <li>Master-key suites for warehouses with multiple internal doors</li>
  <li>Insurance-compliance audits for warehouse stock cover</li>
</ul>

<h3>Insurance compliance</h3>
<p>Most warehouse insurance policies specify Sold-Secure padlocks and reinforced cylinders. We supply the right products and provide invoices naming the standard for your insurer.</p>

<h3>Pricing</h3>
<p>Warehouse locksmith service: <strong>from €160</strong>. Multi-door projects quoted on survey. <a href="/pricing">See full pricing →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for emergency warehouse response 24/7.</p>
'
WHERE `slug` IN ('warehouse-lock');

-- ---------------------------------------------------------------------
-- Group I: Service-area combo pages (Clondalkin / Lucan / Dundrum service variants)
-- ---------------------------------------------------------------------

UPDATE `services` SET `body` = '
<p>Locksmith services across <strong>Clondalkin</strong>, Neilstown, Quarryvale, Liffey Valley, Bawnogue and Knockmitten — 24 hours a day, with a typical response time of 12–18 minutes from our west-Dublin van. PSA-licensed, fixed price agreed before we leave the depot.</p>

<h3>Common Clondalkin jobs</h3>
<ul>
  <li>House and apartment lockouts across the village and surrounding estates</li>
  <li>UPVC and composite multipoint mechanism repair</li>
  <li>Anti-snap cylinder upgrades after attempted break-ins</li>
  <li>BS3621 5-lever mortice deadlocks for older village houses</li>
  <li>Liffey Valley shopping centre car-park lockouts</li>
  <li>Tenant lock changes for landlords</li>
  <li>Burglary repair with insurance-approved reports</li>
</ul>

<h3>Pricing</h3>
<p>Standard lockout: <strong>€95</strong>. Anti-snap cylinder fitted: <strong>€115</strong>. Multipoint repair: <strong>€175 – €245</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call our local Dublin 01 landline <a href="tel:+35318782720">(01) 878 2720</a> — answered 24/7 by a real Dublin team. Not a premium-rate divert, not an overseas call centre.</p>
'
WHERE `slug` IN ('locksmith-clondalkin-service');

UPDATE `services` SET `body` = '
<p>Locksmith services across <strong>Lucan</strong>, Adamstown, Esker, Ballyowen, Rowlagh, Griffeen Valley and the Lucan side of the N4 — 24 hours a day. Typical response time is 18–22 minutes from our west-Dublin van.</p>

<h3>Common Lucan jobs</h3>
<ul>
  <li>House lockouts in Lucan Village, Ballyowen and around the Liffey</li>
  <li>UPVC multipoint gearbox replacement on the modern Adamstown / Griffeen Valley estates</li>
  <li>Anti-snap cylinder upgrades on family homes</li>
  <li>Smart-lock installation for short-term lets near the village and along the N4</li>
  <li>Liffey Valley shopping centre car-park lockouts</li>
  <li>Burglary repair with insurance-approved reports</li>
</ul>

<h3>Pricing</h3>
<p>Standard lockout: <strong>€95</strong>. Anti-snap cylinder fitted: <strong>€115</strong>. Multipoint repair: <strong>€175 – €245</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call our local Dublin 01 landline <a href="tel:+35318782720">(01) 878 2720</a> — answered by a real Dublin team day and night.</p>
'
WHERE `slug` IN ('locksmith-lucan-service');

UPDATE `services` SET `body` = '
<p>Locksmith services across <strong>Dundrum</strong>, Goatstown, Churchtown, Windy Arbour and the Dundrum Town Centre apartment complex — 24 hours a day. Typical response time is 12–18 minutes from our south-Dublin van.</p>

<h3>Common Dundrum jobs</h3>
<ul>
  <li>Dundrum Town Centre apartment lockouts and core re-keys (Rockbrook, The Maple, Belarmine)</li>
  <li>House lockouts across Goatstown, Churchtown and Windy Arbour</li>
  <li>UPVC multipoint mechanism repair on family homes</li>
  <li>Anti-snap cylinder upgrades after attempted break-ins</li>
  <li>Master-key suites for Dundrum-area schools and surrounding offices</li>
  <li>Smart-lock installation for short-term lets</li>
</ul>

<h3>Pricing</h3>
<p>Standard lockout: <strong>€95</strong>. Anti-snap cylinder fitted: <strong>€115</strong>. Multipoint repair: <strong>€175 – €245</strong>. <a href="/pricing">See full pricing →</a></p>

<p>Call our local Dublin 01 landline <a href="tel:+35318782720">(01) 878 2720</a> — answered by a real Dublin team 24 hours a day.</p>
'
WHERE `slug` IN ('locksmith-dundrum-service');
