var ProductAvailableNoticeErrorMessageDisplayer  = (function(){
  function ProductAvailableNoticeErrorMessageDisplayer() {};
  ProductAvailableNoticeErrorMessageDisplayer.prototype.config = function(){
    olookApp.subscribe('product_available_notice:display_error_message', this.facade);
  };

  ProductAvailableNoticeErrorMessageDisplayer.prototype.facade = function(email, productId){
    $('.js-email_field').delay(200).fadeOut();
    $('.js-notice_email_error').delay(200).fadeIn();
  };

  return ProductAvailableNoticeErrorMessageDisplayer;
})();