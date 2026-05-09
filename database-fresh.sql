-- =====================================================================
-- Locksmiths.ie - FRESH INSTALL (drop + recreate everything)
-- MySQL 8.x / MariaDB 10.x
--
-- Use this when you want to wipe the existing database and start clean.
--   1. phpMyAdmin → eqdueglqgt → Import → upload this file → Go.
--   2. All Locksmiths.ie tables are dropped and rebuilt with seed data.
--   3. Default admin login is  admin / ChangeMe!2026  — change immediately.
--
-- Safe to re-run at any time.
-- =====================================================================

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `pricing_items`;
DROP TABLE IF EXISTS `quote_requests`;
DROP TABLE IF EXISTS `faqs`;
DROP TABLE IF EXISTS `testimonials`;
DROP TABLE IF EXISTS `locations`;
DROP TABLE IF EXISTS `services`;
DROP TABLE IF EXISTS `settings`;
DROP TABLE IF EXISTS `admin_users`;
SET FOREIGN_KEY_CHECKS = 1;


-- ---------------------------------------------------------------------
-- Admin users
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `admin_users` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(60) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `role` ENUM('admin','editor') NOT NULL DEFAULT 'admin',
  `last_login` DATETIME DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_username` (`username`),
  UNIQUE KEY `uniq_email` (`email`)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Global business / NAP settings (single row, key=value design)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `settings` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `setting_key` VARCHAR(100) NOT NULL,
  `setting_value` LONGTEXT,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_key` (`setting_key`)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Service pages (Emergency, Burglary, Smart Locks, etc.)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `services` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `slug` VARCHAR(160) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `category` ENUM('residential','commercial','automotive','safe','emergency') NOT NULL DEFAULT 'residential',
  `short_description` VARCHAR(300) DEFAULT NULL,
  `body` LONGTEXT,
  `icon` VARCHAR(60) DEFAULT NULL,
  `featured_image` VARCHAR(255) DEFAULT NULL,
  `meta_title` VARCHAR(160) DEFAULT NULL,
  `meta_description` VARCHAR(320) DEFAULT NULL,
  `focus_keyword` VARCHAR(120) DEFAULT NULL,
  `canonical_url` VARCHAR(255) DEFAULT NULL,
  `price_from` DECIMAL(8,2) DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `sort_order` INT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_service_slug` (`slug`),
  KEY `idx_category` (`category`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Location pages (Dublin districts D1-D24, towns, counties)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `locations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `slug` VARCHAR(160) NOT NULL,
  `name` VARCHAR(120) NOT NULL,
  `region` ENUM('dublin_city','dublin_county','kildare','meath','wicklow') NOT NULL DEFAULT 'dublin_city',
  `district_code` VARCHAR(10) DEFAULT NULL,
  `landmark` VARCHAR(200) DEFAULT NULL,
  `landmark_secondary` VARCHAR(200) DEFAULT NULL,
  `intro` TEXT,
  `body` LONGTEXT,
  `latitude` DECIMAL(10,7) DEFAULT NULL,
  `longitude` DECIMAL(10,7) DEFAULT NULL,
  `featured_image` VARCHAR(255) DEFAULT NULL,
  `meta_title` VARCHAR(160) DEFAULT NULL,
  `meta_description` VARCHAR(320) DEFAULT NULL,
  `focus_keyword` VARCHAR(120) DEFAULT NULL,
  `canonical_url` VARCHAR(255) DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `sort_order` INT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_loc_slug` (`slug`),
  KEY `idx_region` (`region`),
  KEY `idx_loc_active` (`is_active`)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Testimonials / reviews
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `testimonials` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_name` VARCHAR(120) NOT NULL,
  `customer_location` VARCHAR(120) DEFAULT NULL,
  `rating` TINYINT UNSIGNED NOT NULL DEFAULT 5,
  `review_body` TEXT NOT NULL,
  `service_id` INT UNSIGNED DEFAULT NULL,
  `photo` VARCHAR(255) DEFAULT NULL,
  `review_date` DATE DEFAULT NULL,
  `is_featured` TINYINT(1) NOT NULL DEFAULT 0,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_rating` (`rating`),
  KEY `idx_t_active` (`is_active`),
  CONSTRAINT `fk_test_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- FAQ entries (used for FAQPage schema)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `faqs` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `question` VARCHAR(255) NOT NULL,
  `answer` TEXT NOT NULL,
  `service_id` INT UNSIGNED DEFAULT NULL,
  `location_id` INT UNSIGNED DEFAULT NULL,
  `is_global` TINYINT(1) NOT NULL DEFAULT 0,
  `sort_order` INT NOT NULL DEFAULT 0,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_faq_service` (`service_id`),
  KEY `idx_faq_location` (`location_id`),
  CONSTRAINT `fk_faq_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_faq_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Quote / contact submissions
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `quote_requests` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `phone` VARCHAR(40) NOT NULL,
  `email` VARCHAR(150) DEFAULT NULL,
  `area` VARCHAR(120) DEFAULT NULL,
  `service_needed` VARCHAR(160) DEFAULT NULL,
  `message` TEXT,
  `source_page` VARCHAR(200) DEFAULT NULL,
  `ip_address` VARCHAR(45) DEFAULT NULL,
  `user_agent` VARCHAR(255) DEFAULT NULL,
  `status` ENUM('new','contacted','closed','spam') NOT NULL DEFAULT 'new',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_created` (`created_at`)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Pricing list (shown publicly on /pricing, editable in admin)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `pricing_items` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(200) NOT NULL,
  `price_text` VARCHAR(60) NOT NULL,
  `price_from` DECIMAL(8,2) DEFAULT NULL,
  `note` VARCHAR(200) DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `sort_order` INT NOT NULL DEFAULT 0,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pricing_active` (`is_active`)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Default data
-- ---------------------------------------------------------------------
-- Default admin user (password: ChangeMe!2026 — change immediately after install)
INSERT INTO `admin_users` (`username`, `email`, `password_hash`, `role`)
VALUES ('admin', 'admin@locksmiths.ie',
        '$2y$12$PY3fvAGUjkk0CnaM3Fx8MOqa8AYzRqP9tR5P8jW8Wpn9mcbl0hAb.',
        'admin')
ON DUPLICATE KEY UPDATE `password_hash` = VALUES(`password_hash`);

-- Global settings (NAP, PSA, SMTP, code injection)
INSERT INTO `settings` (`setting_key`, `setting_value`) VALUES
('business_name',       'Locksmiths.ie'),
('phone',               '(01) 878 2720'),
('phone_e164',          '+35318782720'),
('whatsapp',            '+35318782720'),
('email',               'info@locksmiths.ie'),
('address_street',      'North City'),
('address_city',        'Dublin 1'),
('address_postcode',    'D01 F297'),
('address_country',     'IE'),
('latitude',            '53.349805'),
('longitude',           '-6.260310'),
('opening_hours',       'Mo-Su 00:00-23:59'),
('price_range',         '€€'),
('psa_license',         'PSA 00709'),
('response_time',       '20-30 minutes'),
('logo',                '/assets/images/locksmiths-ie-logo-horizontal.svg'),
('social_twitter',      'https://twitter.com/IeLocksmiths'),
('social_pinterest',    'https://www.pinterest.com/ielocksmiths/'),
('social_facebook', 'https://www.facebook.com/p/LocksmithsIE-100057039626907/'),
('social_instagram',    ''),
('social_linkedin',     ''),
('social_youtube',      ''),
('custom_css',          ''),
('hero_title',          'Dublin''s Fastest Emergency Locksmith'),
('hero_subtitle',       'PSA Licensed. 20-minute response. No call-out fee. 12-month guarantee on all work.'),
('smtp_host',           'smtp.example.com'),
('smtp_port',           '587'),
('smtp_user',           ''),
('smtp_pass',           ''),
('smtp_secure',         'tls'),
('smtp_from_email',     'noreply@locksmiths.ie'),
('smtp_from_name',      'Locksmiths.ie'),
('inject_head',         ''),
('inject_body_start',   ''),
('inject_footer',       ''),
('google_maps_key',     '')
ON DUPLICATE KEY UPDATE `setting_value` = VALUES(`setting_value`);

