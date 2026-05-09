-- =====================================================================
-- Locksmiths.ie — ALL-IN-ONE DATABASE INSTALL (fresh + content)
-- MySQL 8.x / MariaDB 10.x
--
-- One file, one import. This is the ONLY .sql you need.
--
--   1. Open phpMyAdmin
--   2. Select your database (e.g. eqdueglqgt)
--   3. Import → upload this file → Go
--
-- It safely DROPs all Locksmiths.ie tables, recreates them with the
-- correct utf8mb4 charset (so the € sign and Unicode arrows store
-- without errors), seeds every service / location / pricing row and
-- rewrites the body content with full SEO copy. Re-importing is safe.
--
-- Default admin login:  admin / ChangeMe!2026  (change immediately).
-- =====================================================================

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Make sure the database itself defaults to utf8mb4. Harmless if it
-- already is.
SET @db := DATABASE();
SET @sql := CONCAT('ALTER DATABASE `', @db, '` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- Location pages (Dublin districts D1-D24, towns, counties)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `locations` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `slug` VARCHAR(160) NOT NULL,
  `name` VARCHAR(120) NOT NULL,
  `region` VARCHAR(40) NOT NULL DEFAULT 'dublin_city',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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

-- ===== Extended catalog (more services + more locations) =====
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

UPDATE `services` SET `price_from` = 90.00 WHERE `price_from` IS NOT NULL AND `price_from` < 90;

-- ===== Long-form content (location + key service bodies + testimonials) =====
UPDATE / REPLACE statements).
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
<p><a href="tel:+35318782720">(01) 878 2720</a> is a real Dublin landline. It rings at our office and is answered by a member of our team day and night, including Christmas Day. Minimum job price across D18 is €90 fixed up front, with a 12-month guarantee on every cylinder, mechanism or smart lock we fit.</p>
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
<p>Same number, same Dublin team — <a href="tel:+35318782720">(01) 878 2720</a>. Local 01 landline, no surcharge, no overseas redirect. Minimum job price €90 fixed up front, 12-month guarantee on every job.</p>
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
<p>Response time across Rathfarnham is typically 15–20 minutes from our south-Dublin van. Local 01 landline answered by a real person, day or night: <a href="tel:+35318782720">(01) 878 2720</a>. Minimum job price €90 fixed up front, with a 12-month guarantee on every cylinder, mechanism or lock we fit.</p>
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
<p>Supply and fit the lock, configure the app, set up auto-lock and auto-unlock, configure family / housemate codes, integrate with smart-home systems, and 12-month guarantee on parts and labour.</p>

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

-- ===== Long-form content (remaining service bodies) =====
UPDATE statements).
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

-- ===== Safety updates =====
-- Floor every service price at the €90 minimum
UPDATE `services` SET `price_from` = 90.00 WHERE `price_from` IS NOT NULL AND `price_from` < 90;

-- Belt-and-braces: if any older table is still latin1, convert it now.
ALTER TABLE `admin_users`     CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `settings`        CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `services`        CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `locations`       CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `testimonials`    CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `faqs`            CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `quote_requests`  CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE `pricing_items`   CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- =====================================================================
-- 9 May 2026 — Van Slam Locks service + nearby-counties locations +
-- footer settings.
-- =====================================================================

INSERT INTO `settings` (`setting_key`,`setting_value`) VALUES
('footer_logo',     '/assets/images/logo.webp'),
('footer_about',    'PSA-licensed Dublin locksmith. Emergency lockouts, lock changes, burglary repairs, smart-lock installation and van slam-lock fitting across Dublin and the wider east-coast counties. We answer the local 01 landline 24 hours a day.'),
('copyright_text',  '© {year} {business} · PSA License {psa} · All rights reserved.')
ON DUPLICATE KEY UPDATE `setting_value` = VALUES(`setting_value`);

