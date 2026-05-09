<?php
declare(strict_types=1);

require_once __DIR__ . '/../includes/functions.php';
admin_require();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    setting_save('custom_css', (string)($_POST['custom_css'] ?? ''));
    $_SESSION['flash'] = ['type'=>'success','msg'=>'Custom CSS saved.'];
    redirect('/admin/custom-css.php');
}

$admin_title = 'Custom CSS';
require __DIR__ . '/_layout.php';
?>
<p>CSS entered here is appended after the main stylesheet on every page. Use it for quick brand tweaks without redeploying.</p>
<form method="post" class="form-grid">
  <?= csrf_field() ?>
  <label class="col-2">Custom CSS
    <textarea name="custom_css" rows="22" style="font-family:ui-monospace,Consolas,monospace;font-size:.9rem;background:#0e1f4a;color:#e8efff;border-radius:8px;padding:1rem"
      placeholder="/* e.g.
.site-header { background: #0e1f4a; }
.btn--primary { background: #ff8c2a; }
*/"><?= e(setting('custom_css')) ?></textarea>
  </label>
  <button class="btn btn--primary col-2">Save Custom CSS</button>
</form>
<?php require __DIR__ . '/_layout_end.php'; ?>
