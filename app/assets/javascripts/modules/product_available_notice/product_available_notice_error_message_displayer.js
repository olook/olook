var ProductAvailableNoticeErrorMessageDisplayer  = (function(){
  function ProductAvailableNoticeErrorMessageDisplayer() {};
  ProductAvailableNoticeErrorMessageDisplayer.prototype.config = function(){
    olookApp.subscribe('product_available_notice:display_error_message', this.facade);
  };

  ProductAvailableNoticeErrorMessageDisplayer.prototype.facade = function(email, productId){
    $('.js-product_available_notice_error').delay(200).fadeIn();
  };

  return ProductAvailableNoticeErrorMessageDisplayer;
})();