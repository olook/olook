//= require modules/freight/models/freight
//= require modules/freight/collections/freights
//= require modules/freight/views/freight
//= require modules/freight/views/freights
var FreightController = (function(){
  function FreightController(attr){
    this.cart = attr['cart'];
    this.freights = new app.collections.Freights();
    this.freightsView = new app.views.Freights({collection: this.freights});
  };

  FreightController.prototype.config = function(){
    olookApp.subscribe('address:selected', this.selectAddress, {}, this);
    this.freightsView.$el.appendTo(app.content);
  };

  FreightController.prototype.selectAddress = function(model) {
    this.freights.fetch({reset: true, data: {zip_code: model.get('zip_code'), amount_value: this.cart.get('subtotal')}});
  };

  return FreightController;
})();
