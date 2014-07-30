//= require modules/address/models/address
//= require modules/address/collections/addresses
//= require modules/address/views/address
//= require modules/address/views/list
//= require modules/address/views/form

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
    this.fetchAddress();
    this.freight.config()
    olookApp.subscribe("address:selected", this.setAddress, {}, this);
    olookApp.subscribe("address:handle_views", this.handleViews, {}, this);
  };

  AddressController.prototype.setAddress = function(model){
    this.cart.save("address_id", model.get('id'));
  };

  AddressController.prototype.remove = function(model){
    this.listView.remove();
    this.formView.remove();
    this.freight.remove();
  };

  AddressController.prototype.fetchAddress = function(){
    this.addresses.fetch({ // call fetch() with the following options
      success: this.handleViews
    });
  };

  AddressController.prototype.handleViews = function(collection){
    if(collection.size() == 0){
      olookApp.publish('address:add');
    } else {
    }
  };

  return AddressController;
})();
