var completeLook = function(){

  var addLookItemToCart = function(actionUrl, values) {
    $.post(actionUrl, values, function( data ) {

      var minicartUpdate = {
        variantNumber: values.variant_number,
        productPrice: data.product_price,
        productId: data.product_id
      }

      olookApp.publish(MinicartFadeOutManager.name, variantNumber);
      // Move the input creation to Channel
      olookApp.publish(MinicartInputsUpdater.name, productId, variantNumber);

      setTimeout(function() {
        olookApp.publish('minicart:update', minicartUpdate);
        olookApp.publish(MinicartBoxDisplayUpdater.name);
        olookApp.publish(MinicartFadeInManager.name);
      },300);
    });
  }

  var bindEvents = function(){
    $('li.product form #variant_number').change(function(e){
      var element = $(this);
      var actionUrl = element.parent().attr('action');

      var values = {
        'product_id': element.data('product-id'),
        'variant_number': element.val()
      }

      addLookItemToCart(actionUrl, values);
    });
  }

  return {
    bindEvents: bindEvents
  }

}();

$(function() {
  completeLook.bindEvents();
})
