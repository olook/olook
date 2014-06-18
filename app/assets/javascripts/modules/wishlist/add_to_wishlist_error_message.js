var AddToWishlistErrorMessage = (function(){

  function AddToWishlistErrorMessage(){};

  AddToWishlistErrorMessage.prototype.facade = function(message) {
    $('p.js-wishlist_alert').html(message).show()
      .delay(3000).fadeOut();    
  };

  AddToWishlistErrorMessage.prototype.config = function(){
    olookApp.subscribe("wishlist:add:error_message", this.facade, {}, this);
  };

  return AddToWishlistErrorMessage;
  
})();
