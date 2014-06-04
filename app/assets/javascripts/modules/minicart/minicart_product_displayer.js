var MinicartProductDisplayer  = (function(){
  function MinicartProductDisplayer() {};
  MinicartProductDisplayer.prototype.config = function(){
    olookApp.subscribe('minicart:display_products', this.facade);
  };

  MinicartProductDisplayer.prototype.facade = function(product_list){
    console.log("displaying products");      
  };

  return MinicartProductDisplayer;
})();
