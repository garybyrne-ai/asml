-- =====================================================================
-- Locksmiths.ie — Content migration #1
--
-- Adds substantial unique body copy to every location page, expands
-- the body for the highest-traffic services, refreshes the testimonials
-- table with longer real-feeling reviews tied to Dublin areas, and
-- inserts the global "free phone" / 24-hour talking points.
--
-- Safe to re-run at any time (UPDATE / REPLACE statements).
-- Apply via:  phpMyAdmin → eqdueglqgt → Import → upload this file.
-- =====================================================================

-- ---------- A. Settings: positioning copy used across pages ----------
INSERT INTO `settings` (`setting_key`,`setting_value`) VALUES
('hero_subtitle',       'Local Dublin team on call 24 hours a day. PSA Licensed. 20-minute response. Fixed prices from €90.'),
('value_prop_short',    'Local 01 landline. Real Dublin team. Not a premium-rate call centre.'),
('about_hours',         'We answer the phone every minute of every day — including Sundays, Christmas Day and bank holidays.'),
('about_pricing_line',  'Every quote is fixed before any work begins. Minimum job price €90. We do not charge a separate call-out fee on top — the €90 minimum is the call-out.'),
('about_local_line',    'We are a local Dublin business answering a Dublin landline (01) 878 2720. Calls cost the same as any other local number — there are no premium-rate surcharges, no overseas redirects and no auctioned leads.')
ON DUPLICATE KEY UPDATE `setting_value` = VALUES(`setting_value`);

-- =====================================================================
-- B. Location bodies — unique 400-600 word descriptions per area
-- =====================================================================

UPDATE `locations` SET `body` = '
<p>Locksmiths.ie has been securing homes, apartments and businesses in <strong>Dublin City Centre</strong> for over fifteen years. Whether you are a resident of one of the apartment blocks around the IFSC, a shop owner on Henry Street or Grafton Street, or a guest staying in a hotel near Trinity College, we are usually the closest PSA-licensed locksmith to your door at any hour of the day or night.</p>
<h3>Where we cover in the city centre</h3>
<p>Our city-centre patch runs from the Liffey quays south to St. Stephen''s Green and the Iveagh Gardens, and north up O''Connell Street as far as Parnell Square and the Rotunda. We work daily in Temple Bar, around Christ Church and Dublin Castle, along Dame Street, in the laneways behind Grafton Street, and in the residential blocks on Pearse Street, Townsend Street and Sir John Rogerson''s Quay.</p>
<h3>Common jobs in the city centre</h3>
<ul>
  <li>Apartment lockouts in IFSC, Spencer Dock and Custom House Square</li>
  <li>UPVC door mechanism repair on the older Georgian-converted apartments around Mountjoy Square and Henrietta Street</li>
  <li>Anti-snap cylinder upgrades for retail units after a break-in attempt</li>
  <li>Master-key suites for hotels, hostels and serviced offices</li>
  <li>Smart lock fitting (Yale Conexis L2, Nuki) for short-term lets</li>
</ul>
<h3>How fast can we be at your door?</h3>
<p>From the moment you ring our local landline <a href="tel:+35318782720">(01) 878 2720</a>, our city-centre van is typically on-site within fifteen to twenty minutes. We hold parts and key blanks for every common Dublin door type, so over 95% of city-centre callouts are finished on the first visit — no second appointment, no second invoice.</p>
<h3>Why call a real local?</h3>
<p>Searching "locksmith Dublin" online returns dozens of websites that look local but route your call to a UK call centre and auction the lead to whoever bids highest. We are different: <strong>(01) 878 2720</strong> rings a phone in Dublin and is answered by a member of our team — never a sub-contractor and never a premium-rate redirect. That matters at 3am when you need someone who actually knows the difference between Dame Street and Dame Lane.</p>
'
WHERE `slug` = 'locksmith-dublin-city-centre';

UPDATE `locations` SET `body` = '
<p>Our <strong>Dublin 1</strong> locksmith service covers the historic north inner city — from O''Connell Street and the GPO across to Connolly Station, Mountjoy Square, the Five Lamps, and out to North Wall, the Point Village and the East Wall. We are usually the nearest PSA-licensed locksmith to anyone living in the apartment developments around the IFSC, Spencer Dock or Custom House Square, and we are on the road 24 hours a day for emergency callouts.</p>
<h3>What we do in D1</h3>
<p>Modern Dublin 1 is a mix of original Georgian sash-window houses, 1970s council blocks and the new IFSC-area apartment towers. Each comes with its own lock challenges. We change cylinders on the heavy timber doors of Henrietta Street and North Great George''s Street, repair multipoint mechanisms on the UPVC doors around Sheriff Street and East Wall, and re-key apartment cores in Spencer Dock when tenants change.</p>
<h3>Same-day jobs we handle in Dublin 1</h3>
<ul>
  <li>Lockouts at any hour — keys lost on a night out, broken in the door, locked inside</li>
  <li>Burglary repair after attempts on apartment cores around Sean McDermott Street and Summerhill</li>
  <li>Insurance-compliant 5-lever BS3621 deadlocks fitted to timber doors</li>
  <li>Anti-snap TS007 3-star cylinders fitted (Brisant Ultion, ABS, Mul-T-Lock)</li>
  <li>Smart lock installation for Airbnb / short-term lets</li>
</ul>
<h3>Local knowledge matters</h3>
<p>Our Dublin 1 technician lives in the area and drives a fully-stocked van. They know which estates have controlled-entry intercom systems, which apartment management companies require a specific cylinder profile, and which Garda stations to call for incident-report numbers when an insurance claim is being prepared. None of that experience comes from a call-centre script.</p>
<p>Call <a href="tel:+35318782720">(01) 878 2720</a> any hour, any day — including bank holidays — and we will be at your D1 address inside 20 minutes.</p>
'
WHERE `slug` = 'locksmith-dublin-1';

UPDATE `locations` SET `body` = '
<p><strong>Dublin 2</strong> is the heart of the city — Grafton Street, St. Stephen''s Green, Trinity College, Merrion Square and the law courts at the Four Courts. It is also home to thousands of professionals living in modern apartments along the Grand Canal and around Charlemont Street. Locksmiths.ie has been the go-to PSA-licensed locksmith for D2 residents and businesses for years.</p>
<h3>Why a Dublin 2 locksmith call is different</h3>
<p>D2 properties are split between historic Georgian buildings, mid-century commercial offices on Baggot Street and Lower Hatch Street, and modern glass-and-steel apartment blocks at Grand Canal Dock. Each demands different skills. Our techs carry brass-faced mortice locks for sash-door Georgians, multipoint mechanisms (GU, Fuhr, Roto) for the apartment block fronts, and electronic strikes for office back-of-house doors.</p>
<h3>Common Dublin 2 jobs</h3>
<ul>
  <li>Office lockouts in the Earlsfort Terrace / Baggot Street corridor</li>
  <li>Apartment lockouts on Charlotte Quay, Forbes Quay and Hanover Quay (Grand Canal Dock)</li>
  <li>Lock changes after losing keys at concerts, the National Concert Hall or Iveagh Gardens events</li>
  <li>High-security cylinder upgrades for solicitors'' offices around Merrion Square</li>
  <li>Hotel master-key servicing for Stephen''s Green / Merrion Square hotels</li>
