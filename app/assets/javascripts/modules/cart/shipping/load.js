//= require modules/cart/shipping/request
//= require modules/cart/shipping/info_displayer
//= require modules/cart/shipping/remaining_amount_displayer
//= require modules/cart/shipping/calculation_displayer
//= require formatter

new ShippingRequest().config();
new ShippingInfoDisplayer().config();
new RemainingAmountDisplayer().config();
new ShippingCalculationDisplayer().config();