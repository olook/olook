var CartResumeController = (function(){
  function CartResumeController() {
    this.current_cart = app.models.CurrentCart();
    this.cart_resume = app.views.CartResume({model: this.current_cart});
  };

  CartResumeController.prototype.config = function() {
  };

  return CartResumeController;
})();

olookApp.subscribe('app:init', function() {
  new CartResumeController().config();
});
