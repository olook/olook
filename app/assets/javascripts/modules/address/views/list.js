app.views.List = Backbone.View.extend({
  id: 'address',
  events: {
    'click .js-addAddress': 'addAddress'
  },
  template: _.template($('#tpl-address-list').html() || ""),

  initialize: function(attr) {
    this.cart = attr['cart'];
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
    this.collection.on('change', this.update, this);
    this.cart.on("change", this.setSelected, this);
  },
  setSelected: function() {
    var addressId = this.cart.get('address_id');
    this.collection.forEach(function(address){
      if(addressId == address.id) address.set('selected', true);
    })
  },
  addOne: function(address) {
    var addressView = new app.views.Address({model: address});
    addressView.render();
    this.$el.find('ul#address-list').append(addressView.el);
  },
  addAll: function() {
    this.$el.find('ul#address-list').empty();
    this.collection.forEach(this.addOne, this);
  },
  render: function(){
    this.$el.html(this.template({}));
    this.addAll();
  },
  addAddress: function() {
    olookApp.publish('address:add');
  }
});
