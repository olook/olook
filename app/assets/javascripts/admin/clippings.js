// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function CountDown(domEl, charCount){
  this._input = $(domEl);
  this._count = charCount;
  if(this._input.next('.countdown').length == 1){
    this._placer = this._input.next('.countdown');
  };
};

CountDown

CountDown.prototype.attach = function (){
  if(input.next('.countdown').length == 1){
    input.parent().find('.countdown').html(count);
  };
  input.change(function(){
    updateCountdown($(this), count);
  });
  input.keyup(function(){
    updateCountdown($(this), count);
  });
};










function updateCountdown(origin, count) {
  var remaining = count - origin.val().length;
  origin.parent().find('.countdown').text(remaining);
};
$(document).ready( function() {
  prepareCountdown($('#clipping_title'),40)
  prepareCountdown($('#clipping_clipping_text'),200)
  prepareCountdown($('#clipping_alt'),40)
});