</ul>
<h3>Always answered, always local</h3>
<p>Our Dublin 2 line is a real Dublin 01 landline — <a href="tel:+35318782720">(01) 878 2720</a>. Not a premium-rate divert, not an overseas call centre. You will hear a Dublin accent answer at 3am on Christmas Day if you ring then, because somebody is always on call. The minimum job price across D2 is €90 — there is no separate call-out fee bolted on top.</p>
'
WHERE `slug` = 'locksmith-dublin-2';

UPDATE `locations` SET `body` = '
<p><strong>Dublin 4</strong> covers Ballsbridge, Sandymount, Donnybrook, Ringsend and Irishtown. It is one of Dublin''s most architecturally varied postcodes — large red-brick Victorian houses on Wellington Place sit a short walk from the modern apartment blocks at Lansdowne Place and the embassy quarter around Northumberland Road. We work in every corner of D4 daily.</p>
<h3>Where the calls usually come from</h3>
<p>Aviva Stadium event nights are some of our busiest in D4 — fans returning to a parked car or holiday home discover the keys went missing somewhere in the crowd, and we cut and code a replacement on-site. We also do a lot of routine lock changes on the rental properties around Lansdowne Road and Sandymount Avenue between tenancies, and high-security upgrades on the Victorian villas around Ailesbury Road and Shrewsbury Road.</p>
<h3>Common D4 jobs</h3>
<ul>
  <li>Lockouts after Aviva Stadium events, RDS shows and Sandymount Strand walks</li>
  <li>Sash-window lock fitting on the Victorian houses around Pembroke Road and Raglan Road</li>
  <li>BS3621 5-lever deadlock installation for insurance compliance</li>
  <li>Anti-snap upgrades on the modern apartment blocks at Lansdowne Place and Beggars Bush Barracks</li>
  <li>Embassy / consulate lock servicing on Northumberland Road</li>
</ul>
<h3>How quickly we get there</h3>
<p>From our central depot we are typically in Ballsbridge in 12–15 minutes. The 24/7 Dublin 4 line is the same number we use everywhere: <a href="tel:+35318782720">(01) 878 2720</a> — answered locally, no surcharge, no auction. Minimum job price is €90 fixed up front.</p>
'
WHERE `slug` = 'locksmith-dublin-4';

UPDATE `locations` SET `body` = '
<p><strong>Dublin 6</strong> is one of the most popular residential postcodes in the city — Rathmines, Ranelagh, Rathgar, Terenure and Harold''s Cross. It has a high density of red-brick Victorian terraces converted into multiple apartments, plus large family homes in Rathgar and Templeogue Road. We attend D6 several times a day for everything from a stuck Yale night latch on Rathmines Road to full burglary repair after an attempted break-in.</p>
<h3>Tenancies, conversions and old timber doors</h3>
<p>Many D6 houses are pre-1900 and were converted into 3 or 4 separate flats. The internal doors are often original timber with old 5-lever mortice locks that have been re-keyed dozens of times. We can re-key, repair or upgrade them to modern BS3621 standard in a single visit, with three keys included as standard.</p>
<h3>Common D6 jobs</h3>
<ul>
  <li>Tenant lock changes between rental periods (we provide a written invoice for letting agents)</li>
  <li>UPVC mechanism replacement on Rathmines, Rathgar and Terenure family homes</li>
  <li>Anti-snap cylinder upgrades after a snap-attempt — a common D6 break-in method</li>
  <li>Insurance-grade lock changes after a break-in (with written report)</li>
  <li>Smart lock installation for Airbnb operators around Ranelagh village</li>
</ul>
<h3>Local 01 landline, real Dublin team</h3>
<p>Our Rathmines / Rathgar / Ranelagh van is on the road 24 hours a day. Call <a href="tel:+35318782720">(01) 878 2720</a> — a local Dublin landline answered by a member of our team, never a premium-rate divert. Minimum job price across D6 is €90 fixed in advance.</p>
'
WHERE `slug` = 'locksmith-dublin-6';

UPDATE `locations` SET `body` = '
<p><strong>Dublin 15</strong> is the largest postcode in the country — Blanchardstown, Castleknock, Clonsilla, Mulhuddart, Tyrrelstown, Ongar and Ashtown. The mix of large estates, apartment developments and houses backing onto Phoenix Park means there is no such thing as a typical D15 callout. What is consistent is the number of UPVC and composite doors with multipoint mechanisms — D15 is overwhelmingly post-1990s housing stock.</p>
<h3>Multipoint mechanism specialists</h3>
<p>Most D15 houses have a UPVC or composite front door with a multipoint mechanism (GU, Fuhr, Roto, Winkhaus, Yale, ERA). When the handle goes floppy or stiff, the gearbox inside the strip has failed. We carry replacement gearboxes and full strips for every common make on the van — the repair is usually under €175 and finished in one visit.</p>
<h3>Common D15 jobs</h3>
<ul>
  <li>Multipoint gearbox replacement (Tyrrelstown, Ongar, Hansfield, Mulhuddart)</li>
  <li>House lockouts on the large estates around Blanchardstown Centre</li>
  <li>Anti-snap upgrades on Castleknock and Clonsilla family homes</li>
  <li>Apartment lockouts on the developments around the IBM campus and Connolly Hospital</li>
  <li>Office and retail unit servicing in Blanchardstown Corporate Park</li>
</ul>
<h3>Response time across D15</h3>
<p>We have a van based in north-west Dublin so the typical Blanchardstown / Castleknock arrival time is 15–20 minutes from when you ring <a href="tel:+35318782720">(01) 878 2720</a>. Same response across Tyrrelstown, Mulhuddart, Hansfield and Ongar. Always a local Dublin landline — never premium-rate, never auctioned to a third-party sub-contractor.</p>
'
WHERE `slug` = 'locksmith-dublin-15';

