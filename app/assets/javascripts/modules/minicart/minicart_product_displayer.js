var MinicartProductDisplayer  = (function(){
  function MinicartProductDisplayer() {};
  MinicartProductDisplayer.prototype.config = function(){
    olookApp.subscribe('minicart:display_products', this.facade);
  };

  MinicartProductDisplayer.prototype.facade = function(product_list){
    for(i = 0; i<product_list.length; i++){
      displayProduct(product_list[i]);
    }    
  };

  var displayProduct = function(product){
    $('.js-minicart').append('<li class="product_item" data-id="'+product.id+'"><img alt="'+product.name+'" src="'+product.thumb_picture+'" title="'+product.name+'"><h2>"'+product.formatted_product_name+'"</h2><p class="size">Tamanho: '+product.size+'</p><p class="qte">Quantidade:<span>'+product.quantity+'</span></p><p class="price">R$ '+parseToCurrency(product.retail_price)+'</p></li>');
  }

  var parseToCurrency = function(retail_price){
    return parseFloat(retail_price).toFixed(2).replace(".", ",")
  }

  return MinicartProductDisplayer;
})();