-- Seed core services
INSERT IGNORE INTO `services` (`slug`, `title`, `category`, `short_description`, `body`, `icon`, `meta_title`, `meta_description`, `focus_keyword`, `price_from`, `sort_order`) VALUES
('emergency-lockout',  'Emergency Lockout Service',  'emergency',
 'Locked out? PSA-licensed locksmith on-site in 20 minutes anywhere in Dublin.',
 '<p>Our 24/7 emergency lockout service covers all of Dublin and the Greater Dublin Area. Whether you are locked out of your home, office or car, our PSA-licensed technicians arrive on-site in 20–30 minutes with the tools and skill to get you back inside without damaging your door or lock.</p>',
 'key', 'Emergency Locksmith Dublin | 20-Min Response | PSA Licensed',
 'Locked out in Dublin? Our PSA-licensed emergency locksmiths arrive in 20 minutes. No call-out fee. Available 24/7 across all Dublin districts.',
 'emergency locksmith dublin', 90.00, 1),

('burglary-repairs',   'Burglary Damage Repairs',     'residential',
 'Fast lock and door repair after a break-in. Insurance-approved reports provided.',
 '<p>If you have suffered a break-in, we secure your home or business immediately. We repair or replace damaged locks, frames and doors, upgrade to anti-snap cylinders to British Standard BS3621, and provide an insurance-approved report on the same day.</p>',
 'shield', 'Burglary Repair Locksmith Dublin | Same-Day Service',
 'Broken into? Our Dublin locksmiths secure your property fast with insurance-approved reports and anti-snap lock upgrades.',
 'burglary repair locksmith dublin', 120.00, 2),

('smart-locks',        'Smart Lock Installation',     'residential',
 'Yale, Nuki, Mul-T-Lock and August smart locks supplied and fitted.',
 '<p>We supply and install all leading smart lock brands including Yale Conexis L2, Nuki 4.0, Mul-T-Lock ENTR and August. Full integration with Apple HomeKit, Google Home and Alexa, configured by a PSA-licensed technician.</p>',
 'wifi', 'Smart Lock Installation Dublin | Yale, Nuki, Mul-T-Lock',
 'Professional smart lock installation in Dublin. PSA-licensed fitting of Yale, Nuki, Mul-T-Lock and August smart locks with full smart-home integration.',
 'smart lock installation dublin', 220.00, 3),

('car-key-cutting',    'Car Key Cutting & Programming','automotive',
 'On-site car key cutting and transponder programming for all makes.',
 '<p>Lost your car keys? We cut and programme replacement keys, transponders and remote fobs on-site for all major makes including Ford, Volkswagen, Toyota, BMW and Audi. No need to tow your vehicle to the dealership.</p>',
 'car', 'Car Key Replacement Dublin | On-Site Cutting & Programming',
 'Lost car keys in Dublin? On-site key cutting and transponder programming for all makes. Faster and cheaper than a main dealer.',
 'car key replacement dublin', 150.00, 4),

('safe-opening',       'Safe Opening & Repair',       'safe',
 'Non-destructive safe opening for home and business safes.',
 '<p>Locked out of your safe? We provide non-destructive opening for all major safe brands including Chubb, Burton, Phoenix and Yale. We also reset combinations, replace electronic locks and supply new safes.</p>',
 'lock', 'Safe Opening Dublin | Non-Destructive Locksmith',
 'Professional safe opening service in Dublin. Non-destructive entry for Chubb, Burton, Phoenix and Yale safes. PSA licensed.',
 'safe opening dublin', 180.00, 5),

('commercial-locks',   'Commercial Locksmith Services','commercial',
 'Master key systems, access control and high-security locks for businesses.',
 '<p>We service Dublin businesses with master-key suites, access control, panic bars, electric strikes and high-security commercial cylinders. Insurance-compliant installations to IS EN 1303 and IS EN 12209.</p>',
 'briefcase', 'Commercial Locksmith Dublin | Master Keys & Access Control',
 'Commercial locksmith services across Dublin. Master key systems, access control, panic bars and high-security locks for offices and retail.',
 'commercial locksmith dublin', 200.00, 6);

-- Seed Dublin districts D1-D24 (selected — admin can extend)
INSERT IGNORE INTO `locations` (`slug`, `name`, `region`, `district_code`, `landmark`, `landmark_secondary`, `intro`, `latitude`, `longitude`, `meta_title`, `meta_description`, `focus_keyword`, `sort_order`) VALUES
('locksmith-dublin-1',  'Dublin 1',  'dublin_city', 'D1',  'O''Connell Street',     'The Spire',
 'Locksmith Dublin 1 — PSA-licensed emergency locksmith covering the city centre, IFSC and North Wall.',
 53.350140, -6.259660,
 'Locksmith Dublin 1 (D1) | 20-Min Emergency Response',
 'Need a locksmith in Dublin 1? PSA licensed, 20-minute response across the city centre, IFSC and O''Connell Street. No call-out fee.',
 'locksmith dublin 1', 1),

('locksmith-dublin-2',  'Dublin 2',  'dublin_city', 'D2',  'St. Stephen''s Green',  'Grafton Street',
 'Locksmith Dublin 2 — covering Grafton Street, Trinity College and St. Stephen''s Green.',
 53.339000, -6.260000,
 'Locksmith Dublin 2 (D2) | Grafton Street & St. Stephen''s Green',
 'Locksmith services in Dublin 2 near St. Stephen''s Green and Grafton Street. PSA licensed, 20-minute response, 24/7.',
 'locksmith dublin 2', 2),

('locksmith-dublin-4',  'Dublin 4',  'dublin_city', 'D4',  'Aviva Stadium',         'Sandymount Strand',
 'Locksmith Dublin 4 — covering Ballsbridge, Sandymount, Donnybrook and Ringsend.',
 53.328000, -6.225000,
 'Locksmith Dublin 4 (D4) | Ballsbridge & Sandymount',
 'Trusted PSA-licensed locksmith for Dublin 4 — Ballsbridge, Sandymount, Donnybrook. 20-minute emergency response.',
 'locksmith dublin 4', 4),

('locksmith-dublin-6',  'Dublin 6',  'dublin_city', 'D6',  'Rathmines Town Hall',   'Ranelagh Village',
 'Locksmith Dublin 6 — covering Rathmines, Ranelagh, Rathgar and Terenure.',
 53.320000, -6.260000,
 'Locksmith Dublin 6 (D6) | Rathmines & Ranelagh',
 'Locksmith services for Dublin 6 — Rathmines, Ranelagh, Rathgar. PSA licensed, fast response, 12-month guarantee.',
 'locksmith dublin 6', 6),

('locksmith-dublin-15', 'Dublin 15', 'dublin_city', 'D15', 'Blanchardstown Centre', 'Phoenix Park',
 'Locksmith Dublin 15 — covering Blanchardstown, Castleknock, Clonsilla and Mulhuddart.',
 53.390000, -6.378000,
 'Locksmith Dublin 15 (D15) | Blanchardstown & Castleknock',
 'PSA licensed locksmith covering Dublin 15 — Blanchardstown, Castleknock and Clonsilla. 20-minute emergency response.',
 'locksmith dublin 15', 15),

('locksmith-dublin-18', 'Dublin 18', 'dublin_city', 'D18', 'Dundrum Town Centre',   'Sandyford Industrial Estate',
 'Locksmith Dublin 18 — covering Sandyford, Stepaside, Cabinteely and Foxrock.',
 53.270000, -6.220000,
 'Locksmith Dublin 18 (D18) | Sandyford & Dundrum',
 'Locksmith for Dublin 18 — Sandyford, Stepaside, Cabinteely. PSA licensed, fast on-site response, no call-out fee.',
 'locksmith dublin 18', 18),

('locksmith-tallaght',  'Tallaght',  'dublin_county', NULL, 'The Square Tallaght',   'Tallaght University Hospital',
 'Locksmith Tallaght — emergency PSA-licensed locksmith covering all of Tallaght and surrounding areas.',
 53.288000, -6.373000,
 'Locksmith Tallaght | 20-Min Response | PSA Licensed',
 'Need a locksmith in Tallaght? PSA-licensed, 20-minute emergency response near The Square. 24/7 lockouts, repairs and lock changes.',
 'locksmith tallaght', 50),

('locksmith-swords',    'Swords',    'dublin_county', NULL, 'Pavilions Shopping Centre','Swords Castle',
 'Locksmith Swords — PSA-licensed locksmith for North County Dublin and Dublin Airport.',
 53.459000, -6.218000,
 'Locksmith Swords | North Dublin Emergency Locksmith',
 'Locksmith services in Swords, Co. Dublin. Fast PSA-licensed response near Pavilions Shopping Centre and Dublin Airport.',
 'locksmith swords', 51),

('locksmith-saggart',   'Saggart',   'dublin_county', NULL, 'Citywest Shopping Centre','Citywest Hotel',
 'Locksmith Saggart — covering Citywest, Rathcoole and surrounding West Dublin.',
 53.282000, -6.443000,
 'Locksmith Saggart & Citywest | West Dublin',
 'Locksmith for Saggart, Citywest and Rathcoole. PSA licensed with 20-minute emergency response. No call-out fee.',
 'locksmith saggart', 52);

