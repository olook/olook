var ShowCartModalManager  = (function(){
  function ShowCartModalManager() {};
  ShowCartModalManager.prototype.config = function(){
    olookApp.subscribe('product:show_cart_modal', this.facade);
  };

  ShowCartModalManager.prototype.facade = function(){
    olook.addToCartModal('<div class="product_added"><p>Produto adicionado à sacola</p><button type="button" class="js-close_modal close_modal" role="button">Continuar Comprando</button><button type="button" class="js-go_to_cart go_to_cart" role="button">Ir Para Minha Sacola</button></div>', 200, '#000', function(){console.log("closed")});
  };

  return ShowCartModalManager;
})();
