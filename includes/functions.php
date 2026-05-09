<?php
declare(strict_types=1);

require_once __DIR__ . '/db.php';

/* ========================================================================
 * Output helpers
 * ====================================================================== */

function e(?string $value): string
{
    return htmlspecialchars($value ?? '', ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function url(string $path = ''): string
{
    return SITE_URL . '/' . ltrim($path, '/');
}

function asset(string $path): string
{
    return ASSETS_URL . '/' . ltrim($path, '/');
}

function redirect(string $path, int $status = 302): void
{
    header('Location: ' . (str_starts_with($path, 'http') ? $path : url($path)), true, $status);
    exit;
}

/* ========================================================================
 * CSRF
 * ====================================================================== */

function csrf_token(): string
{
    if (empty($_SESSION[CSRF_TOKEN_NAME])) {
        $_SESSION[CSRF_TOKEN_NAME] = bin2hex(random_bytes(32));
    }
    return $_SESSION[CSRF_TOKEN_NAME];
}

function csrf_field(): string
{
    return '<input type="hidden" name="' . CSRF_TOKEN_NAME . '" value="' . e(csrf_token()) . '">';
}

function csrf_check(?string $token): bool
{
    return is_string($token)
        && !empty($_SESSION[CSRF_TOKEN_NAME])
        && hash_equals($_SESSION[CSRF_TOKEN_NAME], $token);
}

function csrf_require(): void
{
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') return;
    $token = $_POST[CSRF_TOKEN_NAME] ?? ($_SERVER['HTTP_X_CSRF_TOKEN'] ?? null);
    if (!csrf_check($token)) {
        http_response_code(419);
        exit('Invalid CSRF token.');
    }
}

/* ========================================================================
 * Settings (NAP / SMTP / code injection)
 * ====================================================================== */

/**
 * @return array<string,string>
 */
function settings_all(): array
{
    static $cache = null;
    if ($cache !== null) return $cache;
    $rows = db_all('SELECT setting_key, setting_value FROM settings');
    $cache = [];
    foreach ($rows as $r) {
        $cache[$r['setting_key']] = (string) ($r['setting_value'] ?? '');
    }
    return $cache;
}

function setting(string $key, string $default = ''): string
{
    $all = settings_all();
    return $all[$key] ?? $default;
}

function setting_save(string $key, string $value): void
{
    db_exec(
        'INSERT INTO settings (setting_key, setting_value) VALUES (:k, :v)
         ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value)',
        [':k' => $key, ':v' => $value]
    );
}

/* ========================================================================
 * Slug + content helpers
 * ====================================================================== */

function slugify(string $text): string
{
    $text = iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $text) ?: $text;
    $text = strtolower($text);
    $text = preg_replace('~[^a-z0-9]+~', '-', $text);
    return trim($text ?? '', '-');
}

function get_service(string $slug): ?array
{
    return db_one('SELECT * FROM services WHERE slug = :s AND is_active = 1', [':s' => $slug]);
}

function get_location(string $slug): ?array
{
    return db_one('SELECT * FROM locations WHERE slug = :s AND is_active = 1', [':s' => $slug]);
}

/**
 * @return array<int,array<string,mixed>>
 */
function get_services(?string $category = null): array
{
    if ($category) {
        return db_all(
            'SELECT * FROM services WHERE is_active = 1 AND category = :c ORDER BY sort_order, title',
            [':c' => $category]
        );
    }
    return db_all('SELECT * FROM services WHERE is_active = 1 ORDER BY sort_order, title');
}

/**
 * @return array<int,array<string,mixed>>
 */
function get_locations(?string $region = null): array
{
    if ($region) {
        return db_all(
            'SELECT * FROM locations WHERE is_active = 1 AND region = :r ORDER BY sort_order, name',
            [':r' => $region]
        );
    }
    return db_all('SELECT * FROM locations WHERE is_active = 1 ORDER BY sort_order, name');
}

/**
 * @return array<int,array<string,mixed>>
 */
function get_testimonials(int $limit = 25, bool $featured_only = false): array
{
    $sql = 'SELECT * FROM testimonials WHERE is_active = 1';
    if ($featured_only) $sql .= ' AND is_featured = 1';
    $sql .= ' ORDER BY is_featured DESC, review_date DESC LIMIT ' . max(1, $limit);
    return db_all($sql);
}

/**
 * @return array<int,array<string,mixed>>
 */
function get_faqs(?int $service_id = null, ?int $location_id = null): array
{
    if ($service_id) {
        return db_all(
            'SELECT * FROM faqs WHERE is_active = 1 AND (service_id = :s OR is_global = 1)
             ORDER BY service_id IS NULL, sort_order',
            [':s' => $service_id]
        );
    }
    if ($location_id) {
        return db_all(
            'SELECT * FROM faqs WHERE is_active = 1 AND (location_id = :l OR is_global = 1)
             ORDER BY location_id IS NULL, sort_order',
            [':l' => $location_id]
        );
    }
    return db_all('SELECT * FROM faqs WHERE is_active = 1 AND is_global = 1 ORDER BY sort_order');
}

/* ========================================================================
 * SEO + Schema (JSON-LD)
 * ====================================================================== */

function meta_title(?string $custom = null): string
{
    $business = setting('business_name', 'Locksmiths.ie');
    return $custom
        ? $custom . ' | ' . $business
        : $business . ' | PSA Licensed Dublin Locksmith';
}

function build_canonical(string $path): string
{
    return SITE_URL . '/' . ltrim($path, '/');
}

/**
 * @param array<string,mixed> $data
 */
function json_ld(array $data): string
{
    return '<script type="application/ld+json">'
         . json_encode($data, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE)
         . '</script>';
}

