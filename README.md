# Locksmiths.ie — Dublin Locksmith Website

High-conversion, ultra-fast PHP 8 / MySQL website for **locksmiths.ie**.
Optimised for the Dublin & Greater Dublin Area, designed for DigitalOcean / Cloudways
hosting (Nginx + Redis-ready).

## Stack

- **PHP 8.x** (no framework, no WordPress)
- **MySQL 8 / MariaDB 10**
- **jQuery 3.7.1** (CDN, integrity-pinned)
- **PHPMailer 6.x** (SMTP)
- **Google Fonts**: Outfit (headings), Inter (body)

## File structure

```
/admin/                 Secure admin dashboard (login + full CRUD)
/api/quote.php          AJAX endpoint for the hero "Quick Quote" form
/assets/
  /css/style.css        Front-end styles (mobile first)
  /css/admin.css        Admin styles
  /js/main.js           Front-end JS (AJAX form, mobile menu, tracking)
  /images/              Logos, favicon (e.g. locksmith-dublin-tallaght.jpg)
/includes/
  config.php            DB, site URL, session, env config
  db.php                PDO singleton + prepared-statement helpers
  functions.php         CSRF, settings, slug, SEO, JSON-LD, auth
  mailer.php            PHPMailer wrapper (SMTP from settings table)
  header.php            Site header + hero strip
  footer.php            Site footer + floating Call/WhatsApp buttons
  hero.php              Reusable above-the-fold hero (split layout)
/pages/
  home.php              Homepage
  services.php          Services index (siloed by category)
  services-single.php   Dynamic service page
  locations.php         Locations index (Dublin + Greater Dublin)
  location-single.php   Dynamic location page (with landmark line)
  reviews.php           Full reviews page
  contact.php           Contact page
  about.php / privacy / terms / 404
index.php               Front controller (slug routing)
sitemap.php             Dynamic XML sitemap (mapped from /sitemap.xml)
robots.txt              Allow public, disallow admin/api/includes
.htaccess               Apache rewrites, compression, caching, security headers
database.sql            Complete MySQL schema + seed data
```

## Install

1. **Database**

   ```bash
   mysql -u root -p < database.sql
   ```

2. **Environment** (set in DigitalOcean / Cloudways app config)

   ```
   DB_HOST=127.0.0.1
   DB_NAME=locksmiths_ie
   DB_USER=locksmiths_user
   DB_PASS=•••
   SITE_URL=https://locksmiths.ie
   APP_ENV=production
   ```

3. **PHPMailer** — drop into `/vendor/PHPMailer/src/` or `composer require phpmailer/phpmailer`.

4. **Default admin login**: `admin` / `ChangeMe!2026` — **change immediately** at `/admin/`.

5. **Apache**: `mod_rewrite`, `mod_headers`, `mod_deflate`, `mod_expires` enabled.
   For Nginx, mirror the rewrites with `try_files $uri $uri/ /index.php?$query_string;`.

## SEO features

- **Yoast-style backend** per page: meta title, meta description, focus keyword, canonical.
- **Schema.org JSON-LD**: LocalBusiness + Locksmith, FAQPage, Review, Service, BreadcrumbList — auto-generated.
- **Dynamic location pages** with landmark sentences:
  *“Emergency Locksmith near Dundrum Town Centre — PSA licensed, 20-30 minutes response.”*
- **Clean URLs**: `/locksmith-dublin-15`, `/locksmith-tallaght`, `/emergency-lockout`.
- **Sitemap** auto-generated at `/sitemap.xml`.

## Conversion features

- Pulsating **CALL NOW** button (above the fold + floating mobile button).
- Floating **WhatsApp** button (mobile-first).
- AJAX **Quick Quote** form on every page (CSRF + honeypot + rate-limit).
- Trust strip: PSA Licence, 20-min arrival, no call-out fee, 12-month guarantee.

## PSA license note

It is **illegal** to operate a locksmith in Ireland without a PSA licence.
Set the licence in `Admin → Global Settings → PSA License Number` — it renders
in the footer and as a JSON-LD trust signal on every page.

## Image naming

Always name images with **service + location** keywords for SEO:

```
locksmith-dublin-tallaght.jpg
emergency-locksmith-dublin-15.jpg
smart-lock-installation-rathmines.jpg
```
