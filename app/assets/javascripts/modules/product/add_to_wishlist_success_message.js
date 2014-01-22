AddToWishlistSuccessMessage = function(){

  facade = function(message) {
    $('#js-addToWishlistButton').fadeOut()
    $('#js-removeFromWishlistButton').fadeIn();
  }

  return {
    name: "ADD_TO_WISHLIST_SUCCESS_MESSAGE",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(AddToWishlistSuccessMessage); 
});