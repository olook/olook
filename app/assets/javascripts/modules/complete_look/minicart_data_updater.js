MinicartDataUpdater = function(){

  getProductName = function(productId) {
    return $('li[data-id='+productId+']').data('name');
  }

  var writePrice = function(){
    var installments = CreditCard.installmentsNumberFor($("#total_price").val());
    if ($("li.product").length == ($(".js-minicartItem").length)){
      $(".minicart_price").html("De<span class='original_price'>" + installments + "x de " + Formatter.toCurrency( $("#total_price").val() / installments ) + "</span>Por <span class='discounted_price'>"+$(".total_with_discount").html() + " sem juros</span>");
    } else if(($(".cart_related ul li").length - 1) > 0){
      $(".minicart_price").html("Por<span class='first_price'>" + installments + "x de " + Formatter.toCurrency( $("#total_price").val() / installments ) + " sem juros </span>");
    }
  };

  var productNameInMinicart = function(productId){
    var productName = getProductName(productId);
    // Improve this selector
    return($( ".cart_related ul li:contains("+ productName +")" ));
  };

  var addItem = function(productId, productPrice){
    var productName = getProductName(productId);
    $('.cart_related ul').append("<li class='js-minicartItem'>"+ productName +"</li>");
    if(isCartEmpty()){
      $("#total_price").val(parseFloat(productPrice));
    } else {
      $("#total_price").val( parseFloat($("#total_price").val()) + parseFloat(productPrice));
    }      
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
    return ($( ".cart_related ul li").length - 1 == 0);
  };

  return{
    name: "UPDATE_MINICART_DATA",
    facade: function(params){
      var productId = params[0];
      var productPrice = params[1];
      var variantNumber = params[2];

      if (isAddition(productId, variantNumber)){
        addItem(productId, productPrice);
      } else if (isRemoval(productId, variantNumber)){
        removeItem(productId, productPrice);
      }
      writePrice();
    }
  };

}();

$(function(){
  olookApp.subscribe(MinicartDataUpdater);
});