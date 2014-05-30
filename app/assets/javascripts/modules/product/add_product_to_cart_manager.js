var AddProductToCartManager  = (function(){
  function AddProductToCartManager() {};
  AddProductToCartManager.prototype.config = function(){
    olookApp.subscribe('product:add', this.facade);
  };

  AddProductToCartManager.prototype.facade = function(){
    var variantId = null 

    $.post('/url_to_add', {variant_id: variantId})
      .done(function(data) {
        _data = JSON.parse(data.responseText);
      });
  };

  return AddProductToCartManager;
})();
