RemoveFromWishlist = function(){

  facade = function(productId) {
    var action_url = '/wished_products/' + productId;

    $.ajax({
      'type': 'DELETE',
      'url': action_url,
      'success': function(data) {
          olookApp.publish(RemoveFromWishlistSuccessMessage.name);
      }});
  }

  return {
    name: "REMOVE_FROM_WISHLIST",
    facade: facade
  };
}();

$(function(){
  olookApp.subscribe(RemoveFromWishlist); 
});