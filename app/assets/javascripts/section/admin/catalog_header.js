// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require plugins/admin/countdown
new Countdown('#header_new_url', 50).placer().attach();
new Countdown('#header_old_url', 50).placer().attach();
new Countdown('#header_alt_small_banner1', 40).placer().attach();
new Countdown('#header_alt_small_banner2', 40).placer().attach();
new Countdown('#header_alt_medium_banner', 40).placer().attach();
new Countdown('#header_alt_big_banner', 40).placer().attach();
new Countdown('#header_title', 40).placer().attach();
new Countdown('#header_resume_title', 200).placer().attach();
new Countdown('#header_text_complement', 600).placer().attach();
$(document).ready(function() {
  function showHide(el) {
    var it = $(el);
    if(it.val() === '2'){
      $('#custom_url').show();
      $('#no_custom_url').hide();
    } else {
      $('#custom_url').hide();
      $('#no_custom_url').show();
    }
  }

  $('#header_url_type').change(function(){ showHide(this); });
  showHide('#header_url_type');
});