-- ----- Dedicated Van Slam Locks service -----
INSERT IGNORE INTO `services`
  (`slug`,`title`,`category`,`short_description`,`body`,`icon`,`meta_title`,`meta_description`,`focus_keyword`,`price_from`,`sort_order`) VALUES
('van-slam-locks-installation', 'Van Slam Locks Installation', 'commercial',
 'Slam locks, hooks and deadlocks fitted to Sprinter, Transit, Crafter, Master and Vivaro vans across Dublin and nearby counties.',
 '',
 'truck',
 'Van Slam Locks Installation Dublin & Nearby Counties',
 'Van slam locks, hooks and deadlocks fitted on-site for tradesmen across Dublin, Kildare, Meath, Louth, Wicklow, Wexford and Cork. PSA licensed, fixed price.',
 'van slam locks installation', 180.00, 90);

UPDATE `services` SET `body` = '
<p>Van slam locks are the single biggest deterrent against opportunist tool theft. A standard factory-fit van lock can be defeated in seconds by a determined thief with a flat-head screwdriver. A slam lock engages automatically the second the door closes — there''s no key to forget, no central-locking signal that can be jammed, and no exposed cylinder face for a thief to attack.</p>

<p>We fit slam locks, deadlocks, hooks and anti-peel reinforcement plates on-site at your home, depot or job address — usually inside 90 minutes per van. PSA licensed, fixed price agreed before we travel, twelve-month guarantee on every fitting.</p>

<h3>Vans we fit slam locks to</h3>
<ul>
  <li>Mercedes-Benz Sprinter (all generations, 2006 onwards)</li>
  <li>Ford Transit, Transit Custom, Transit Connect</li>
  <li>Volkswagen Crafter, Transporter (T5, T6, T6.1)</li>
  <li>Renault Master, Trafic, Kangoo</li>
  <li>Vauxhall / Opel Vivaro, Movano, Combo</li>
  <li>Peugeot Boxer, Expert, Partner</li>
  <li>Citroën Relay, Dispatch, Berlingo</li>
  <li>Iveco Daily</li>
  <li>Fiat Ducato, Doblo</li>
  <li>Toyota ProAce, Hiace</li>
  <li>Nissan NV200, NV400, Primastar</li>
</ul>

<h3>What we fit and why</h3>
<ul>
  <li><strong>Slam locks (×1 per door)</strong> — engage automatically when the door closes. Cab, side load and rear barn doors all available.</li>
  <li><strong>Deadlocks (×1 per door)</strong> — second locking point above the factory lock, key-operated, defeats the rip-cord and lock-bumping methods.</li>
  <li><strong>Hooks</strong> — secondary catches that engage at the top and bottom of the door, removing the leverage point a thief uses to peel the door open.</li>
  <li><strong>Anti-peel plates</strong> — reinforce the door edge and frame to stop "peel" attacks.</li>
  <li><strong>Internal partition locks</strong> — separate the cab from the cargo area so a thief who breaks into the cab can''t reach the tools.</li>
  <li><strong>Replacement keys and fobs</strong> — cut and programmed on-site if you''ve lost yours.</li>
</ul>

<h3>How long the fitting takes</h3>
<p>A single slam lock takes about 45 minutes per door, including drilling the door skin, fitting the lock body, lining up the keep, and testing. A typical tradesman van — slam locks on the side load and rear barn doors plus a deadlock on each — is finished inside two hours. We work at your home, your depot, or any job site you can leave the van for the morning.</p>

<h3>Where we travel</h3>
<p>Our van slam-lock service covers all of Dublin city and county and the nearby east-coast and midland counties: <strong>Kildare, Meath, Louth, Wicklow, Wexford, Carlow, Westmeath, Laois, Offaly, Cavan, Monaghan</strong> and on-request as far as <strong>Cork, Limerick, Galway, Waterford</strong> for fleets of three or more vans. We''ll quote a fixed all-in price including travel before we leave Dublin.</p>

