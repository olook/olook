//= require modules/checkout/views/steps
var CheckoutController = (function() {
  function CheckoutController() {
    this.steps = new app.views.Steps();
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
