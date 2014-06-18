var FacebookShare  = (function(){
  function FacebookShare() {};

  FacebookShare.prototype.config = function(){
    olookApp.subscribe('product:facebook_share', this.facade, {}, this);
    $('.js-facebook_share').click(function(event) {
      olookApp.publish('product:facebook_share');
      return false;
    });
  };

  FacebookShare.prototype.facade = function(){
    _gaq.push(['_trackEvent', 'Share', 'Facebook', 'Product_page', , true]);
    var product_url = $('.js-facebook_share').data('product-url');
    debugger;
    FB.ui({
      method: 'share',
      href: product_url,
    }, function(response){});
  };

  return FacebookShare;
})();
