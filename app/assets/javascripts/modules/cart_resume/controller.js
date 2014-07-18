//= require modules/cart_resume/models/current_cart
//= require modules/cart_resume/models/cart_item
//= require modules/cart_resume/views/cart_resume
//= require modules/cart_resume/views/cart_item
var CartResumeController = (function(){
  function CartResumeController(attr) {
    this.current_cart = attr['cart'];
    this.cart_resume = new app.views.CartResume({model: this.current_cart});
  };

  CartResumeController.prototype.config = function() {
    this.cart_resume.$el.appendTo(app.content);
    this.current_cart.fetch();
  };

  return CartResumeController;
})();