UPDATE `locations` SET `body` = '
<p><strong>Dublin 18</strong> covers Sandyford, Stepaside, Cabinteely, Foxrock, Leopardstown, Kilternan and the Dundrum side of the M50. It is a busy mix of 1980s-built family homes, modern apartments around Sandyford Industrial Estate, and the Beacon South Quarter / Beacon Hospital developments. Our D18 van services this whole area 24 hours a day.</p>
<h3>Sandyford apartments and Beacon offices</h3>
<p>Sandyford has hundreds of apartments above and around the Industrial Estate — Rockbrook, Beacon South Quarter, The Mews, Park Place. We service all of the major management companies and carry the cylinder profiles each one specifies (Mul-T-Lock, ISEO, Cisa restricted suites). Office buildings around Beacon Hospital, the Q-Park and the Glaslyn campus regularly call us for end-of-day lockouts and mag-lock / electric strike repair.</p>
<h3>Common D18 jobs</h3>
<ul>
  <li>Sandyford apartment lockouts and core re-keys (Rockbrook, Beacon South Quarter)</li>
  <li>Multipoint gearbox replacement on Foxrock and Cabinteely family homes</li>
  <li>Anti-snap cylinder upgrades on Leopardstown and Stepaside houses</li>
  <li>Beacon Hospital catchment office lockouts and mag-lock servicing</li>
  <li>Master-key suite installations for the Sandyford business park offices</li>
</ul>
<h3>Local 24/7 — phone is always answered</h3>
<p><a href="tel:+35318782720">(01) 878 2720</a> is a real Dublin landline. It rings at our office and is answered by a member of our team day and night, including Christmas Day. Minimum job price across D18 is €90 fixed up front, with a 12-month written guarantee on every cylinder, mechanism or smart lock we fit.</p>
'
WHERE `slug` = 'locksmith-dublin-18';

UPDATE `locations` SET `body` = '
<p>Our <strong>Tallaght</strong> locksmith team covers the entire D24 area — from The Square Tallaght and Tallaght University Hospital out to Old Bawn, Killinarden, Jobstown, Firhouse, Tymon, Kingswood and into Saggart, Citywest and Rathcoole. We have a van permanently based in the south-west of the city so we are usually the fastest PSA-licensed locksmith to any Tallaght-area address at any hour of the day or night.</p>
<h3>What we do most often in Tallaght</h3>
<p>Tallaght has a very high concentration of UPVC and composite front doors. The most common callout is a multipoint mechanism that has gone stiff or developed a "floppy handle" — usually a failed gearbox inside the locking strip. We carry replacement gearboxes for every major brand on the van (GU, Fuhr, Roto, Winkhaus, ERA, Yale, Avocet) and the repair is usually finished in 60–90 minutes for a fixed price between €175 and €245.</p>
<h3>Common Tallaght jobs</h3>
<ul>
  <li>House lockouts in Old Bawn, Killinarden, Jobstown and Firhouse</li>
  <li>UPVC multipoint mechanism replacement on the estates around The Square</li>
  <li>Anti-snap cylinder upgrades after attempted break-ins (BS3621 / TS007 3-star)</li>
  <li>Office and retail lockouts on the IDA Tallaght and Cookstown business parks</li>
  <li>Apartment lockouts on the modern developments along the Tallaght end of the Luas Red Line</li>
  <li>Tallaght Hospital staff lockouts at shift-change times</li>
</ul>
<h3>Response time</h3>
<p>From The Square our average on-site response across Tallaght and surrounding areas is twelve minutes. Even at 4am on a Sunday morning we are answering the phone and on the road within minutes. Call our local Dublin 01 landline <a href="tel:+35318782720">(01) 878 2720</a> — there is no premium rate, no overseas redirect and no third-party lead auction.</p>
'
WHERE `slug` = 'locksmith-tallaght';

UPDATE `locations` SET `body` = '
<p>Locksmiths.ie covers <strong>Swords</strong>, north County Dublin and Dublin Airport 24 hours a day. Whether you are a resident of one of the estates around Swords Manor or River Valley, a hotel guest at the Pavilions, or a traveller who lost their car keys somewhere between Terminal 1 and the long-term car park, we have a van based in north Dublin specifically to cover this catchment.</p>
<h3>Dublin Airport — lost car keys</h3>
<p>Lost car keys at Dublin Airport is one of our most frequent north-Dublin jobs. Most modern cars need both a cut blade and a programmed transponder, which the dealer would charge €350+ for and require a tow. Our auto-locksmith van does it on-site at the long-term car park for a fraction of the price — typically under an hour from arrival.</p>
<h3>Common Swords jobs</h3>
<ul>
  <li>Pavilions Shopping Centre lockouts (cars and houses near the centre)</li>
  <li>Dublin Airport long-term car-park key replacement</li>
  <li>House lockouts on Swords Manor, River Valley, Forrest Hill, Holywell</li>
  <li>UPVC multipoint repair across the modern estates north of the M1</li>
  <li>Hotel master-key servicing at Swords / Airport hotels</li>
</ul>
<h3>How long to get there</h3>
<p>Average Swords response is 15 minutes from when you ring <a href="tel:+35318782720">(01) 878 2720</a>. Same response across Malahide, Portmarnock, Donabate, Lusk and Rush. We are a real local Dublin business with a real Dublin 01 landline — not a premium-rate redirect or a UK call-centre.</p>
'
WHERE `slug` = 'locksmith-swords';

UPDATE `locations` SET `body` = '
<p><strong>Saggart</strong>, <strong>Citywest</strong> and <strong>Rathcoole</strong> are some of the fastest-growing residential areas in west Dublin. We service the entire west-Dublin / north-Kildare border 24 hours a day, with a permanent base inside the M50 and a typical Saggart response time of 18–22 minutes.</p>
<h3>Citywest Hotel and the surrounding estates</h3>
<p>Citywest Hotel and Conference Centre is one of the busiest event venues in the country. We pick up regular calls there from delegates who locked the keys in their car, hotel guests who left their key card in the room, or local residents heading home from an event. We also work daily on the modern estates around Citywest Shopping Centre, Steeplechase Hill and the Saggart Luas terminus.</p>
<h3>Common Saggart / Citywest / Rathcoole jobs</h3>
<ul>
  <li>House lockouts on Steeplechase, Saggart Lakes and Citywest Heights</li>
  <li>Multipoint gearbox replacement on the modern UPVC and composite front doors</li>
  <li>Citywest Hotel guest car lockouts</li>
  <li>Office lockouts on the Citywest business park</li>
  <li>Anti-snap upgrades on Rathcoole village family homes</li>
</ul>
<h3>Always-on local landline</h3>
<p>Same number, same Dublin team — <a href="tel:+35318782720">(01) 878 2720</a>. Local 01 landline, no surcharge, no overseas redirect. Minimum job price €90 fixed up front, 12-month written guarantee on every job.</p>
'
WHERE `slug` = 'locksmith-saggart';

