<?php
declare(strict_types=1);

require_once __DIR__ . '/../includes/functions.php';
admin_require();

/**
 * Logo upload + auto-process.
 *
 *   • Accepts PNG / JPG / WebP up to 5 MB
 *   • Trims fully-transparent / pure-black border pixels
 *   • Resizes to a configurable max width (default 250 px)
 *   • Saves a high-quality WebP to /assets/images/logo.webp
 *   • A PNG fallback is also written to /assets/images/logo.png
 *   • Updates the `logo` setting so the rest of the site picks it up
 */

const LOGO_DIR        = __DIR__ . '/../assets/images';
const LOGO_MAX_BYTES  = 5 * 1024 * 1024;
const LOGO_BG_TOL     = 12;          // 0–255, pixels darker/lighter than this on each channel are kept

$flash = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    try {
        if (!isset($_FILES['logo']) || $_FILES['logo']['error'] !== UPLOAD_ERR_OK) {
            throw new RuntimeException('No file uploaded.');
        }
        if ($_FILES['logo']['size'] > LOGO_MAX_BYTES) {
            throw new RuntimeException('File is larger than 5 MB.');
        }
        $maxWidth = max(80, min(800, (int)($_POST['max_width'] ?? 250)));

        [$pngPath, $webpPath, $finalW, $finalH] = process_logo($_FILES['logo']['tmp_name'], $maxWidth);

        // Save with a cache-bust timestamp so the browser fetches the new file.
        setting_save('logo', '/assets/images/logo.webp?v=' . time());
        $flash = ['type'=>'success', 'msg'=>"Logo saved ({$finalW}×{$finalH} px). Hard-refresh the front-end to see it."];
    } catch (Throwable $e) {
        $flash = ['type'=>'error', 'msg'=>$e->getMessage()];
    }
}

/**
 * Returns [png_path, webp_path, width, height]
 */
function process_logo(string $tmp, int $maxW): array
{
    $info = getimagesize($tmp);
    if (!$info) throw new RuntimeException('Not an image.');

    switch ($info[2]) {
        case IMAGETYPE_PNG:  $src = imagecreatefrompng($tmp);  break;
        case IMAGETYPE_JPEG: $src = imagecreatefromjpeg($tmp); break;
        case IMAGETYPE_WEBP: $src = imagecreatefromwebp($tmp); break;
        default: throw new RuntimeException('Use PNG, JPG or WebP.');
    }
    if (!$src) throw new RuntimeException('Could not decode image.');

    imagepalettetotruecolor($src);
    imagealphablending($src, false);
    imagesavealpha($src, true);

    [$cropped, $cw, $ch] = trim_borders($src);
    imagedestroy($src);

    // Resize keeping aspect ratio, only down-scale if larger
    if ($cw > $maxW) {
        $newW = $maxW;
        $newH = (int) round($ch * ($maxW / $cw));
        $resized = imagecreatetruecolor($newW, $newH);
        imagealphablending($resized, false);
        imagesavealpha($resized, true);
        imagefill($resized, 0, 0, imagecolorallocatealpha($resized, 0, 0, 0, 127));
        imagecopyresampled($resized, $cropped, 0, 0, 0, 0, $newW, $newH, $cw, $ch);
        imagedestroy($cropped);
    } else {
        $resized = $cropped;
        $newW = $cw; $newH = $ch;
    }

    if (!is_dir(LOGO_DIR) && !mkdir(LOGO_DIR, 0775, true)) {
        throw new RuntimeException('assets/images is not writable.');
    }
    $pngPath  = LOGO_DIR . '/logo.png';
    $webpPath = LOGO_DIR . '/logo.webp';

    if (!imagepng($resized, $pngPath, 9))         throw new RuntimeException('PNG save failed.');
    if (!imagewebp($resized, $webpPath, 92))      throw new RuntimeException('WebP save failed.');
    imagedestroy($resized);

    return [$pngPath, $webpPath, $newW, $newH];
}

/**
 * Trim transparent and near-black borders.
 * Returns [GdImage, width, height]
 */
function trim_borders(\GdImage $img): array
{
    $w = imagesx($img);
    $h = imagesy($img);

    $isBg = static function (int $rgba): bool {
        $a = ($rgba >> 24) & 0x7F;          // 0 = opaque, 127 = transparent
        if ($a > 100) return true;          // mostly transparent → background
        $r = ($rgba >> 16) & 0xFF;
        $g = ($rgba >> 8)  & 0xFF;
        $b =  $rgba        & 0xFF;
        // Treat near-black-on-fully-opaque-PNG as background only if it's a
        // very narrow band on every channel — otherwise it's logo.
        return ($a < 20 && $r < LOGO_BG_TOL && $g < LOGO_BG_TOL && $b < LOGO_BG_TOL);
    };

    $top = 0; $bot = $h - 1; $left = 0; $right = $w - 1;

    // top
    for (; $top < $h; $top++) {
        for ($x = 0; $x < $w; $x++) {
            if (!$isBg(imagecolorat($img, $x, $top))) break 2;
        }
    }
    // bottom
    for (; $bot > $top; $bot--) {
        for ($x = 0; $x < $w; $x++) {
            if (!$isBg(imagecolorat($img, $x, $bot))) break 2;
        }
    }
    // left
    for (; $left < $w; $left++) {
        for ($y = $top; $y <= $bot; $y++) {
            if (!$isBg(imagecolorat($img, $left, $y))) break 2;
        }
    }
    // right
    for (; $right > $left; $right--) {
        for ($y = $top; $y <= $bot; $y++) {
            if (!$isBg(imagecolorat($img, $right, $y))) break 2;
        }
    }

    $cw = $right - $left + 1;
    $ch = $bot   - $top  + 1;
    if ($cw < 10 || $ch < 10) {
        // Couldn't detect — return original
        return [$img, $w, $h];
    }

    $out = imagecreatetruecolor($cw, $ch);
    imagealphablending($out, false);
    imagesavealpha($out, true);
    imagefill($out, 0, 0, imagecolorallocatealpha($out, 0, 0, 0, 127));
    imagecopy($out, $img, 0, 0, $left, $top, $cw, $ch);
    return [$out, $cw, $ch];
}

$admin_title = 'Logo Upload';
require __DIR__ . '/_layout.php';

$current = setting('logo', '/assets/images/locksmiths-ie-logo-horizontal.svg');
?>
<?php if ($flash): ?>
  <div class="alert alert--<?= e($flash['type']) ?>"><?= e($flash['msg']) ?></div>
<?php endif; ?>

<p>Upload a PNG, JPG or WebP. The image is automatically trimmed of transparent / black borders and converted to a 250 px-wide WebP for use in the menu.</p>

<div class="card" style="background:#0e1f4a;padding:1.5rem;border-radius:14px;margin-bottom:1.4rem;display:flex;align-items:center;justify-content:center;min-height:140px">
  <img src="<?= e(asset('images/' . basename($current))) ?>?v=<?= e((string)time()) ?>" alt="Current logo" style="max-height:90px;max-width:100%">
</div>

<form method="post" enctype="multipart/form-data" class="form-grid">
  <?= csrf_field() ?>
  <label class="col-2">Choose image
    <input type="file" name="logo" accept="image/png,image/jpeg,image/webp" required>
  </label>
  <label>Max width (px)
    <input type="number" name="max_width" value="250" min="80" max="800">
  </label>
  <button class="btn btn--primary col-2">Upload &amp; convert</button>
</form>

<?php require __DIR__ . '/_layout_end.php'; ?>
