RemoveFromWishlist = function(){

  facade = function(productId) {
    var action_url = '/wished_products/' + productId;

    $.ajax({
      'type': 'DELETE',
      'url': action_url,
      'success': function(data) {
          olookApp.publish(RemoveFromWishlistSuccessMessage.name);
      }}).fail(function(data){
          if (data.status == 401) {//non authorized
            window.location.href='/entrar';
          }
      });
  }

  return {
    name: "REMOVE_FROM_WISHLIST",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(RemoveFromWishlist); 
});