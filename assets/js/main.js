/* Locksmiths.ie — front-end JS (jQuery 3.7.1) */
(function ($) {
  'use strict';

  // Mobile nav toggle
  $('.nav-toggle').on('click', function () {
    var $nav = $('.primary-nav');
    var open = $nav.toggleClass('is-open').hasClass('is-open');
    $(this).attr('aria-expanded', open ? 'true' : 'false');
  });

  // Close mobile menu after clicking a real (leaf) link
  $('#primary-menu a').on('click', function (e) {
    var $li = $(this).parent('li.has-dropdown');
    if ($li.length && window.matchMedia('(max-width: 960px)').matches) {
      // On mobile a tap on the parent toggles the submenu rather than navigating
      e.preventDefault();
      $li.toggleClass('is-open').siblings().removeClass('is-open');
      return;
    }
    $('.primary-nav').removeClass('is-open');
    $('.has-dropdown').removeClass('is-open');
    $('.nav-toggle').attr('aria-expanded', 'false');
  });

  // Close dropdowns on outside click
  $(document).on('click', function (e) {
    if (!$(e.target).closest('.has-dropdown').length) {
      $('.has-dropdown').removeClass('is-open');
    }
  });

  // ESC closes
  $(document).on('keydown', function (e) {
    if (e.key === 'Escape') {
      $('.has-dropdown, .primary-nav').removeClass('is-open');
      $('.nav-toggle').attr('aria-expanded', 'false');
    }
  });

  // AJAX quote submit
  $('#quote-form').on('submit', function (e) {
    e.preventDefault();

    var $form = $(this);
    var $msg  = $form.find('.quote-form__msg').removeClass('is-success is-error').text('Sending…');
    var $btn  = $form.find('button[type="submit"]').prop('disabled', true);

    $.ajax({
      url: '/api/quote.php',
      method: 'POST',
      data: $form.serialize(),
      dataType: 'json'
    }).done(function (res) {
      if (res && res.ok) {
        $msg.addClass('is-success').text(res.message || 'Thank you — we will call you shortly.');
        $form[0].reset();
        if (window.dataLayer) {
          window.dataLayer.push({ event: 'quote_submit_success' });
        }
      } else {
        $msg.addClass('is-error').text((res && res.error) || 'Something went wrong.');
      }
    }).fail(function (xhr) {
      var err = (xhr.responseJSON && xhr.responseJSON.error)
        || 'Network error. Please call us directly: ' + ($('.header-call strong').text() || '');
      $msg.addClass('is-error').text(err);
    }).always(function () {
      $btn.prop('disabled', false);
    });
  });

  // Track click-to-call events
  $(document).on('click', 'a[href^="tel:"]', function () {
    if (window.dataLayer) {
      window.dataLayer.push({
        event: 'phone_call_click',
        phone_number: $(this).attr('href').replace('tel:', '')
      });
    }
  });

  // Smooth-scroll to #quote
  $('a[href="#quote"]').on('click', function (e) {
    var t = $('#quote');
    if (t.length) { e.preventDefault(); $('html,body').animate({ scrollTop: t.offset().top - 80 }, 400); }
  });

})(jQuery);
