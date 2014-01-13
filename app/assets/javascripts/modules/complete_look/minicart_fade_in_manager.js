function MinicartFadeInManager(){
  function hasToFadeIn(){
    return ($('.cart_related').css("display") == "none");
  }

  function fadeIn(){
    $('.cart_related').fadeIn("fast");    
  }

  this.facade = function(){
    if(hasToFadeIn()) {
      fadeIn();
    } 
  }  
}

$(function(){
  olookApp.mediator.subscribe("fadeInMinicart", new MinicartFadeInManager().facade); 
});