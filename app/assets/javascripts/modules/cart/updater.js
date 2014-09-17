var CartUpdater = (function(){
  function CartUpdater() {
    this.developer = 'Nelson Haraguchi';
  };

  CartUpdater.prototype = {
    changeView: function(data) {
      if(data.total) {
        $("#total_value").html(data.total);
        $("#float_total_value").html(data.total);
      }
      if(data.subtotal) {
        $('#subtotal_parcial').html(data.subtotal);
      }
      if(data.discount) {
        $('#js-discount-value').text(data.discount);
      }
      if(data.usedCredits && data.currentUserCredits) {
        $('#js-credit-value').text(data.usedCredits);
        if(data.subtotal && parseFloat(data.subtotal.replace("R$ ","").replace(",",".")) > 100 && parseFloat(data.discount.replace("R$ ","").replace(",",".")) == 0) {
          $('.js-credits').fadeIn();
          $('#total_user_credits').text(data.currentUserCredits);
        } else {
          $('.js-credits').fadeOut();
          $("#cart_use_credits").prop('checked', false);
        }
      }      
      if (data.totalItens) {
        //update items quantity on cart summary header
        $("#cart_items").text(data.totalItens);

        //update items total on cart title
        $(".js-total-itens").html(data.totalItens);
      }
      if(typeof data.usingCoupon !== 'undefined') {
        if(data.usingCoupon) {
          $("#coupon_discount").html(data.couponCode);
          $("#coupon_info").show();
          $("#coupon").hide();
        } else {
          $("#coupon_discount").html("");
          $("#coupon_info").hide();
          $("#coupon").show();
        }
        olookApp.publish('minicart:update');
      }
    },
    config: function() {
      olookApp.mediator.subscribe('cart:update', this.changeView, {}, this);
    }
  };

  return CartUpdater;
})();
