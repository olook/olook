//= require modules/minicart/minicart_updater
//= require modules/minicart/minicart_coupon_applier
//= require modules/minicart/minicart_product_displayer
//= require modules/minicart/minicart_empty_message_displayer
//= require modules/minicart/minicart_header_updater

new MinicartUpdater().config();
new MinicartCouponApplier().config();
new MinicartProductDisplayer().config();
new MinicartEmptyMessageDisplayer().config();
new MinicartHeaderUpdater().config();