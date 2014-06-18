/* 

Para utilizar essa classe, deve-se ter um elemento com a classe 'js-facebook_share'. 
Este elemento, por sua vez, deve conter um parametro chamado data-product-url, possuindo o url do produto. 

*/

var FacebookShare  = (function(){
  function FacebookShare(selector) {
    this.selector = selector;
  };

  FacebookShare.prototype.config = function(){
    olookApp.subscribe('product:facebook_share', this.facade, {}, this);
    $('.js-facebook_share').click(function(event) {
      olookApp.publish('product:facebook_share');
      return false;
    });
  };

  FacebookShare.prototype.facade = function(){
    _gaq.push(['_trackEvent', 'Share', 'Facebook', 'Product_page', , true]);
    var product_url = this.selector('.js-facebook_share').data('product-url');
    FB.ui({
      method: 'share',
      href: product_url,
    });
  };

  return FacebookShare;
})();
