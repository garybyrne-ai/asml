<?php
declare(strict_types=1);

require_once __DIR__ . '/includes/functions.php';

/**
 * Front controller — also used as the homepage.
 * .htaccess routes /<slug> here. We resolve slug → service or location.
 */

$path = trim(parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?? '/', '/');

// Static routes
$static_pages = [
    ''          => 'home',
    'services'  => 'services',
    'locations' => 'locations',
    'pricing'   => 'pricing',
    'prices'    => 'pricing',
    'reviews'   => 'reviews',
    'contact'   => 'contact',
    'about'     => 'about',
    'privacy'   => 'privacy',
    'terms'     => 'terms',
];

if (isset($static_pages[$path])) {
    require __DIR__ . '/pages/' . $static_pages[$path] . '.php';
    exit;
}

// Dynamic: try service slug, then location slug
if ($svc = get_service($path)) {
    $service = $svc;
    require __DIR__ . '/pages/service-single.php';
    exit;
}

if ($loc = get_location($path)) {
    $location = $loc;
    require __DIR__ . '/pages/location-single.php';
    exit;
}

// 404
http_response_code(404);
require __DIR__ . '/pages/404.php';
