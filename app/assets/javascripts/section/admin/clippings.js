// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require plugins/admin/countdown

$(document).ready( function() {
  new Countdown('#clipping_title',40).placer().attach();
  new Countdown('#clipping_clipping_text',200).placer().attach();
  new Countdown('#clipping_alt',40).placer().attach();
});
