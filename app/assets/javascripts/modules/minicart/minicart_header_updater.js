var MinicartHeaderUpdater  = (function(){
  function MinicartHeaderUpdater() {};

  var displayFullHeader = function(items_length){
    $(".js-minicart_header").addClass('full');
  };

  var updateMinicartItemsNumber = function(items_length){
    var item_text = (items_length == 1) ? "item" : "itens";
    $(".js-minicart_header_items").text(items_length+" "+item_text);
  };

  var displayEmptyHeader = function(){
    $(".js-minicart_header").removeClass('full');
  };

  MinicartHeaderUpdater.prototype.config = function(){
    olookApp.subscribe('minicart:update_header', this.facade);
  };

  MinicartHeaderUpdater.prototype.facade = function(items_length){
    items_length > 0 ? displayFullHeader(items_length) : displayEmptyHeader();
    updateMinicartItemsNumber(items_length);
  };

  return MinicartHeaderUpdater;
})();
