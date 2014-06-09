var MinicartUpdater  = (function(){
  function MinicartUpdater() {};
  MinicartUpdater.prototype.config = function(){
    olookApp.subscribe('minicart:update', this.facade);
  };

  var applyCoupon = function(data){
    if(data.coupon != null && data.coupon != undefined){
      olookApp.publish('minicart:apply_coupon', data.coupon.is_percentage, data.coupon.value);
    } 
  };

  var displayEmptyMessage = function(){
    olookApp.publish('minicart:display_empty_message');    
  };

  var displayProducts = function(data){
    olookApp.publish('minicart:display_products', data.items);
  };

  var updateHeader = function(items_length){
    olookApp.publish('minicart:update_header', items_length);
  };

  var clearMinicart = function(){
    $(".js-minicart").children().remove();
  };


  MinicartUpdater.prototype.facade = function(){
    console.log("getting the json");
    $.get("/sacola.json").done(function(data){
      clearMinicart();
      applyCoupon(data);
      updateHeader(data.items_total);
      (data.items.length > 0) ? displayProducts(data) : displayEmptyMessage();
    });    
  };

  return MinicartUpdater;
})();
