<?php
/**
 * Local production overrides for Locksmiths.ie.
 *
 *   1. Copy this file to /includes/config.local.php on the live server.
 *   2. Fill in the real values from Cloudways → Application → Access Details.
 *   3. /includes/config.local.php is gitignored, so it never reaches the repo.
 */

define('DB_HOST', 'localhost');     // Cloudways usually uses 'localhost'
define('DB_NAME', 'eqdueglqgt');    // Cloudways DB name (Application Access Details)
define('DB_USER', 'eqdueglqgt');    // Cloudways DB user
define('DB_PASS', 'CHANGE_ME');     // Cloudways DB password

define('SITE_URL', 'https://locksmiths.ie');
define('ENV',      'production');
