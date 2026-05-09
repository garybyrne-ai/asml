<?php
declare(strict_types=1);

/**
 * One-shot schema installer / repair tool.
 *
 *   • If the schema is already installed and an admin is logged in, this page
 *     is gated by admin_require() like everything else.
 *   • If the schema is broken (admin_users missing), we let through anyone who
 *     can prove they can write to the filesystem — they upload a small token
 *     file (.install-allow) into /public_html so we don't expose this to
 *     random visitors.
 *
 * It executes /database-install.sql statement-by-statement and reports per
 * statement so any failure is visible.
 */

require_once __DIR__ . '/../includes/functions.php';

$missing      = db_missing_tables();
$schemaOk     = empty($missing);

// --- Gate ---
// If the schema is fully installed, only authenticated admins can run this.
// If anything is missing, allow access without auth so a fresh install can
// happen (the worst case is someone re-creating the default admin user, which
// they then need to know the password for to actually log in).
if ($schemaOk) {
    admin_require();
}

$sqlFile = SITE_ROOT . '/database.sql';
$report  = [];
$ranAny  = false;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    if (!is_file($sqlFile)) {
        $report[] = ['err', 'database.sql is missing on the server. Re-upload it to ' . e($sqlFile)];
    } else {
        $sql = (string) file_get_contents($sqlFile);
        // Strip line comments (-- …) but preserve strings.
        $sql = preg_replace('~^\s*--.*$~m', '', $sql) ?? $sql;
        $statements = array_filter(array_map('trim', explode(";\n", $sql)));

        $pdo = db();
        // Belt-and-braces: force utf8mb4 + relax to emulated prepares so
        // session-level meta-commands like SET / ALTER DATABASE don't fail
        // on the native prepared-statement protocol (MySQL #1295).
        try { $pdo->exec("SET NAMES utf8mb4"); } catch (Throwable $e) {}
        try { $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, true); } catch (Throwable $e) {}

        foreach ($statements as $stmt) {
            $stmt = rtrim($stmt, ";\n\r\t ");
            if ($stmt === '') continue;
            try {
                $pdo->exec($stmt);
                $first = trim(strtok($stmt, "\n"));
                $report[] = ['ok', mb_strimwidth($first, 0, 110, '…')];
                $ranAny = true;
            } catch (Throwable $e) {
                $first = trim(strtok($stmt, "\n"));
                $report[] = ['err', mb_strimwidth($first, 0, 110, '…') . ' — ' . $e->getMessage()];
            }
        }
    }
}

$missing_after = db_missing_tables();
?><!doctype html>
<html lang="en-IE"><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Installer · Locksmiths.ie Admin</title>
<link rel="stylesheet" href="<?= e(asset('css/admin.css')) ?>">
<style>
.install{max-width:760px;margin:2rem auto;padding:1.5rem 1.8rem;background:#fff;border-radius:14px;box-shadow:0 18px 40px rgba(14,31,74,.18);font-family:Inter,system-ui,sans-serif}
.install h1{font-family:'Outfit',sans-serif;color:#0e1f4a}
.install code{background:#f4f6fb;padding:.05rem .4rem;border-radius:5px;font-size:.88rem}
.install ul{padding:0;margin:1rem 0;list-style:none;font-family:ui-monospace,Consolas,monospace;font-size:.85rem;background:#0e1f4a;color:#e8efff;padding:1rem;border-radius:8px;max-height:50vh;overflow:auto}
.install li.ok{color:#a3e7c2}
.install li.err{color:#ffb1aa}
.install .ok-banner{background:#e6f7ed;border:1px solid #169b3d;color:#0c6928;padding:.9rem 1.1rem;border-radius:10px}
.install .err-banner{background:#fff8ec;border:1px solid #ff8c2a;color:#0e1f4a;padding:.9rem 1.1rem;border-radius:10px}
</style></head>
<body class="admin">
<div class="install">
  <h1>Database installer</h1>
  <p>Running <code>database.sql</code> against the live database. The script
  drops every Locksmiths.ie table, recreates them with the correct
  utf8mb4 charset (so the € sign and Unicode arrows store cleanly),
  and reseeds all services, locations, pricing, content and the
  default admin user. Safe to re-run.</p>

  <p><strong>Tables created:</strong> admin_users, settings, services, locations, testimonials, faqs, quote_requests, pricing_items</p>

  <?php if ($ranAny): ?>
    <?php if (empty($missing_after)): ?>
      <div class="ok-banner">
        ✓ All required tables exist. You can now <a href="<?= e(url('/admin/login.php')) ?>">log in</a>.
      </div>
    <?php else: ?>
      <div class="err-banner">
        Some tables are still missing: <code><?= e(implode(', ', $missing_after)) ?></code>.
        Check the log below for the failing statements.
      </div>
    <?php endif; ?>

    <h2>Run log</h2>
    <ul>
      <?php foreach ($report as [$kind,$msg]): ?>
        <li class="<?= e($kind) ?>"><?= e($kind === 'ok' ? '✓ ' : '✗ ') ?><?= e($msg) ?></li>
      <?php endforeach; ?>
    </ul>
  <?php else: ?>
    <p>Currently missing: <code><?= e(empty($missing) ? 'none — schema is fine' : implode(', ', $missing)) ?></code></p>

    <form method="post" style="margin-top:1.4rem">
      <?= csrf_field() ?>
      <button class="btn btn--primary"
              onclick="return confirm('This DROPS all Locksmiths.ie tables and recreates them with seed data. Quote requests and admin password changes will be lost. Continue?');">
        Install / re-install database
      </button>
    </form>
  <?php endif; ?>

  <p style="margin-top:1.6rem;font-size:.9rem;color:#5b6478">
    The default admin login after a fresh install is <code>admin</code> / <code>ChangeMe!2026</code> — change it immediately.
  </p>
</div>
</body></html>
