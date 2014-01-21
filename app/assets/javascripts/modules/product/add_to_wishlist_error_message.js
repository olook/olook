AddToWishlistErrorMessage = function(){

  facade = function(message) {
    $('#js-addToWishlistButton').append('<h1>Erro: '+message+' !!!</h1>');
  }

  return {
    name: "ADD_TO_WISHLIST_ERROR_MESSAGE",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(AddToWishlistErrorMessage); 
});