var MinicartEmptyMessageDisplayer  = (function(){
  function MinicartEmptyMessageDisplayer() {};
  MinicartEmptyMessageDisplayer.prototype.config = function(){
    olookApp.subscribe('minicart:display_empty_message', this.facade);
  };

  MinicartEmptyMessageDisplayer.prototype.facade = function(){
    $(".js-minicart").append("<li class='product_item'><p class='empty_cart'>Sua sacola está vazia :(<br>Navegue no site e mude isso já!</p></li>");   
  };

  return MinicartEmptyMessageDisplayer;
})();
