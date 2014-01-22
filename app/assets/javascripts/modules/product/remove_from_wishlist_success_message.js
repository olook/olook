RemoveFromWishlistSuccessMessage = function(){

  facade = function() {
    $('#js-removeFromWishlistButton').fadeOut();    
    $('#js-addToWishlistButton').fadeIn()
  }

  return {
    name: "REMOVE_FROM_WISHLIST_SUCCESS_MESSAGE",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(RemoveFromWishlistSuccessMessage); 
});