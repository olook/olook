MinicartInputsUpdater = function(){

  appendHiddenFieldToMiniCartForm = function(productId, variantNumber) {
    if (!StringUtils.isEmpty(variantNumber)) {
      $('<input type="hidden">').attr({
          'id': 'variant_numbers_',
          'name': 'variant_numbers[]',
          'value': variantNumber,
          'class': 'js-' + productId
      }).appendTo('#minicart');
    }
  }

  return{
    facade: function(productId, variantNumber){
      $('.js-' + productId).remove();
      appendHiddenFieldToMiniCartForm(productId, variantNumber);
    }
  }
}();

/* 
 * assim que o documento for renderizado, devemos criar uma nova instancia do modulo
 * e declarar o subscribe usando o metodo de facade como callback
 */
$(function(){
  olookApp.subscribe("minicart:update:inputs", MinicartInputsUpdater.facade);   
});