var ProductAvailableNoticeSuccessMessageDisplayer  = (function(){
  function ProductAvailableNoticeSuccessMessageDisplayer() {};
  ProductAvailableNoticeSuccessMessageDisplayer.prototype.config = function(){
    olookApp.subscribe('product_available_notice:display_success_message', this.facade);
  };

  ProductAvailableNoticeSuccessMessageDisplayer.prototype.facade = function(email, productId){
    $('.js-product_available_notice_form').delay(200).fadeOut();
    $('.js-product_available_notice_error').delay(200).fadeOut();
    $('.js-product_available_notice_success').delay(200).fadeIn();
  };

  return ProductAvailableNoticeSuccessMessageDisplayer;
})();
