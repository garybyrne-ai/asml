<?php
require_once __DIR__ . '/../includes/functions.php';
admin_require();

$action = $_GET['action'] ?? 'list';
$id     = (int)($_GET['id'] ?? 0);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    $do = $_POST['do'] ?? '';

    if ($do === 'delete') {
        db_exec('DELETE FROM services WHERE id = :id', [':id' => (int)$_POST['id']]);
        $_SESSION['flash'] = ['type' => 'success', 'msg' => 'Service deleted.'];
        redirect('/admin/services.php');
    }

    $data = [
        ':slug'              => slugify((string)($_POST['slug']  ?? $_POST['title'] ?? '')),
        ':title'             => trim((string)$_POST['title']),
        ':category'          => (string)$_POST['category'],
        ':short_description' => (string)$_POST['short_description'],
        ':body'              => (string)$_POST['body'],
        ':icon'              => (string)$_POST['icon'],
        ':featured_image'    => (string)$_POST['featured_image'],
        ':meta_title'        => (string)$_POST['meta_title'],
        ':meta_description'  => (string)$_POST['meta_description'],
        ':focus_keyword'     => (string)$_POST['focus_keyword'],
        ':canonical_url'     => (string)$_POST['canonical_url'],
        ':price_from'        => $_POST['price_from'] !== '' ? (float)$_POST['price_from'] : null,
        ':is_active'         => isset($_POST['is_active']) ? 1 : 0,
        ':sort_order'        => (int)$_POST['sort_order'],
    ];

    if ($do === 'create') {
        db_exec(
            'INSERT INTO services
              (slug,title,category,short_description,body,icon,featured_image,meta_title,
               meta_description,focus_keyword,canonical_url,price_from,is_active,sort_order)
             VALUES
              (:slug,:title,:category,:short_description,:body,:icon,:featured_image,:meta_title,
               :meta_description,:focus_keyword,:canonical_url,:price_from,:is_active,:sort_order)',
            $data
        );
        $_SESSION['flash'] = ['type' => 'success', 'msg' => 'Service created.'];
    } elseif ($do === 'update') {
        $data[':id'] = (int)$_POST['id'];
        db_exec(
            'UPDATE services SET
                slug=:slug, title=:title, category=:category, short_description=:short_description,
                body=:body, icon=:icon, featured_image=:featured_image, meta_title=:meta_title,
                meta_description=:meta_description, focus_keyword=:focus_keyword,
                canonical_url=:canonical_url, price_from=:price_from,
                is_active=:is_active, sort_order=:sort_order
             WHERE id=:id',
            $data
        );
        $_SESSION['flash'] = ['type' => 'success', 'msg' => 'Service updated.'];
    }
    redirect('/admin/services.php');
}

$admin_title = 'Services';

if ($action === 'edit' || $action === 'new') {
    $row = $action === 'edit'
        ? db_one('SELECT * FROM services WHERE id = :id', [':id' => $id])
        : ['id' => 0,'slug'=>'','title'=>'','category'=>'residential','short_description'=>'',
           'body'=>'','icon'=>'','featured_image'=>'','meta_title'=>'','meta_description'=>'',
           'focus_keyword'=>'','canonical_url'=>'','price_from'=>'','is_active'=>1,'sort_order'=>0];
    if (!$row) { http_response_code(404); exit('Not found'); }

    require __DIR__ . '/_layout.php';
    ?>
    <a href="services.php">← Back</a>
    <h2><?= $action === 'edit' ? 'Edit' : 'New' ?> Service</h2>
    <form method="post" class="form-grid">
      <?= csrf_field() ?>
      <input type="hidden" name="do" value="<?= $action === 'edit' ? 'update' : 'create' ?>">
      <input type="hidden" name="id" value="<?= (int)$row['id'] ?>">

      <label class="col-2">Title <input name="title" required value="<?= e($row['title']) ?>"></label>
      <label>Slug <input name="slug" value="<?= e($row['slug']) ?>" placeholder="auto from title"></label>
      <label>Category
        <select name="category">
          <?php foreach (['emergency','residential','commercial','automotive','safe'] as $c): ?>
            <option <?= $row['category'] === $c ? 'selected' : '' ?>><?= $c ?></option>
          <?php endforeach; ?>
        </select>
      </label>
      <label>Icon (key/lock/car/shield/wifi/briefcase) <input name="icon" value="<?= e($row['icon']) ?>"></label>
      <label>Price from (€) <input name="price_from" type="number" step="0.01" value="<?= e((string)$row['price_from']) ?>"></label>
      <label>Sort order <input name="sort_order" type="number" value="<?= (int)$row['sort_order'] ?>"></label>
      <label>Featured image (URL/path) <input name="featured_image" value="<?= e($row['featured_image']) ?>"></label>
      <label class="col-2">Short description <input name="short_description" maxlength="300" value="<?= e($row['short_description']) ?>"></label>
      <label class="col-2">Body (HTML) <textarea name="body" rows="10"><?= e($row['body']) ?></textarea></label>

      <fieldset class="col-2">
        <legend>SEO (Yoast-style)</legend>
        <label>Meta Title <input name="meta_title" maxlength="160" value="<?= e($row['meta_title']) ?>"></label>
        <label>Meta Description <textarea name="meta_description" maxlength="320" rows="2"><?= e($row['meta_description']) ?></textarea></label>
        <label>Focus Keyword <input name="focus_keyword" value="<?= e($row['focus_keyword']) ?>"></label>
        <label>Canonical URL <input name="canonical_url" value="<?= e($row['canonical_url']) ?>"></label>
      </fieldset>

      <label class="col-2"><input type="checkbox" name="is_active" <?= $row['is_active'] ? 'checked' : '' ?>> Active (visible on site)</label>

      <button class="btn btn--primary col-2" type="submit">Save</button>
    </form>
    <?php
    require __DIR__ . '/_layout_end.php';
    exit;
}

$rows = db_all('SELECT * FROM services ORDER BY sort_order, title');
require __DIR__ . '/_layout.php';
?>
<a class="btn btn--primary" href="?action=new">+ New Service</a>
<table class="table">
  <thead><tr><th>Title</th><th>Category</th><th>Slug</th><th>Active</th><th>Order</th><th></th></tr></thead>
  <tbody>
  <?php foreach ($rows as $r): ?>
    <tr>
      <td><?= e($r['title']) ?></td>
      <td><?= e($r['category']) ?></td>
      <td><code>/<?= e($r['slug']) ?></code></td>
      <td><?= $r['is_active'] ? '✓' : '—' ?></td>
      <td><?= (int)$r['sort_order'] ?></td>
      <td>
        <a href="?action=edit&id=<?= (int)$r['id'] ?>">Edit</a>
        <form method="post" style="display:inline" onsubmit="return confirm('Delete this service?');">
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
