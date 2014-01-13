function MinicartBoxDisplayUpdater(){

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

  function isCartEmpty(){
    return ($( ".cart_related ul li").length - 1 == 0);
  }

  this.facade = function(){
    if(isCartEmpty()) {
      showEmptyCartBox();
      disableSubmitButton();
    } else {
      enableSubmitButton();
    }
  }
}

$(function(){
  olookApp.mediator.subscribe("updateMinicartBoxDisplay", new MinicartBoxDisplayUpdater().facade);
});