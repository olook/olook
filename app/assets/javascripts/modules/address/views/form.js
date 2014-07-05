app.views.Form = Backbone.View.extend({
  className: 'addressForm',
  template: _.template($("#tpl-address-form").html()),

  initialize: function() {
    olookApp.subscribe('address:change', this.changeAddress, {}, this);
    olookApp.subscribe('address:add', this.addAddress, {}, this);
    olookApp.subscribe('address:selected', this.hideForm, {}, this);
    if(!this.model) this.model = new app.models.Address();
    this.on("saved", function() {
      this.collection.fetch({reset: true});
    });
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
      mobile: this.$('#mobile').val(),
      full_name: this.$('#full_name').val(),
      complement: this.$('#complement').val()
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

  render: function(obj) {
    var html = this.template(this.model.attributes);
    this.$el.html(html);
  },

  showForm: function(e) {
    this.$el.find('.js-addressForm').show();
  },

  hideForm: function(e) {
    this.$el.find('.js-addressForm').hide();
  },

  changeAddress: function(model) {
    this.model = model;
    this.render();
    this.showForm();
  },

  addAddress: function() {
    this.model = new app.models.Address();
    this.render();
    this.showForm();
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
