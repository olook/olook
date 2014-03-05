var RemoveFromWishlist = (function(){
  function RemoveFromWishlist(){};

  RemoveFromWishlist.prototype.facade = function(productId) {
    var action_url = '/wished_products/' + productId;

    $.ajax({
      'type': 'DELETE',
      'url': action_url,
      'success': function(data) {
          olookApp.mediator.publish("wishlist:remove:success_message", productId);
      }}).fail(function(data){
          if (data.status == 401) {//non authorized
            window.location.href='/entrar';
          }
      });
  };

  RemoveFromWishlist.prototype.config = function() {
    olookApp.subscribe('wishlist:remove:click_button', this.facade, {}, this);
  };

  return RemoveFromWishlist;
})();