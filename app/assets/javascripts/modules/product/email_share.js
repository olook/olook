/* 

Para utilizar essa classe, deve-se ter um elemento com a classe 'js-twitter_share'. 
Este elemento, por sua vez, deve conter um parametro chamado data-product-url, possuindo o url do produto,
e um parametro chamado data-text, com o texto a ser compartilhado. Tambem devem ser passadas as dimensoes do 
box de share no momento do publish da mensagem.

*/

var EmailShare  = (function(){
  function EmailShare(selector) {
    this.selector = selector;
  };
  
  EmailShare.prototype.config = function(){
    olookApp.subscribe('product:email_share', this.facade, {}, this);
    this.selector('.js-email_share').click(function(event) {
      olookApp.publish('product:email_share');
      return false;
    });
  };

  EmailShare.prototype.facade = function(){
    _gaq.push(['_trackEvent', 'Share', 'Email', 'Product_page', , true]);
    var content = $('#compartilhar_email');
    olook.newModal(content,515,630,'#FFF');
  };

  return EmailShare;
})();