<h3>Pricing</h3>
<ul>
  <li>Single slam lock supplied and fitted: <strong>from €180 per door</strong></li>
  <li>Slam lock + deadlock combo per door: <strong>from €260 per door</strong></li>
  <li>Full van pack (slam locks + deadlocks + hooks on three doors): <strong>from €750 fitted</strong></li>
  <li>Fleets of 3+ vans: <strong>discounted, quoted on the phone</strong></li>
</ul>
<p><a href="/pricing">See the full price list →</a></p>

<h3>Brands we fit</h3>
<p>Locks 4 Vans, Slamlocks Direct, Vanguard, Maple, Armaplate, Trade Vans Ireland — depending on van, brand and use case we''ll recommend the right combination. All UK and EU-spec, all sold-secure where applicable, all backed by manufacturer guarantee in addition to our 12-month fitting guarantee.</p>

<h3>What we''ll need from you on the phone</h3>
<ol>
  <li>Make, model and year of the van</li>
  <li>Which doors you want secured (cab / side load / rear barn / single rear)</li>
  <li>Where you''d like the work done (home / depot / job site)</li>
  <li>Any history with the van (insurance claim, attempted theft, prior fitting)</li>
</ol>

<p>Call <a href="tel:+35318782720">(01) 878 2720</a> for a fixed-price quote. Local Dublin landline, real Dublin team, no premium-rate divert.</p>
'
WHERE `slug` = 'van-slam-locks-installation';

-- ----- Nearby-counties locations -----
INSERT IGNORE INTO `locations`
  (`slug`,`name`,`region`,`landmark`,`landmark_secondary`,`intro`,`body`,
   `latitude`,`longitude`,`meta_title`,`meta_description`,`focus_keyword`,`sort_order`) VALUES

('locksmith-cork', 'Cork', 'cork',
 'Cork City Centre', 'Patrick Street',
 'Cork locksmith service — emergency lockouts, lock changes and on-site van slam-lock fitting across Cork city and county.',
 '<p>Locksmiths.ie covers Cork city and county for our specialist services — primarily van slam-lock fitting for the trade fleets based around Little Island, Mahon, Carrigaline and the Cork docks. We also travel for fleet master-key suites, commercial security upgrades and high-spec residential anti-snap and BS3621 work.</p>
<h3>What we cover in Cork</h3>
<ul>
  <li>Van slam-lock fitting (Sprinter, Transit, Crafter, Master, Vivaro)</li>
  <li>Fleet master-key systems for Cork-area trade businesses</li>
  <li>Anti-snap TS007 3-star cylinder upgrades</li>
  <li>Multi-site commercial security audits</li>
  <li>Insurance-grade BS3621 5-lever mortice fitting</li>
</ul>
<h3>How we work in Cork</h3>
<p>Our travel rate is included in the fixed quote — no surprise top-up for the trip down the M8. We schedule Cork visits in batches (typically every 7–10 days) so the cost-per-job is comparable with a Cork-based locksmith for fleet work. For a single van or single house we''ll quote on the phone — sometimes it makes more sense to use a local Cork PSA-licensee, and we''ll say so honestly.</p>
<p>Ring <a href="tel:+35318782720">(01) 878 2720</a> for a fixed-price quote.</p>',
 51.898514, -8.475603,
 'Locksmith Cork | Van Slam Locks & Fleet Security',
 'PSA-licensed locksmith service in Cork — van slam-lock fitting, fleet master-key suites and high-spec security upgrades. Fixed-price quotes including travel.',
 'locksmith cork', 70),

