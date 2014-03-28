var MinicartInputsUpdater = (function(){
  function MinicartInputsUpdater() {};

  var appendHiddenFieldToMiniCartForm = function(productId, variantNumber) {
    if (!StringUtils.isEmpty(variantNumber)) {
      $('<input type="hidden">').attr({
          'id': 'variant_numbers_',
          'name': 'variant_numbers[]',
          'value': variantNumber,
          'class': 'js-' + productId
      }).appendTo('#minicart');
    }
  }

  MinicartInputsUpdater.prototype.facade = function(params){
    $('.js-' + params['productId']).remove();
    appendHiddenFieldToMiniCartForm(params['productId'], params['variantNumber']);
  }

  /*
   * assim que o documento for renderizado, devemos criar uma nova instancia do modulo
   * e declarar o subscribe usando o metodo de facade como callback
   */
  MinicartInputsUpdater.prototype.config = function() {
    olookApp.subscribe("minicart:update:input", this.facade, {}, this);
  }

  return MinicartInputsUpdater;
})();

