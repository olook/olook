var MockCheckout = (function(){
  function MockCheckout(){
  };

  MockCheckout.prototype.config = function(){
    olookApp.subscribe('checkout:payment_type', this.update, {}, this);
  };

  MockCheckout.prototype.update = function(model){
    console.log("updating checkout:");
    console.log(model.attributes);
  };  
  return MockCheckout;
})();

olookApp.subscribe('app:init', function(){
  new MockCheckout().config();
});
