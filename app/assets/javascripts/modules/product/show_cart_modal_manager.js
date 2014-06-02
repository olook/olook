var ShowCartModalManager  = (function(){
  function ShowCartModalManager() {};
  ShowCartModalManager.prototype.config = function(){
    olookApp.subscribe('product:show_cart_modal', this.facade);
  };

  ShowCartModalManager.prototype.facade = function(){
    console.log("modal up!");
  };

  return ShowCartModalManager;
})();