-- Seed FAQs
INSERT IGNORE INTO `faqs` (`question`, `answer`, `is_global`, `sort_order`) VALUES
('How fast can a locksmith reach me in Dublin?',
 'Our average response time across Dublin city and the Greater Dublin Area is 20 to 30 minutes, 24 hours a day.', 1, 1),
('Are you PSA licensed?',
 'Yes. Operating as a locksmith in Ireland legally requires a Private Security Authority (PSA) licence. Our licence number is displayed in the footer of every page.', 1, 2),
('Is there a call-out fee?',
 'No. We never charge a call-out fee. You only pay for the work carried out, and we provide a fixed price before starting.', 1, 3),
('Do you provide a guarantee?',
 'Yes. All our work and parts are covered by a 12-month guarantee.', 1, 4),
('Will you damage my door?',
 'No. Our PSA-licensed technicians use non-destructive entry methods on more than 95% of jobs.', 1, 5);

-- Seed example testimonials
INSERT IGNORE INTO `testimonials` (`customer_name`, `customer_location`, `rating`, `review_body`, `is_featured`, `review_date`) VALUES
('Sarah O''Brien',    'Rathmines, D6',          5, 'Locked out at 1am — they were at my door in 18 minutes and had me inside in 5. Brilliant service.', 1, '2026-04-21'),
('Mark Kavanagh',     'Tallaght',               5, 'Quoted me a fixed price on the phone, no hidden fees. Fitted a new anti-snap cylinder same day.', 1, '2026-04-15'),
('Aoife Murphy',      'Sandyford, D18',         5, 'Genuinely the fastest locksmith in Dublin. Polite, professional and reasonably priced.', 1, '2026-04-09'),
('Liam Byrne',        'Blanchardstown, D15',    5, 'Came out on a Sunday for a burglary repair. Sorted insurance paperwork too. Highly recommend.', 1, '2026-03-30'),
('Niamh Walsh',       'Swords',                 5, 'Lost my car keys at the airport. They cut and programmed a new key on-site in under an hour.', 0, '2026-03-22');

-- Seed price list (matches the printed list on the live site)
INSERT IGNORE INTO `pricing_items` (`label`, `price_text`, `price_from`, `note`, `sort_order`) VALUES
('Match Prices — Home & Commercial Lockouts', '€95',         95.00,  'Non-destructive entry, no damage in 95% of cases.', 1),
('Anti Snap Cylinder Installation',           '€115',        115.00, 'TS007 3-star anti-snap cylinder fitted.',          2),
('5 Lever Dead Lock Installation',            '€125',        125.00, 'BS3621 5-lever — insurance compliant.',            3),
('Multipoint Lock Installation',              '€175 – €245', 175.00, 'Price depends on door / mechanism (UPVC, composite).', 4),
('Dead Locking Nightlatch Installation',      '€128',        128.00, 'BS3621 deadlocking nightlatch.',                   5),
('Traditional Night Latch Installation',      '€98',         98.00,  'Yale-style classic night latch.',                  6),
('Window Locks for PVC or Timber Windows',    '€15',         15.00,  'Per lock. Bulk discounts on whole-house jobs.',    7),
('Restricting Bolt for Patio Doors',          '€105',        105.00, 'Anti-lift restrictor for sliding patio doors.',    8);

-- ===== Extended catalog + brand details =====

-- ---------- Business contact details ----------
INSERT INTO `settings` (`setting_key`,`setting_value`) VALUES
('business_name',    'Locksmiths.ie'),
('phone',            '(01) 878 2720'),
('phone_e164',       '+35318782720'),
('whatsapp',         '+35318782720'),
('email',            'info@locksmiths.ie'),
('address_street',   'North City'),
('address_city',     'Dublin 1'),
('address_postcode', 'D01 F297'),
('address_country',  'IE'),
('psa_license',      'PSA 00709'),
('logo',             '/assets/images/locksmiths-ie-logo-horizontal.svg'),
('social_facebook', 'https://www.facebook.com/p/LocksmithsIE-100057039626907/'),
('social_twitter',   'https://twitter.com/IeLocksmiths'),
('social_pinterest', 'https://www.pinterest.com/ielocksmiths/'),
('social_instagram', ''),
('social_youtube',   ''),
('social_linkedin',  ''),
('custom_css',       '')
ON DUPLICATE KEY UPDATE `setting_value` = VALUES(`setting_value`);

-- ---------- Add new services (skip if slug already exists) ----------
INSERT IGNORE INTO `services`
  (`slug`,`title`,`category`,`short_description`,`body`,`icon`,`meta_title`,`meta_description`,`focus_keyword`,`price_from`,`sort_order`) VALUES

-- Emergency / 24/7
('emergency-locksmith-dublin', 'Emergency Locksmith Dublin', 'emergency',
 'Round-the-clock PSA-licensed emergency locksmith covering all of Dublin.',
 '<p>Our 24/7 emergency locksmith team responds across Dublin city and the Greater Dublin Area in 20–30 minutes. Lockouts, break-in repairs, broken keys, snapped cylinders — fixed on the first visit.</p>',
 'siren', 'Emergency Locksmith Dublin | 24/7 PSA Licensed',
 'PSA-licensed emergency locksmith Dublin. 20-min response, 24/7, no call-out fee. Lockouts, lock changes and burglary repairs.',
 'emergency locksmith dublin', 90.00, 10),

('24-hour-locksmith', '24 Hour Locksmith', 'emergency',
 'A locksmith on call 24 hours a day, 365 days a year.',
 '<p>We never close. Our 24-hour Dublin locksmith team are dispatched day and night for lockouts, break-ins and emergency lock changes.</p>',
 'clock', '24 Hour Locksmith Dublin | Always Open',
 '24 hour locksmith Dublin — PSA-licensed, fast response, no call-out fee. Open 24/7/365.',
 '24 hour locksmith dublin', 90.00, 11),

('locksmith-dublin-24-7', 'Locksmith Dublin 24/7', 'emergency',
 'Always-open Dublin locksmith. Phones answered immediately, fast on-site response.',
 '<p>When you need a locksmith in Dublin at 3am, you need someone who actually answers the phone. We do — 24 hours a day, 7 days a week, including bank holidays.</p>',
 'phone', 'Locksmith Dublin 24/7 | PSA Licensed Emergency Service',
 '24/7 Dublin locksmith. PSA licensed, 20-minute response, no call-out fee, 12-month guarantee on every job.',
 'locksmith dublin 24/7', 90.00, 12),

('locksmith-near-me-dublin', 'Locksmith Near Me — Dublin', 'emergency',
 'Local PSA-licensed locksmith covering every Dublin postcode and surrounding county.',
 '<p>Searching for a "locksmith near me" in Dublin? We have technicians spread across Dublin city and county so we are usually 15 minutes from your door — Tallaght, Swords, Blanchardstown, Dundrum, Lucan or anywhere inside the M50.</p>',
 'pin', 'Locksmith Near Me Dublin | 15-Min Local Response',
 'Local Dublin locksmith near you. PSA licensed, 15-minute average response across Dublin city and county. Call now.',
 'locksmith near me dublin', 90.00, 13),

('mobile-locksmith-dublin', 'Mobile Locksmith Dublin', 'emergency',
 'Fully-equipped mobile locksmith vans across Dublin — work completed at your door.',
 '<p>Our mobile workshops are stocked with cylinders, multipoint mechanisms, smart locks, key blanks and programming tools so 95% of jobs are finished in a single visit.</p>',
 'truck', 'Mobile Locksmith Dublin | Fully-Equipped Vans',
 'Mobile locksmith Dublin — vans stocked with locks, mechanisms and key blanks. Most jobs finished in one visit.',
 'mobile locksmith dublin', 90.00, 14),

('same-day-locksmith', 'Same Day Locksmith Service', 'emergency',
 'Booked today, fixed today — guaranteed across Dublin.',
 '<p>Need it sorted before you go to bed? Our same-day Dublin locksmith service guarantees attendance and completion the same calendar day.</p>',
 'calendar', 'Same Day Locksmith Dublin | Booked & Fixed Today',
 'Same-day locksmith service across Dublin. PSA licensed, fixed price, 12-month guarantee.',
 'same day locksmith dublin', 90.00, 15),

