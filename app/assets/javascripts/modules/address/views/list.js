app.views.List = Backbone.View.extend({
  id: 'address',
  events: {
    'click .js-addAddress': 'addAddress',
    'click .js-showAll': 'showAll',
    'click .js-showOnlySelected': 'showOnlySelected',
  },
  template: _.template($('#tpl-address-list').html() || ""),

  initialize: function(attr) {
    this.cart = attr['cart'];
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
    this.collection.on('remove', this.addAll, this);

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
    this.showOnlySelected();
  },

  render: function(){
    this.$el.html(this.template({hasAddresses: this.collection.size() > 0}));
    
    this.backButton = this.$el.find('.js-showOnlySelected');
    this.addButton = this.$el.find('.js-add_address');

    this.addAll();
  },
  addAddress: function() {
    olookApp.publish('address:add');
    this.hideList();
    this.$el.find("#save-btn").val("Cadastrar Endereço");
  },

  showList: function() {
    this.$el.find('.js-addressListView').show();
  },

  hideList: function() {
    this.$el.find('.js-addressListView').hide();
  },

  showOnlySelected: function() {
    var elements = this.$el.find('ul#address-list li');
    this.$el.find('ul#address-list li ul').removeClass('addressBox');
    this.$el.find('ul#address-list').removeClass('allAddressList');

    this.renderShowAllButton();
    this.backButton.hide();
    this.renderAddAddressButton();
    
    elements.find('input').parent().hide();
    elements.find('input:checked').parent().show();

  },

  showAll: function() {
    var elements = this.$el.find('ul#address-list li');
    elements.find('input').parent().show();
    this.$el.find('ul#address-list li ul').addClass('addressBox');
    this.$el.find('ul#address-list').addClass('allAddressList');

    this.backButton.show();
    this.addButton.hide();

    olookApp.publish('address:notSelected');

    this.$el.find('.js-showAll').hide();
  },

  renderShowAllButton: function() {
    var showAllButton = this.$el.find('.js-showAll');

    if (this.collection.isEmpty() || this.collection.size() == 1) {
      showAllButton.hide();
    } else {
      showAllButton.show();
    }
  },

  renderAddAddressButton: function() {
    var addAddressButton = this.$el.find('.js-add_address');

    if (this.collection.isEmpty()) {
      addAddressButton.hide();
    } else {
      addAddressButton.show();
    }
  },

});
