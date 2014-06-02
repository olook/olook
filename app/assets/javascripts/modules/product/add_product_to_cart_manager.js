var AddProductToCartManager  = (function(){
  function AddProductToCartManager() {};
  AddProductToCartManager.prototype.config = function(){
    olookApp.subscribe('product:add', this.facade);
  };

  var displayAlertSize = function(text){
    $('p.alert_size').show().html(text).delay(3000).fadeOut();
  }

  var closeSpy = function(){
    $('#close_quick_view').click();
  }

  AddProductToCartManager.prototype.facade = function(){
    var variantId = $(".selected .js-variant_id").val();
    var quantity = $(".js-quantity").val(); 
    var productId = $("#id").val();

    if(StringUtils.isEmpty(variantId)){
      displayAlertSize("Qual é o seu tamanho mesmo?");
    } else {
      $.post('/sacola/items.json', {"variant[id]": variantId, quantity: quantity, id: productId})
        .done(function(data) {
          // if(data.responseAction == "showModal"){
              closeSpy();
              olookApp.publish('product:show_cart_modal');
          // } else {
          //   olookApp.publish('product:redirect_to_cart');
          // }
        }).fail(function(data){
          _data = JSON.parse(data.responseText);
          displayAlertSize(_data.notice);
        });
    }
  };

  return AddProductToCartManager;
})();
