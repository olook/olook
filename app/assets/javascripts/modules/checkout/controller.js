//= require modules/address/controller
//= require modules/freight/controller
//= require modules/payment/controller
//= require modules/cart_resume/controller
//= require modules/credit/controller
//= require modules/checkout/views/steps
//= require modules/checkout/router
var CheckoutController = (function() {
  function CheckoutController() {
    this.steps = new app.views.Steps();
    this.router = new Router();
  };

  CheckoutController.prototype.config = function () {
    this.steps.$el.prependTo("#content");
    this.steps.render();
  };

  return CheckoutController;
})();

olookApp.subscribe('app:init', function() {
  new CheckoutController().config();
});
