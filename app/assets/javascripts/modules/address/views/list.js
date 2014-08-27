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

  addAll: function() {
    this.add(this.collection.length);
  },

  addAll: function() {
    this.$el.find('ul#address-list').empty();
    this.collection.forEach(this.addOne, this);
    this.setSelected();
    this.showOnlySelected();
  },

  render: function(){
    this.$el.html(this.template({}));
    this.addAll();
  },
  addAddress: function() {
    olookApp.publish('address:add');
    this.hideList();
    this.$el.find("#save-btn").val("Cadastrar Endereço");
  },

  showList: function() {
    this.$el.find('ul#address-list').show();
    this.$el.find('.js-add_address').show();
  },

  hideList: function() {
    this.$el.find('ul#address-list').hide();
    this.$el.find('.js-add_address').hide();
  },

  showOnlySelected: function() {
    var elements = this.$el.find('ul#address-list li');
    elements.removeClass('addressBox');
    elements.find('input').parent().hide();
    elements.find('input:checked').parent().show();

    this.$el.find('.js-showOnlySelected').hide();
    this.$el.find('.js-showAll').show();
    this.$el.find('.js-add_address').show();
  },

  showAll: function() {
    var elements = this.$el.find('ul#address-list li');
    elements.find('input').parent().show();
    elements.addClass('addressBox');

    olookApp.publish('address:notSelected');

    this.$el.find('.js-showOnlySelected').show();
    this.$el.find('.js-showAll').hide();
    this.$el.find('.js-add_address').hide();
  },
  

});
