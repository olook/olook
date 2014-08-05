//= require modules/address/controller
//= require modules/freight/controller
//= require modules/payment/controller
//= require modules/cart_resume/controller
//= require modules/login/controller
//= require modules/credit/controller
//= require modules/checkout/views/steps
//= require modules/checkout/router
var CheckoutController = (function() {
  function CheckoutController() {
    this.cart = new app.models.CurrentCart();
    this.session = new app.models.Session();
    this.router = new app.routers.CheckoutRouter({session: this.session, cart: this.cart});
    this.steps = new app.views.Steps({model: this.cart});
  };

  CheckoutController.prototype.config = function () {
    this.steps.$el.prependTo("#content");
    this.steps.render();
    this.router.start();
    olookApp.subscribe("app:next_step", this.nextStep, {}, this);
    olookApp.subscribe("freight:selected", this.freightSelected, {}, this);
  };

  CheckoutController.prototype.freightSelected = function(model) {
    this.cart.save({shipping_service_id: model.get('shipping_service_id')}, {wait: true});
  };

  CheckoutController.prototype.nextStep = function() {
    var nextStep = this.steps.checkNextStep();
    var url = this.router.translateStep(this.steps.checkNextStep());
    this.router.navigate(url, {trigger: true});
  };

  return CheckoutController;
})();

olookApp.subscribe('app:init', function() {
  window.checkout = new CheckoutController().config();
});
