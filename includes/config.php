<?php
declare(strict_types=1);

/**
 * Locksmiths.ie - Application configuration.
 * Set these via environment variables in production (DigitalOcean / Cloudways).
 */

// ---- Database ----
define('DB_HOST', getenv('DB_HOST') ?: '127.0.0.1');
define('DB_NAME', getenv('DB_NAME') ?: 'locksmiths_ie');
define('DB_USER', getenv('DB_USER') ?: 'locksmiths_user');
define('DB_PASS', getenv('DB_PASS') ?: '');
define('DB_CHARSET', 'utf8mb4');

// ---- Site ----
define('SITE_URL',   rtrim(getenv('SITE_URL') ?: 'https://locksmiths.ie', '/'));
define('SITE_ROOT',  dirname(__DIR__));
define('ASSETS_URL', SITE_URL . '/assets');

// ---- Security ----
define('CSRF_TOKEN_NAME', '_csrf');
define('SESSION_NAME',    'lkid');
define('ENV', getenv('APP_ENV') ?: 'production');

// ---- Session ----
if (session_status() === PHP_SESSION_NONE) {
    session_name(SESSION_NAME);
    session_set_cookie_params([
        'lifetime' => 0,
        'path'     => '/',
        'domain'   => '',
        'secure'   => isset($_SERVER['HTTPS']),
        'httponly' => true,
        'samesite' => 'Lax',
    ]);
    session_start();
}

// ---- Error reporting ----
if (ENV === 'production') {
    error_reporting(E_ALL & ~E_DEPRECATED & ~E_STRICT);
    ini_set('display_errors', '0');
    ini_set('log_errors', '1');
} else {
    error_reporting(E_ALL);
    ini_set('display_errors', '1');
}

date_default_timezone_set('Europe/Dublin');
