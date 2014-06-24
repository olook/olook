var Address = Backbone.Model.extend({
  defaults: {
    city: '',
    number: ''
  }
});

var AddressView = Backbone.View.extend({
  model: Address,
  template: _.template($("#template").html()),
  initialize: function() {
    this.model.on('sync', this.render());
  },
  render: function() {
    var dict = this.model.toJSON();
    var html = this.template(dict);
    this.$el.html(html);
  }
});


var AddressList = Backbone.Collection.extend({
  model: Address,
  url: '/api/v1/addresses',

  initialize: function() {
    console.log('colecao inicializada');
    this.bind('add', this.onModelAdded, this);
    this.bind('remove', this.onModelRemoved, this);
  },

  onModelAdded: function(model, collection, options) {
    console.log("options = ", options);
    // model.save();
  },
  onModelRemoved: function (model, collection, options) {
    console.log("options = ", options);
    model.destroy();
  }


});

var AddressListView = Backbone.View.extend({
  tagName: 'ul',
  initialize: function() {
    console.log('view principal inicializada');
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




// $(function() {
  var addressList = new AddressList();
  var view = new AddressListView({collection: addressList});
  addressList.fetch();
  $('#addressApp').html(view.el);
// })