('locksmith-louth', 'Louth', 'louth',
 'Drogheda', 'Dundalk',
 'Louth locksmith service — emergency response across Drogheda, Dundalk, Ardee and surrounding north-Leinster.',
 '<p>Drogheda is 45 minutes from Dublin city centre on the M1; Dundalk is just over an hour. We cover both towns and surrounding north-Leinster — emergency lockouts, lock changes, multipoint mechanism repair on the modern UPVC and composite doors, anti-snap upgrades and van slam-lock fitting.</p>
<h3>Common Louth jobs</h3>
<ul>
  <li>House lockouts in Drogheda, Dundalk and Ardee</li>
  <li>Anti-snap cylinder upgrades on the post-2000 estates</li>
  <li>UPVC multipoint gearbox repair</li>
  <li>Commercial / retail emergency response on Drogheda West Street and Dundalk''s Park Street</li>
  <li>Van slam-lock fitting at trade-base addresses</li>
</ul>
<p>Average response time from our north-Dublin van is 45–60 minutes to Drogheda, 60–80 minutes to Dundalk. Same fixed-price model as inside Dublin — ring <a href="tel:+35318782720">(01) 878 2720</a>.</p>',
 53.715000, -6.350000,
 'Locksmith Louth | Drogheda & Dundalk',
 'PSA-licensed locksmith service across Co. Louth — Drogheda, Dundalk, Ardee and surrounding north-Leinster. 24/7 response, fixed price.',
 'locksmith louth', 71),

('locksmith-wexford', 'Wexford', 'wexford',
 'Wexford Town', 'Enniscorthy',
 'Wexford locksmith service — emergency response across Wexford town, Enniscorthy, Gorey and Rosslare.',
 '<p>Wexford is around 90 minutes from Dublin via the M11. We cover the Wexford catchment for fleet van slam-lock fitting, commercial master-key work and emergency lockouts where a Dublin-based response is faster than waiting for a county locksmith.</p>
<h3>Common Wexford jobs</h3>
<ul>
  <li>Holiday-home lock changes around Rosslare and Curracloe</li>
  <li>Van slam-lock fitting for trade businesses around Wexford industrial estates</li>
  <li>Anti-snap cylinder upgrades on the modern estates around Gorey and Enniscorthy</li>
  <li>Holiday-let smart-lock fitting (Yale Conexis, Nuki) for short-term operators</li>
</ul>
<p>Ring <a href="tel:+35318782720">(01) 878 2720</a> for a fixed-price quote including travel from Dublin.</p>',
 52.336500, -6.463400,
 'Locksmith Wexford | Coastal South-East Service',
 'PSA-licensed locksmith service across Co. Wexford — Wexford town, Enniscorthy, Gorey, Rosslare. Fixed-price quotes including travel.',
 'locksmith wexford', 72),

('locksmith-carlow', 'Carlow', 'carlow',
 'Carlow Town', 'Tullow',
 'Carlow locksmith service — emergency response and fleet van slam-lock fitting across Carlow town and surrounding south-Leinster.',
 '<p>Carlow is 90 minutes from Dublin via the M9. We service the Carlow catchment primarily for van slam-lock fleet fitting and commercial master-key work.</p>
<h3>Common Carlow jobs</h3>
<ul>
  <li>Van slam-lock fitting on tradesmen vans</li>
  <li>Commercial security upgrades for SETU campus and Carlow business park</li>
  <li>Multipoint mechanism repair on modern UPVC and composite doors</li>
</ul>
<p>Ring <a href="tel:+35318782720">(01) 878 2720</a> for a fixed-price quote including travel.</p>',
 52.836400, -6.934000,
 'Locksmith Carlow | South-Leinster Service',
 'PSA-licensed locksmith service across Co. Carlow — Carlow town, Tullow, Bagenalstown. Fixed-price quotes including travel.',
 'locksmith carlow', 73),