('weekend-locksmith', 'Weekend Locksmith Service', 'emergency',
 'Saturday and Sunday locksmith service — no weekend surcharge.',
 '<p>Most weekend lockouts happen between 1am and 4am. We dispatch the same way we do midweek: 20-minute response, fixed price, no surcharge.</p>',
 'calendar', 'Weekend Locksmith Dublin | No Surcharge',
 'Weekend locksmith Dublin (Sat & Sun). PSA licensed, no weekend surcharge, fast response.',
 'weekend locksmith dublin', 90.00, 16),

('night-locksmith', 'Night Locksmith Service', 'emergency',
 'Out-of-hours night locksmith — phones answered all night.',
 '<p>Every night between 10pm and 7am, our on-call team is dispatched within minutes of the call.</p>',
 'moon', 'Night Locksmith Dublin | Out of Hours Specialist',
 'Night locksmith Dublin. Phones answered all night. PSA-licensed, fast response, fixed price.',
 'night locksmith dublin', 90.00, 17),

('emergency-door-opening', 'Emergency Door Opening', 'emergency',
 'Locked-out door opening with no damage, day or night.',
 '<p>Whether you have left the keys inside, snapped a key off in the lock or lost them entirely, we open the door with no damage in over 95% of cases.</p>',
 'door', 'Emergency Door Opening Dublin | Non-Destructive',
 'Emergency door opening across Dublin. Non-destructive entry in 95% of cases. PSA licensed.',
 'emergency door opening dublin', 90.00, 18),

-- Residential
('residential-locksmith', 'Residential Locksmith', 'residential',
 'Home locksmith services — lock changes, upgrades and entry.',
 '<p>House lockouts, lock changes after losing keys, upgrades to anti-snap cylinders, fitting deadbolts on apartment doors. Insurance-compliant residential locksmithing across Dublin.</p>',
 'home', 'Residential Locksmith Dublin | Home Lock Changes',
 'Residential locksmith Dublin. Lock changes, upgrades, lockouts and break-in repairs. PSA licensed.',
 'residential locksmith dublin', 100.00, 20),

('house-lockout', 'House Lockout Assistance', 'emergency',
 'Locked out of your house? Inside in 5 minutes with no door damage.',
 '<p>Our techs use bypass tools and PSA-approved entry methods — 95% of house lockouts are opened with no damage to the door, lock or frame.</p>',
 'home', 'House Lockout Dublin | No Damage Entry',
 'Locked out of your house in Dublin? PSA-licensed locksmith on-site in 20 minutes with non-destructive entry.',
 'house lockout dublin', 90.00, 21),

('lock-replacement', 'Lock Replacement', 'residential',
 'Full lock replacement — Yale, ABS, Mul-T-Lock, Brisant.',
 '<p>Replacing a worn or insurance-non-compliant lock with a modern anti-snap, anti-pick, anti-drill cylinder to BS3621 / TS007 standard.</p>',
 'lock', 'Lock Replacement Dublin | Anti-Snap Upgrades',
 'Lock replacement across Dublin — Yale, Mul-T-Lock, Brisant ABS to BS3621 / TS007. PSA licensed.',
 'lock replacement dublin', 110.00, 22),

('lock-installation', 'Lock Installation', 'residential',
 'New lock installation on doors, gates, sheds and apartments.',
 '<p>Supply and install new mortice locks, deadbolts, night latches, multipoint mechanisms and high-security cylinders.</p>',
 'tool', 'Lock Installation Dublin | New Lock Fitting',
 'New lock installation Dublin. Mortice locks, deadbolts, night latches and multipoint mechanisms.',
 'lock installation dublin', 110.00, 23),

('lock-repair', 'Lock Repair', 'residential',
 'Lock not turning? Sticking? We diagnose and repair.',
 '<p>Most "broken" locks are actually misaligned doors, worn cylinders or jammed multipoint gearboxes. Our techs identify and repair the root cause without replacing the whole lock.</p>',
 'wrench', 'Lock Repair Dublin | Same-Day Service',
 'Lock repair Dublin. Sticking, jammed or broken locks repaired same-day. PSA licensed.',
 'lock repair dublin', 90.00, 24),

('lock-rekeying', 'Lock Rekeying', 'residential',
 'Change which keys open your locks without replacing the lock itself.',
 '<p>Rekeying changes the cylinder pins so old keys no longer work. Cheaper than full replacement — ideal after losing keys, ending a tenancy or buying a property.</p>',
 'key', 'Lock Rekeying Dublin | Cheaper Than New Locks',
 'Lock rekeying Dublin. Reset locks so old keys no longer work — cheaper than replacement. PSA licensed.',
 'lock rekeying dublin', 90.00, 25),

('tenant-lock-changes', 'Tenant Lock Changes', 'residential',
 'Lock changes between tenancies — quick, insurance-compliant, with copies.',
 '<p>Standard service for landlords and letting agents: change cylinders, supply 3 keys, provide an itemised invoice.</p>',
 'home', 'Tenant Lock Changes Dublin | Landlord Service',
 'Tenant lock changes for Dublin landlords. PSA licensed, 3 keys included, fixed price.',
 'tenant lock change dublin', 95.00, 26),

('post-break-in-repairs', 'Post Break-In Repairs', 'residential',
 'Same-day burglary repair with insurance-approved report.',
 '<p>We secure the property immediately, replace damaged frames and locks, upgrade to anti-snap cylinders and supply a written insurance report.</p>',
 'shield', 'Post Break-In Repair Dublin | Insurance Report',
 'Same-day burglary repair Dublin with insurance-approved report. PSA licensed.',
 'burglary repair dublin', 130.00, 27),

('security-upgrades', 'Home Security Upgrades', 'residential',
 'Upgrade to insurance-grade locks, hinges and reinforcements.',
 '<p>Most older Dublin homes have euro cylinders that snap in seconds. We upgrade to TS007 3-star anti-snap cylinders, hinge bolts and reinforced strike plates.</p>',
 'shield', 'Home Security Upgrades Dublin | TS007 3-Star',
 'Home security upgrades Dublin. TS007 3-star anti-snap cylinders, hinge bolts, reinforced strike plates.',
 'home security upgrades dublin', 140.00, 28),

('anti-snap-locks', 'Anti-Snap Lock Installation', 'residential',
 'TS007 3-star anti-snap, anti-pick, anti-drill cylinders.',
 '<p>The single biggest upgrade you can make. Brisant Ultion, Mul-T-Lock MT5+ and ABS cylinders fitted in under 30 minutes.</p>',
 'lock', 'Anti-Snap Lock Installation Dublin | Brisant Ultion',
 'Anti-snap lock installation Dublin. TS007 3-star Brisant Ultion, Mul-T-Lock and ABS cylinders.',
 'anti snap locks dublin', 120.00, 29),

('high-security-locks', 'High Security Locks', 'residential',
 'Sold-secure high security locks for valuables and property.',
 '<p>Mul-T-Lock MT5+, ABS Avocet and Brisant Ultion cylinders for homes with elevated security needs.</p>',
 'shield', 'High Security Locks Dublin | Sold Secure',
 'High security locks Dublin — Mul-T-Lock, ABS, Brisant Ultion. Sold-Secure rated.',
 'high security locks dublin', 160.00, 30),

('door-lock-repair', 'Door Lock Repair', 'residential',
 'All door lock types repaired — same day across Dublin.',
 '<p>From a sticky Yale night latch to a snapped multipoint mechanism, we repair all common door locks. Often cheaper than a replacement.</p>',
 'wrench', 'Door Lock Repair Dublin | Same Day Service',
 'Door lock repair Dublin. All lock types — Yale, mortice, multipoint. PSA licensed, same day.',
 'door lock repair dublin', 95.00, 31),

('door-handle-repair', 'Door Handle Repair', 'residential',
 'Loose, broken or seized door handles repaired or replaced.',
 '<p>We supply and fit lever-on-rose, lever-on-backplate and pull handles for residential and commercial doors.</p>',
 'tool', 'Door Handle Repair Dublin | Same Day',
 'Door handle repair and replacement Dublin. Same-day PSA-licensed service.',
 'door handle repair dublin', 90.00, 32),

('door-closer-installation', 'Door Closer Installation', 'commercial',
 'Overhead and concealed door closers fitted to fire and access doors.',
 '<p>Briton, Dorma and Geze closers fitted to commercial, hotel and apartment-block doors. Fire-rated to IS EN 1154.</p>',
 'door', 'Door Closer Installation Dublin | Fire Rated',
 'Door closer installation Dublin — Briton, Dorma, Geze. Fire-rated IS EN 1154.',
 'door closer installation dublin', 130.00, 33),

