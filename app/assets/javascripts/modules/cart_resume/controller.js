//= require modules/cart_resume/models/current_cart
//= require modules/cart_resume/models/cart_item
//= require modules/cart_resume/views/cart_resume
//= require modules/cart_resume/views/cart_item
var CartResumeController = (function(){
  function CartResumeController(attr) {
    this.cart = attr['cart'];
    this.cart_resume = new app.views.CartResume({model: this.cart});
  };

  CartResumeController.prototype.config = function() {
    this.cart_resume.$el.appendTo(app.content);
    this.cart_resume.render();
  };

  CartResumeController.prototype.remove = function() {
    this.cart_resume.remove();
  };

  return CartResumeController;
})();
