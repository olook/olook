MinicartFadeInManager = function(){
  var hasToFadeIn = function(){
    return ($('.cart_related').css("display") == "none");
  };

  var fadeIn = function(){
    $('.cart_related').fadeIn("fast");    
  };

  return{
    name: 'FADE_IN_MINICART',
    facade: function(){
      if(hasToFadeIn()) {
        fadeIn();
      } 
    }
  }

}();

$(function(){
  olookApp.subscribe(MinicartFadeInManager);
});