function CustomUrlAttributes(domEl){
  this._input = $(domEl);
  if(this._input.val() == 'Nova url'){
    $('#custom_url').show();
  }else{
    $('#custom_url').hide();
  }
  return this;
};
CustomUrlAttributes.prototype.show_hide = function() {
  this._input.change(function(){
    if(this.value == 'Nova url'){
      $('#custom_url').show();
    }else{
      $('#custom_url').hide();
    }
  });
};
