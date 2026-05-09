<?php
declare(strict_types=1);

require_once __DIR__ . '/functions.php';

/**
 * Sends mail via PHPMailer using SMTP credentials from the settings table.
 * Drop PHPMailer 6.x into /vendor/PHPMailer/src/ or install via composer.
 */

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception as MailException;

if (file_exists(SITE_ROOT . '/vendor/autoload.php')) {
    require_once SITE_ROOT . '/vendor/autoload.php';
} elseif (file_exists(SITE_ROOT . '/vendor/PHPMailer/src/PHPMailer.php')) {
    require_once SITE_ROOT . '/vendor/PHPMailer/src/Exception.php';
    require_once SITE_ROOT . '/vendor/PHPMailer/src/PHPMailer.php';
    require_once SITE_ROOT . '/vendor/PHPMailer/src/SMTP.php';
}

/**
 * Send mail. Returns true on success.
 *
 * @param string $to
 * @param string $subject
 * @param string $html_body
 * @param array<int,array{path:string,name:string}> $attachments
 */
function send_mail(string $to, string $subject, string $html_body, array $attachments = []): bool
{
    if (!class_exists(PHPMailer::class)) {
        error_log('[mailer] PHPMailer not installed.');
        return false;
    }

    $mail = new PHPMailer(true);
    try {
        $mail->isSMTP();
        $mail->Host          = setting('smtp_host');
        $mail->Port          = (int) setting('smtp_port', '587');
        $mail->SMTPAuth      = setting('smtp_user') !== '';
        $mail->Username      = setting('smtp_user');
        $mail->Password      = setting('smtp_pass');
        $smtpSecure          = strtolower(setting('smtp_secure', 'tls'));
        $mail->SMTPSecure    = $smtpSecure === 'ssl'
            ? PHPMailer::ENCRYPTION_SMTPS
            : PHPMailer::ENCRYPTION_STARTTLS;
        $mail->CharSet       = 'UTF-8';

        $mail->setFrom(
            setting('smtp_from_email', setting('email')),
            setting('smtp_from_name', setting('business_name'))
        );
        $mail->addAddress($to);
        $mail->addReplyTo(setting('email'), setting('business_name'));

        foreach ($attachments as $att) {
            $mail->addAttachment($att['path'], $att['name']);
        }

        $mail->isHTML(true);
        $mail->Subject = $subject;
        $mail->Body    = $html_body;
        $mail->AltBody = trim(strip_tags($html_body));

        return $mail->send();
    } catch (MailException $e) {
        error_log('[mailer] ' . $e->getMessage());
        return false;
    }
}

/**
 * Notify the business of a new quote request.
 *
 * @param array<string,mixed> $data
 */
function send_quote_notification(array $data): bool
{
    $to = setting('email', 'info@locksmiths.ie');

    $rows = [
        'Name'           => $data['name'] ?? '',
        'Phone'          => $data['phone'] ?? '',
        'Email'          => $data['email'] ?? '',
        'Area'           => $data['area'] ?? '',
        'Service Needed' => $data['service_needed'] ?? '',
        'Message'        => $data['message'] ?? '',
        'Source Page'    => $data['source_page'] ?? '',
        'IP'             => $data['ip_address'] ?? '',
    ];

    $body = '<h2>New Quote Request — Locksmiths.ie</h2><table cellpadding="6" cellspacing="0" border="1">';
    foreach ($rows as $k => $v) {
        $body .= '<tr><th align="left">' . e($k) . '</th><td>' . nl2br(e((string) $v)) . '</td></tr>';
    }
    $body .= '</table>';

    return send_mail($to, 'New Quote Request — ' . ($data['area'] ?: 'Dublin'), $body);
}
