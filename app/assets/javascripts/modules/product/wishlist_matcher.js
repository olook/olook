var WishlistMatcher = (function(){
  function WishlistMatcher(){};

  WishlistMatcher.prototype.facade = function() {
    var action_url = '/wishlist_matcher';
    $.get(action_url, {}, function(data) {
      olook.newModal(data.message, 504, 610, '#fff');
    });
  };

  WishlistMatcher.prototype.config = function(){
    olookApp.subscribe('wishlist:matches', this.facade, {}, this);
  };

  return WishlistMatcher;
})();