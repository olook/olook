var ProductAvailableNoticeSuccessMessageDisplayer  = (function(){
  function ProductAvailableNoticeSuccessMessageDisplayer() {};
  ProductAvailableNoticeSuccessMessageDisplayer.prototype.config = function(){
    olookApp.subscribe('product_available_notice:display_success_message', this.facade);
  };

  ProductAvailableNoticeSuccessMessageDisplayer.prototype.facade = function(email, productId){
    $('.js-product_available_notice_form').fadeOut();
    $('.js-product_available_notice_error').fadeOut();
    $('.js-product_available_notice_success').delay(400).fadeIn();
  };

  return ProductAvailableNoticeSuccessMessageDisplayer;
})();
