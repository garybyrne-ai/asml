<?php
require_once __DIR__ . '/../includes/functions.php';

if (admin_check()) redirect('/admin/');

$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    $u = (string)($_POST['username'] ?? '');
    $p = (string)($_POST['password'] ?? '');
    if (admin_login($u, $p)) {
        redirect('/admin/');
    }
    $error = 'Invalid credentials.';
    sleep(1);
}
?>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Admin Login · Locksmiths.ie</title>
<link rel="stylesheet" href="<?= e(asset('css/admin.css')) ?>">
</head>
<body class="admin admin--login">
<form class="login-card" method="post" action="">
  <h1>Locksmiths.ie Admin</h1>
  <?php if ($error): ?><p class="alert alert--error"><?= e($error) ?></p><?php endif; ?>
  <?= csrf_field() ?>
  <label>Username or email <input type="text" name="username" required autofocus></label>
  <label>Password <input type="password" name="password" required></label>
  <button class="btn btn--primary btn--block" type="submit">Sign in</button>
</form>
</body>
</html>
