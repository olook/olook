//= require modules/cart/shipping/request
//= require modules/cart/shipping/info_displayer
//= require modules/cart/shipping/remaining_amount_displayer
//= require modules/cart/shipping/calculation_displayer
//= require plugins/jquery.meio.mask
//= require formatter

new ShippingRequest().config();
new ShippingInfoDisplayer().config();
new RemainingAmountDisplayer().config();
new ShippingCalculationDisplayer().config();

$(function(){
  $("#zip_code").setMask({
    mask: '99999-999'
  });
});