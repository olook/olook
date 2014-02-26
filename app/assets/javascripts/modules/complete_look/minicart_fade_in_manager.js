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
    facade: facade
  }

}();

$(function(){
  olookApp.subscribe('minicart:update:fadein', MinicartFadeInManager.facade);
});
