<?php
require_once __DIR__ . '/../includes/functions.php';
admin_require();

$safe_count = function (string $sql): int {
    try { return (int)(db_one($sql)['c'] ?? 0); }
    catch (Throwable $e) { error_log('[admin index] ' . $e->getMessage()); return 0; }
};
$counts = [
    'services'     => $safe_count('SELECT COUNT(*) AS c FROM services'),
    'locations'    => $safe_count('SELECT COUNT(*) AS c FROM locations'),
    'testimonials' => $safe_count('SELECT COUNT(*) AS c FROM testimonials'),
    'faqs'         => $safe_count('SELECT COUNT(*) AS c FROM faqs'),
    'quotes_new'   => $safe_count("SELECT COUNT(*) AS c FROM quote_requests WHERE status='new'"),
];
try {
    $recent = db_all('SELECT id, name, phone, area, service_needed, created_at FROM quote_requests ORDER BY id DESC LIMIT 10');
} catch (Throwable $e) {
    error_log('[admin index recent] ' . $e->getMessage());
    $recent = [];
}

$missing = db_missing_tables();

$admin_title = 'Dashboard';
require __DIR__ . '/_layout.php';
?>
<?php if (!empty($missing)): ?>
  <div class="alert alert--error" style="background:#fff8ec;border:1px solid #ff8c2a;color:#0e1f4a">
    <strong>Schema incomplete.</strong> Missing tables: <code><?= e(implode(', ', $missing)) ?></code>.
    <a href="<?= e(url('/admin/install.php')) ?>">Run installer</a>.
  </div>
<?php endif; ?>
<div class="stat-grid">
  <a class="stat" href="services.php"><span class="stat__num"><?= $counts['services'] ?></span><span>Services</span></a>
  <a class="stat" href="locations.php"><span class="stat__num"><?= $counts['locations'] ?></span><span>Locations</span></a>
  <a class="stat" href="testimonials.php"><span class="stat__num"><?= $counts['testimonials'] ?></span><span>Testimonials</span></a>
  <a class="stat" href="faqs.php"><span class="stat__num"><?= $counts['faqs'] ?></span><span>FAQs</span></a>
  <a class="stat stat--alert" href="quotes.php"><span class="stat__num"><?= $counts['quotes_new'] ?></span><span>New Quotes</span></a>
</div>

<h2>Recent quote requests</h2>
<table class="table">
  <thead><tr><th>Date</th><th>Name</th><th>Phone</th><th>Area</th><th>Service</th></tr></thead>
  <tbody>
  <?php foreach ($recent as $r): ?>
    <tr>
      <td><?= e($r['created_at']) ?></td>
      <td><?= e($r['name']) ?></td>
      <td><a href="tel:<?= e($r['phone']) ?>"><?= e($r['phone']) ?></a></td>
      <td><?= e($r['area']) ?></td>
      <td><?= e($r['service_needed']) ?></td>
    </tr>
  <?php endforeach; ?>
  </tbody>
</table>
<?php require __DIR__ . '/_layout_end.php'; ?>