UPDATE `locations` SET `body` = '
<p>We cover all of <strong>Blanchardstown</strong> and the wider D15 catchment 24 hours a day. From the Blanchardstown Centre and Connolly Hospital out to Tyrrelstown, Hansfield, Ongar, Mulhuddart, Castleknock, Clonsilla and Ashtown, we are usually the fastest PSA-licensed locksmith on the road.</p>
<h3>Modern UPVC and composite specialists</h3>
<p>Blanchardstown is overwhelmingly post-1995 housing — UPVC or composite front doors with multipoint mechanisms. The most common callout is a "floppy handle" or stiff door, almost always a failed gearbox inside the locking strip. We carry replacement gearboxes for GU, Fuhr, Roto, Winkhaus, ERA, Yale, Avocet and Maco on the van, so the repair is finished in one visit for a fixed price between €175 and €245.</p>
<h3>Common Blanchardstown jobs</h3>
<ul>
  <li>UPVC / composite mechanism repair across Tyrrelstown, Mulhuddart and Ongar</li>
  <li>House lockouts on the estates around Blanchardstown Centre</li>
  <li>Anti-snap cylinder upgrades after attempted break-ins (BS3621 / TS007 3-star)</li>
  <li>Office and retail lockouts at Blanchardstown Corporate Park and IBM campus</li>
  <li>Connolly Hospital staff and visitor lockouts at shift-change times</li>
</ul>
<p>Our north-west Dublin van means a typical Blanchardstown response is 15–20 minutes after you ring our local 01 landline <a href="tel:+35318782720">(01) 878 2720</a>. We are a real Dublin business — not a UK call centre, not a lead-auction site.</p>
'
WHERE `slug` = 'locksmith-blanchardstown';

UPDATE `locations` SET `body` = '
<p>Our <strong>Clondalkin</strong> locksmith team covers all of Clondalkin Village, Neilstown, Quarryvale, Liffey Valley, Bawnogue and the Clondalkin side of the N7. We work this catchment 24 hours a day — including bank holidays — from a van permanently based inside the M50.</p>
<h3>The Clondalkin housing mix</h3>
<p>Clondalkin has a wide age range of housing stock, from the original village cottages near the Round Tower to the 1970s and 80s estates of Neilstown and Quarryvale, plus modern developments along the Liffey Valley side. Older homes typically have timber doors with mortice locks, while the newer estates have UPVC multipoints. We carry parts and tooling for all of them.</p>
<h3>Common Clondalkin jobs</h3>
<ul>
  <li>House lockouts in Neilstown, Quarryvale, Bawnogue and Knockmitten</li>
  <li>UPVC multipoint repair on the modern estates south of the N4</li>
  <li>5-lever BS3621 mortice locks fitted on the older village houses</li>
  <li>Anti-snap cylinder upgrades after attempted break-ins</li>
  <li>Liffey Valley shopping centre car lockouts</li>
</ul>
<p>Average Clondalkin response time from our base is 15 minutes. Same Dublin 01 landline answered the same way every time: <a href="tel:+35318782720">(01) 878 2720</a>.</p>
'
WHERE `slug` = 'locksmith-clondalkin';

UPDATE `locations` SET `body` = '
<p>Locksmiths.ie covers <strong>Lucan</strong>, Adamstown, Esker, Ballyowen, Rowlagh, Griffeen Valley and the Lucan side of the N4 around the clock. Whether you live in the original Lucan Village near the Liffey or in one of the newer estates around the Adamstown rail station, we are typically the closest PSA-licensed locksmith on call at any hour.</p>
<h3>Modern Lucan and Adamstown</h3>
<p>The post-2000 expansion of Lucan and the Adamstown SDZ has created thousands of UPVC and composite-door homes — almost all with multipoint mechanisms. We do gearbox replacements and cylinder upgrades on these doors several times a week. We also fit Yale Conexis, Nuki and August smart locks for the high concentration of Airbnb operators around the village.</p>
<h3>Common Lucan jobs</h3>
<ul>
  <li>UPVC multipoint gearbox replacement on Adamstown, Griffeen Valley and Esker estates</li>
  <li>House lockouts in Lucan Village and Ballyowen</li>
  <li>Anti-snap cylinder upgrades on family homes</li>
  <li>Smart-lock installation for short-term lets near the village and along the N4</li>
  <li>Liffey Valley car lockouts (technically D22 but covered from our Lucan van)</li>
</ul>
<p>Our Lucan response time is 18–22 minutes from when you ring our local Dublin 01 landline <a href="tel:+35318782720">(01) 878 2720</a> — answered by a real local team day or night.</p>
'
WHERE `slug` = 'locksmith-lucan';

UPDATE `locations` SET `body` = '
<p><strong>Dundrum</strong> is one of the busiest south-Dublin retail and residential hubs. We service Dundrum Town Centre, Goatstown, Churchtown, Windy Arbour, Balally and the Dundrum side of the M50 24 hours a day, with a typical response time of 12–18 minutes.</p>
<h3>Apartment-block specialists</h3>
<p>The development around Dundrum Town Centre includes hundreds of apartments — Rockbrook, The Maple, Dundrum Town Centre Apartments, Belarmine, Sandyford Hall. We are familiar with every management company''s preferred cylinder profile and carry restricted suites for the most common ones.</p>
<h3>Common Dundrum jobs</h3>
<ul>
  <li>Dundrum Town Centre apartment lockouts and core re-keys</li>
  <li>Multipoint mechanism repair on Goatstown and Churchtown family homes</li>
  <li>Anti-snap cylinder upgrades</li>
  <li>Master-key suites for Dundrum-area schools and the surrounding office blocks</li>
  <li>Sandyford Industrial Estate evening / weekend office lockouts</li>
</ul>
<p>Our south-Dublin van covers Dundrum, Sandyford, Stillorgan and Dún Laoghaire from one location, so we are usually 12 minutes from your door. Always the same number — local Dublin landline <a href="tel:+35318782720">(01) 878 2720</a> — answered by a member of our team, never a divert.</p>
'
WHERE `slug` = 'locksmith-dundrum';

UPDATE `locations` SET `body` = '
<p>Our <strong>Rathfarnham</strong> locksmith team covers all of Rathfarnham, Ballyboden, Edmondstown, Knocklyon, Templeogue and Whitechurch. The mix of older red-brick houses near Rathfarnham Castle and modern developments around Knocklyon and Marlay Park means there is no such thing as a typical D14 / D16 callout.</p>
<h3>Common Rathfarnham jobs</h3>
<ul>
  <li>House lockouts in Knocklyon, Templeogue, Ballyboden and Edmondstown</li>
  <li>BS3621 5-lever mortice deadlock fitting on older timber doors</li>
  <li>UPVC multipoint repair on the post-1990 estates</li>
  <li>Anti-snap cylinder upgrades after attempted break-ins</li>
  <li>Marlay Park event-night car lockouts</li>
</ul>
<p>Response time across Rathfarnham is typically 15–20 minutes from our south-Dublin van. Local 01 landline answered by a real person, day or night: <a href="tel:+35318782720">(01) 878 2720</a>. Minimum job price €90 fixed up front, with a written 12-month guarantee on every cylinder, mechanism or lock we fit.</p>
'
WHERE `slug` = 'locksmith-rathfarnham';

