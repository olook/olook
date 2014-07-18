//= require modules/address/controller
//= require modules/freight/controller
//= require modules/payment/controller
//= require modules/cart_resume/controller
//= require modules/credit/controller
//= require modules/checkout/views/steps
//= require modules/checkout/router
var CheckoutController = (function() {
  function CheckoutController() {
    this.current_cart = new app.models.CurrentCart();
    this.router = new app.routers.CheckoutRouter({cart: this.current_cart});
    this.steps = new app.views.Steps({model: this.current_cart});
  };

  CheckoutController.prototype.config = function () {
    this.steps.$el.prependTo("#content");
    this.steps.render();
    this.router.start();
  };

  return CheckoutController;
})();

olookApp.subscribe('app:init', function() {
  window.checkout = new CheckoutController().config();
});
