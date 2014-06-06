var ProductAvailableNoticeSuccessMessageDisplayer  = (function(){
  function ProductAvailableNoticeSuccessMessageDisplayer() {};
  ProductAvailableNoticeSuccessMessageDisplayer.prototype.config = function(){
    olookApp.subscribe('product_available_notice:display_success_message', this.facade);
  };

  ProductAvailableNoticeSuccessMessageDisplayer.prototype.facade = function(email, productId){
    $('.js-email_field').delay(200).fadeOut();
    $('.js-notice_email_success').delay(200).fadeIn();
  };

  return ProductAvailableNoticeSuccessMessageDisplayer;
})();
