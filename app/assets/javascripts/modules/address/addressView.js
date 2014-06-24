var AddressView = Backbone.View.extend({
  model: Address,
  template: _.template($("#template").html()),
  
  initialize: function() {
    this.model.on('destroy', this.remove, this);
  },

  render: function() {
    var dict = this.model.toJSON();
    var html = this.template(dict);
    this.$el.html(html);
  },

  remove: function() {
    this.$el.remove();
  }
});


var AddressListView = Backbone.View.extend({
  tagName: 'ul',
  initialize: function() {
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
  },
  addOne: function(address) {
    var addressView = new AddressView({model: address});
    addressView.render();
    this.$el.append(addressView.el);
  },
  addAll: function() {
    this.collection.forEach(this.addOne, this);
  },
  render: function(){
    this.addAll();
  },

  remove: function(e) {
    var id = e.target.id;
    var modelToDestroy = this.collection.get(id);
    this.collection.remove(modelToDestroy);
  },

  events: {
    'click .zip': 'remove'
  },  


})