// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function updateCountdown(origin, count) {
  var remaining = count - origin.val().length;
  origin.parent().find('.countdown').text(remaining);
};
function prepareCountdown(input,count){
  input.change(function(){
    updateCountdown($(this), count);
  });
  input.keyup(function(){
    updateCountdown($(this), count);
  });
};
$(document).ready( function() {
  prepareCountdown($('#clipping_title'),100)
  prepareCountdown($('#clipping_clipping_text'),240)
  prepareCountdown($('#clipping_alt'),50)
});