('night-latch', 'Night Latch Installation', 'residential',
 'Yale-style night latches supplied and fitted.',
 '<p>The classic "Yale" night latch — 2- and 3-lever, deadlocking, BS3621 versions. Supplied and fitted same day.</p>',
 'lock', 'Night Latch Installation Dublin | Yale BS3621',
 'Yale night latch installation Dublin. BS3621 deadlocking versions for insurance compliance.',
 'night latch installation dublin', 110.00, 34),

('deadbolt-installation', 'Deadbolt Installation', 'residential',
 'Single- and double-cylinder deadbolts fitted to wood doors.',
 '<p>5-lever deadbolts to BS3621, fitted in under 90 minutes including drilling and chiselling.</p>',
 'lock', 'Deadbolt Installation Dublin | BS3621',
 'Deadbolt installation Dublin — 5-lever BS3621. Insurance-compliant.',
 'deadbolt installation dublin', 130.00, 35),

('mortice-lock-installation', 'Mortice Lock Installation', 'residential',
 '5-lever mortice deadlocks and sashlocks for wooden doors.',
 '<p>BS3621 5-lever mortice locks — the standard requirement on most home insurance policies in Ireland.</p>',
 'lock', 'Mortice Lock Installation Dublin | 5-Lever BS3621',
 'Mortice lock installation Dublin — 5-lever BS3621 for insurance compliance.',
 'mortice lock installation dublin', 130.00, 36),

('yale-lock-repair', 'Yale Lock Repair', 'residential',
 'Yale night latches and mortice locks serviced and repaired.',
 '<p>Yale parts kept on every van. Worn cams, broken keys, jammed deadlocking mechanisms — fixed same-day.</p>',
 'lock', 'Yale Lock Repair Dublin | Same Day',
 'Yale lock repair Dublin. Night latches and mortice locks fixed same-day.',
 'yale lock repair dublin', 95.00, 37),

-- UPVC / Composite doors
('upvc-door-lock-repair', 'UPVC Door Lock Repair', 'residential',
 'UPVC door lock not turning? We repair the cylinder or mechanism same-day.',
 '<p>Most UPVC door issues come down to a worn euro cylinder or a failed gearbox in the multipoint mechanism. We carry spares for ERA, Yale, GU, Fuhr, Roto and Winkhaus.</p>',
 'door', 'UPVC Door Lock Repair Dublin | Same Day',
 'UPVC door lock repair Dublin. Cylinders and gearboxes fixed same-day. PSA licensed.',
 'upvc door lock repair dublin', 110.00, 38),

('upvc-mechanism-repair', 'UPVC Door Mechanism Repair', 'residential',
 'Multipoint locking strip replacement on UPVC and composite doors.',
 '<p>If the handle has gone floppy or stiff, the gearbox inside the multipoint strip has failed. Replacing it restores the door without replacing the whole strip in most cases.</p>',
 'tool', 'UPVC Mechanism Repair Dublin | Multipoint',
 'UPVC multipoint mechanism repair Dublin. Gearbox replacement same-day.',
 'upvc mechanism repair dublin', 160.00, 39),

('multipoint-lock-repair', 'Multipoint Lock Repair', 'residential',
 'Multipoint mechanism repair across all UPVC, composite and aluminium doors.',
 '<p>GU, Fuhr, Roto, Winkhaus, ERA, Yale, Avocet — we carry the gearboxes and full strips.</p>',
 'tool', 'Multipoint Lock Repair Dublin | All Brands',
 'Multipoint lock repair Dublin — GU, Fuhr, Roto, Winkhaus, ERA, Yale.',
 'multipoint lock repair dublin', 150.00, 40),

-- Smart / Digital
('digital-lock-installation', 'Digital Lock Installation', 'residential',
 'Keypad and code locks for homes, offices and Airbnbs.',
 '<p>Battery and mains-powered digital locks fitted on hinged and sliding doors. Ideal for short-term lets and busy households.</p>',
 'wifi', 'Digital Lock Installation Dublin',
 'Digital lock installation Dublin. Keypad and code locks for homes, offices and Airbnbs.',
 'digital lock installation dublin', 200.00, 41),

('smart-lock-installation', 'Smart Lock Installation', 'residential',
 'Yale, Nuki and August smart locks with full smart-home integration.',
 '<p>Pair with HomeKit, Google Home and Alexa, configure auto-lock, set up family codes and integrate with door sensors.</p>',
 'wifi', 'Smart Lock Installation Dublin',
 'Smart lock installation Dublin. Yale, Nuki, August. HomeKit, Google Home, Alexa integration.',
 'smart lock installation dublin', 220.00, 42),

('fingerprint-lock', 'Fingerprint Lock Installation', 'residential',
 'Biometric fingerprint locks fitted to home and office doors.',
 '<p>Aqara, eufy and Yale fingerprint locks supplied and fitted in under an hour.</p>',
 'fingerprint', 'Fingerprint Lock Installation Dublin',
 'Fingerprint lock installation Dublin. Aqara, eufy, Yale biometric locks.',
 'fingerprint lock dublin', 250.00, 43),

('electronic-lock-repair', 'Electronic Lock Repair', 'commercial',
 'Repairs to electric strikes, mag-locks and electronic deadlocks.',
 '<p>Common electronic lock failures: power supply, releases, request-to-exit buttons, electric strikes. We diagnose and repair on-site.</p>',
 'wrench', 'Electronic Lock Repair Dublin',
 'Electronic lock repair Dublin. Electric strikes, mag-locks, deadbolts.',
 'electronic lock repair dublin', 140.00, 44),

-- Keys
('key-cutting', 'Key Cutting', 'residential',
 'Mobile key cutting for home, office and car keys.',
 '<p>Most domestic keys cut on-site in 60 seconds — Yale, Mul-T-Lock, ABS, Avocet, ERA, Era Fortress, Chubb, Banham.</p>',
 'key', 'Key Cutting Dublin | Mobile Service',
 'Mobile key cutting Dublin. All domestic and most commercial keys cut on-site.',
 'key cutting dublin', 90.00, 45),

('lost-keys', 'Lost Keys Service', 'emergency',
 'Lost keys? We make a new key and rekey the locks.',
 '<p>If you have lost the only key, we open the door, generate a new key and rekey the lock — all in one visit.</p>',
 'key', 'Lost Keys Locksmith Dublin',
 'Lost keys Dublin — locksmith opens door, makes a new key and rekeys the lock in one visit.',
 'lost keys dublin', 110.00, 46),

('broken-key-extraction', 'Broken Key Extraction', 'emergency',
 'Snapped a key in the lock? We extract it without damaging the cylinder.',
 '<p>Specialist extractor tools mean the cylinder almost never has to be replaced.</p>',
 'key', 'Broken Key Extraction Dublin | Same Day',
 'Broken key extraction Dublin. PSA-licensed, no cylinder damage.',
 'broken key extraction dublin', 90.00, 47),

('lockout-service', 'Lockout Service', 'emergency',
 'House, office and car lockout assistance across Dublin.',
 '<p>Our PSA-licensed techs open homes, offices, vans and cars with no damage in over 95% of jobs.</p>',
 'key', 'Lockout Service Dublin | 20-Min Response',
 'Locked out in Dublin? PSA-licensed lockout service with 20-minute response.',
 'lockout service dublin', 90.00, 48),

('office-lockout', 'Office Lockout Service', 'commercial',
 'Office and commercial lockouts opened in 20 minutes.',
 '<p>Locked out of your office or business premises? We open and rekey if needed — discreet and fast.</p>',
 'briefcase', 'Office Lockout Dublin',
 'Office lockout service Dublin. Discreet and fast PSA-licensed entry.',
 'office lockout dublin', 110.00, 49),

-- Commercial
('commercial-locksmith', 'Commercial Locksmith', 'commercial',
 'Master-key suites, access control, panic bars and security upgrades.',
 '<p>End-to-end commercial locksmith services — from a single re-key to a full master-key system across multiple sites.</p>',
 'briefcase', 'Commercial Locksmith Dublin',
 'Commercial locksmith Dublin. Master-key suites, access control, panic bars.',
 'commercial locksmith dublin', 200.00, 50),

('master-key-systems', 'Master Key Systems', 'commercial',
 'One key opens many doors — multi-level keying for offices, schools and apartment blocks.',
 '<p>Designed and installed using Mul-T-Lock, Abloy, Iseo and Cisa platforms.</p>',
 'key', 'Master Key Systems Dublin',
 'Master-key systems Dublin — Mul-T-Lock, Abloy, Iseo, Cisa platforms.',
 'master key systems dublin', 350.00, 51),

