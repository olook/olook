var TwitterShare  = (function(){
  function TwitterShare() {};

  var shareOnTwitter = function(){
    var product_url = $('.js-twitter_share').data('product-url');
    var text = $('.js-twitter_share').data('text');
    var width  = 575,
    height = 400,
    left   = ($(window).width()  - width)  / 2,
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
      olookApp.publish('product:twitter_share');
      return false;
    });
  };

  TwitterShare.prototype.facade = function(){
    _gaq.push(['_trackEvent', 'Share', 'Twitter', 'Product_page', , true]);
    shareOnTwitter();
  };

  return TwitterShare;
})();
