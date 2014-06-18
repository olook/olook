//= require modules/product/cart_redirect_manager
//= require modules/product/show_cart_modal_manager
//= require modules/product/add_product_to_cart_manager
//= require modules/product/twitter_share

new TwitterShare(jQuery).config();
new AddProductToCartManager().config();
new CartRedirectManager().config();
new ShowCartModalManager().config();

$("#add_product").click(function(){
  olookApp.publish('product:add');
});