AddToWishlist = function(){

  facade = function(productId) {

    var action_url = '/wished_products';

    var element = $('[name="variant[id]"]:checked');
    if (element.size() == 0) {
      olookApp.publish(AddToWishlistErrorMessage.name, "Qual é o seu tamanho mesmo?");
    } else {
      var values = {'variant_id': element.val()}
      $.post(action_url, values, function(data) {
          olookApp.publish(AddToWishlistSuccessMessage.name, data.message);
        }).fail(function(){
          olookApp.publish(AddToWishlistErrorMessage.name, 'Erro. Tente novamente');
        });

    }



  }

  return {
    name: "ADD_TO_WISHLIST",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(AddToWishlist); 
});