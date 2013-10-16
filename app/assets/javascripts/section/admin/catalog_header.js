// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require plugins/admin/countdown
//= require plugins/admin/custom_url_attributes
new Countdown('#catalog_base_url', 50).placer().attach();
new Countdown('#catalog_base_alt_small_banner1', 40).placer().attach();
new Countdown('#catalog_base_alt_small_banner2', 40).placer().attach();
new Countdown('#catalog_base_alt_medium_banner', 40).placer().attach();
new Countdown('#catalog_base_alt_big_banner', 40).placer().attach();
new Countdown('#catalog_base_title', 40).placer().attach();
new Countdown('#catalog_base_resume_title', 200).placer().attach();
new Countdown('#catalog_base_text_complement', 600).placer().attach();
$(document).ready( function() {
  new CustomUrlAttributes('#catalog_base_new_url').show_hide();
});


