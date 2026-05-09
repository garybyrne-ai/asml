<?php
declare(strict_types=1);

/**
 * Locksmiths.ie - Application configuration.
 *
 * Credentials precedence (highest first):
 *   1. /includes/config.local.php   (NOT committed to git — safe place for prod creds)
 *   2. Environment variables        (DigitalOcean / Cloudways "Application Vars")
 *   3. Defaults below                (local dev fallback)
 */

if (is_file(__DIR__ . '/config.local.php')) {
    require __DIR__ . '/config.local.php';
}

// ---- Database ----
defined('DB_HOST') || define('DB_HOST', getenv('DB_HOST') ?: '127.0.0.1');
defined('DB_NAME') || define('DB_NAME', getenv('DB_NAME') ?: 'locksmiths_ie');
defined('DB_USER') || define('DB_USER', getenv('DB_USER') ?: 'locksmiths_user');
defined('DB_PASS') || define('DB_PASS', getenv('DB_PASS') ?: '');
defined('DB_CHARSET') || define('DB_CHARSET', 'utf8mb4');

// ---- Site ----
defined('SITE_URL')   || define('SITE_URL',   rtrim(getenv('SITE_URL') ?: 'https://locksmiths.ie', '/'));
defined('SITE_ROOT')  || define('SITE_ROOT',  dirname(__DIR__));
defined('ASSETS_URL') || define('ASSETS_URL', SITE_URL . '/assets');

// ---- Security ----
defined('CSRF_TOKEN_NAME') || define('CSRF_TOKEN_NAME', '_csrf');
defined('SESSION_NAME')    || define('SESSION_NAME',    'lkid');
defined('ENV')             || define('ENV', getenv('APP_ENV') ?: 'production');

// ---- Session ----
if (session_status() === PHP_SESSION_NONE) {
    // Cloudways / most hosts terminate TLS at a proxy, so $_SERVER['HTTPS']
    // is not always set. Trust X-Forwarded-Proto when it's present.
    $isHttps =
        (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ||
        (($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '') === 'https')   ||
        ((int)($_SERVER['SERVER_PORT'] ?? 0) === 443);

    session_name(SESSION_NAME);
    session_set_cookie_params([
        'lifetime' => 0,
        'path'     => '/',
        'domain'   => '',
        'secure'   => $isHttps,
        'httponly' => true,
        'samesite' => 'Lax',
    ]);
    session_start();
}

// ---- Error reporting ----
if (ENV === 'production') {
    // E_STRICT is removed in PHP 8.4; only mask it when the constant exists.
    $mask = E_ALL & ~E_DEPRECATED;
    if (defined('E_STRICT')) $mask &= ~E_STRICT;
    error_reporting($mask);
    ini_set('display_errors', '0');
    ini_set('log_errors', '1');
} else {
    error_reporting(E_ALL);
    ini_set('display_errors', '1');
}

date_default_timezone_set('Europe/Dublin');
