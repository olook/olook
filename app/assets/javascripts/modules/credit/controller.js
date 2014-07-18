//= require modules/credit/views/credits
var CreditsController = (function(){
  function CreditsController() {
    this.current_cart = new app.models.CurrentCart();
    this.CreditsView = new app.views.Credits({model: this.current_cart});
  };

  CreditsController.prototype.config = function() {
    this.CreditsView.$el.appendTo(app.content);
    this.fetchCartInfo();
  };

  CreditsController.prototype.fetchCartInfo = function(){
    this.current_cart.fetch();
  };

  return CreditsController;
})();
