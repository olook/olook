var CartRedirectManager  = (function(){
  function CartRedirectManager() {};
  CartRedirectManager.prototype.config = function(){
    olookApp.subscribe('product:redirect_to_cart', this.facade);
  };

  CartRedirectManager.prototype.facade = function(){
  };

  return CartRedirectManager;
})();
