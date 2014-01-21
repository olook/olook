AddToWishlistErrorMessage = function(){

  facade = function(parameters) {  
    var message = parameters[0];
    $('p.alert_size').html(message).show()
      .delay(3000).fadeOut();    
  }

  return {
    name: "ADD_TO_WISHLIST_ERROR_MESSAGE",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(AddToWishlistErrorMessage); 
});