('access-control-systems', 'Access Control Systems', 'commercial',
 'Card, fob and PIN access control for offices and apartment blocks.',
 '<p>Paxton Net2, Salto KS, HID and Suprema systems designed, installed and serviced.</p>',
 'shield', 'Access Control Dublin | Paxton, Salto, HID',
 'Access control Dublin — Paxton, Salto, HID, Suprema. Cards, fobs, PIN, biometric.',
 'access control dublin', 600.00, 52),

('access-keypad-systems', 'Access Keypad Systems', 'commercial',
 'Standalone keypad locks for staff entrances and back doors.',
 '<p>Codelocks, Borg, Lockey — supplied and fitted on standalone doors.</p>',
 'tool', 'Access Keypad Systems Dublin',
 'Access keypad systems Dublin — Codelocks, Borg, Lockey.',
 'access keypad dublin', 200.00, 53),

('panic-bar', 'Panic Bar Installation', 'commercial',
 'Push-pad and crash bars on fire-exit doors.',
 '<p>Single-, two- and three-point panic hardware to IS EN 1125. Compulsory on most fire-exit routes.</p>',
 'shield', 'Panic Bar Installation Dublin | IS EN 1125',
 'Panic bar installation Dublin — push-pad, crash bars to IS EN 1125.',
 'panic bar installation dublin', 220.00, 54),

('security-door-installation', 'Security Door Installation', 'commercial',
 'Steel and reinforced security doors fitted to homes and businesses.',
 '<p>Anti-burglary doors with multi-point locking, anti-drill cylinders and reinforced frames.</p>',
 'door', 'Security Door Installation Dublin',
 'Security door installation Dublin — multi-point, anti-drill.',
 'security door installation dublin', 1200.00, 55),

('fire-door-lock-installation', 'Fire Door Lock Installation', 'commercial',
 'Fire-rated locks on FD30 and FD60 doors.',
 '<p>Mortice locks, escape locks and panic furniture rated to IS EN 1634.</p>',
 'shield', 'Fire Door Lock Installation Dublin | IS EN 1634',
 'Fire door lock installation Dublin — IS EN 1634 rated.',
 'fire door lock installation dublin', 170.00, 56),

('cctv-installation', 'CCTV Installation', 'commercial',
 'IP and analogue CCTV systems for homes and businesses.',
 '<p>HikVision and Dahua systems with night-vision, motion detection and remote viewing on iOS and Android.</p>',
 'camera', 'CCTV Installation Dublin',
 'CCTV installation Dublin — HikVision and Dahua, remote viewing on iOS / Android.',
 'cctv installation dublin', 450.00, 57),

('alarm-installation', 'Alarm Installation', 'commercial',
 'Wired and wireless intruder alarms.',
 '<p>HKC, Texecom and Honeywell systems compliant with EN 50131. Optional 24/7 monitoring.</p>',
 'shield', 'Alarm Installation Dublin | EN 50131',
 'Intruder alarm installation Dublin — HKC, Texecom, Honeywell.',
 'alarm installation dublin', 550.00, 58),

('intercom-systems', 'Intercom Systems', 'commercial',
 'Audio and video intercom for apartment blocks and businesses.',
 '<p>Comelit, Aiphone and Fermax systems. Connect to phone via 4G or wifi gateway.</p>',
 'phone', 'Intercom Systems Dublin',
 'Audio and video intercom installation Dublin — Comelit, Aiphone, Fermax.',
 'intercom systems dublin', 380.00, 59),

('smart-home-security', 'Smart Home Security', 'residential',
 'Smart locks, cameras and sensors all in one system.',
 '<p>Aqara, eufy and Ring ecosystems integrated with HomeKit and Google Home.</p>',
 'wifi', 'Smart Home Security Dublin',
 'Smart home security Dublin — locks, cameras, sensors. HomeKit, Google Home.',
 'smart home security dublin', 350.00, 60),

-- Specialist
('garage-door-locks', 'Garage Door Locks', 'residential',
 'Garage door locks supplied, repaired and replaced.',
 '<p>Up-and-over and roller-shutter garage door locks. Anti-snap T-handle replacements.</p>',
 'lock', 'Garage Door Locks Dublin',
 'Garage door locks Dublin — repair and replacement.',
 'garage door locks dublin', 110.00, 61),

('window-lock-repair', 'Window Lock Repair', 'residential',
 'UPVC and aluminium window locks repaired and replaced.',
 '<p>Espagnolette, shootbolt and cockspur window locks. Insurance-compliant key-locking versions fitted.</p>',
 'lock', 'Window Lock Repair Dublin',
 'Window lock repair Dublin — espag, shootbolt, cockspur.',
 'window lock repair dublin', 90.00, 62),

('safe-installation', 'Safe Installation', 'safe',
 'Domestic and commercial safes supplied and fitted.',
 '<p>Burton, Phoenix, Chubb and Yale safes — bolted into floor or wall.</p>',
 'briefcase', 'Safe Installation Dublin',
 'Safe installation Dublin — Burton, Phoenix, Chubb, Yale.',
 'safe installation dublin', 280.00, 63),

('safe-lock-repair', 'Safe Lock Repair', 'safe',
 'Mechanical and electronic safe locks repaired.',
 '<p>Sargent & Greenleaf, La Gard, Mauer and Tecnosicurezza safe locks repaired and replaced.</p>',
 'wrench', 'Safe Lock Repair Dublin',
 'Safe lock repair Dublin — mechanical and electronic.',
 'safe lock repair dublin', 220.00, 64),

('mailbox-lock', 'Mailbox Lock Replacement', 'residential',
 'Apartment-block and post-box mailbox locks replaced.',
 '<p>Cam locks for mailboxes — keys provided. Block-wide replacements available.</p>',
 'lock', 'Mailbox Lock Replacement Dublin',
 'Mailbox lock replacement Dublin — apartment blocks, post boxes.',
 'mailbox lock replacement dublin', 90.00, 65),

('shutter-lock-repair', 'Shutter Lock Repair', 'commercial',
 'Roller-shutter locks repaired on retail and warehouse units.',
 '<p>Floor sockets, T-handles and slam locks repaired and replaced.</p>',
 'tool', 'Shutter Lock Repair Dublin',
 'Roller-shutter lock repair Dublin — retail and warehouse.',
 'shutter lock repair dublin', 150.00, 66),

('gate-lock-installation', 'Gate Lock Installation', 'residential',
 'Pedestrian and driveway gate locks fitted.',
 '<p>Locinox, AMF, Adler and bespoke padlocks supplied for steel and wood gates.</p>',
 'lock', 'Gate Lock Installation Dublin',
 'Gate lock installation Dublin — Locinox, AMF, Adler.',
 'gate lock installation dublin', 140.00, 67),

('patio-door-lock-repair', 'Patio Door Lock Repair', 'residential',
 'Sliding patio door locks repaired.',
 '<p>Hookbolt and shootbolt patio mechanisms — common Yale, Mila and Maco systems.</p>',
 'door', 'Patio Door Lock Repair Dublin',
 'Patio door lock repair Dublin — Yale, Mila, Maco.',
 'patio door lock repair dublin', 130.00, 68),

('sliding-door-lock-repair', 'Sliding Door Lock Repair', 'residential',
 'Aluminium and UPVC sliding doors fixed.',
 '<p>Re-aligning rollers, replacing locks and adjusting tracks.</p>',
 'door', 'Sliding Door Lock Repair Dublin',
 'Sliding door lock repair Dublin — UPVC and aluminium.',
 'sliding door lock repair dublin', 130.00, 69),

('french-door-lock-repair', 'French Door Lock Repair', 'residential',
 'French door multipoint mechanisms repaired.',
 '<p>Active and inactive leaf gearboxes, shootbolts and flush bolts.</p>',
 'door', 'French Door Lock Repair Dublin',
 'French door lock repair Dublin — multipoint mechanisms.',
 'french door lock repair dublin', 140.00, 70),

-- Automotive
('auto-locksmith', 'Auto Locksmith', 'automotive',
 'On-site auto locksmith — keys, fobs, programming, lockouts.',
 '<p>All major makes — Ford, VW, Audi, BMW, Toyota, Hyundai, Nissan, Renault, Peugeot. Faster and cheaper than the dealer.</p>',
 'car', 'Auto Locksmith Dublin | Car Keys & Programming',
 'Auto locksmith Dublin — keys, fobs, programming for all major makes. Cheaper than the dealer.',
 'auto locksmith dublin', 150.00, 71),

('car-locksmith-dublin', 'Car Locksmith Dublin', 'automotive',
 'Specialist car locksmith covering all of Dublin and Greater Dublin Area.',
 '<p>Car key replacement, transponder programming, key fob coding and on-site car unlocking — usually faster than the AA and far cheaper than the main dealer.</p>',
 'car', 'Car Locksmith Dublin | Keys, Fobs, Lockouts',
 'Car locksmith Dublin — keys, fobs, programming, on-site unlocks. Cheaper than the dealer.',
 'car locksmith dublin', 150.00, 72),

