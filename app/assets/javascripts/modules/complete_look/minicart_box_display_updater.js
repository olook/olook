MinicartBoxDisplayUpdater = function(){

  var showEmptyCartBox = function(){
    $('.cart_related').removeClass('product_added');
    $(".cart_related .minicart_price").html("");
    $('.cart_related div.empty_minicart').fadeIn("fast");
  };

  var disableSubmitButton = function(){
    $("form#minicart input[type=submit]").attr("disabled", "disabled").addClass("disabled");
  };

  var enableSubmitButton = function(){
    $("form#minicart input[type=submit]").removeAttr("disabled").removeClass("disabled");
  };

  var isCartEmpty = function(){
    return ($( ".cart_related ul li").length - 1 == 0);
  };

  return{
    name: "UPDATE_MINICART_BOX_DISPLAY",
    facade: function(){
      if(isCartEmpty()) {
        showEmptyCartBox();
        disableSubmitButton();
      } else {
        enableSubmitButton();
      }
    }
  };

}();

$(function(){
  olookApp.subscribe(MinicartBoxDisplayUpdater);
});