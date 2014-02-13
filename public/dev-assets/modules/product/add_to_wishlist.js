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
        }).fail(function(data){
          if (data.status == 401) {//non authorized
            window.location.href='/entrar/1';
          }
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
