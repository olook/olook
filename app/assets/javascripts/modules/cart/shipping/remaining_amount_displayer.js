var RemainingAmountDisplayer = (function(){
  function RemainingAmountDisplayer() {
  };

  RemainingAmountDisplayer.prototype.config = function(){
    olookApp.subscribe('shipping:display_remaining_amount', this.facade, {}, this);
  };

  RemainingAmountDisplayer.prototype.facade = function(data, value){
    var remainingAmount = parseFloat(data.free_shipping_value) - parseFloat(value.replace(",","."));
    $(".js-remaining_amount_text").text(Formatter.toCurrency(remainingAmount));
    $(".js-remaining_amount").show();
  };
  return RemainingAmountDisplayer;
})();

