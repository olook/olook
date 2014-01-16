MinicartFadeOutManager = function(){

  hasToFadeOut = function(variantNumber){
    return $('.js-minicartItem').size() == 0 && !StringUtils.isEmpty(variantNumber);
  };

  fadeOut = function(){
    $("#total_price").val('0.0');

    $('.cart_related').fadeOut("fast",function(){
      $('.cart_related').addClass('product_added');
      $('.cart_related div.empty_minicart').hide();
    });
  };

  facade = function(variantNumber){
    if(hasToFadeOut(variantNumber)){
      fadeOut();
    }
  }

  return {
    name: "FADE_OUT_MINICART",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(MinicartFadeOutManager); 
});