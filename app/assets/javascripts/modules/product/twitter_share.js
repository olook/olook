/* 
  Para utilizar essa classe, deve-se ter um elemento com a classe 'js-twitter_share'. 
Este elemento, por sua vez, deve conter um parametro chamado data-product-url, possuindo o url do produto,
e um parametro chamado data-text, com o texto a ser compartilhado.

  Obs.: Para personalizar o tamanho do box do twitter, devem ser passadas as dimensoes do box de share no
  momento do publish da mensagem.
*/

var TwitterShare  = (function(){
  function TwitterShare() {};

  var shareOnTwitter = function(w, h){
    var product_url = $('.js-twitter_share').data('product-url');
    var text = $('.js-twitter_share').data('text');
    var width  = (typeof w === "undefined") ? 575 : w;
    var height = (typeof h === "undefined") ? 400 : h;

    var left   = ($(window).width()  - width)  / 2,
    top    = ($(window).height() - height) / 2,
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
    $('.js-twitter_share').click(function(event) {
      olookApp.publish('product:twitter_share',1000,1000);
      return false;
    });
  };

  TwitterShare.prototype.facade = function(width, height){
    _gaq.push(['_trackEvent', 'Share', 'Twitter', 'Product_page', , true]);
    shareOnTwitter(width, height);
  };

  return TwitterShare;
})();
