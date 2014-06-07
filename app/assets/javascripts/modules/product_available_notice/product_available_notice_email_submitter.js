var ProductAvailableNoticeEmailSubmitter  = (function(){
  function ProductAvailableNoticeEmailSubmitter() {};
  ProductAvailableNoticeEmailSubmitter.prototype.config = function(){
    olookApp.subscribe('product_available_notice:submit_email', this.facade, {}, this);
  };

  ProductAvailableNoticeEmailSubmitter.prototype.facade = function(email, productId){

    $.post('/api/v1/product_interest', {"email": email, "product_id": productId})
      .done(function() {
        olookApp.publish('product_available_notice:display_success_message');
      }).fail(function(){
        olookApp.publish('product_available_notice:display_error_message');
      });
  };

  return ProductAvailableNoticeEmailSubmitter;
})();
