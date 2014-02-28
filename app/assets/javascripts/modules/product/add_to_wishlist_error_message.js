AddToWishlistErrorMessage = function(){

  facade = function(message) {
    $('p.alert_size').html(message).show()
      .delay(3000).fadeOut();    
  }

  return {
    facade: facade,
    name: "wishlist:add:error_message"
  };
}();

$(function(){
  olookApp.subscribe("wishlist:add:error_message", AddToWishlistErrorMessage.facade, {}, AddToWishlistErrorMessage);
});