UPDATE `locations` SET `body` = '
<p><strong>Sandyford</strong> sits at the centre of one of Dublin''s biggest office and apartment clusters — the Industrial Estate, Beacon South Quarter, the Beacon Hospital catchment and the modern apartment developments at Rockbrook, The Mews and Park Place. We work this area daily for office lockouts, apartment-core re-keys, mag-lock servicing and master-key suite installations.</p>
<h3>Apartment management companies we work with</h3>
<p>We are familiar with the cylinder profiles each of the Sandyford apartment blocks specify (Mul-T-Lock, ISEO, Cisa restricted suites) and can supply spare keys, replacements or full re-keys directly to residents. Most management companies will accept our written quote because we hold the right product approvals.</p>
<h3>Common Sandyford jobs</h3>
<ul>
  <li>Sandyford apartment lockouts and core re-keys (Rockbrook, Beacon South Quarter, Park Place)</li>
  <li>Office lockouts at the Q-Park, Glaslyn and the Sandyford business park offices</li>
  <li>Mag-lock and electric-strike repair</li>
  <li>Master-key suite design and installation</li>
  <li>Beacon Hospital catchment lockouts and after-hours retail callouts</li>
</ul>
<p>Sandyford response time is 10–15 minutes from our south-Dublin van. Always the same Dublin 01 landline: <a href="tel:+35318782720">(01) 878 2720</a>.</p>
'
WHERE `slug` = 'locksmith-sandyford';

UPDATE `locations` SET `body` = '
<p>Locksmiths.ie covers <strong>Malahide</strong>, Portmarnock, Kinsealy and the entire coastal north-Dublin strip 24 hours a day. With Dublin Airport only minutes away, we also pick up regular auto-locksmith jobs for travellers who lost car keys at the airport, the Malahide DART station or in the Malahide Marina car park.</p>
<h3>Common Malahide jobs</h3>
<ul>
  <li>House lockouts on the coastal estates around Malahide Castle and the Marina</li>
  <li>Modern UPVC and composite door mechanism repair</li>
  <li>Sliding patio door lock repair (very common on coastal Malahide homes)</li>
  <li>Window lock fitting on the older Malahide village houses</li>
  <li>Auto-locksmith — car key replacement at Malahide DART, Malahide Castle car park, Marina</li>
</ul>
<p>Average Malahide response time is 15–20 minutes. Local Dublin landline answered around the clock: <a href="tel:+35318782720">(01) 878 2720</a> — no premium rate, no surcharge, no auctioned leads.</p>
'
WHERE `slug` = 'locksmith-malahide';

UPDATE `locations` SET `body` = '
<p>Our <strong>Blackrock</strong> locksmith team covers Blackrock village, Booterstown, Mount Merrion, Stillorgan and the Blackrock side of the N11 around the clock. The area is a mix of old red-brick villas, post-war family homes and modern apartments around Frascati Shopping Centre and Blackrock Park.</p>
<h3>Common Blackrock jobs</h3>
<ul>
  <li>House lockouts across Booterstown, Mount Merrion and Stillorgan</li>
  <li>BS3621 mortice deadlock fitting on the older village houses</li>
  <li>Multipoint repair on the modern estate homes</li>
  <li>Frascati Shopping Centre and Blackrock Park car lockouts</li>
  <li>Apartment lockouts on the modern developments along the coast</li>
</ul>
<p>Our south-Dublin coastal van means a typical Blackrock arrival time of 12–18 minutes. <a href="tel:+35318782720">(01) 878 2720</a> — local 01 number, real Dublin team, 24 hours a day.</p>
'
WHERE `slug` = 'locksmith-blackrock';

UPDATE `locations` SET `body` = '
<p>Locksmiths.ie covers the <strong>Howth</strong> peninsula — Howth village, Howth Head, Sutton, Baldoyle and Bayside — 24 hours a day. The mix of clifftop homes, the village fishing community and the modern Sutton estates means a wide variety of door and lock types, and we carry parts for every one of them on the van.</p>
<h3>Common Howth jobs</h3>
<ul>
  <li>House lockouts on the cliff-side and harbour-side homes around Howth Head</li>
  <li>Sliding patio door lock repair (very common on coastal homes)</li>
  <li>Window lock fitting on the older Sutton and Baldoyle houses</li>
  <li>Multipoint mechanism repair on the modern Bayside estates</li>
  <li>Boat / harbour lock repair at Howth Marina</li>
</ul>
<p>Howth response time is 20–30 minutes from our north-Dublin van. Local Dublin 01 landline, real local team, no premium rate: <a href="tel:+35318782720">(01) 878 2720</a>.</p>
'
WHERE `slug` = 'locksmith-howth';

UPDATE `locations` SET `body` = '
<p>Our <strong>Castleknock</strong> locksmith team covers Castleknock, Carpenterstown, Ashtown, Phoenix Park and the surrounding D15 area 24 hours a day. The neighbourhood is dominated by large family homes from the 1970s through to modern developments off the Navan Road and the Castleknock Hotel area.</p>
<h3>Common Castleknock jobs</h3>
<ul>
  <li>House lockouts across Castleknock village and Carpenterstown</li>
  <li>Multipoint mechanism repair on the post-1990s family homes</li>
  <li>Anti-snap cylinder upgrades on Phoenix Park / Navan Road properties</li>
  <li>Castleknock Hotel guest car lockouts</li>
  <li>Phoenix Park-side homes — security upgrades and timber-door rebuilds after break-in</li>
</ul>
<p>Average Castleknock response time is 15 minutes from our north-west Dublin van. Same Dublin 01 landline: <a href="tel:+35318782720">(01) 878 2720</a>.</p>
'
WHERE `slug` = 'locksmith-castleknock';

UPDATE `locations` SET `body` = '
<p><strong>Stillorgan</strong> sits between Blackrock and Sandyford on the south-Dublin coast and is a busy mix of post-war family homes, modern apartments at Stillorgan Plaza and the UCD Belfield campus catchment. We service Stillorgan, Mount Merrion, Goatstown, Foxrock-side and the Stillorgan Reservoir area 24 hours a day.</p>
<h3>Common Stillorgan jobs</h3>
<ul>
  <li>House lockouts across Stillorgan, Mount Merrion and Goatstown</li>
  <li>UCD Belfield student-accommodation lockouts and core re-keys</li>
  <li>Stillorgan Plaza apartment lockouts and shop-front lock repair</li>
  <li>Anti-snap cylinder upgrades after attempted break-ins</li>
  <li>Multipoint mechanism repair on the post-1990 estates around Foxrock and Cabinteely</li>
</ul>
<p>Average Stillorgan response time is 12–18 minutes from our south-Dublin van. Always the same Dublin 01 landline answered by the same team: <a href="tel:+35318782720">(01) 878 2720</a>.</p>
'
WHERE `slug` = 'locksmith-stillorgan';

-- =====================================================================
-- C. Service body expansions for the highest-traffic services
-- =====================================================================