function schema_local_business(): string
{
    $reviews = get_testimonials(5, true);
    $rating  = 0.0;
    foreach ($reviews as $r) $rating += (int) $r['rating'];
    $rating  = $reviews ? round($rating / count($reviews), 1) : 5.0;

    return json_ld([
        '@context'      => 'https://schema.org',
        '@type'         => ['LocalBusiness', 'Locksmith'],
        '@id'           => SITE_URL . '#org',
        'name'          => setting('business_name'),
        'url'           => SITE_URL,
        'telephone'     => setting('phone'),
        'email'         => setting('email'),
        'image'         => SITE_URL . setting('logo'),
        'priceRange'    => setting('price_range', '€€'),
        'address'       => [
            '@type'           => 'PostalAddress',
            'streetAddress'   => setting('address_street'),
            'addressLocality' => setting('address_city'),
            'postalCode'      => setting('address_postcode'),
            'addressCountry'  => setting('address_country', 'IE'),
        ],
        'geo' => [
            '@type'     => 'GeoCoordinates',
            'latitude'  => (float) setting('latitude'),
            'longitude' => (float) setting('longitude'),
        ],
        'openingHoursSpecification' => [
            '@type'     => 'OpeningHoursSpecification',
            'dayOfWeek' => ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'],
            'opens'     => '00:00',
            'closes'    => '23:59',
        ],
        'aggregateRating' => [
            '@type'       => 'AggregateRating',
            'ratingValue' => $rating,
            'reviewCount' => max(25, count(get_testimonials(100))),
        ],
        'areaServed' => array_map(fn($l) => $l['name'], get_locations()),
    ]);
}

/**
 * @param array<int,array<string,mixed>> $faqs
 */
function schema_faq(array $faqs): string
{
    if (!$faqs) return '';
    return json_ld([
        '@context'   => 'https://schema.org',
        '@type'      => 'FAQPage',
        'mainEntity' => array_map(fn($f) => [
            '@type'          => 'Question',
            'name'           => $f['question'],
            'acceptedAnswer' => ['@type' => 'Answer', 'text' => strip_tags($f['answer'])],
        ], $faqs),
    ]);
}

/**
 * @param array<int,array<string,mixed>> $reviews
 */
function schema_reviews(array $reviews): string
{
    if (!$reviews) return '';
    return json_ld([
        '@context' => 'https://schema.org',
        '@type'    => 'Product',
        'name'     => setting('business_name') . ' Locksmith Services',
        'review'   => array_map(fn($r) => [
            '@type'         => 'Review',
            'reviewRating'  => ['@type' => 'Rating', 'ratingValue' => (int) $r['rating'], 'bestRating' => 5],
            'author'        => ['@type' => 'Person', 'name' => $r['customer_name']],
            'reviewBody'    => $r['review_body'],
            'datePublished' => $r['review_date'] ?? null,
        ], $reviews),
    ]);
}

/**
 * @param array<int,array{label:string,url:?string}> $crumbs
 */
function schema_breadcrumbs(array $crumbs): string
{
    return json_ld([
        '@context'        => 'https://schema.org',
        '@type'           => 'BreadcrumbList',
        'itemListElement' => array_map(fn($i, $c) => [
            '@type'    => 'ListItem',
            'position' => $i + 1,
            'name'     => $c['label'],
            'item'     => $c['url'] ? (str_starts_with($c['url'], 'http') ? $c['url'] : url($c['url'])) : null,
        ], array_keys($crumbs), $crumbs),
    ]);
}

/* ========================================================================
 * Validation
 * ====================================================================== */

function validate_phone_ie(string $phone): bool
{
    $p = preg_replace('~[^0-9+]~', '', $phone) ?? '';
    return preg_match('~^(\+?353|0)[1-9][0-9]{6,9}$~', $p) === 1;
}

function client_ip(): string
{
    foreach (['HTTP_CF_CONNECTING_IP', 'HTTP_X_FORWARDED_FOR', 'REMOTE_ADDR'] as $k) {
        if (!empty($_SERVER[$k])) {
            return explode(',', $_SERVER[$k])[0];
        }
    }
    return '';
}

/* ========================================================================
 * Auth
 * ====================================================================== */

function admin_login(string $username, string $password): bool
{
    $user = db_one(
        'SELECT * FROM admin_users WHERE username = :u OR email = :u LIMIT 1',
        [':u' => $username]
    );
    if (!$user || !password_verify($password, $user['password_hash'])) {
        return false;
    }
    $_SESSION['admin_id']       = (int) $user['id'];
    $_SESSION['admin_username'] = $user['username'];
    $_SESSION['admin_role']     = $user['role'];
    db_exec('UPDATE admin_users SET last_login = NOW() WHERE id = :id', [':id' => $user['id']]);
    session_regenerate_id(true);
    return true;
}

function admin_logout(): void
{
    $_SESSION = [];
    session_destroy();
}

function admin_check(): bool
{
    return !empty($_SESSION['admin_id']);
}

function admin_require(): void
{
    if (!admin_check()) {
        redirect('/admin/login.php');
    }
}

/* ========================================================================
 * Breadcrumbs renderer
 * ====================================================================== */

/**
 * @param array<int,array{label:string,url:?string}> $crumbs
 */
function render_breadcrumbs(array $crumbs): string
{
    $html = '<nav class="breadcrumbs" aria-label="Breadcrumb"><ol>';
    foreach ($crumbs as $i => $c) {
        $last = ($i === count($crumbs) - 1);
        $html .= '<li>';
        if ($c['url'] && !$last) {
            $html .= '<a href="' . e($c['url']) . '">' . e($c['label']) . '</a>';
        } else {
            $html .= '<span aria-current="page">' . e($c['label']) . '</span>';
        }
        $html .= '</li>';
    }
    return $html . '</ol></nav>';
}
