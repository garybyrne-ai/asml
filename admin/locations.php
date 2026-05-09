<?php
require_once __DIR__ . '/../includes/functions.php';
admin_require();

$action = $_GET['action'] ?? 'list';
$id     = (int)($_GET['id'] ?? 0);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    $do = $_POST['do'] ?? '';

    if ($do === 'delete') {
        db_exec('DELETE FROM locations WHERE id = :id', [':id' => (int)$_POST['id']]);
        $_SESSION['flash'] = ['type' => 'success', 'msg' => 'Location deleted.'];
        redirect('/admin/locations.php');
    }

    $data = [
        ':slug'              => slugify((string)($_POST['slug']  ?? $_POST['name'] ?? '')),
        ':name'              => trim((string)$_POST['name']),
        ':region'            => (string)$_POST['region'],
        ':district_code'     => (string)$_POST['district_code'],
        ':landmark'          => (string)$_POST['landmark'],
        ':landmark_secondary'=> (string)$_POST['landmark_secondary'],
        ':intro'             => (string)$_POST['intro'],
        ':body'              => (string)$_POST['body'],
        ':latitude'          => $_POST['latitude']  !== '' ? (float)$_POST['latitude']  : null,
        ':longitude'         => $_POST['longitude'] !== '' ? (float)$_POST['longitude'] : null,
        ':featured_image'    => (string)$_POST['featured_image'],
        ':meta_title'        => (string)$_POST['meta_title'],
        ':meta_description'  => (string)$_POST['meta_description'],
        ':focus_keyword'     => (string)$_POST['focus_keyword'],
        ':canonical_url'     => (string)$_POST['canonical_url'],
        ':is_active'         => isset($_POST['is_active']) ? 1 : 0,
        ':sort_order'        => (int)$_POST['sort_order'],
    ];

    if ($do === 'create') {
        db_exec(
            'INSERT INTO locations
              (slug,name,region,district_code,landmark,landmark_secondary,intro,body,latitude,longitude,
               featured_image,meta_title,meta_description,focus_keyword,canonical_url,is_active,sort_order)
             VALUES
              (:slug,:name,:region,:district_code,:landmark,:landmark_secondary,:intro,:body,:latitude,:longitude,
               :featured_image,:meta_title,:meta_description,:focus_keyword,:canonical_url,:is_active,:sort_order)',
            $data
        );
        $_SESSION['flash'] = ['type' => 'success', 'msg' => 'Location created.'];
    } elseif ($do === 'update') {
        $data[':id'] = (int)$_POST['id'];
        db_exec(
            'UPDATE locations SET
                slug=:slug, name=:name, region=:region, district_code=:district_code,
                landmark=:landmark, landmark_secondary=:landmark_secondary,
                intro=:intro, body=:body, latitude=:latitude, longitude=:longitude,
                featured_image=:featured_image, meta_title=:meta_title,
                meta_description=:meta_description, focus_keyword=:focus_keyword,
                canonical_url=:canonical_url, is_active=:is_active, sort_order=:sort_order
             WHERE id=:id',
            $data
        );
        $_SESSION['flash'] = ['type' => 'success', 'msg' => 'Location updated.'];
    }
    redirect('/admin/locations.php');
}

$admin_title = 'Locations';

if ($action === 'edit' || $action === 'new') {
    $row = $action === 'edit'
        ? db_one('SELECT * FROM locations WHERE id = :id', [':id' => $id])
        : ['id'=>0,'slug'=>'','name'=>'','region'=>'dublin_city','district_code'=>'',
           'landmark'=>'','landmark_secondary'=>'','intro'=>'','body'=>'',
           'latitude'=>'','longitude'=>'','featured_image'=>'',
           'meta_title'=>'','meta_description'=>'','focus_keyword'=>'',
           'canonical_url'=>'','is_active'=>1,'sort_order'=>0];
    if (!$row) { http_response_code(404); exit('Not found'); }

    require __DIR__ . '/_layout.php'; ?>
    <a href="locations.php">← Back</a>
    <h2><?= $action === 'edit' ? 'Edit' : 'New' ?> Location</h2>
    <form method="post" class="form-grid">
      <?= csrf_field() ?>
      <input type="hidden" name="do" value="<?= $action === 'edit' ? 'update' : 'create' ?>">
      <input type="hidden" name="id" value="<?= (int)$row['id'] ?>">

      <label>Name <input name="name" required value="<?= e($row['name']) ?>"></label>
      <label>Slug <input name="slug" value="<?= e($row['slug']) ?>" placeholder="locksmith-..."></label>
      <label>Region
        <select name="region">
          <?php foreach (['dublin_city','dublin_county','kildare','meath','wicklow'] as $r): ?>
            <option value="<?= $r ?>" <?= $row['region'] === $r ? 'selected' : '' ?>><?= $r ?></option>
          <?php endforeach; ?>
        </select>
      </label>
      <label>District code (D1–D24) <input name="district_code" value="<?= e($row['district_code']) ?>"></label>
      <label>Landmark <input name="landmark" value="<?= e($row['landmark']) ?>" placeholder="e.g. Dundrum Town Centre"></label>
      <label>Secondary landmark <input name="landmark_secondary" value="<?= e($row['landmark_secondary']) ?>"></label>
      <label>Latitude <input name="latitude"  value="<?= e((string)$row['latitude']) ?>"></label>
      <label>Longitude <input name="longitude" value="<?= e((string)$row['longitude']) ?>"></label>
      <label>Sort order <input name="sort_order" type="number" value="<?= (int)$row['sort_order'] ?>"></label>
      <label>Featured image <input name="featured_image" value="<?= e($row['featured_image']) ?>"></label>

      <label class="col-2">Intro (1 sentence) <input name="intro" value="<?= e($row['intro']) ?>"></label>
      <label class="col-2">Body (HTML) <textarea name="body" rows="10"><?= e($row['body']) ?></textarea></label>

      <fieldset class="col-2">
        <legend>SEO</legend>
        <label>Meta Title <input name="meta_title" maxlength="160" value="<?= e($row['meta_title']) ?>"></label>
        <label>Meta Description <textarea name="meta_description" rows="2"><?= e($row['meta_description']) ?></textarea></label>
        <label>Focus Keyword <input name="focus_keyword" value="<?= e($row['focus_keyword']) ?>"></label>
        <label>Canonical URL <input name="canonical_url" value="<?= e($row['canonical_url']) ?>"></label>
      </fieldset>

      <label class="col-2"><input type="checkbox" name="is_active" <?= $row['is_active'] ? 'checked' : '' ?>> Active</label>

      <button class="btn btn--primary col-2" type="submit">Save</button>
    </form>
    <?php require __DIR__ . '/_layout_end.php'; exit;
}

$rows = db_all('SELECT * FROM locations ORDER BY region, sort_order, name');
require __DIR__ . '/_layout.php';
?>
<a class="btn btn--primary" href="?action=new">+ New Location</a>
<table class="table">
  <thead><tr><th>Name</th><th>Region</th><th>Code</th><th>Landmark</th><th>Slug</th><th>Active</th><th></th></tr></thead>
  <tbody>
  <?php foreach ($rows as $r): ?>
    <tr>
      <td><?= e($r['name']) ?></td>
      <td><?= e($r['region']) ?></td>
      <td><?= e((string)$r['district_code']) ?></td>
      <td><?= e((string)$r['landmark']) ?></td>
      <td><code>/<?= e($r['slug']) ?></code></td>
      <td><?= $r['is_active'] ? '✓' : '—' ?></td>
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
