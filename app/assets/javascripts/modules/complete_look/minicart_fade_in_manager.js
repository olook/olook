MinicartFadeInManager = function(){
  var hasToFadeIn = function(){
    return ($('.cart_related').css("display") == "none");
  };

  var fadeIn = function(){
    $('.cart_related').fadeIn("fast");    
  };

  var facade = function(){
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
