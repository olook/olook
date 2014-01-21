AddToWishlistSuccessMessage = function(){

  facade = function(message) {
    $('#js-addToWishlistButton').append('<h1>'+message+'</h1>');
  }

  return {
    name: "ADD_TO_WISHLIST_SUCCESS_MESSAGE",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(AddToWishlistSuccessMessage); 
});