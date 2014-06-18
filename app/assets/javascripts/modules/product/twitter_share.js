/* 

Para utilizar essa classe, deve-se ter um elemento com a classe 'js-twitter_share'. 
Este elemento, por sua vez, deve conter um parametro chamado data-product-url, possuindo o url do produto,
e um parametro chamado data-text, com o texto a ser compartilhado. Tambem devem ser passadas as dimensoes do 
box de share no momento do publish da mensagem.

*/

var TwitterShare  = (function(){
  function TwitterShare(selector) {
    this.selector = selector;
  };

  var shareOnTwitter = function(selector, w, h){
    var product_url = selector('.js-twitter_share').data('product-url');
    var text = selector('.js-twitter_share').data('text');
    var width  = w;
    var height = h;

    var left   = (selector(window).width()  - width)  / 2,
    top    = (selector(window).height() - height) / 2,
    url    = 'https://twitter.com/share?url='+product_url+'&text='+text,
    opts   = 'status=1' +
      ',width='  + width  +
      ',height=' + height +
      ',top='    + top    +
      ',left='   + left;

    window.open(url, 'twitter', opts);
  };
  
  TwitterShare.prototype.config = function(){
    olookApp.subscribe('product:twitter_share', this.facade, {}, this);
    this.selector('.js-twitter_share').click(function(event) {
      olookApp.publish('product:twitter_share',575,400);
      return false;
    });
  };

  TwitterShare.prototype.facade = function(width, height){
    _gaq.push(['_trackEvent', 'Share', 'Twitter', 'Product_page', , true]);
    console.log(this.selector);
    shareOnTwitter(this.selector, width, height);
  };

  return TwitterShare;
})();
