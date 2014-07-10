var ShippingInfoDisplayer = (function(){
  function ShippingInfoDisplayer() {
  };

  ShippingInfoDisplayer.prototype.config = function(){
    olookApp.subscribe('shipping:display_info', this.facade, {}, this);
  };

  ShippingInfoDisplayer.prototype.facade = function(data, value){
    var price = parseFloat(data.price);
    var priceText = null;
    $(".js-shipping_info_delivery_time").text(data.delivery_time);
    if(price > 0){
      priceText = Formatter.toCurrency(price);
      olookApp.publish("shipping:display_remaining_amount", data, value);
    } else {
      priceText = "Frete Grátis";
    }
    $(".js-shipping_info_price").text(priceText);
    $(".js-shipping_info").show();
    $(".js-shipping_calculation").hide();

  };
  return ShippingInfoDisplayer;
})();

