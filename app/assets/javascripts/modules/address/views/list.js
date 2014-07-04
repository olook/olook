app.views.List = Backbone.View.extend({
  events: {
    'click .js-addAddress': 'addAddress'
  },
  initialize: function() {
    this.template = _.template($('#tpl-address-list').html());
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
    this.collection.on('change', this.update, this);
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
