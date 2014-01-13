function MinicartDisplayUpdateManager(){

  function hasToFadeIn(){
    return ($('.cart_related').css("display") == "none");
  }

  function fadeIn(){
    $('.cart_related').fadeIn("fast");    
  }

  function showEmptyCartBox(){
    $('.cart_related').removeClass('product_added');
    $(".cart_related .minicart_price").html("");
    $('.cart_related div.empty_minicart').fadeIn("fast");
  }

  function disableSubmitButton(){
    $("form#minicart input[type=submit]").attr("disabled", "disabled").addClass("disabled");
  }

  function enableSubmitButton(){
    $("form#minicart input[type=submit]").removeAttr("disabled").removeClass("disabled");
  }

  function displayPrice(){
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

  function hasToFadeOut(variantNumber){
    return ((StringUtils.isEmpty($("#total_price").val()) || ($( ".cart_related ul li").length -1 == 0)) && !StringUtils.isEmpty(variantNumber));
  }

  function fadeOut(){
    $("#total_price").val('0.0');

    $('.cart_related').fadeOut("fast",function(){
      $('.cart_related').addClass('product_added');
      $('.cart_related div.empty_minicart').hide();    
    });
  }

  this.facade = function(productId, productPrice, variantNumber){

    if(hasToFadeOut(variantNumber)){
      fadeOut();
    }

    setTimeout(function() {
      if (isAddition(productId, variantNumber)){
        addItem(productId, productPrice);
      } else if (isRemoval(productId, variantNumber)){
        removeItem(productId, productPrice);
      }

      displayPrice();

      if(isCartEmpty()) {
        showEmptyCartBox();
        disableSubmitButton();
      } else {
        enableSubmitButton();
      }
      console.log(hasToFadeIn());
      if(hasToFadeIn()) {
        fadeIn();
      }

    },300);    
  }
}

function MinicartInputUpdateManager(){

  this.facade = function(variantNumbers, variantNumber, inputValues){
    for(i=0;i<variantNumbers.length;i++){
      $('#variant_numbers_[value=\"'+variantNumbers[i]+'\"]').remove();
      $('#variant_numbers[][value=\"'+variantNumbers[i]+'\"]').remove();  
    }

    if(variantNumber.length > 0){
      $('#minicart').append(inputValues);
    }
  }

}

/* 
 * assim que o documento for renderizado, devemos criar uma nova instancia do modulo e declarar o subscribe
 * usando o metodo de facade como callback
 */

$(function(){
  var minicartInputUpdateManager = new MinicartInputUpdateManager();
  olookApp.mediator.subscribe("updateMinicartInput", minicartInputUpdateManager.facade);   

  var minicartDisplayUpdateManager = new MinicartDisplayUpdateManager();
  olookApp.mediator.subscribe("updateMinicartDisplay", minicartDisplayUpdateManager.facade); 
});