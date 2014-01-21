AddToWishlistSuccessMessage = function(){

  facade = function(message) {
    removeButton = '<div class="js-removeFromWishlist">Remover da wishlist S2</div>';

    addToWishlistButton = $('#js-addToWishlistButton');
    addToWishlistButton.after(removeButton);
    addToWishlistButton.hide();   
  }

  return {
    name: "ADD_TO_WISHLIST_SUCCESS_MESSAGE",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(AddToWishlistSuccessMessage); 
});