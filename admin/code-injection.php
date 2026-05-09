<?php
require_once __DIR__ . '/../includes/functions.php';
admin_require();

$keys = [
    'inject_head'       => '&lt;head&gt; (Google Analytics, GTM, etc.)',
    'inject_body_start' => 'Body start (FB Pixel noscript, GTM noscript)',
    'inject_footer'     => 'Footer (chat widgets, retargeting pixels)',
];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    foreach ($keys as $k => $_) setting_save($k, (string)($_POST[$k] ?? ''));
    $_SESSION['flash'] = ['type'=>'success','msg'=>'Code injection saved.'];
    redirect('/admin/code-injection.php');
}

$admin_title = 'Code Injection';
require __DIR__ . '/_layout.php';
?>
<p>Add scripts that should appear globally on every page. Output is unescaped — only paste code from trusted sources.</p>
<form method="post" class="form-grid">
  <?= csrf_field() ?>
  <?php foreach ($keys as $k => $label): ?>
    <label class="col-2"><?= $label ?>
      <textarea name="<?= e($k) ?>" rows="6" style="font-family:ui-monospace,monospace"><?= e(setting($k)) ?></textarea>
    </label>
  <?php endforeach; ?>
  <button class="btn btn--primary">Save</button>
</form>
<?php require __DIR__ . '/_layout_end.php'; ?>
