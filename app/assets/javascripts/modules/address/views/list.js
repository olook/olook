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
    this.collection.on("add remove", this.updateList, this);
    this.cart.on("change", this.setSelected, this);
  },
  setSelected: function() {
    if(this.collection.length == 1) {
      this.collection.at(0).set('selected', true);
    } else {
      var addressId = this.cart.get('address_id');
      this.collection.forEach(function(address){
        if(addressId == address.id) address.set('selected', true);
      });
    }
  },
  addOne: function(address) {
    var addressView = new app.views.Address({model: address});
    addressView.render();
    this.$el.find('ul#address-list').append(addressView.el);
  },
  addAll: function() {
    this.$el.find('ul#address-list').empty();
    this.collection.forEach(this.addOne, this);
    this.setSelected();
  },
  render: function(){
    this.$el.html(this.template({}));
    this.addAll();
    this.updateList();
  },
  addAddress: function() {
    olookApp.publish('address:add');
    this.$el.find("#save-btn").val("Cadastrar Endereço");
  },
  updateList: function() {
    if(this.collection.size() >= 1){
      this.$el.find(".js-no_addresses").hide();
      this.$el.find('.js-add_address').show();
    } else {
      this.$el.find(".js-no_addresses").show()
      this.$el.find('.js-add_address').hide();
    }
    olookApp.publish("address:handle_views", this.collection);
  }
});