('vehicle-unlock', 'Vehicle Unlock Service', 'automotive',
 'Locked your keys in the car? On-site unlock with no damage.',
 '<p>Air wedge and bypass tools — no broken windows, no damaged doors.</p>',
 'car', 'Vehicle Unlock Dublin | No Damage',
 'Vehicle unlock service Dublin — no damage entry on all makes.',
 'vehicle unlock dublin', 90.00, 73),

('ignition-repair', 'Ignition Repair', 'automotive',
 'Stuck or seized ignition cylinders repaired or replaced.',
 '<p>Common Ford, VW, BMW and Renault ignition lock failures fixed on-site.</p>',
 'tool', 'Ignition Repair Dublin',
 'Car ignition repair Dublin — stuck and seized cylinders.',
 'ignition repair dublin', 200.00, 74),

('car-key-programming', 'Car Key Programming', 'automotive',
 'Transponder car keys programmed on-site for most makes.',
 '<p>OBD2 programming or full pin-code reading where required. We carry blanks for the most common 200 vehicles in Ireland.</p>',
 'car', 'Car Key Programming Dublin | On-Site',
 'Car key programming Dublin — OBD and pin-code methods. PSA licensed.',
 'car key programming dublin', 180.00, 75),

('transponder-key-programming', 'Transponder Key Programming', 'automotive',
 'Chipped transponder keys cut and coded.',
 '<p>Megamos, Hitag, Texas, Philips chips programmed and paired to your car.</p>',
 'car', 'Transponder Key Programming Dublin',
 'Transponder key programming Dublin — Megamos, Hitag, Texas, Philips.',
 'transponder key programming dublin', 180.00, 76),

('key-fob-replacement', 'Key Fob Replacement', 'automotive',
 'Replacement remote key fobs supplied and coded.',
 '<p>Most makes covered — including keyless entry / keyless go fobs.</p>',
 'car', 'Key Fob Replacement Dublin',
 'Key fob replacement Dublin — keyless entry and remote fobs.',
 'key fob replacement dublin', 160.00, 77),

('car-key-replacement', 'Car Key Replacement Dublin', 'automotive',
 'Lost car keys? Cut and coded on-site, no tow needed.',
 '<p>We come to you. New keys and remotes generated on-site for all major Dublin-region vehicles.</p>',
 'car', 'Car Key Replacement Dublin | On-Site',
 'Car key replacement Dublin. On-site, no dealer needed. PSA licensed.',
 'car key replacement dublin', 150.00, 78),

('van-locksmith', 'Van Locksmith Services', 'automotive',
 'Sprinter, Transit, Crafter and Master vans serviced.',
 '<p>Slam locks, hooks, deadlocks and replacement keys for tradesman vans.</p>',
 'truck', 'Van Locksmith Dublin | Slam Locks & Deadlocks',
 'Van locksmith Dublin — slam locks, deadlocks, replacement keys.',
 'van locksmith dublin', 180.00, 79),

('motorbike-key', 'Motorbike Key Replacement', 'automotive',
 'Replacement bike keys for Honda, Yamaha, Kawasaki, BMW.',
 '<p>Cut and coded for both ignition and seat / cap.</p>',
 'key', 'Motorbike Key Replacement Dublin',
 'Motorbike key replacement Dublin — Honda, Yamaha, Kawasaki, BMW.',
 'motorbike key replacement dublin', 140.00, 80),

-- Vertical specialists
('apartment-locksmith', 'Apartment Locksmith Services', 'residential',
 'Apartment-block specialist locksmith — communal and unit doors.',
 '<p>Mul-T-Lock and Iseo restricted suites for apartment blocks. Common-area access cylinders.</p>',
 'home', 'Apartment Locksmith Dublin',
 'Apartment locksmith Dublin — communal and unit doors, restricted suites.',
 'apartment locksmith dublin', 110.00, 81),

('hotel-locksmith', 'Hotel Locksmith Services', 'commercial',
 'Hotel locksmith — Salto, VingCard and Onity systems serviced.',
 '<p>Card encoding, lock servicing, master suites and emergency override.</p>',
 'briefcase', 'Hotel Locksmith Dublin | Salto, VingCard, Onity',
 'Hotel locksmith Dublin — Salto, VingCard, Onity serviced.',
 'hotel locksmith dublin', 220.00, 82),

('retail-locksmith', 'Retail Shop Locksmith', 'commercial',
 'Shop-front shutter, door and till locks repaired.',
 '<p>End-of-day lock changes, shutter mechanisms, till locks and back-room access.</p>',
 'briefcase', 'Retail Shop Locksmith Dublin',
 'Retail shop locksmith Dublin — shutters, doors, till locks.',
 'retail locksmith dublin', 130.00, 83),

('warehouse-lock', 'Warehouse Lock Services', 'commercial',
 'Roller-shutter, sliding and personnel-door locks for warehouses.',
 '<p>Loading-bay shutters, padlocks and reinforced cylinders.</p>',
 'briefcase', 'Warehouse Locksmith Dublin',
 'Warehouse locksmith Dublin — shutters, padlocks, reinforced cylinders.',
 'warehouse locksmith dublin', 160.00, 84);

-- ---------- Locations ----------
INSERT IGNORE INTO `locations`
  (`slug`,`name`,`region`,`district_code`,`landmark`,`landmark_secondary`,`intro`,`latitude`,`longitude`,`meta_title`,`meta_description`,`focus_keyword`,`sort_order`) VALUES

('locksmith-dublin-city-centre','Dublin City Centre','dublin_city',NULL,'Trinity College','Temple Bar',
 'Locksmith Dublin City Centre — PSA-licensed emergency locksmith covering D1, D2 and the surrounding cultural quarter.',
 53.347000,-6.260000,'Locksmith Dublin City Centre | 20-Min Response',
 'PSA-licensed locksmith Dublin City Centre. 20-minute response across D1 and D2. No call-out fee.',
 'locksmith dublin city centre',0),

('locksmith-blanchardstown','Blanchardstown','dublin_county',NULL,'Blanchardstown Centre','Connolly Hospital',
 'Locksmith Blanchardstown — covering Tyrrelstown, Mulhuddart, Castleknock and the wider D15.',
 53.391500,-6.376600,'Locksmith Blanchardstown D15 | 20-Min Response',
 'Locksmith Blanchardstown — fast PSA-licensed response across D15.',
 'locksmith blanchardstown',53),

('locksmith-clondalkin','Clondalkin','dublin_county',NULL,'The Round Tower','Liffey Valley',
 'Locksmith Clondalkin — emergency locksmith for Clondalkin, Neilstown and surrounding West Dublin.',
 53.323000,-6.394000,'Locksmith Clondalkin | West Dublin Emergency',
 'Locksmith Clondalkin — PSA-licensed, 20-minute emergency response across West Dublin.',
 'locksmith clondalkin',54),

('locksmith-lucan','Lucan','dublin_county',NULL,'Lucan Village','Liffey Valley Shopping Centre',
 'Locksmith Lucan — covering Lucan, Adamstown, Esker and Liffey Valley.',
 53.357000,-6.451000,'Locksmith Lucan | West Dublin Locksmith',
 'Locksmith Lucan — PSA-licensed locksmith covering Lucan, Adamstown and Esker.',
 'locksmith lucan',55),

('locksmith-dundrum','Dundrum','dublin_county',NULL,'Dundrum Town Centre','Airfield Estate',
 'Locksmith Dundrum — covering Dundrum, Goatstown, Churchtown and surrounding D14 / D16.',
 53.290000,-6.248000,'Locksmith Dundrum | South Dublin Emergency',
 'Locksmith Dundrum — fast PSA-licensed response near Dundrum Town Centre.',
 'locksmith dundrum',56),

('locksmith-rathfarnham','Rathfarnham','dublin_county',NULL,'Rathfarnham Castle','Marlay Park',
 'Locksmith Rathfarnham — covering Rathfarnham, Ballyboden and Knocklyon.',
 53.299000,-6.290000,'Locksmith Rathfarnham | D14 / D16',
 'Locksmith Rathfarnham — PSA-licensed, 20-minute response.',
 'locksmith rathfarnham',57),

('locksmith-sandyford','Sandyford','dublin_county',NULL,'Sandyford Industrial Estate','Beacon Hospital',
 'Locksmith Sandyford — covering Sandyford, Stepaside, Stillorgan and Leopardstown.',
 53.275000,-6.226000,'Locksmith Sandyford | South County Dublin',
 'Locksmith Sandyford — PSA-licensed, fast response near the Beacon and Sandyford Industrial Estate.',
 'locksmith sandyford',58),

