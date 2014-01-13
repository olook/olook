var MinicartDisplayUpdateManager = function(){

  var updateMinicartDisplay = function(hasToFadeIn,cartContainsItems, productId, productPrice, variantNumber){
    if ($( ".cart_related ul li:contains("+$('li[data-id='+productId+'] img').attr("alt")+")" ).length == 0 && variantNumber.length > 0){
      $('.cart_related ul').append("<li>"+$('li[data-id='+productId+'] img').attr("alt")+"</li>");
      $("#total_price").val( parseFloat($("#total_price").val()) + parseFloat(productPrice));
    } else if ($( ".cart_related ul li:contains("+$('li[data-id='+productId+'] img').attr("alt")+")" ).length > 0 && variantNumber.length == 0){
      $( ".cart_related ul li:contains("+$('li[data-id='+productId+'] img').attr("alt")+")" ).remove();
      $("#total_price").val( parseFloat($("#total_price").val()) - parseFloat(productPrice));
      if($( ".cart_related ul li").length -1 == 0){
        $("#total_price").val('');
        cartContainsItems = false;
        hasToFadeIn = true;
      }
    }

    var installments = CreditCard.installmentsNumberFor($("#total_price").val());

    if ($("li.product").length == ($(".cart_related ul li").length - 1)){
      $(".cart_related .minicart_price").html("De<span class='original_price'>" + installments + "x de " + Formatter.toCurrency( $("#total_price").val() / installments ) + "</span>Por <span class='discounted_price'>"+$(".total_with_discount").html() + " sem juros</span>")
    } else if(($(".cart_related ul li").length - 1) > 0){
      $(".cart_related .minicart_price").html("Por<span class='first_price'>" + installments + "x de " + Formatter.toCurrency( $("#total_price").val() / installments ) + " sem juros </span>");
    }

    $("form#minicart input[type=submit]").removeAttr("disabled").removeClass("disabled");

    if(!cartContainsItems) {
      $('.cart_related').removeClass('product_added');
      $(".cart_related .minicart_price").html("");
      $('.cart_related div.empty_minicart').fadeIn("fast");
    }

    if(hasToFadeIn) {
      $('.cart_related').fadeIn("fast");
    }
  };

  return {
    // este metodo deve ser o unico metodo publico do modulo
    facade: function(hasToFadeIn,cartContainsItems, productId, productPrice, variantNumber){
      updateMinicartDisplay(hasToFadeIn,cartContainsItems, productId, productPrice, variantNumber);
    }
  };

};

/* 
 * assim que o documento for renderizado, devemos criar uma nova instancia do modulo e declarar o subscribe
 * usando o metodo de facade como callback
 */

$(function(){
  var minicartDisplayUpdateManager = new MinicartDisplayUpdateManager(olookApp);
  olookApp.getMediator().subscribe("updateMinicartDisplay", minicartDisplayUpdateManager.facade); 
});