app.views.List = Backbone.View.extend({
  id: 'address',
  events: {
    'click .js-addAddress': 'addAddress'
  },
  template: _.template($('#tpl-address-list').html() || ""),

  initialize: function(attr) {
    this.cart = attr['cart'];
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addLastTwoAddresses, this);
    this.collection.on('change', this.updateList, this);
    this.collection.on("add remove", this.updateList, this);
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
  addLastTwoAddresses: function() {
    this.add(2);
  },

  addAll: function() {
    this.add(this.collection.length);
  },

  add: function(amount) {
    this.$el.find('ul#address-list').empty();
    this.collection.last(amount).forEach(this.addOne, this);
    this.setSelected();
    this.updateList();
  },

  render: function(){
    this.$el.html(this.template({}));
    this.addLastTwoAddresses();
  },
  addAddress: function() {
    olookApp.publish('address:add');
    this.hideList();
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
  },

  showList: function() {
    this.$el.find('ul#address-list').show();
    this.$el.find('.js-add_address').show();
  },

  hideList: function() {
    this.$el.find('ul#address-list').hide();
    this.$el.find('.js-add_address').hide();
  },

});
