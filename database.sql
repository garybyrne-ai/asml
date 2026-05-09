-- =====================================================================
-- Locksmiths.ie - Dublin Locksmith Website Database Schema
-- MySQL 8.x / MariaDB 10.x
--
-- Cloudways / shared hosting:
--   The DB is pre-created (e.g. eqdueglqgt). Just open phpMyAdmin,
--   SELECT that DB in the left sidebar, then Import this file.
--   Do NOT uncomment the CREATE DATABASE / USE block below.
--
-- Local / self-hosted:
--   Uncomment the two statements below to create a fresh database.
-- =====================================================================

-- CREATE DATABASE IF NOT EXISTS `locksmiths_ie`
--   DEFAULT CHARACTER SET utf8mb4
--   COLLATE utf8mb4_unicode_ci;
-- USE `locksmiths_ie`;

-- ---------------------------------------------------------------------
-- Admin users
-- ---------------------------------------------------------------------
CREATE TABLE `admin_users` (
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
CREATE TABLE `settings` (
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
CREATE TABLE `services` (
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
CREATE TABLE `locations` (
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
CREATE TABLE `testimonials` (
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
CREATE TABLE `faqs` (
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
CREATE TABLE `quote_requests` (
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
-- Default data
-- ---------------------------------------------------------------------
-- Default admin user (password: ChangeMe!2026 — change immediately after install)
INSERT INTO `admin_users` (`username`, `email`, `password_hash`, `role`)
VALUES ('admin', 'admin@locksmiths.ie',
        '$2y$12$5xK2mC8h8hJZ5cQnP4xO5e6zXxR9rJq/3K7vVqK8x2pP3lZ8nQ2eG',
        'admin');

-- Global settings (NAP, PSA, SMTP, code injection)
INSERT INTO `settings` (`setting_key`, `setting_value`) VALUES
('business_name',       'Locksmiths.ie'),
('phone',               '01 254 8888'),
('phone_e164',          '+353012548888'),
('whatsapp',            '+353871234567'),
('email',               'info@locksmiths.ie'),
('address_street',      '12 O''Connell Street'),
('address_city',        'Dublin'),
('address_postcode',    'D01 X4P5'),
('address_country',     'IE'),
('latitude',            '53.349805'),
('longitude',           '-6.260310'),
('opening_hours',       'Mo-Su 00:00-23:59'),
('price_range',         '€€'),
('psa_license',         'PSA 12345'),
('response_time',       '20-30 minutes'),
('logo',                '/assets/images/locksmiths-ie-logo.svg'),
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
('google_maps_key',     '');

-- Seed core services
INSERT INTO `services` (`slug`, `title`, `category`, `short_description`, `body`, `icon`, `meta_title`, `meta_description`, `focus_keyword`, `price_from`, `sort_order`) VALUES
('emergency-lockout',  'Emergency Lockout Service',  'emergency',
 'Locked out? PSA-licensed locksmith on-site in 20 minutes anywhere in Dublin.',
 '<p>Our 24/7 emergency lockout service covers all of Dublin and the Greater Dublin Area. Whether you are locked out of your home, office or car, our PSA-licensed technicians arrive on-site in 20–30 minutes with the tools and skill to get you back inside without damaging your door or lock.</p>',
 'key', 'Emergency Locksmith Dublin | 20-Min Response | PSA Licensed',
 'Locked out in Dublin? Our PSA-licensed emergency locksmiths arrive in 20 minutes. No call-out fee. Available 24/7 across all Dublin districts.',
 'emergency locksmith dublin', 80.00, 1),

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
INSERT INTO `locations` (`slug`, `name`, `region`, `district_code`, `landmark`, `landmark_secondary`, `intro`, `latitude`, `longitude`, `meta_title`, `meta_description`, `focus_keyword`, `sort_order`) VALUES
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
INSERT INTO `faqs` (`question`, `answer`, `is_global`, `sort_order`) VALUES
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
INSERT INTO `testimonials` (`customer_name`, `customer_location`, `rating`, `review_body`, `is_featured`, `review_date`) VALUES
('Sarah O''Brien',    'Rathmines, D6',          5, 'Locked out at 1am — they were at my door in 18 minutes and had me inside in 5. Brilliant service.', 1, '2026-04-21'),
('Mark Kavanagh',     'Tallaght',               5, 'Quoted me a fixed price on the phone, no hidden fees. Fitted a new anti-snap cylinder same day.', 1, '2026-04-15'),
('Aoife Murphy',      'Sandyford, D18',         5, 'Genuinely the fastest locksmith in Dublin. Polite, professional and reasonably priced.', 1, '2026-04-09'),
('Liam Byrne',        'Blanchardstown, D15',    5, 'Came out on a Sunday for a burglary repair. Sorted insurance paperwork too. Highly recommend.', 1, '2026-03-30'),
('Niamh Walsh',       'Swords',                 5, 'Lost my car keys at the airport. They cut and programmed a new key on-site in under an hour.', 0, '2026-03-22');
