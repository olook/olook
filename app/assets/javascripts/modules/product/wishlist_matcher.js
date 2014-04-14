var WishlistMatcher = (function(){
  function WishlistMatcher(){};

  WishlistMatcher.prototype.facade = function(variantId) {
    var action_url = '/wishlist_matcher';
    $.get(action_url, {variant_id: variantId}, function(data) {
      if(data.message != '') olook.newModal(data.message, 300, 540, '#fff');
    });
  };

  WishlistMatcher.prototype.config = function(){
    olookApp.subscribe('wishlist:matches', this.facade, {}, this);
  };

  return WishlistMatcher;
})();