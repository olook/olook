//= require modules/freight/models/freight
//= require modules/freight/collections/freights
//= require modules/freight/views/freight
//= require modules/freight/views/freights
var FreightController = (function(){
  function FreightController(){
    this.freights = new app.collections.Freights();
    this.freightsView = new app.views.Freights({collection: this.freights});
  };

  FreightController.prototype.config = function(){
    olookApp.subscribe('address:selected', this.selectAddress, {}, this);
    this.freightsView.$el.appendTo(app.content);
  };

  FreightController.prototype.selectAddress = function(data) {
    this.freights.fetch({reset: true, data: {zip_code: data['zip_code'], amount_value: '99.9'}});
  };

  return FreightController;
})();

olookApp.subscribe('app:init', function(){
  new FreightController().config();
});
