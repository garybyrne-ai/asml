<?php
require_once __DIR__ . '/../includes/functions.php';
admin_require();

$keys = [
    'business_name'    => 'Business name',
    'phone'            => 'Phone (display)',
    'phone_e164'       => 'Phone (E.164, e.g. +35312548888)',
    'whatsapp'         => 'WhatsApp number',
    'email'            => 'Email',
    'address_street'   => 'Street',
    'address_city'     => 'City',
    'address_postcode' => 'Eircode / postcode',
    'address_country'  => 'Country (ISO, e.g. IE)',
    'latitude'         => 'Latitude',
    'longitude'        => 'Longitude',
    'opening_hours'    => 'Opening hours (Schema format)',
    'price_range'      => 'Price range (€, €€, €€€)',
    'psa_license'      => 'PSA License Number',
    'response_time'    => 'Response time text',
    'logo'             => 'Logo path (under /assets/...)',
    'hero_title'       => 'Default hero H1',
    'hero_subtitle'    => 'Default hero subtitle',
    'google_maps_key'  => 'Google Maps API key (optional)',
];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    csrf_require();
    foreach ($keys as $k => $_) {
        setting_save($k, (string)($_POST[$k] ?? ''));
    }
    $_SESSION['flash'] = ['type'=>'success','msg'=>'Settings saved.'];
    redirect('/admin/settings.php');
}

$admin_title = 'Global Settings (NAP)';
require __DIR__ . '/_layout.php';
?>
<form method="post" class="form-grid">
  <?= csrf_field() ?>
  <?php foreach ($keys as $k => $label): ?>
    <label class="col-2"><?= e($label) ?>
      <input name="<?= e($k) ?>" value="<?= e(setting($k)) ?>">
    </label>
  <?php endforeach; ?>
  <button class="btn btn--primary col-2">Save settings</button>
</form>
<?php require __DIR__ . '/_layout_end.php'; ?>
