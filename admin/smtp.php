<?php
require_once __DIR__ . '/../includes/mailer.php';
admin_require();

$keys = [
    'smtp_host'       => 'SMTP host',
    'smtp_port'       => 'SMTP port (587 / 465)',
    'smtp_user'       => 'SMTP username',
    'smtp_pass'       => 'SMTP password',
    'smtp_secure'     => 'Encryption (tls / ssl)',
    'smtp_from_email' => 'From email',
    'smtp_from_name'  => 'From name',
];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    if (!empty($_POST['test'])) {
        // save first
        foreach ($keys as $k => $_) setting_save($k, (string)($_POST[$k] ?? ''));
        $ok = send_mail(setting('email'), 'SMTP test from Locksmiths.ie', '<p>SMTP working.</p>');
        $_SESSION['flash'] = ['type' => $ok ? 'success' : 'error', 'msg' => $ok ? 'Test email sent.' : 'Test failed - check error log.'];
    } else {
        foreach ($keys as $k => $_) setting_save($k, (string)($_POST[$k] ?? ''));
        $_SESSION['flash'] = ['type'=>'success','msg'=>'SMTP settings saved.'];
    }
    redirect('/admin/smtp.php');
}

$admin_title = 'SMTP / Mail';
require __DIR__ . '/_layout.php';
?>
<form method="post" class="form-grid">
  <?= csrf_field() ?>
  <?php foreach ($keys as $k => $label): ?>
    <label class="col-2"><?= e($label) ?>
      <input name="<?= e($k) ?>" value="<?= e(setting($k)) ?>" <?= $k === 'smtp_pass' ? 'type="password"' : '' ?>>
    </label>
  <?php endforeach; ?>
  <button class="btn btn--primary">Save</button>
  <button class="btn" name="test" value="1">Save &amp; send test</button>
</form>
<?php require __DIR__ . '/_layout_end.php'; ?>
