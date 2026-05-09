<?php
declare(strict_types=1);

/**
 * AJAX quote-request endpoint.
 * Method: POST  Returns: JSON
 */

require_once __DIR__ . '/../includes/mailer.php';

header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['ok' => false, 'error' => 'Method not allowed']);
    exit;
}

// CSRF
$token = $_POST[CSRF_TOKEN_NAME] ?? ($_SERVER['HTTP_X_CSRF_TOKEN'] ?? null);
if (!csrf_check($token)) {
    http_response_code(419);
    echo json_encode(['ok' => false, 'error' => 'Session expired. Please refresh and try again.']);
    exit;
}

// Honeypot
if (!empty($_POST['website'])) {
    echo json_encode(['ok' => true, 'message' => 'Thanks!']);
    exit;
}

$name    = trim((string)($_POST['name']    ?? ''));
$phone   = trim((string)($_POST['phone']   ?? ''));
$email   = trim((string)($_POST['email']   ?? ''));
$area    = trim((string)($_POST['area']    ?? ''));
$service = trim((string)($_POST['service_needed'] ?? ''));
$message = trim((string)($_POST['message'] ?? ''));
$source  = trim((string)($_POST['source_page']    ?? ''));

$errors = [];
if ($name === '' || mb_strlen($name) > 120)             $errors[] = 'Please enter your name.';
if (!validate_phone_ie($phone))                          $errors[] = 'Please enter a valid Irish phone number.';
if ($area === '')                                        $errors[] = 'Please select your area.';
if ($service === '')                                     $errors[] = 'Please select a service.';
if ($email !== '' && !filter_var($email, FILTER_VALIDATE_EMAIL)) $errors[] = 'Please enter a valid email.';

if ($errors) {
    http_response_code(422);
    echo json_encode(['ok' => false, 'error' => implode(' ', $errors)]);
    exit;
}

// Simple rate limit: 1 request per 30 seconds per IP
$ip = client_ip();
$rl = db_one(
    'SELECT id FROM quote_requests WHERE ip_address = :ip AND created_at > (NOW() - INTERVAL 30 SECOND) LIMIT 1',
    [':ip' => $ip]
);
if ($rl) {
    http_response_code(429);
    echo json_encode(['ok' => false, 'error' => 'Please wait a moment before submitting again.']);
    exit;
}

$data = [
    'name'           => $name,
    'phone'          => $phone,
    'email'          => $email !== '' ? $email : null,
    'area'           => $area,
    'service_needed' => $service,
    'message'        => $message,
    'source_page'    => $source,
    'ip_address'     => $ip,
    'user_agent'     => substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 250),
];

db_exec(
    'INSERT INTO quote_requests
       (name, phone, email, area, service_needed, message, source_page, ip_address, user_agent)
     VALUES
       (:name, :phone, :email, :area, :service_needed, :message, :source_page, :ip_address, :user_agent)',
    array_combine(
        array_map(fn($k) => ':' . $k, array_keys($data)),
        array_values($data)
    )
);

@send_quote_notification($data);

echo json_encode([
    'ok'      => true,
    'message' => "Thanks {$name}! We'll call you in the next 5 minutes on {$phone}.",
]);