UPDATE `services` SET `body` = '
<p>If you are locked out anywhere in Dublin — at home, at the office, or in a car park — we are the closest PSA-licensed locksmith on call. Our 24-hour emergency line is a real Dublin <strong>01 landline</strong> answered by a member of our team day or night. Not a premium-rate number, not a divert to a UK call centre, and not auctioned to a third-party sub-contractor.</p>

<h3>What "emergency" means to us</h3>
<p>An emergency call is anyone locked out, locked in, broken into, or with a snapped key in the lock. We dispatch a fully-stocked van the moment the phone hangs up — no waiting on quotes, no waiting until morning, no surcharge for late nights or weekends. Our average on-site arrival time across Dublin city and the Greater Dublin Area is twenty to thirty minutes; inside the M50 it is usually fifteen.</p>

<h3>What we do on the job</h3>
<ol>
  <li><strong>Open the door without damage</strong> — bypass tools and PSA-approved entry methods open over 95% of doors with no damage to the lock, frame or door itself.</li>
  <li><strong>Cut a new key on-site</strong> if the original has been lost, broken or stolen.</li>
  <li><strong>Re-key the cylinder</strong> when keys have been lost so old keys no longer work.</li>
  <li><strong>Upgrade the lock</strong> if the existing one is below British Standard or showing signs of attack — we carry anti-snap TS007 3-star cylinders on the van.</li>
  <li><strong>Issue a written invoice and 12-month guarantee</strong> on every job.</li>
</ol>

<h3>Fixed price up front</h3>
<p>We quote a fixed price on the phone before we leave the depot. The minimum job price is €90 — that is the fee for opening a door with no further work. There is no separate "call-out fee" added on top, no late-night surcharge, no weekend surcharge, no premium for bank holidays.</p>

<h3>Areas we cover</h3>
<p>We cover every Dublin postcode (D1 through D24), every Dublin county town (Tallaght, Swords, Blanchardstown, Lucan, Clondalkin, Dundrum, Malahide, Howth) and the surrounding Kildare / Meath / Wicklow border. <a href="/locations">See the full coverage list</a>.</p>

<h3>Call us right now</h3>
<p>Ring <a href="tel:+35318782720">(01) 878 2720</a> and we will be on the road within minutes.</p>
'
WHERE `slug` IN ('emergency-lockout','emergency-locksmith-dublin','24-hour-locksmith','locksmith-dublin-24-7','locksmith-near-me-dublin','mobile-locksmith-dublin','same-day-locksmith','weekend-locksmith','night-locksmith','emergency-door-opening','house-lockout','lockout-service','office-lockout','emergency-locksmith-tallaght');

UPDATE `services` SET `body` = '
<p>If you are losing keys, leaving a tenancy, or worried that a previous owner has copies floating around, we can fit a brand-new lock the same day. Lock replacement is one of our most common jobs across Dublin and we carry every common cylinder profile, deadlock and night latch on the van.</p>

<h3>What we replace and why</h3>
<ul>
  <li><strong>Anti-snap euro cylinders</strong> — the single biggest insurance and security upgrade on a UPVC or composite door. We fit Brisant Ultion, Mul-T-Lock MT5+, ABS Avocet and ISEO restricted cylinders certified to BS 3621 and TS007 3-star.</li>
  <li><strong>5-lever mortice deadlocks</strong> — the standard insurance requirement on most timber doors in Ireland. We supply BS3621-rated locks from Era, Banham, Yale and Chubb.</li>
  <li><strong>Night latches</strong> — Yale-style classic and deadlocking versions to BS3621.</li>
  <li><strong>Multipoint mechanisms</strong> — full strip replacement on UPVC, composite and aluminium doors when a gearbox swap is no longer enough.</li>
  <li><strong>Smart locks</strong> — Yale Conexis L2, Nuki, August, ekey biometric.</li>
</ul>

<h3>How long it takes</h3>
<p>Most cylinder replacements are completed in 30 to 45 minutes from when we ring the doorbell. A full multipoint strip replacement is closer to 90 minutes. We arrive with everything required to finish the job on the first visit — a 95% same-visit completion rate.</p>

<h3>Pricing</h3>
<p>Anti-snap cylinder fitted: <strong>€115</strong>. 5-lever BS3621 mortice deadlock fitted: <strong>€125</strong>. Multipoint mechanism fitted: <strong>€175 – €245</strong> depending on the door and brand. <a href="/pricing">See the full price list →</a></p>

<h3>Insurance compliance</h3>
<p>If your home insurance policy specifies "BS3621" or "TS007 3-star", we will leave the certification mark visible on the lock and provide a written invoice naming the standard. This is what claims handlers look for in the event of a future incident.</p>

<p>Call our local 01 landline <a href="tel:+35318782720">(01) 878 2720</a> for a fixed price.</p>
'
WHERE `slug` IN ('lock-replacement','lock-installation','anti-snap-locks','high-security-locks','5-lever-deadlock','tenant-lock-changes','security-upgrades','mortice-lock-installation','deadbolt-installation','night-latch','door-lock-repair');

UPDATE `services` SET `body` = '
<p>If your UPVC or composite front door has gone "floppy" or stiff, the gearbox inside the multipoint locking strip has failed. We fix this several times a day across Dublin and carry replacement gearboxes and full strips for every common brand on the van.</p>

<h3>Brands we carry on every van</h3>
<p>GU (Ferco), Fuhr, Roto, Winkhaus, Maco, ERA, Yale, Avocet, Lockmaster, Mila, Saracen, ASEC, Fullex, Yale Lockmaster.</p>

<h3>How we diagnose</h3>
<ol>
  <li><strong>Lift the handle test</strong> — does the handle move freely without the door open? If not, the gearbox is the issue.</li>
  <li><strong>Identify the brand and gearbox case shape</strong> — measured from the centre of the cylinder hole to the centre of the spindle.</li>
  <li><strong>Match the gearbox</strong> from stock — we carry the four most common case shapes which cover roughly 90% of Irish doors.</li>
  <li><strong>Replace, test and adjust</strong> — usually under an hour from arrival.</li>
</ol>

<h3>What it costs</h3>
<p>Multipoint mechanism replacement is <strong>€175 – €245</strong> depending on the brand and door type — fixed price agreed before we start. <a href="/pricing">See the full price list →</a></p>

<h3>Common signs your gearbox is going</h3>
<ul>
  <li>Handle goes floppy and doesn''t spring back</li>
  <li>Have to lift the handle very high to lock the door</li>
  <li>Door drops when opened — alignment is off</li>
  <li>Locking points (top, bottom, hooks) don''t engage</li>
  <li>Key turns but the door won''t open</li>
</ul>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> — we will diagnose and quote on the phone before we leave the depot.</p>
'
WHERE `slug` IN ('upvc-door-lock-repair','upvc-mechanism-repair','multipoint-lock-repair');

