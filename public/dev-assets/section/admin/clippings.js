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


$(document).ready( function() {
  new Countdown('#clipping_title',40).placer().attach();
  new Countdown('#clipping_clipping_text',200).placer().attach();
  new Countdown('#clipping_alt',40).placer().attach();
});