('locksmith-westmeath', 'Westmeath', 'westmeath',
 'Mullingar', 'Athlone',
 'Westmeath locksmith service — emergency response across Mullingar, Athlone and surrounding Lakelands.',
 '<p>Mullingar is 75 minutes from Dublin on the N4 / M4. Athlone is 90 minutes. We cover both for van slam-lock fitting, commercial security work and emergency lockouts where a Dublin-based response can beat a county locksmith.</p>
<h3>Common Westmeath jobs</h3>
<ul>
  <li>Van slam-lock fitting on trade fleets around Mullingar and Athlone industrial estates</li>
  <li>Anti-snap cylinder upgrades on the modern Mullingar estates</li>
  <li>Commercial master-key suites for offices around the Athlone IT campus</li>
</ul>
<p>Ring <a href="tel:+35318782720">(01) 878 2720</a> for a fixed-price quote.</p>',
 53.526100, -7.339000,
 'Locksmith Westmeath | Mullingar & Athlone',
 'PSA-licensed locksmith service across Co. Westmeath — Mullingar, Athlone and surrounding Lakelands.',
 'locksmith westmeath', 74),

('locksmith-galway', 'Galway', 'galway',
 'Galway City', 'Eyre Square',
 'Galway locksmith service — fleet van slam-lock fitting and commercial security work across Galway city and county.',
 '<p>Galway is around 2 hours 15 minutes from Dublin on the M6. We travel for van slam-lock fleet fitting (3+ vans) and commercial master-key suite installations where the project warrants it. We''ll honestly recommend a local Galway PSA-licensee for single-job emergency callouts.</p>
<h3>What we typically do in Galway</h3>
<ul>
  <li>Van slam-lock fleet installations (3+ vans, scheduled in batches)</li>
  <li>Commercial master-key suites for offices and retail chains</li>
  <li>Fleet-wide cylinder rekey for transport companies</li>
</ul>
<p>Ring <a href="tel:+35318782720">(01) 878 2720</a> for a fixed-price quote including travel from Dublin.</p>',
 53.270900, -9.056800,
 'Locksmith Galway | Fleet Van Slam Locks & Commercial',
 'Galway locksmith service — fleet van slam-lock fitting, commercial master-key suites. Fixed-price quotes including travel from Dublin.',
 'locksmith galway', 75),

('locksmith-limerick', 'Limerick', 'limerick',
 'Limerick City', 'King John''s Castle',
 'Limerick locksmith service — fleet van slam-lock fitting and commercial security work.',
 '<p>Limerick is 2 hours from Dublin on the M7. We travel for van slam-lock fleet fitting and commercial security projects.</p>
<h3>What we cover</h3>
<ul>
  <li>Van slam-lock fleet installations (3+ vans, scheduled in batches)</li>
  <li>Commercial master-key suites for offices and retail</li>
  <li>Fleet-wide cylinder rekeys for transport businesses</li>
</ul>
<p>Ring <a href="tel:+35318782720">(01) 878 2720</a> for a fixed-price quote including travel.</p>',
 52.668200, -8.630500,
 'Locksmith Limerick | Fleet Van Slam Locks',
 'Limerick locksmith service — fleet van slam-lock fitting and commercial security work. Fixed-price quotes including travel.',
 'locksmith limerick', 76),

('locksmith-waterford', 'Waterford', 'waterford',
 'Waterford City', 'The Quay',
 'Waterford locksmith service — fleet van slam-lock fitting and commercial security work across Waterford city and county.',
 '<p>Waterford is 2 hours from Dublin on the M9. We travel for van slam-lock fleet fitting and commercial security projects.</p>
<h3>What we cover</h3>
<ul>
  <li>Van slam-lock fleet installations</li>
  <li>Commercial master-key suites</li>
  <li>Fleet rekeys for transport and delivery companies</li>
</ul>
<p>Ring <a href="tel:+35318782720">(01) 878 2720</a> for a fixed-price quote including travel.</p>',
 52.259200, -7.110600,
 'Locksmith Waterford | Fleet Van Slam Locks',
 'Waterford locksmith service — fleet van slam-lock fitting and commercial security work.',
 'locksmith waterford', 77);

-- Make sure existing nearby counties (Kildare / Meath / Wicklow) have a friendly region label
