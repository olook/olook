_.templateSettings = {
  interpolate: /\{\{(.+?)\}\}/g
};

app.views.Form = Backbone.View.extend({
  className: 'addressForm',
  template: _.template($("#form_template").html()),

  initialize: function() {
    this.model = new app.models.Address();

    this.model.on('change', this.render, this);

    this.model.on('invalid', this.showErrors, this);

    this.on("saved", function() {
      app.addresses.fetch();
    });          

    this.render();
  },

  events: {
    'click #save-btn': 'addNew',
    'submit': 'addNew',
    'blur #zip_code': 'fetchAddress',
    'click .js-addAddress': 'showForm',
  },
  
  addNew: function(e) {
    e.preventDefault();
    this.updateModel();
    if (this.model.isValid()) {
      this.collection.create(this.model.attributes, {wait: true});
      this.hideForm();
      this.model = new app.models.Address();
      this.trigger("saved"); 
    }
  },

  updateModel: function() {
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

    this.model.set(values);
  },

  showErrors: function(model, errors) { 
    _.each(errors, function (error) {
      var controlGroup = this.$('.' + error.name);
      controlGroup.addClass('error');
      controlGroup.find('.help-inline').text(error.message);
    }, this);
  },

  displayAddressData: function(modelId){
    this.model.set('id', modelId );
    this.model.fetch();
  },

  showForm: function(e, editing) {
    if(editing){
      this.displayAddressData(e.target.id);
    }
    this.$('.js-address_form').show();
    this.$('.js-addAddress').hide();
  },
  
  hideForm: function(e) {
    this.$('.js-address_form').hide();
    this.$('.js-addAddress').show();
  },

  render: function(obj) {
    debugger;
    var html = this.template(this.model.attributes);
    this.$el.html(html);
    if(obj){
      this.showForm();
    }
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