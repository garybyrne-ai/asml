<?php
require_once __DIR__ . '/../includes/functions.php';
admin_require();

$action = $_GET['action'] ?? 'list';
$id     = (int)($_GET['id'] ?? 0);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    $do = $_POST['do'] ?? '';

    if ($do === 'delete') {
        db_exec('DELETE FROM faqs WHERE id=:id', [':id' => (int)$_POST['id']]);
        $_SESSION['flash'] = ['type'=>'success','msg'=>'Deleted.'];
        redirect('/admin/faqs.php');
    }

    $data = [
        ':question'    => trim((string)$_POST['question']),
        ':answer'      => trim((string)$_POST['answer']),
        ':service_id'  => $_POST['service_id']  !== '' ? (int)$_POST['service_id']  : null,
        ':location_id' => $_POST['location_id'] !== '' ? (int)$_POST['location_id'] : null,
        ':is_global'   => isset($_POST['is_global']) ? 1 : 0,
        ':sort_order'  => (int)$_POST['sort_order'],
        ':is_active'   => isset($_POST['is_active']) ? 1 : 0,
    ];

    if ($do === 'create') {
        db_exec(
            'INSERT INTO faqs (question,answer,service_id,location_id,is_global,sort_order,is_active)
             VALUES (:question,:answer,:service_id,:location_id,:is_global,:sort_order,:is_active)',
            $data
        );
    } else {
        $data[':id'] = (int)$_POST['id'];
        db_exec(
            'UPDATE faqs SET question=:question, answer=:answer, service_id=:service_id,
              location_id=:location_id, is_global=:is_global, sort_order=:sort_order, is_active=:is_active
             WHERE id=:id',
            $data
        );
    }
    $_SESSION['flash'] = ['type'=>'success','msg'=>'Saved.'];
    redirect('/admin/faqs.php');
}

$admin_title = 'FAQs';
$services  = get_services();
$locations = get_locations();

if ($action === 'edit' || $action === 'new') {
    $row = $action === 'edit'
        ? db_one('SELECT * FROM faqs WHERE id=:id', [':id'=>$id])
        : ['id'=>0,'question'=>'','answer'=>'','service_id'=>'','location_id'=>'','is_global'=>1,'sort_order'=>0,'is_active'=>1];
    if (!$row) { http_response_code(404); exit; }
    require __DIR__ . '/_layout.php'; ?>
    <a href="faqs.php">← Back</a>
    <h2><?= $action === 'edit' ? 'Edit' : 'New' ?> FAQ</h2>
    <form method="post" class="form-grid">
      <?= csrf_field() ?>
      <input type="hidden" name="do" value="<?= $action === 'edit' ? 'update' : 'create' ?>">
      <input type="hidden" name="id" value="<?= (int)$row['id'] ?>">
      <label class="col-2">Question <input name="question" required value="<?= e($row['question']) ?>"></label>
      <label class="col-2">Answer <textarea name="answer" rows="4" required><?= e($row['answer']) ?></textarea></label>
      <label>Service (optional)
        <select name="service_id">
          <option value="">—</option>
          <?php foreach ($services as $s): ?>
            <option value="<?= (int)$s['id'] ?>" <?= (int)$row['service_id']===(int)$s['id']?'selected':'' ?>><?= e($s['title']) ?></option>
          <?php endforeach; ?>
        </select>
      </label>
      <label>Location (optional)
        <select name="location_id">
          <option value="">—</option>
          <?php foreach ($locations as $l): ?>
            <option value="<?= (int)$l['id'] ?>" <?= (int)$row['location_id']===(int)$l['id']?'selected':'' ?>><?= e($l['name']) ?></option>
          <?php endforeach; ?>
        </select>
      </label>
      <label>Sort order <input type="number" name="sort_order" value="<?= (int)$row['sort_order'] ?>"></label>
      <label><input type="checkbox" name="is_global" <?= $row['is_global']?'checked':'' ?>> Global (homepage)</label>
      <label><input type="checkbox" name="is_active" <?= $row['is_active']?'checked':'' ?>> Active</label>
      <button class="btn btn--primary col-2">Save</button>
    </form>
    <?php require __DIR__ . '/_layout_end.php'; exit;
}

$rows = db_all('SELECT * FROM faqs ORDER BY is_global DESC, sort_order, id');
require __DIR__ . '/_layout.php'; ?>
<a class="btn btn--primary" href="?action=new">+ New FAQ</a>
<table class="table">
  <thead><tr><th>Question</th><th>Scope</th><th>Active</th><th></th></tr></thead>
  <tbody>
  <?php foreach ($rows as $r): ?>
    <tr>
      <td><?= e($r['question']) ?></td>
      <td><?= $r['is_global']?'Global':($r['service_id']?'Service':($r['location_id']?'Location':'-')) ?></td>
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
