var MinicartUpdater  = (function(){
  function MinicartUpdater() {};
  MinicartUpdater.prototype.config = function(){
    olookApp.subscribe('minicart:update', this.facade);
  };

  MinicartUpdater.prototype.facade = function(){
    console.log("getting the json");
    $.get("/sacola.json").done(function(data){
      //Apply coupon
      //Then, put products w/ retail price, name, size, quantity and pic
      console.log("cart updated");
      console.log(data);
      olookApp.publish('minicart:apply_coupon', true, "20");
      olookApp.publish('minicart:display_products', []);
    }).fail(function() {      
    });    
  };

  return MinicartUpdater;
})();
