function Countdown(domEl, charCount){
  this._input = $(domEl);
  this._count = charCount;
  if(this._input.next('.countdown').length == 1){
    this._placer = this._input.next('.countdown');
  };
};

Countdown.prototype.placer = function() {
  if(!this._placer) {
    this._input.after('<div class="countdown"></div>')
  }
}

Countdown.prototype.attach = function (){
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
