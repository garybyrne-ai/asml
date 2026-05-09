<?php
require_once __DIR__ . '/../includes/functions.php';
admin_require();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    $do = $_POST['do'] ?? '';
    if ($do === 'status') {
        db_exec('UPDATE quote_requests SET status=:s WHERE id=:id', [
            ':s'  => (string)$_POST['status'],
            ':id' => (int)$_POST['id'],
        ]);
    } elseif ($do === 'delete') {
        db_exec('DELETE FROM quote_requests WHERE id=:id', [':id' => (int)$_POST['id']]);
    }
    $_SESSION['flash'] = ['type'=>'success','msg'=>'Updated.'];
    redirect('/admin/quotes.php');
}

$rows = db_all('SELECT * FROM quote_requests ORDER BY id DESC LIMIT 200');
$admin_title = 'Quote Requests';
require __DIR__ . '/_layout.php'; ?>

<table class="table">
  <thead><tr><th>Date</th><th>Name</th><th>Phone</th><th>Email</th><th>Area</th><th>Service</th><th>Status</th><th></th></tr></thead>
  <tbody>
  <?php foreach ($rows as $r): ?>
    <tr class="status-<?= e($r['status']) ?>">
      <td><?= e($r['created_at']) ?></td>
      <td><?= e($r['name']) ?></td>
      <td><a href="tel:<?= e($r['phone']) ?>"><?= e($r['phone']) ?></a></td>
      <td><?= e((string)$r['email']) ?></td>
      <td><?= e((string)$r['area']) ?></td>
      <td><?= e((string)$r['service_needed']) ?></td>
      <td>
        <form method="post" style="display:inline">
          <?= csrf_field() ?>
          <input type="hidden" name="do" value="status">
          <input type="hidden" name="id" value="<?= (int)$r['id'] ?>">
          <select name="status" onchange="this.form.submit()">
            <?php foreach (['new','contacted','closed','spam'] as $s): ?>
              <option <?= $r['status']===$s?'selected':'' ?>><?= $s ?></option>
            <?php endforeach; ?>
          </select>
        </form>
      </td>
      <td>
        <form method="post" onsubmit="return confirm('Delete?');" style="display:inline">
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
