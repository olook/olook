//= require modules/product_available_notice/product_available_notice_email_submitter
//= require modules/product_available_notice/product_available_notice_success_message_displayer
//= require modules/product_available_notice/product_available_notice_error_message_displayer
var AUTH = AUTH || {}
AUTH.token = '4ac99b5ed36f20e5ef882faa154fb053';
new ProductAvailableNoticeEmailSubmitter().config();
new ProductAvailableNoticeSuccessMessageDisplayer().config();
new ProductAvailableNoticeErrorMessageDisplayer().config();