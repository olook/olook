//= require modules/address/models/address
//= require modules/address/collections/addresses
//= require modules/address/views/address
//= require modules/address/views/list
//= require modules/address/views/form
//= require modules/address/views/selectedAddress

var AddressController = (function(){
  function AddressController(attr) {
    this.cart = attr['cart'];
    this.addresses = new app.collections.Addresses();
    this.listView = new app.views.List({collection: this.addresses, cart: this.cart});
    this.formView = new app.views.Form({collection: this.addresses});
    this.freight = new FreightController({cart: this.cart});
  };

  AddressController.prototype.config = function() {
    this.listView.render();
    this.listView.$el.appendTo(app.content);
    this.formView.$el.appendTo(app.content);
    this.freight.config();
    
    olookApp.subscribe("address:selected", this.setAddress, {}, this);
    olookApp.subscribe("address:added", this.showAddressList, {}, this);
    olookApp.subscribe("address:canceled", this.showAddressList, {}, this);

    olookApp.subscribe("address:change", this.hideAddressList, {}, this);

    this.addresses.fetch({reset: true});
  };

  AddressController.prototype.setAddress = function(model){
    this.cart.save({ address_id: model.get('id'), shipping_service_id: null });
    this.listView.showOnlySelected();
  };

  AddressController.prototype.remove = function(model){
    this.listView.remove();
    this.formView.remove();
    this.freight.remove();
    olookApp.mediator.remove('address:selected', this.setAddress);
    olookApp.mediator.remove('address:added', this.showAddressList);
    olookApp.mediator.remove('address:canceled', this.showAddressList);
    olookApp.mediator.remove("address:change", this.hideAddressList);
  };

  AddressController.prototype.showAddressList = function(){
    this.listView.showList();
  };

  AddressController.prototype.hideAddressList = function(){
    this.listView.hideList();
  };



  return AddressController;
})();
