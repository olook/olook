var MinicartBoxDisplayUpdater = (function(){
  function MinicartBoxDisplayUpdater(){};

  var showEmptyCartBox = function(){
    $('.cart_related').removeClass('look_product_added');
    $('.minicart_price').html("");
    $('.empty_minicart').fadeIn("fast");
  };

  var disableSubmitButton = function(){
    $(".js-addToCartButton").attr("disabled", "disabled").addClass("disabled");
  };

  var enableSubmitButton = function(){
    $(".js-addToCartButton").removeAttr("disabled").removeClass("disabled");
  };

  var isCartEmpty = function(){
    return ($( ".js-minicartItem").length == 0);
  };

  MinicartBoxDisplayUpdater.prototype.facade = function(params){
    if(isCartEmpty()) {
      showEmptyCartBox();
      disableSubmitButton();
    } else {
      enableSubmitButton();
    }
  };

  MinicartBoxDisplayUpdater.prototype.config = function() {
    olookApp.subscribe("minicart:update:box_display", this.facade, {}, this);
  };

  return MinicartBoxDisplayUpdater;
})();
