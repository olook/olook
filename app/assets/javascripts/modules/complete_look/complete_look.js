var completeLook = function(){

  addLookItemToCart = function(actionUrl, values) {
    $.post(actionUrl, values, function( data ) {

      var variantNumber = data['variant_number'];
      var productPrice = data['product_price'];
      var productId = data['product_id'];

      var variantNumbers = data['variant_numbers'];

      olookApp.mediator.publish(MinicartFadeOutManager.name, variantNumber);
      // Move the input creation to Channel
      olookApp.mediator.publish(MinicartInputsUpdater.name,variantNumbers, variantNumber, "<input type='hidden' id='variant_numbers_' name='variant_numbers[]' value='"+variantNumber+"'>");

      setTimeout(function() {
        olookApp.publish(MinicartDataUpdater.name, productId, productPrice, variantNumber);  
        olookApp.publish(MinicartBoxDisplayUpdater.name);
        olookApp.publish(MinicartFadeInManager.name);  
      },300);    
    });
  }

  bindEvents = function(){
    $('li.product form #variant_number').change(function(e){
      var element = $(this);
      var actionUrl = element.parent().attr('action');

      values = {
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