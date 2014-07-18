//= require modules/address/models/address
//= require modules/address/collections/addresses
//= require modules/address/views/address
//= require modules/address/views/list
//= require modules/address/views/form

var AddressController = (function(){
  function AddressController(attr) {
    this.addresses = new app.collections.Addresses();
    this.listView = new app.views.List({collection: this.addresses});
    this.formView = new app.views.Form({collection: this.addresses});
  };

  AddressController.prototype.config = function() {
    this.listView.render();
    this.listView.$el.appendTo(app.content);
    this.formView.$el.appendTo(app.content);
    this.fetchAddress();
  };

  AddressController.prototype.fetchAddress = function(){
    this.addresses.fetch();
  };

  return AddressController;
})();
