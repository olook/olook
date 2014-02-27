AddToWishlistErrorMessage = function(){

  facade = function(parameters) {  
    var message = parameters[0];
    $('p.alert_size').html(message).show()
      .delay(3000).fadeOut();    
  }

  return {
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe("wishlist:add:error_message", AddToWishlistErrorMessage.facade, {}, AddToWishlistErrorMessage);
});
