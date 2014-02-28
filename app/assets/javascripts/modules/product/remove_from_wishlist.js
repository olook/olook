RemoveFromWishlist = function(){

  var facade = function(productId) {
    var action_url = '/wished_products/' + productId;

    $.ajax({
      'type': 'DELETE',
      'url': action_url,
      'success': function(data) {
          olookApp.mediator.publish(RemoveFromWishlistSuccessMessage.name, productId);
      }}).fail(function(data){
          if (data.status == 401) {//non authorized
            window.location.href='/entrar';
          }
      });
  }

  return {
    facade: facade,
    name: 'wishlist:remove:click_button'
  };
}();

$(function(){
  olookApp.subscribe('wishlist:remove:click_button', RemoveFromWishlist.facade, {}, RemoveFromWishlist);
});
