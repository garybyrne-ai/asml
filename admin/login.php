<?php
require_once __DIR__ . '/../includes/functions.php';

if (admin_check()) redirect('/admin/');

$missing      = db_missing_tables();
$schemaIssue  = !empty($missing);
$loginError   = $_SESSION['admin_login_error'] ?? null;
unset($_SESSION['admin_login_error']);

$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    $u = (string)($_POST['username'] ?? '');
    $p = (string)($_POST['password'] ?? '');
    if (admin_login($u, $p)) {
        redirect('/admin/');
    }
    $error = $schemaIssue
        ? 'Cannot log in — the database schema is missing tables. See banner above.'
        : 'Invalid credentials.';
    sleep(1);
}
?>
<!doctype html>
<html lang="en-IE">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Login · Locksmiths.ie</title>
<link rel="stylesheet" href="<?= e(asset('css/admin.css')) ?>">
<style>
.install-banner{background:#fff8ec;border:1px solid #ff8c2a;border-left-width:5px;border-radius:10px;padding:1rem 1.2rem;margin:0 0 1rem;color:#0e1f4a;font-size:.95rem}
.install-banner h2{margin:0 0 .35rem;font-size:1.05rem;color:#0e1f4a}
.install-banner code{background:#fff;padding:.05rem .35rem;border:1px solid #e2e7ef;border-radius:6px;font-size:.85rem}
.install-banner .btn{margin-top:.6rem}
</style>
</head>
<body class="admin admin--login">
<form class="login-card" method="post" action="">
  <h1>Locksmiths.ie Admin</h1>

  <?php if ($schemaIssue): ?>
    <div class="install-banner">
      <h2>Database is not fully installed</h2>
      <p>The following tables are missing: <code><?= e(implode(', ', $missing)) ?></code></p>
      <p>Click below to install the schema (creates any missing tables and seeds data — existing data is preserved).</p>
      <a class="btn btn--primary" href="<?= e(url('/admin/install.php')) ?>">Run installer →</a>
    </div>
  <?php endif; ?>

  <?php if ($loginError && !$schemaIssue): ?>
    <p class="alert alert--error"><strong>Database error:</strong> <?= e($loginError) ?></p>
  <?php endif; ?>

  <?php if ($error): ?>
    <p class="alert alert--error"><?= e($error) ?></p>
  <?php endif; ?>

  <?= csrf_field() ?>
  <label>Username or email <input type="text" name="username" required autofocus></label>
  <label>Password <input type="password" name="password" required></label>
  <button class="btn btn--primary btn--block" type="submit">Sign in</button>
</form>
</body>
</html>
