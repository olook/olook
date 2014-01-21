AddToWishlist = function(){

  facade = function(productId) {

    var action_url = '/wished_products';
    var values = {'product_id': productId}

    $.post(action_url, values, function(data) {
        olookApp.publish(AddToWishlistSuccessMessage.name, data.message);
      }).fail(function(){
        olookApp.publish(AddToWishlistErrorMessage.name, 'Escolha o tamanho');
      });
  }

  return {
    name: "ADD_TO_WISHLIST",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(AddToWishlist); 
});