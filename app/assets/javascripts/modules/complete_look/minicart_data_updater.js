var MinicartDataUpdater = (function(){
  function MinicartDataUpdater() {};

  var getProductName = function(productId) {
    return $('.js-look-product[data-id='+productId+']').data('name');
  }

  var writePrice = function(){
    var installments = CreditCard.installmentsNumberFor($("#total_price").val());
    if ($(".js-look-product").length == ($(".js-minicartItem").length) && (parseFloat($("#total_price").val()) > parseFloat($("#total_look_promotion_price").val()))){
      $(".minicart_price").html("De<span class='original_price'>" + installments + "x de " + Formatter.toCurrency( $("#total_price_without_discount").val() / installments ) + "</span>Por <span class='discounted_price'>"+$(".total_with_discount").html() + " sem juros</span>");

    } else if(($(".js-minicartItem").length) > 0){
      $(".minicart_price").html("Por<span class='first_price'>" + installments + "x de " + Formatter.toCurrency( $("#total_price").val() / installments ) + " sem juros </span>");
    }
  };

  var productNameInMinicart = function(productId){
    return($( ".js-minicartItem[data-id='"+ productId +"']" ));
  };

  var addItem = function(productId, productPrice){
    var productName = getProductName(productId);
    if(isCartEmpty()){
      $("#total_price").val(parseFloat(productPrice));
    } else {
      $("#total_price").val( parseFloat($("#total_price").val()) + parseFloat(productPrice));
    }
    $('.js-look-products').append("<li class='js-minicartItem' data-id='"+productId+"'>"+ productName +"</li>");
  };

  var removeItem = function(productId, productPrice){
    productNameInMinicart(productId).remove();
    if(isCartEmpty()){
      $("#total_price").val('');
    } else {
      $("#total_price").val( parseFloat($("#total_price").val()) - parseFloat(productPrice));
    }
  };

  var isAddition = function(productId, variantNumber){
    return (productNameInMinicart(productId).length == 0 && variantNumber.length > 0);
  };

  var isRemoval = function(productId, variantNumber){
    return (productNameInMinicart(productId).length > 0 && variantNumber.length == 0);
  };

  var isCartEmpty = function(){
    return ($( ".js-minicartItem").length == 0);
  };

  var applyDiscount = function(productPrice){};

  MinicartDataUpdater.prototype.facade = function(params){
    olookApp.publish('minicart:update:fadeout', params);
    olookApp.publish('minicart:update:input', params);
    setTimeout(function(){
      if (isAddition(params['productId'], params['variantNumber'])){
        addItem(params['productId'], params['productPrice']);
      } else if (isRemoval(params['productId'], params['variantNumber'])){
        removeItem(params['productId'], params['productPrice']);
      }
      writePrice();
      olookApp.publish('minicart:update:box_display', params);
      olookApp.publish('minicart:update:fadein');
    }, 300);
  };

  MinicartDataUpdater.prototype.config = function() {
    olookApp.subscribe('minicart:update:data', this.facade, {}, this);
  };

  return MinicartDataUpdater;
})();
