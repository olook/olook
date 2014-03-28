function Countdown(domEl, charCount){
  this._input = $(domEl);
  this._count = charCount;
  if(this._input.next('.countdown').length == 1){
    this._placer = this._input.next('.countdown');
  };
  return this;
};

Countdown.prototype.placer = function() {
  if(!this._placer) {
    this._input.after('<div class="countdown"></div>');
  }
  this._placer = this._input.next('.countdown');
  this._placer.html(this._count);
  return this;
}

Countdown.prototype.attach = function (){
  this.updateCount();
  var cd = this;
  this._input.keyup(function(){
    cd.updateCount();
  });
  this._input.change(function(){
    cd.updateCount();
  });
};

Countdown.prototype.updateCount = function (){
  try {
    this._placer.text(this._count - this._input.val().length);
  } catch (e) {
    console.log(e)
  }
};


// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

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


