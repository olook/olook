//= require modules/product/cart_redirect_manager
//= require modules/product/show_cart_modal_manager
//= require modules/product/add_product_to_cart_manager
//= require modules/product/twitter_share
//= require modules/product/facebook_share
//= require modules/product/email_share

new FacebookShare(jQuery).config();
new TwitterShare(jQuery).config();
new EmailShare(jQuery).config();
new AddProductToCartManager().config();
new CartRedirectManager().config();