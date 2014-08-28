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
    olookApp.subscribe("app:addressStep", this.addressStep, {}, this);
    olookApp.subscribe("freight:selected", this.freightSelected, {}, this);
    olookApp.subscribe("address:remove", this.removeAddress, {}, this);
    olookApp.subscribe('checkout:payment_type', this.paymentTypeSelected, {}, this);
    olookApp.subscribe('checkout:finish', this.finish, {}, this);
  };

  CheckoutController.prototype.paymentTypeSelected = function(model){
    if(this.cart.get('payment_method') != model.get('type')) {
      this.cart.save({ payment_method: model.get('type')}, {wait: true});
    } else {
      this.cart.trigger('change:payment_method');
    }
  };

  CheckoutController.prototype.freightSelected = function(model) {
    this.cart.save({shipping_service_id: model.get('shipping_service_id')});
    this.nextStep();
  };

  CheckoutController.prototype.finish = function(model) {
    var that = this;

    $.post("/api/v1/checkout", {}).done(function(data, status, resp){
      
      that.cart = new app.models.CurrentCart();
      window.location = resp.getResponseHeader('location');

    }).fail(function(data, status, resp) {
      that.cart.attributes.payment_data.errorMessage = JSON.parse(data.responseText).message;
      that.router.navigate('pagamento', {trigger: true});
    })

  };

  CheckoutController.prototype.removeAddress = function(model) {
    if(model.id == this.cart.get('address_id')) {
      this.cart.save({shipping_service_id: null, address_id: null});
    }
  };

  CheckoutController.prototype.nextStep = function() {
    var nextStep = this.steps.checkNextStep();
    var url = this.router.translateStep(this.steps.checkNextStep());
    this.router.navigate(url, {trigger: true});
  };

  CheckoutController.prototype.addressStep = function() {
    this.router.navigate('endereco', {trigger: true});
  };

  return CheckoutController;
})();

olookApp.subscribe('app:init', function() {
  window.checkout = new CheckoutController().config();
});
