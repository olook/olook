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
  };

  FreightController.prototype.selectAddress = function(data) {
    $('#main').html(this.freightsView.el);
    this.freights.fetch({data: {zip_code: data['zip_code'], amount_value: '99.9'}});
  };

  return FreightController;
})();

olookApp.subscribe('app:init', function(){
  new FreightController().config();
});
