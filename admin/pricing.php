<?php
require_once __DIR__ . '/../includes/functions.php';
admin_require();

$action = $_GET['action'] ?? 'list';
$id     = (int)($_GET['id'] ?? 0);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    $do = $_POST['do'] ?? '';

    if ($do === 'delete') {
        db_exec('DELETE FROM pricing_items WHERE id=:id', [':id' => (int)$_POST['id']]);
        $_SESSION['flash'] = ['type'=>'success','msg'=>'Deleted.'];
        redirect('/admin/pricing.php');
    }

    if ($do === 'save_settings') {
        setting_save('minimum_price',  trim((string)($_POST['minimum_price']  ?? '')));
        setting_save('callout_policy', trim((string)($_POST['callout_policy'] ?? '')));
        setting_save('pricing_intro',  trim((string)($_POST['pricing_intro']  ?? '')));
        $_SESSION['flash'] = ['type'=>'success','msg'=>'Pricing settings saved.'];
        redirect('/admin/pricing.php');
    }

    $price_from = ($_POST['price_from'] ?? '') !== '' ? (float)$_POST['price_from'] : null;
    $data = [
        ':label'      => trim((string)$_POST['label']),
        ':price_text' => trim((string)$_POST['price_text']),
        ':price_from' => $price_from,
        ':note'       => trim((string)$_POST['note']) ?: null,
        ':sort_order' => (int)$_POST['sort_order'],
        ':is_active'  => isset($_POST['is_active']) ? 1 : 0,
    ];

    if ($do === 'create') {
        db_exec(
            'INSERT INTO pricing_items (label, price_text, price_from, note, sort_order, is_active)
             VALUES (:label, :price_text, :price_from, :note, :sort_order, :is_active)',
            $data
        );
    } else {
        $data[':id'] = (int)$_POST['id'];
        db_exec(
            'UPDATE pricing_items SET label=:label, price_text=:price_text, price_from=:price_from,
              note=:note, sort_order=:sort_order, is_active=:is_active
             WHERE id=:id',
            $data
        );
    }
    $_SESSION['flash'] = ['type'=>'success','msg'=>'Saved.'];
    redirect('/admin/pricing.php');
}

$admin_title = 'Pricing';

if ($action === 'edit' || $action === 'new') {
    $row = $action === 'edit'
        ? db_one('SELECT * FROM pricing_items WHERE id=:id', [':id'=>$id])
        : ['id'=>0,'label'=>'','price_text'=>'','price_from'=>'','note'=>'','sort_order'=>0,'is_active'=>1];
    if (!$row) { http_response_code(404); exit; }
    require __DIR__ . '/_layout.php'; ?>
    <a href="pricing.php">← Back</a>
    <h2><?= $action === 'edit' ? 'Edit' : 'New' ?> price item</h2>
    <form method="post" class="form-grid">
      <?= csrf_field() ?>
      <input type="hidden" name="do" value="<?= $action === 'edit' ? 'update' : 'create' ?>">
      <input type="hidden" name="id" value="<?= (int)$row['id'] ?>">
      <label class="col-2">Service / item
        <input name="label" required maxlength="200" value="<?= e($row['label']) ?>">
      </label>
      <label>Price (display, e.g. €115 or €175 – €245)
        <input name="price_text" required maxlength="60" value="<?= e($row['price_text']) ?>">
      </label>
      <label>Price from (numeric, used for Schema)
        <input name="price_from" type="number" step="0.01" value="<?= e((string)$row['price_from']) ?>">
      </label>
      <label class="col-2">Short note (optional)
        <input name="note" maxlength="200" value="<?= e($row['note'] ?? '') ?>">
      </label>
      <label>Sort order
        <input type="number" name="sort_order" value="<?= (int)$row['sort_order'] ?>">
      </label>
      <label><input type="checkbox" name="is_active" <?= $row['is_active']?'checked':'' ?>> Active</label>
      <button class="btn btn--primary col-2">Save</button>
    </form>
    <?php require __DIR__ . '/_layout_end.php'; exit;
}

$rows = db_all('SELECT * FROM pricing_items ORDER BY sort_order, id');
require __DIR__ . '/_layout.php'; ?>

<form method="post" class="form-grid" style="background:var(--c-bg-alt,#f4f6fb);padding:1rem 1.2rem;border-radius:10px;margin-bottom:1.4rem">
  <?= csrf_field() ?>
  <input type="hidden" name="do" value="save_settings">
  <h3 class="col-2" style="margin:.2rem 0 .6rem">Page-wide settings</h3>
  <label>Minimum price (display)
    <input name="minimum_price" value="<?= e(setting('minimum_price', '€90')) ?>">
  </label>
  <label class="col-2">Call-out policy
    <input name="callout_policy" value="<?= e(setting('callout_policy', 'Minimum job price €90. We do not offer free call-outs.')) ?>">
  </label>
  <label class="col-2">Pricing page intro
    <textarea name="pricing_intro" rows="2"><?= e(setting('pricing_intro')) ?></textarea>
  </label>
  <button class="btn col-2">Save settings</button>
</form>

<a class="btn btn--primary" href="?action=new">+ New price item</a>
<table class="table">
  <thead><tr><th>#</th><th>Service</th><th>Price</th><th>Active</th><th></th></tr></thead>
  <tbody>
  <?php foreach ($rows as $r): ?>
    <tr>
      <td><?= (int)$r['sort_order'] ?></td>
      <td><strong><?= e($r['label']) ?></strong>
        <?php if (!empty($r['note'])): ?><br><small><?= e($r['note']) ?></small><?php endif; ?>
      </td>
      <td><?= e($r['price_text']) ?></td>
      <td><?= $r['is_active']?'✓':'—' ?></td>
      <td>
        <a href="?action=edit&id=<?= (int)$r['id'] ?>">Edit</a>
        <form method="post" style="display:inline" onsubmit="return confirm('Delete?');">
          <?= csrf_field() ?>
          <input type="hidden" name="do" value="delete">
          <input type="hidden" name="id" value="<?= (int)$r['id'] ?>">
          <button class="link-button">Delete</button>
        </form>
      </td>
    </tr>
  <?php endforeach; ?>
  </tbody>
</table>
<?php require __DIR__ . '/_layout_end.php'; ?>