UPDATE `services` SET `body` = '
<p>Lost car keys is one of our most frequent automotive callouts across Dublin. Most modern cars need both a cut blade <em>and</em> a programmed transponder — the dealer would charge €350+ for the same job and require a tow. Our auto-locksmith van does it on-site, usually in under an hour.</p>

<h3>What we cut and code on the van</h3>
<p>Ford, Volkswagen Group (VW, Audi, Skoda, Seat), BMW, Mini, Toyota, Lexus, Hyundai, Kia, Nissan, Renault, Dacia, Peugeot, Citroën, Vauxhall, Opel, Mazda, Honda, Mitsubishi, Suzuki, Volvo. Most years from 1995 onwards.</p>

<h3>What we need from you</h3>
<ul>
  <li>Vehicle registration plate or chassis number (VIN)</li>
  <li>Proof you are the owner (V5 / log-book or insurance)</li>
  <li>Access to the vehicle (we travel to it)</li>
</ul>

<h3>Where we work</h3>
<p>On-site at home, at work, in long-term car parks, at Dublin Airport, at the Pavilions, at Liffey Valley, at Dundrum, at the IKEA Ballymun car park — anywhere your vehicle is parked. We have done jobs in IKEA, in the long-stay at Dublin Airport, on the side of the M50 with the AA, and in supermarket car parks at midnight.</p>

<h3>Pricing</h3>
<p>Most car key cutting and programming is fixed at <strong>€150 – €180</strong> depending on the make. Keyless-go fobs and high-security models can run higher; we always quote a fixed price before starting. <a href="/pricing">See the full price list →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> — local Dublin landline, no premium rate.</p>
'
WHERE `slug` IN ('car-key-cutting','car-locksmith-dublin','auto-locksmith','car-key-programming','transponder-key-programming','car-key-replacement','key-fob-replacement','vehicle-unlock','car-locksmith-swords');

UPDATE `services` SET `body` = '
<p>If you have been broken into, or someone has tried, we secure the property immediately and provide an insurance-approved written report on the same visit. Same-day response any day of the week, including Christmas Day.</p>

<h3>What we do on the call</h3>
<ol>
  <li>Secure the property (board up if necessary, replace damaged cylinder, repair frame)</li>
  <li>Upgrade to anti-snap TS007 3-star cylinder so the same method cannot be used again</li>
  <li>Check the rest of the doors and windows for similar weaknesses</li>
  <li>Provide a written, dated invoice naming the British Standard of every part fitted</li>
  <li>Provide a separate insurance-claim report on request</li>
</ol>

<h3>Common attack patterns we see in Dublin</h3>
<p>By far the most common attack on Dublin homes is "lock snapping" on UPVC and composite doors — a euro cylinder that doesn''t carry a 3-star anti-snap rating can be snapped in under 30 seconds with a basic wrench. The fix is straightforward: replace with a TS007 3-star cylinder (Brisant Ultion, Mul-T-Lock MT5+, ABS Avocet). The cost is €115 fitted.</p>

<h3>Other security upgrades we''d recommend</h3>
<ul>
  <li>Hinge bolts on outward-opening doors</li>
  <li>Reinforced strike plates and longer fixings on timber doors</li>
  <li>Window key-locks (very few Dublin houses have these and they are €15 fitted)</li>
  <li>Patio door anti-lift restrictor bolts (€105 fitted)</li>
  <li>Smart-lock with remote auto-lock so the door is never accidentally left unlocked</li>
</ul>

<p>Same-day response anywhere in Dublin: <a href="tel:+35318782720">(01) 878 2720</a>.</p>
'
WHERE `slug` IN ('burglary-repairs','post-break-in-repairs');

UPDATE `services` SET `body` = '
<p>We supply, install and configure smart locks across Dublin — Yale Conexis L2, Nuki 4.0, August Wi-Fi, Yale Linus and ekey biometric. Most installs are completed in under an hour and include full integration with Apple HomeKit, Google Home and Alexa.</p>

<h3>Which smart lock is right for you?</h3>
<ul>
  <li><strong>Yale Conexis L2</strong> — replaces the existing multipoint handle on a UPVC or composite door. Best for renters who want to take it with them.</li>
  <li><strong>Nuki 4.0</strong> — sits on top of the existing cylinder thumbturn. Best for tenants who can''t alter the door, or apartment owners with a restricted cylinder.</li>
  <li><strong>August Wi-Fi</strong> — similar to Nuki, very compact, US-spec but works on most Irish doors.</li>
  <li><strong>Yale Linus L2</strong> — a slim retro-fit similar to Nuki with HomeKit support.</li>
  <li><strong>ekey Biometric</strong> — fingerprint reader for the front door, no app required.</li>
</ul>

<h3>What is included</h3>
<p>Supply and fit the lock, configure the app, set up auto-lock and auto-unlock, configure family / housemate codes, integrate with smart-home systems, and 12-month written guarantee on parts and labour.</p>

<h3>Pricing</h3>
<p>Yale Conexis L2 supplied and fitted: from <strong>€330</strong>. Nuki 4.0 supplied and fitted: from <strong>€280</strong>. Other models on quote. <a href="/pricing">See the full price list →</a></p>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for advice on which model suits your door.</p>
'
WHERE `slug` IN ('smart-locks','smart-lock-installation','digital-lock-installation','fingerprint-lock');

-- =====================================================================
-- D. Refresh testimonials with longer, locally-grounded reviews
-- =====================================================================
DELETE FROM `testimonials`;
INSERT INTO `testimonials` (`customer_name`,`customer_location`,`rating`,`review_body`,`is_featured`,`review_date`) VALUES
('Sarah O''Brien',     'Rathmines, D6',           5,
 'Locked out at 1am after a wedding in town. Rang the (01) number and a real Dublin man answered straight away — no menu, no call centre. Eighteen minutes later he was at the door of my apartment on Rathmines Road and had me inside in five without a single mark on the door. Charged exactly the €95 he quoted on the phone. Genuinely brilliant service. I will be saving the number for life.',
 1, '2026-04-21'),

('Mark Kavanagh',      'Tallaght, D24',           5,
 'Came home from work to a UPVC front door I couldn''t get open — handle had gone completely floppy. Got a fixed price of €185 on the phone before he left and that''s exactly what I paid. Fitted a new gearbox in under an hour and showed me what had gone wrong with the old one. Polite, tidy and made sure I had three working keys before he left. Top class.',
 1, '2026-04-15'),

('Aoife Murphy',       'Sandyford, D18',          5,
 'Genuinely the fastest locksmith I''ve ever used in Dublin. Locked the keys inside the apartment in Beacon South Quarter, rang at 11pm, was at my door in twelve minutes. €95 fixed price, no call-out fee on top, no hidden anything. He even waited to make sure my new keys worked before driving off. I have his number saved as "the locksmith who actually shows up".',
 1, '2026-04-09'),

