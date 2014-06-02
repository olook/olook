var ShowCartModalManager  = (function(){
  function ShowCartModalManager() {};
  ShowCartModalManager.prototype.config = function(){
    olookApp.subscribe('product:show_cart_modal', this.facade);
  };

  ShowCartModalManager.prototype.facade = function(){
    olook.addToCartModal("<p>teste</p>", 200, '#fff', function(){console.log("closed")});
  };

  return ShowCartModalManager;
})();
