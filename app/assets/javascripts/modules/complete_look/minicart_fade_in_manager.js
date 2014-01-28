MinicartFadeInManager = function(){
  hasToFadeIn = function(){
    return ($('.cart_related').css("display") == "none");
  };

  fadeIn = function(){
    $('.cart_related').fadeIn("fast");    
  };

  facade = function(){
    if(hasToFadeIn()) {
      fadeIn();
    } 
  }

  return{
    name: 'FADE_IN_MINICART',
    facade: facade
  }

}();

$(function(){
  olookApp.subscribe(MinicartFadeInManager);
});