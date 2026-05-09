<?php
require_once __DIR__ . '/../includes/functions.php';
admin_require();

$action = $_GET['action'] ?? 'list';
$id     = (int)($_GET['id'] ?? 0);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    $do = $_POST['do'] ?? '';

    if ($do === 'delete') {
        db_exec('DELETE FROM testimonials WHERE id = :id', [':id' => (int)$_POST['id']]);
        $_SESSION['flash'] = ['type' => 'success', 'msg' => 'Testimonial deleted.'];
        redirect('/admin/testimonials.php');
    }

    $data = [
        ':customer_name'     => trim((string)$_POST['customer_name']),
        ':customer_location' => (string)$_POST['customer_location'],
        ':rating'            => max(1, min(5, (int)$_POST['rating'])),
        ':review_body'       => trim((string)$_POST['review_body']),
        ':service_id'        => $_POST['service_id'] !== '' ? (int)$_POST['service_id'] : null,
        ':photo'             => (string)$_POST['photo'],
        ':review_date'       => $_POST['review_date'] !== '' ? (string)$_POST['review_date'] : null,
        ':is_featured'       => isset($_POST['is_featured']) ? 1 : 0,
        ':is_active'         => isset($_POST['is_active'])   ? 1 : 0,
    ];

    if ($do === 'create') {
        db_exec(
            'INSERT INTO testimonials
              (customer_name,customer_location,rating,review_body,service_id,photo,review_date,is_featured,is_active)
             VALUES
              (:customer_name,:customer_location,:rating,:review_body,:service_id,:photo,:review_date,:is_featured,:is_active)',
            $data
        );
    } else {
        $data[':id'] = (int)$_POST['id'];
        db_exec(
            'UPDATE testimonials SET
                customer_name=:customer_name, customer_location=:customer_location, rating=:rating,
                review_body=:review_body, service_id=:service_id, photo=:photo,
                review_date=:review_date, is_featured=:is_featured, is_active=:is_active
             WHERE id=:id',
            $data
        );
    }
    $_SESSION['flash'] = ['type' => 'success', 'msg' => 'Saved.'];
    redirect('/admin/testimonials.php');
}

$admin_title = 'Testimonials';
$services    = get_services();

if ($action === 'edit' || $action === 'new') {
    $row = $action === 'edit'
        ? db_one('SELECT * FROM testimonials WHERE id=:id', [':id' => $id])
        : ['id'=>0,'customer_name'=>'','customer_location'=>'','rating'=>5,'review_body'=>'',
           'service_id'=>'','photo'=>'','review_date'=>'','is_featured'=>0,'is_active'=>1];
    if (!$row) { http_response_code(404); exit; }
    require __DIR__ . '/_layout.php'; ?>
    <a href="testimonials.php">← Back</a>
    <h2><?= $action === 'edit' ? 'Edit' : 'New' ?> Testimonial</h2>
    <form method="post" class="form-grid">
      <?= csrf_field() ?>
      <input type="hidden" name="do" value="<?= $action === 'edit' ? 'update' : 'create' ?>">
      <input type="hidden" name="id" value="<?= (int)$row['id'] ?>">
      <label>Customer name <input name="customer_name" required value="<?= e($row['customer_name']) ?>"></label>
      <label>Location <input name="customer_location" value="<?= e((string)$row['customer_location']) ?>"></label>
      <label>Rating
        <select name="rating">
          <?php for ($i=5;$i>=1;$i--): ?>
            <option value="<?= $i ?>" <?= (int)$row['rating']===$i?'selected':'' ?>><?= $i ?> stars</option>
          <?php endfor; ?>
        </select>
      </label>
      <label>Service
        <select name="service_id">
          <option value="">— none —</option>
          <?php foreach ($services as $s): ?>
            <option value="<?= (int)$s['id'] ?>" <?= (int)$row['service_id']===(int)$s['id']?'selected':'' ?>><?= e($s['title']) ?></option>
          <?php endforeach; ?>
        </select>
      </label>
      <label>Photo URL <input name="photo" value="<?= e((string)$row['photo']) ?>"></label>
      <label>Review date <input type="date" name="review_date" value="<?= e((string)$row['review_date']) ?>"></label>
      <label class="col-2">Review body <textarea name="review_body" rows="4" required><?= e($row['review_body']) ?></textarea></label>
      <label><input type="checkbox" name="is_featured" <?= $row['is_featured']?'checked':'' ?>> Featured</label>
      <label><input type="checkbox" name="is_active"   <?= $row['is_active']  ?'checked':'' ?>> Active</label>
      <button class="btn btn--primary col-2" type="submit">Save</button>
    </form>
    <?php require __DIR__ . '/_layout_end.php'; exit;
}

$rows = db_all('SELECT * FROM testimonials ORDER BY is_featured DESC, review_date DESC');
require __DIR__ . '/_layout.php'; ?>
<a class="btn btn--primary" href="?action=new">+ New Testimonial</a>
<table class="table">
  <thead><tr><th>Name</th><th>Rating</th><th>Body</th><th>Featured</th><th>Active</th><th></th></tr></thead>
  <tbody>
  <?php foreach ($rows as $r): ?>
    <tr>
      <td><?= e($r['customer_name']) ?> <small><?= e((string)$r['customer_location']) ?></small></td>
      <td><?= str_repeat('★', (int)$r['rating']) ?></td>
      <td><?= e(mb_substr($r['review_body'], 0, 90)) ?>…</td>
      <td><?= $r['is_featured']?'★':'—' ?></td>
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
