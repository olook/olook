var ShowCartModalManager  = (function(){
  function ShowCartModalManager() {};
  ShowCartModalManager.prototype.config = function(){
    olookApp.subscribe('product:show_cart_modal', this.facade, {}, this, 'ShowCartModalManager');
  };

  ShowCartModalManager.prototype.facade = function(){
    console.log("showing product_added modal in " + Date.now());
    var content = '<div class="product_added"><p>Produto adicionado à sacola</p><button type="button" class="js-close-modal close_modal" role="button">Continuar Comprando</button><button type="button" class="js-go_to_cart go_to_cart" role="button">Ir Para Minha Sacola</button></div>';
    olook.addToCartModal(content, 200, '100%', '#000');
  };

  return ShowCartModalManager;
})();
