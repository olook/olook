var MinicartFadeOutManager = (function(){
  function MinicartFadeOutManager() {};

  var hasToFadeOut = function(variantNumber){
    return $('.js-minicartItem').size() == 0 && !StringUtils.isEmpty(variantNumber);
  };

  var fadeOut = function(){
    $("#total_price").val('0.0');

    $('.cart_related').fadeOut("fast",function(){
      $('.cart_related').addClass('look_product_added');
      $('.empty_minicart').hide();
    });
  };

  MinicartFadeOutManager.prototype.facade = function(params){
    if(hasToFadeOut(params['variantNumber'])){
      fadeOut();
    }
  }

  MinicartFadeOutManager.prototype.config = function(){
    olookApp.subscribe('minicart:update:fadeout', this.facade, {}, this);
  }

  return MinicartFadeOutManager;
})();
