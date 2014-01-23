RemoveFromWishlistSuccessMessage = function(){

  facade = function(productId) {
    // product-page
    $('#js-removeFromWishlistButton').fadeOut();    
    $('#js-addToWishlistButton').fadeIn();

    // wishlist page
    $('.js-product-' + productId).fadeOut();
  }

  return {
    name: "REMOVE_FROM_WISHLIST_SUCCESS_MESSAGE",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(RemoveFromWishlistSuccessMessage); 
});