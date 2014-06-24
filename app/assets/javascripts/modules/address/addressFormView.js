var App = App || {}

App.AddressFormView = Backbone.View.extend({
  el: $(".form"),
  className: 'addressForm',
  tagName: 'form',
  template: _.template($("#form_template").html()),

  initialize: function() {
    this.model.on('invalid', this.showErrors, this);
    this.render();

    _.bindAll(this, 'fetchAddress');
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

    addr = new Address(values);
    if (addr.isValid()) {
      this.collection.create(addr.toJSON(), {wait: true})
    }
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
    $.get("/get_address_by_zipcode", {zipcode: this.$('#zip_code').val()} , function(data) {
      $('#city').val(data.city);
      $('#state').val(data.state);
      $('#street').val(data.street);
      $('#neighborhood').val(data.neighborhood);
    },"json");
  }  
});