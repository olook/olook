// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function updateCountdown(origin, count) {
  var remaining = count - origin.val().length;
  origin.parent().find('.countdown').text(remaining);
};
function prepareCountdown(input,count){
  if(input.parent().find('.countdown').length == 1){
    input.parent().find('.countdown').html(count);
  };
  input.change(function(){
    updateCountdown($(this), count);
  });
  input.keyup(function(){
    updateCountdown($(this), count);
  });
};
$(document).ready( function() {
  prepareCountdown($('#clipping_title'),40)
  prepareCountdown($('#clipping_clipping_text'),200)
  prepareCountdown($('#clipping_alt'),40)
});
