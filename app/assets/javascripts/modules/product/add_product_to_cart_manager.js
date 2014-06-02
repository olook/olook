var AddProductToCartManager  = (function(){
  function AddProductToCartManager() {};
  AddProductToCartManager.prototype.config = function(){
    olookApp.subscribe('product:add', this.facade);
  };

  AddProductToCartManager.prototype.facade = function(){
    var variantId = $(".selected .js-variant_id").val();
    var quantity = $(".js-quantity").val(); 
    var productId = $("#id").val(); 
    $.post('/sacola/items.json', {"variant[id]": variantId, quantity: quantity, id: productId})
      .done(function(data) {
        if(data.showModal){
            olookApp.publish('product:show_cart_modal');
        } else {
          olookApp.publish('product:redirect_to_cart');
        }
      });
  };

  return AddProductToCartManager;
})();
