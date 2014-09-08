//= require modules/freight/models/freight
//= require modules/freight/collections/freights
//= require modules/freight/views/freight
//= require modules/freight/views/freights
var FreightController = (function(){
  function FreightController(attr){
    this.cart = attr['cart'];
    this.freights = new app.collections.Freights();
    this.freightsView = new app.views.Freights({collection: this.freights, cart: this.cart });
  };

  FreightController.prototype.config = function(){
    olookApp.subscribe('address:selected', this.selectAddress, {}, this);
    olookApp.subscribe('address:notSelected', this.hide, {}, this);
  };

  FreightController.prototype.hide = function(){
    this.freightsView.hide();
  };

  FreightController.prototype.remove = function(){
    this.freightsView.remove();
    olookApp.mediator.remove('address:selected', this.selectAddress);
    olookApp.mediator.remove('address:notSelected', this.hide);
  };

  FreightController.prototype.selectAddress = function(model) {
    this.freightsView.$el.appendTo(app.content);
    this.freights.fetch({reset: true, data: {zip_code: model.get('zip_code'), amount_value: this.cart.get('subtotal')}});
  };

  return FreightController;
})();
