//= require modules/minicart/minicart_updater
//= require modules/minicart/minicart_coupon_applier
//= require modules/minicart/minicart_product_displayer

new MinicartUpdater().config();
new MinicartCouponApplier().config();
new MinicartProductDisplayer().config();