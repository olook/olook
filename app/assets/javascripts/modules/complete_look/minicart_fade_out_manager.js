function MinicartFadeOutManager(){
  function hasToFadeOut(variantNumber){
    return ((StringUtils.isEmpty($("#total_price").val()) || ($( ".cart_related ul li").length -1 == 0)) && !StringUtils.isEmpty(variantNumber));
  }

  function fadeOut(){
    $("#total_price").val('0.0');

    $('.cart_related').fadeOut("fast",function(){
      $('.cart_related').addClass('product_added');
      $('.cart_related div.empty_minicart').hide();    
    });
  }

  this.facade = function(variantNumber){
    if(hasToFadeOut(variantNumber)){
      fadeOut();
    }
  }
}

$(function(){
  olookApp.mediator.subscribe("fadeOutMinicart", new MinicartFadeOutManager().facade); 
});