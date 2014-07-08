var RemainingAmountDisplayer = (function(){
  function RemainingAmountDisplayer() {
  };

  RemainingAmountDisplayer.prototype.config = function(){
    olookApp.subscribe('shipping:display_remaining_amount', this.facade, {}, this);
  };

  RemainingAmountDisplayer.prototype.facade = function(data){
    $(".js-remaining_amount_text").text(Formatter.toCurrency(parseFloat(data.free_shipping_value)));
    $(".js-remaining_amount").show();
  };
  return RemainingAmountDisplayer;
})();

