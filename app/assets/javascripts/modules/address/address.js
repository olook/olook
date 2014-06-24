var App = App || {}

var Address = Backbone.Model.extend({
  url: '/api/v1/addresses',

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


App.AddressForm = Backbone.View.extend({
  el: $(".form"),
  className: 'addressForm',
  tagName: 'form',
  template: _.template($("#form_template").html()),

  initialize: function() {
    this.model.on('invalid', this.showErrors, this);
  },

  events: {
    'click #save-btn': 'addNew',
    'blur #zip_code': 'fetchAddress'
  },
  addNew: function(e) {
    e.preventDefault();

    var me = this;

    var values = {
      city: this.$('#city').val(),
      zip_code: this.$('#zip_code').val(),
      street: this.$('#street').val(),
      state: this.$('#state').val(),
      country: this.$('#country').val(),
      number: this.$('#number').val(),
      neighborhood: this.$('#neighborhood').val(),
      telephone: this.$('#telephone').val(),
    };

    this.model.save(values);
  },
  showErrors: function(model, errors) { 
    _.each(errors, function (error) {
      var controlGroup = this.$('.' + error.name);
      controlGroup.addClass('error');
      controlGroup.find('.help-inline').text(error.message);
    }, this);
  },

  render: function() {
    var html = this.template({});
    this.$el.html(html);
  },
  fetchAddress: function() {
    console.log('deveria buscar o cep agora...')
  }  
});

var addressList = new AddressList();

form = new App.AddressForm({model: new Address(), collection: addressList});
form.render();


// $(function() {
  var view = new AddressListView({collection: addressList});
  addressList.fetch();
  $('#addressApp').html(view.el);
// })