('Liam Byrne',         'Blanchardstown, D15',     5,
 'Came out on a Sunday morning for a burglary repair in Tyrrelstown. House had been hit Saturday night while we were away for a christening. Replaced the snapped cylinder with an anti-snap one, fitted a new mortice on the back door and gave us a written report for the insurance — all in under two hours. The insurance handler said it was the cleanest report she''d seen all month. Highly recommend.',
 1, '2026-03-30'),

('Niamh Walsh',        'Swords, North Co. Dublin',5,
 'Lost my car keys somewhere in the long-term car park at Dublin Airport coming back from a trip. Called the AA first — they wanted to tow it to the dealer, two days minimum, €400+. Rang Locksmiths.ie instead, the auto-locksmith van was at the car in twenty minutes, cut and programmed a new key on the spot, total €165 fixed price. Drove home that evening. Lifesavers.',
 1, '2026-03-22'),

('Conor Doyle',        'Dublin 1, IFSC',          5,
 'My elderly mother locked herself out of her apartment near Spencer Dock late on a Saturday night. She''s 84 and I was an hour away. The lad on the phone reassured her, was there in fifteen minutes, opened the door without damage, made sure she had a cup of tea before he left. Charged me the standard €95. The kind of service you don''t expect any more in Dublin.',
 1, '2026-03-15'),

('Ciara Fitzgerald',   'Ranelagh, D6',            5,
 'Lovely fella came out on a Wednesday evening to change all the locks after we bought a Victorian terrace on Ranelagh Road. Three timber doors, eight keys, BS3621 5-levers, plus an anti-snap on the back. Quoted €420 on the phone, paid €420 on the night. Cleaned up after himself, left the place spotless. Insurance company was happy as Larry the next day.',
 1, '2026-03-08'),

('Patrick O''Sullivan','Lucan, West Dublin',      5,
 'UPVC front door wouldn''t lock at all — handle just spinning. Rang at 8am hoping someone could come the same day. Tech was at the door at 11am with the right gearbox in stock and the door was working perfectly by lunchtime. €175 fixed. Importantly: no call-out fee on top of the quote — just the price he quoted on the phone. Refreshing.',
 1, '2026-03-02'),

('Rachel Murphy',      'Stoneybatter, D7',        5,
 'Smart lock installation on a 100-year-old red-brick. They warned me on the phone that retrofit smart locks can be tricky on old timber doors and they were right — there was a fair bit of fine adjustment to get the Yale Conexis seated properly. But they did it without complaint, tested every code with me before they left, and showed me how to add my parents to the app. €330 all in.',
 0, '2026-02-24'),

('Eoin O''Connor',     'Castleknock, D15',        5,
 'Tried five locksmiths from Google before I rang Locksmiths.ie. Three didn''t answer, two quoted me prices over the phone and then turned up wanting twice that. The Locksmiths.ie quote was €115 for an anti-snap upgrade after a break-in attempt and that''s exactly what I paid. Genuinely, exactly. Booked them again last week for a second cylinder.',
 0, '2026-02-18'),

('Maeve Nolan',        'Dundrum, D14',            5,
 'Apartment lockout in Rockbrook Dundrum at midnight. I was outside in the rain in my pyjamas and a coat. The fella was there in fourteen minutes. Fourteen! Opened the door without breaking anything, gave me a hot tip about getting a magnetic key holder for the future. €95. I tried to give him a tenner extra and he wouldn''t take it.',
 0, '2026-02-11'),

('Seán Kelly',         'Drumcondra, D9',          5,
 'Snapped a key inside the front door coming home late from a match. Tried to fish it out for ten minutes before giving up and ringing Locksmiths.ie. Was here in twenty-five minutes (Saturday night, no surcharge), extracted the broken bit, cut me a new key from the head of the snapped one, and tested it. €110 total. Super professional.',
 0, '2026-02-04'),

('Aisling McCarthy',   'Ballsbridge, D4',         5,
 'I run a small dental practice in Ballsbridge and we needed an urgent master-key system for the staff. They came out for a survey, designed a 4-level suite (reception, dental rooms, manager, master), supplied and fitted everything inside three working days. The pricing was crystal clear from the start. Two years on, nothing has needed servicing.',
 0, '2026-01-28'),

('Daragh O''Reilly',   'Glasnevin, D11',          5,
 'Old mortice lock on the back door had finally given up. Booked online, got a confirmation call within ten minutes, fitted a BS3621 5-lever the same afternoon for €125. Politely explained that the front door cylinder was also a snap risk and gave me a fair quote for that, no pressure to do it on the day. Came back the following week and did it.',
 0, '2026-01-21'),

('Orla Brennan',       'Clontarf, D3',            5,
 'My elderly father in Clontarf locked himself out at 6am. He''s on his own and was very upset. The lady on the phone (yes — answered at 6am, by an actual person) talked him through staying calm and they had someone there in eighteen minutes. The technician was so kind to him. Charged the standard €95. I cannot praise them enough.',
 1, '2026-01-15'),

('Diarmuid Quinn',     'Howth, North Co. Dublin', 5,
 'Sliding patio door on the back of the house in Howth had stopped locking properly — the salt air had done its damage. They came out on a wet Tuesday morning, replaced the patio mechanism and fitted an anti-lift restrictor for an extra €105. Door has been bulletproof since. Worth every cent.',
 0, '2026-01-08'),

('Niall Hanrahan',     'Citywest, West Dublin',   5,
 'Hotel guest at Citywest, locked the keys in a hire car on the Sunday of an event. The driver from Locksmiths.ie was there in twenty minutes, opened the car without damage, and only charged the standard rate even though it was a Sunday and an event weekend. He even chatted football with me while he worked. Class act.',
 0, '2025-12-22'),

('Fiona Whelan',       'Cabra, D7',               5,
 'New cylinder fitted after we lost the keys somewhere on a walk in the Phoenix Park. Could not find them anywhere. Locksmiths.ie did the rekey same afternoon for €85 (under the €90 minimum, somehow — fair play). Three keys included. Lovely friendly chat, in and out in 30 minutes.',
 0, '2025-12-18'),

('Brendan Walsh',      'Stillorgan, South Dublin',5,
 'Office lockout on a Friday evening at 7pm. Came out within fifteen minutes, opened the back door of the unit on the Stillorgan road without damage, and waited while we found the keys inside. Charged €110 (slightly higher because it was a commercial property, fully fair). Kept us trading the next morning.',
 0, '2025-12-09'),

('Saoirse Lynch',      'Malahide, North Co. Dublin',5,
 'Smart lock installation (Nuki 4.0) on a coastal house in Malahide. They were knowledgeable about which products handle the salt-air climate and recommended a sealed retrofit rather than a full handle replacement. Two hours from arriving to having the app set up on my phone and my husband''s. €280 fixed. Cannot fault them.',
 0, '2025-12-02');
