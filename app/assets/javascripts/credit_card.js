var CreditCard = {};

CreditCard = {
  validateNumber: function(str) {
    var luhnArr = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];
    var counter = 0;
    var incNum;
    var odd = false;
    var temp = String(str).replace(/[^\d]/g, "");
    if ( temp.length == 0)
      return false;
    for (var i = temp.length-1; i >= 0; --i) {
      incNum = parseInt(temp.charAt(i), 10);
      counter += (odd = !odd)? incNum : luhnArr[incNum];
    }
    return (counter%10 == 0);
  },

  installmentsNumberFor: function(value, reseller) {
    number = Math.floor((value / 30));
    if(reseller === "true"){
      number = Math.min(3, number);
    }else{
      number = Math.min(6, number);
    }
    return number == 0 ? 1 : number;
  }
};

(function($){
  $.fn.validateCreditCardNumber = function() {
    return this.each(function() {
      $(this).blur(function() {
      $("#credit_card_error").remove();
        if (CreditCard.validateNumber(this.value)) {
          $(".credit_card_number").removeClass("input_error");
        } else {
          parent_node = $("#checkout_payment_credit_card_number").parent().parent();
          parent_node.append('<span id="credit_card_error" class="span_error">O número do cartão parece estranho. Pode conferir?</span>');
          $(".credit_card_number").addClass("input_error");
        }
      });
    });
  };
})(jQuery);

$(function() {
  $("#checkout_payment_credit_card_number").validateCreditCardNumber();
});