('locksmith-malahide','Malahide','dublin_county',NULL,'Malahide Castle','Malahide Marina',
 'Locksmith Malahide — covering Malahide, Portmarnock and Kinsealy.',
 53.450000,-6.155000,'Locksmith Malahide | Coastal North Dublin',
 'Locksmith Malahide — PSA-licensed, fast response across coastal North Dublin.',
 'locksmith malahide',59),

('locksmith-blackrock','Blackrock','dublin_county',NULL,'Blackrock Park','Frascati Shopping Centre',
 'Locksmith Blackrock — covering Blackrock, Booterstown and Stillorgan.',
 53.302000,-6.178000,'Locksmith Blackrock | South Dublin Coast',
 'Locksmith Blackrock — PSA-licensed locksmith on the South Dublin coast.',
 'locksmith blackrock',60),

('locksmith-howth','Howth','dublin_county',NULL,'Howth Harbour','Howth Head',
 'Locksmith Howth — covering Howth, Sutton and Baldoyle.',
 53.387000,-6.063000,'Locksmith Howth | Sutton & Baldoyle',
 'Locksmith Howth — PSA-licensed, fast response across the Howth peninsula.',
 'locksmith howth',61),

('locksmith-castleknock','Castleknock','dublin_county',NULL,'Phoenix Park','Castleknock Hotel',
 'Locksmith Castleknock — covering Castleknock, Carpenterstown and Ashtown.',
 53.378000,-6.363000,'Locksmith Castleknock | D15',
 'Locksmith Castleknock — PSA-licensed locksmith near Phoenix Park.',
 'locksmith castleknock',62),

('locksmith-stillorgan','Stillorgan','dublin_county',NULL,'Stillorgan Plaza','UCD Belfield',
 'Locksmith Stillorgan — covering Stillorgan, Mount Merrion and Goatstown.',
 53.290000,-6.205000,'Locksmith Stillorgan | South County Dublin',
 'Locksmith Stillorgan — PSA-licensed, 20-minute emergency response.',
 'locksmith stillorgan',63);

-- ---------- High-converting commercial-intent landing pages ----------
-- These map slugs in /pages/service-single.php so they need to live in services
-- (the URLs the user listed are stored there).
INSERT IGNORE INTO `services`
  (`slug`,`title`,`category`,`short_description`,`body`,`icon`,`meta_title`,`meta_description`,`focus_keyword`,`price_from`,`sort_order`) VALUES

('emergency-locksmith-tallaght', 'Emergency Locksmith Tallaght', 'emergency',
 '24/7 PSA-licensed emergency locksmith covering all of Tallaght.',
 '<p>Locked out in Tallaght? Our nearest van is usually no more than 12 minutes from The Square. We cover Old Bawn, Killinarden, Jobstown, Firhouse and Templeogue with the same 20-minute response promise.</p><h2>Common Tallaght jobs</h2><ul><li>House lockouts on apartment blocks around The Square</li><li>UPVC mechanism replacements on estates around Old Bawn</li><li>Anti-snap upgrades after break-ins in Jobstown / Killinarden</li><li>Office lockouts on the IDA Tallaght business park</li></ul>',
 'siren', 'Emergency Locksmith Tallaght | 12-Min Response',
 'Emergency locksmith Tallaght — PSA-licensed, 12-minute response near The Square. 24/7, no call-out fee.',
 'emergency locksmith tallaght', 90.00, 200),

('car-locksmith-swords', 'Car Locksmith Swords', 'automotive',
 'Auto locksmith covering Swords, the Pavilions and Dublin Airport.',
 '<p>Lost your car keys at the Pavilions or in the airport long-stay? Our auto locksmith van is on-site in 20 minutes, cuts and codes a new key on the spot, and gets you home — usually for half the cost of a tow to the dealer.</p>',
 'car', 'Car Locksmith Swords | Dublin Airport',
 'Car locksmith Swords. Lost car keys at the Pavilions or Dublin Airport? On-site key cutting and programming.',
 'car locksmith swords', 150.00, 201),

('locksmith-clondalkin-service', 'Locksmith Clondalkin', 'emergency',
 'PSA-licensed locksmith covering Clondalkin and surrounding West Dublin.',
 '<p>Lockouts, lock changes, smart locks and burglary repair across Clondalkin, Neilstown and Liffey Valley.</p>',
 'home', 'Locksmith Clondalkin | West Dublin Service',
 'Locksmith Clondalkin — fast PSA-licensed locksmith service across West Dublin.',
 'locksmith clondalkin', 90.00, 202),

('locksmith-lucan-service', 'Locksmith Lucan', 'emergency',
 'Lucan locksmith — covering Adamstown, Esker and Lucan Village.',
 '<p>House and apartment lockouts, anti-snap upgrades and UPVC repairs across Lucan, Adamstown and Esker.</p>',
 'home', 'Locksmith Lucan | West Dublin',
 'Locksmith Lucan — PSA licensed, 20-minute response across Lucan, Adamstown and Esker.',
 'locksmith lucan', 90.00, 203),

('locksmith-dundrum-service', 'Locksmith Dundrum', 'emergency',
 'Dundrum locksmith — covering Goatstown, Churchtown and Windy Arbour.',
 '<p>Fast lock changes, smart-lock fitting and UPVC mechanism repair around Dundrum Town Centre.</p>',
 'home', 'Locksmith Dundrum | South Dublin',
 'Locksmith Dundrum — PSA licensed, 20-minute response across South Dublin.',
 'locksmith dundrum', 90.00, 204);

-- ---------- Landlord FAQs to support the new pages ----------
INSERT IGNORE INTO `faqs` (`question`,`answer`,`is_global`,`sort_order`) VALUES
('Do you charge a call-out fee at night or on weekends?',
 'No. Our pricing is the same 24/7 — no night, weekend or bank-holiday surcharges.', 1, 6),
('Can you cut a new car key without the original?',
 'Yes — for the vast majority of vehicles we can read the immobiliser, cut a new blade and program a fresh transponder on-site.', 1, 7),
('Are you insurance-compliant?',
 'Yes. We fit cylinders and mechanisms certified to BS3621 / TS007 3-star, which is what most Irish home insurance policies require.', 1, 8);

-- =====================================================================
-- Pricing list (added in upgrade #2.1)
-- =====================================================================
CREATE TABLE IF NOT EXISTS `pricing_items` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(200) NOT NULL,
  `price_text` VARCHAR(60) NOT NULL,
  `price_from` DECIMAL(8,2) DEFAULT NULL,
  `note` VARCHAR(200) DEFAULT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 1,
  `sort_order` INT NOT NULL DEFAULT 0,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pricing_active` (`is_active`)
) ENGINE=InnoDB;

INSERT IGNORE INTO `pricing_items` (`label`, `price_text`, `price_from`, `note`, `sort_order`) VALUES
('Match Prices — Home & Commercial Lockouts', '€95',         95.00,  'Non-destructive entry, no damage in 95% of cases.', 1),
('Anti Snap Cylinder Installation',           '€115',        115.00, 'TS007 3-star anti-snap cylinder fitted.',          2),
('5 Lever Dead Lock Installation',            '€125',        125.00, 'BS3621 5-lever — insurance compliant.',            3),
('Multipoint Lock Installation',              '€175 – €245', 175.00, 'Price depends on door / mechanism (UPVC, composite).', 4),
('Dead Locking Nightlatch Installation',      '€128',        128.00, 'BS3621 deadlocking nightlatch.',                   5),
('Traditional Night Latch Installation',      '€98',         98.00,  'Yale-style classic night latch.',                  6),
('Window Locks for PVC or Timber Windows',    '€15',         15.00,  'Per lock. Bulk discounts on whole-house jobs.',    7),
('Restricting Bolt for Patio Doors',          '€105',        105.00, 'Anti-lift restrictor for sliding patio doors.',    8);

-- Pricing-related settings
INSERT INTO `settings` (`setting_key`,`setting_value`) VALUES
('minimum_price',     '€90'),
('callout_policy',    'Minimum job price €90. We do not offer free call-outs.'),
('pricing_intro',     'Indicative prices for the most common Dublin locksmith jobs. Final quote is fixed before any work begins — no surprises.')
ON DUPLICATE KEY UPDATE `setting_value` = VALUES(`setting_value`);

-- Enforce €90 minimum on every service price (call-out floor)
UPDATE `services` SET `price_from` = 90.00 WHERE `price_from` IS NOT NULL AND `price_from` < 90;
