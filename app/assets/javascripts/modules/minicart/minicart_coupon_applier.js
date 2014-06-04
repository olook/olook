var MinicartCouponApplier  = (function(){
  function MinicartCouponApplier() {};
  MinicartCouponApplier.prototype.config = function(){
    olookApp.subscribe('minicart:apply_coupon', this.facade);
  };

  MinicartCouponApplier.prototype.facade = function(is_percentage, amount){
    if(is_percentage){
      console.log("coupon applied - "+amount+"%");
    } else {
      console.log("coupon applied - R$"+amount);
    }
  };

  return MinicartCouponApplier;
})();
