var AddToWishlistErrorMessage = (function(){

  function AddToWishlistErrorMessage(){};

  AddToWishlistErrorMessage.prototype.facade = function(message) {
    var el = $('#js-addToWishlistButton');
    if(el.length > 0)
      initProduct.showAlert(el)
    else
      initProduct.showAlert();
  };

  AddToWishlistErrorMessage.prototype.config = function(){
    olookApp.subscribe("wishlist:add:error_message", this.facade, {}, this);
  };

  return AddToWishlistErrorMessage;
  
})();
