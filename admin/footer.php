<?php
declare(strict_types=1);

require_once __DIR__ . '/../includes/functions.php';
admin_require();

$keys = [
    'footer_logo'    => 'Footer logo (path under /assets/, or a full URL — leave blank to reuse the header logo)',
    'footer_about'   => 'Footer about / tagline paragraph',
    'copyright_text' => 'Copyright line — placeholders: {year} {business} {psa}',
];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    foreach ($keys as $k => $_) {
        setting_save($k, (string)($_POST[$k] ?? ''));
    }
    $_SESSION['flash'] = ['type'=>'success','msg'=>'Footer settings saved.'];
    redirect('/admin/footer.php');
}

$admin_title = 'Footer';
require __DIR__ . '/_layout.php';

$footerLogo = setting('footer_logo') ?: setting('logo');
?>
<p>Edit the logo, about-text and copyright line that show in the dark footer.</p>

<div class="card" style="background:#1f1f1f;padding:1.5rem;border-radius:14px;margin-bottom:1.4rem;display:flex;align-items:center;justify-content:center;min-height:140px">
  <?php if ($footerLogo): ?>
    <img src="<?= e(preg_match('~^https?://~', $footerLogo) ? $footerLogo : asset('images/' . basename(parse_url($footerLogo, PHP_URL_PATH) ?? ''))) ?>"
         alt="Footer logo preview" style="max-height:90px;max-width:100%">
  <?php else: ?>
    <em style="color:#cfd6e4">No footer logo set</em>
  <?php endif; ?>
</div>

<form method="post" class="form-grid">
  <?= csrf_field() ?>

  <label class="col-2">Footer logo path / URL
    <input name="footer_logo" value="<?= e(setting('footer_logo')) ?>"
           placeholder="/assets/images/logo.webp">
    <small style="color:var(--c-muted,#5b6478);font-size:.85rem">Leave blank to fall back to the header logo set in <a href="logo.php">Logo</a>.</small>
  </label>

  <label class="col-2">Footer about / tagline
    <textarea name="footer_about" rows="3"><?= e(setting('footer_about', 'PSA-licensed Dublin locksmith. Emergency lockouts, lock changes, burglary repairs and smart-lock installation across Dublin and the Greater Dublin Area.')) ?></textarea>
  </label>

  <label class="col-2">Copyright line
    <input name="copyright_text"
           value="<?= e(setting('copyright_text', '© {year} {business} · PSA License {psa} · All rights reserved.')) ?>">
    <small style="color:var(--c-muted,#5b6478);font-size:.85rem">Placeholders: <code>{year}</code> <code>{business}</code> <code>{psa}</code></small>
  </label>

  <button class="btn btn--primary col-2">Save footer settings</button>
</form>

<?php require __DIR__ . '/_layout_end.php'; ?>
