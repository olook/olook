var completeLook = function(){

  var addLookItemToCart = function(actionUrl, values) {
    $.post(actionUrl, values, function( data ) {

      var minicartUpdate = {
        variantNumber: values.variant_number,
        productPrice: data.product_price,
        productId: data.product_id
      };

      olookApp.publish('minicart:update:data', minicartUpdate);
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
