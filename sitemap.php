<?php
declare(strict_types=1);

require_once __DIR__ . '/includes/functions.php';

header('Content-Type: application/xml; charset=utf-8');

$urls = [
    ['/',          '1.0', 'daily'],
    ['/services',  '0.9', 'weekly'],
    ['/locations', '0.9', 'weekly'],
    ['/reviews',   '0.7', 'weekly'],
    ['/about',     '0.5', 'monthly'],
    ['/contact',   '0.7', 'monthly'],
];

foreach (get_services()  as $s) $urls[] = ['/' . $s['slug'], '0.85', 'weekly', $s['updated_at']];
foreach (get_locations() as $l) $urls[] = ['/' . $l['slug'], '0.85', 'weekly', $l['updated_at']];

echo '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' . "\n";
foreach ($urls as $u) {
    echo "  <url>\n";
    echo '    <loc>'        . e(SITE_URL . $u[0]) . "</loc>\n";
    echo '    <priority>'   . e($u[1]) . "</priority>\n";
    echo '    <changefreq>' . e($u[2]) . "</changefreq>\n";
    if (!empty($u[3])) {
        echo '    <lastmod>' . e(date('c', strtotime((string)$u[3]))) . "</lastmod>\n";
    }
    echo "  </url>\n";
}
echo "</urlset>\n";
