var ShippingCalculationDisplayer = (function(){
  function ShippingCalculationDisplayer() {
  };

  ShippingCalculationDisplayer.prototype.config = function(){
    olookApp.subscribe('shipping:display_calculation', this.facade, {}, this);
    $(".js-display_calculation").click(function(e){
      e.preventDefault();
      olookApp.publish('shipping:display_calculation');
    });
  };

  ShippingCalculationDisplayer.prototype.facade = function(data){
    $("#zip_code").val("");
    $(".js-shipping_info").hide();
    $(".js-remaining_amount").hide();
    $(".js-shipping_calculation").show();
  };
  return ShippingCalculationDisplayer;
})();

