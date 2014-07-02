_.templateSettings = {
  interpolate: /\{\{(.+?)\}\}/g
};

app.views.Form = Backbone.View.extend({
  className: 'addressForm',
  template: _.template($("#form_template").html()),

  initialize: function() {
    this.model = new app.models.Address();

    this.on("saved", function() {
      app.addresses.fetch({async:false});
    });       

    this.render();
  },

  events: {
    'click #save-btn': 'addNew',
    'submit': 'addNew',
    'blur #zip_code': 'fetchAddress',
    'click .js-addAddress': 'displayCreateForm',
  },
  
  addNew: function(e) {
    e.preventDefault();
    this.updateModel();
    if (this.model.isValid()) {
      if(this.model.id === undefined ){
        this.collection.create(this.model.attributes, {wait: true});
      } else {
        this.model.save();
        this.collection.set(this.model.attributes,{remove: false, wait: true, validate: true});        
      }
      this.trigger("saved");
      this.hideForm();
    } else {
      this.showErrors();
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

  showErrors: function() {
    _.each(this.model.validationError, function (error) {
      var controlGroup = this.$('.' + error.name);
      controlGroup.addClass('error');
      controlGroup.find('.help-inline').text(error.message);
    }, this);
  },

  displayUpdateForm: function(modelId){
    this.model.set('id', modelId );
    this.model.fetch({async: false});
    this.render();
    this.showForm();
  },

  displayCreateForm: function(modelId){
    this.model = new app.models.Address();
    this.render();
    this.showForm();
  },  

  showForm: function(e) {
    this.$('.js-address_form').show();
    this.$('.js-addAddress').hide();
  },
  
  hideForm: function(e) {
    this.$('.js-address_form').hide();
    this.$('.js-addAddress').show();
  },

  render: function(obj) {
    var html = this.template(this.model.attributes);
    this.$el.html(html);
  },

  fetchAddress: function() {
    $.get("/api/v1/zip_code/"+this.$('#zip_code').val()+".json", {} , function(data) {
      $('#city').val(data.city);
      $('#state').val(data.state);
      $('#street').val(data.street);
      $('#neighborhood').val(data.neighborhood);
    },"json");
  }  
});