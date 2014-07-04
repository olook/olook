app.views.List = Backbone.View.extend({
  tagName: 'ul',
  events: {
    'click .zip': 'remove',
    'click .js-addAddress': 'addAddress'
  },
  initialize: function() {
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
    this.collection.on('change', this.update, this);
  },
  addOne: function(address) {
    var addressView = new app.views.Address({model: address});
    addressView.render();
    this.$el.append(addressView.el);
  },
  addAll: function() {
    this.$el.empty();
    this.collection.forEach(this.addOne, this);
  },
  render: function(){
    this.addAll();
  },
  addAddress: function() {
    olookApp.publish('address:add');
  }
})
