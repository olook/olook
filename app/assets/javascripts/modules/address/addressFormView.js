var App = App || {}

App.AddressFormView = Backbone.View.extend({
  el: $(".form"),
  className: 'addressForm',
  tagName: 'form',
  template: _.template($("#form_template").html()),

  initialize: function() {
    this.model.on('invalid', this.showErrors, this);
    this.render();
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