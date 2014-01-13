function MinicartDataUpdater(){
  function writePrice(){
    var installments = CreditCard.installmentsNumberFor($("#total_price").val());

    if ($("li.product").length == ($(".cart_related ul li").length - 1)){
      $(".cart_related .minicart_price").html("De<span class='original_price'>" + installments + "x de " + Formatter.toCurrency( $("#total_price").val() / installments ) + "</span>Por <span class='discounted_price'>"+$(".total_with_discount").html() + " sem juros</span>");
    } else if(($(".cart_related ul li").length - 1) > 0){
      $(".cart_related .minicart_price").html("Por<span class='first_price'>" + installments + "x de " + Formatter.toCurrency( $("#total_price").val() / installments ) + " sem juros </span>");
    }
  }

  function productNameInMinicart(productId){
    return($( ".cart_related ul li:contains("+$('li[data-id='+productId+'] img').attr("alt")+")" ));
  }

  function addItem(productId, productPrice){
    $('.cart_related ul').append("<li>"+$('li[data-id='+productId+'] img').attr("alt")+"</li>");
    $("#total_price").val( parseFloat($("#total_price").val()) + parseFloat(productPrice));
  }

  function removeItem(productId, productPrice){
    productNameInMinicart(productId).remove();
    if(isCartEmpty()){
      $("#total_price").val('');
    } else {
      $("#total_price").val( parseFloat($("#total_price").val()) - parseFloat(productPrice));
    }    
  }

  function isAddition(productId, variantNumber){
    return (productNameInMinicart(productId).length == 0 && variantNumber.length > 0);
  }

  function isRemoval(productId, variantNumber){
    return (productNameInMinicart(productId).length > 0 && variantNumber.length == 0);
  }

  function isCartEmpty(){
    return ($( ".cart_related ul li").length - 1 == 0);
  }

  this.facade = function(productId, productPrice, variantNumber){
    if (isAddition(productId, variantNumber)){
      addItem(productId, productPrice);
    } else if (isRemoval(productId, variantNumber)){
      removeItem(productId, productPrice);
    }
    writePrice();
  }
}

$(function(){
  olookApp.mediator.subscribe("updateMinicartData", new MinicartDataUpdater().facade);
});