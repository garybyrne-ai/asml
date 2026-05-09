/* Locksmiths.ie — front-end JS (jQuery 3.7.1) */
(function ($) {
  'use strict';

  /* ---------------------------------------------------------------
   * Mega-dropdown navigation
   * ------------------------------------------------------------- */
  var $dropdowns = $('.has-dropdown');
  var isMobile   = function () { return window.matchMedia('(max-width: 960px)').matches; };

  // Force-hide every dropdown on init regardless of CSS state.
  $dropdowns.children('.dropdown').attr('hidden', true).hide();

  function closeAllDropdowns($except) {
    $dropdowns.not($except || []).each(function () {
      var $li = $(this);
      $li.removeClass('is-open');
      $li.children('.has-dropdown__toggle').attr('aria-expanded', 'false');
      $li.children('.dropdown').stop(true, true).slideUp(160, function () {
        $(this).attr('hidden', true);
      });
    });
  }

  function openDropdown($li) {
    $li.addClass('is-open');
    $li.children('.has-dropdown__toggle').attr('aria-expanded', 'true');
    var $dd = $li.children('.dropdown').removeAttr('hidden');
    $dd.stop(true, true).slideDown(180);
  }

  // Click on the parent toggle: prevent navigation, open the dropdown.
  // Second click (on an already-open one) lets the link go through.
  $('.has-dropdown__toggle').on('click', function (e) {
    var $li = $(this).parent('.has-dropdown');
    if (!$li.hasClass('is-open')) {
      e.preventDefault();
      closeAllDropdowns($li);
      openDropdown($li);
    } else if (isMobile()) {
      // On mobile a second tap closes; we never auto-navigate the parent
      e.preventDefault();
      closeAllDropdowns();
    }
  });

  // Hover-open on desktop (with a small delay)
  var hoverTimer;
  $dropdowns.on('mouseenter', function () {
    if (isMobile()) return;
    clearTimeout(hoverTimer);
    var $li = $(this);
    closeAllDropdowns($li);
    openDropdown($li);
  }).on('mouseleave', function () {
    if (isMobile()) return;
    var $li = $(this);
    hoverTimer = setTimeout(function () {
      $li.removeClass('is-open');
      $li.children('.has-dropdown__toggle').attr('aria-expanded', 'false');
      $li.children('.dropdown').stop(true, true).slideUp(160, function () {
        $(this).attr('hidden', true);
      });
    }, 160);
  });

  // Outside click closes
  $(document).on('click', function (e) {
    if (!$(e.target).closest('.has-dropdown').length) closeAllDropdowns();
  });

  // ESC closes
  $(document).on('keydown', function (e) {
    if (e.key === 'Escape') {
      closeAllDropdowns();
      $('.primary-nav').removeClass('is-open');
      $('.nav-toggle').attr('aria-expanded', 'false');
    }
  });

  /* ---------------------------------------------------------------
   * Mobile menu toggle (hamburger)
   * ------------------------------------------------------------- */
  $('.nav-toggle').on('click', function () {
    var $nav = $('.primary-nav');
    var open = $nav.toggleClass('is-open').hasClass('is-open');
    $(this).attr('aria-expanded', open ? 'true' : 'false');
    if (!open) closeAllDropdowns();
  });

  // When a leaf nav link is clicked on mobile, close the menu
  $('#primary-menu a').not('.has-dropdown__toggle').on('click', function () {
    if (isMobile()) {
      $('.primary-nav').removeClass('is-open');
      $('.nav-toggle').attr('aria-expanded', 'false');
      closeAllDropdowns();
    }
  });

  /* ---------------------------------------------------------------
   * Quote form
   * ------------------------------------------------------------- */
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
        if (window.dataLayer) window.dataLayer.push({ event: 'quote_submit_success' });
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

  /* ---------------------------------------------------------------
   * Tracking + smooth scroll
   * ------------------------------------------------------------- */
  $(document).on('click', 'a[href^="tel:"]', function () {
    if (window.dataLayer) {
      window.dataLayer.push({
        event: 'phone_call_click',
        phone_number: $(this).attr('href').replace('tel:', '')
      });
    }
  });

  $('a[href="#quote"]').on('click', function (e) {
    var t = $('#quote');
    if (t.length) { e.preventDefault(); $('html,body').animate({ scrollTop: t.offset().top - 80 }, 400); }
  });

})(jQuery);
