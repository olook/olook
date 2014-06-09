var MinicartCouponApplier  = (function(){
  function MinicartCouponApplier() {};
  MinicartCouponApplier.prototype.config = function(){
    olookApp.subscribe('minicart:apply_coupon', this.facade);
  };

  var insertCouponElement = function(discount) {
    $(".js-minicart").prepend("<li class='coupon_info product_item'><img alt='Big_coupon' class='big_coupon' src='"+$('.js-minicart').data("coupon-image-url")+"'><p class='coupon_tag'>Sua sacola agora tem um cupom de "+discount+" de desconto. Aproveite! ;)</p></li>");
  }

  MinicartCouponApplier.prototype.facade = function(is_percentage, amount){
    if(is_percentage){
      insertCouponElement(amount+"%");
    } else {
      insertCouponElement("R$ "+amount);
    }
  };

  return MinicartCouponApplier;
})();
