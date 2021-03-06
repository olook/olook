var MinicartFadeInManager = (function(){
  function MinicartFadeInManager(){};

  var hasToFadeIn = function(){
    return ($('.cart_related').css("display") == "none");
  };

  var fadeIn = function(){
    $('.cart_related').fadeIn("fast");
  };

  MinicartFadeInManager.prototype.facade = function(params) {
    if(hasToFadeIn()) {
      fadeIn();
    }
  };

  MinicartFadeInManager.prototype.config = function() {
    olookApp.subscribe('minicart:update:fadein', this.facade, {}, this);
  }

  return MinicartFadeInManager;
})();

