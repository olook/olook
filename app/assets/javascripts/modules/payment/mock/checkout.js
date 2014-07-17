var MockCheckout = (function(){
  function MockCheckout(){
  };

  MockCheckout.prototype.config = function(){
    olookApp.subscribe('checkout:payment_type', this.update, {}, this);
  };

  MockCheckout.prototype.update = function(model){
    console.log(model.attributes);
    console.log("o desconto para "+model.attributes.name+" é de "+model.attributes.percentage+"%");
  };  
  return MockCheckout;
})();

olookApp.subscribe('app:init', function(){
  new MockCheckout().config();
});
