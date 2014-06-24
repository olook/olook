var Address = Backbone.Model.extend({
  urlRoot: '/api/v1/addresses',

  validate: function(attr) {
    errors = [];

    if (!attr.city) {
      errors.push({name: 'city', message: 'Cidade é obrigatória'});
    }
    
    if (!attr.zip_code) {
      errors.push({name: 'zip_code', message: 'CEP é obrigatório'});
    }


    return errors.length > 0 ? errors : false;
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
    console.log("[add] options = ", options);
    // model.save();
  },
  onModelRemoved: function (model, collection, options) {
    console.log("[remove] options = ", options);
    model.destroy();
  }


});

var AddressListView = Backbone.View.extend({
  tagName: 'ul',
  initialize: function() {
    console.log('view principal inicializada');
    this.collection.on('add', this.addOne, this);
    this.collection.on('remove', this.remove, this);
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
    this.collection.trigger('reset');
  },

  events: {
    'click .zip': 'remove'
  },  


})