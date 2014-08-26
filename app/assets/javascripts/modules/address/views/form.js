//= require state_cities
//= require jquery.meio.mask.js
app.views.Form = Backbone.View.extend({
  className: 'addressForm',
  template: _.template($("#tpl-address-form").html() || ""),

  initialize: function() {
    olookApp.subscribe('address:change', this.changeAddress, {}, this);
    olookApp.subscribe('address:add', this.addAddress, {}, this);
    olookApp.subscribe('address:selected', this.hideForm, {}, this);
    if(!this.model) this.model = new app.models.Address();
    this.collection.on("add remove sync", this.checkShow, this);
    this.on("saved", function() {
      this.collection.fetch({reset: true});
    });
  },

  remove: function() {
    Backbone.View.prototype.remove.call(this);
    olookApp.mediator.remove('address:change', this.changeAddress);
    olookApp.mediator.remove('address:add', this.addAddress);
    olookApp.mediator.remove('address:selected', this.hideForm);
  },

  events: {
    'click #save-btn': 'addNew',
    'submit': 'addNew',
    'blur #zip_code': 'fetchAddress',
    'keyup #mobile' : 'updateMobileMask'
  },

  addNew: function(e) {
    e.preventDefault();
    this.updateModel();
    var it = this;
    var translateServerErrors = function(model, response, options) {
      var jerrors = JSON.parse(response.responseText);
      var errors = _.map(jerrors, function(value, name) {
        return { name: name, message: value[0] };
      });
      it.showErrors(errors);
    };
    if (this.model.isValid()) {
      var finish = function() {
        it.trigger("saved");
        it.hideForm();
        olookApp.mediator.publish("address:added");
      }
      if(this.model.id === undefined){
        this.collection.create(this.model.attributes, {wait: true, success: finish, error: translateServerErrors});
      } else {
        this.model.save({}, {success: finish, error: translateServerErrors});
      }
    } else {
      this.showErrors(this.model.validationError);
    }
  },

  checkShow: function() {
    if(this.collection.length == 0){
      this.addAddress();
    }
  },

  updateModel: function() {
    var formValues = this.$el.find('.js-addressForm form').serializeArray();
    var values = _.object(_.map(formValues, function(item) {
       return [item.name, item.value]
    }));

    this.model.set(values, {silent: true});
  },

  showErrors: function(errors) {
    this.$el.find('.help-inline').text('');
    this.$el.find('.control-group').removeClass('error');
    _.each(errors, this.showError, this);
  },

  showError: function(error) {
    var controlGroup = this.$el.find('.' + error.name);
    controlGroup.addClass('error');
    controlGroup.find('.help-inline').text(error.message);
  },

  render: function(obj) {
    var html = this.template(this.model.attributes);
    this.$el.html(html);
    this.initMasks();
  },

  showForm: function(e) {
    this.render();
    this.$el.find('.js-addressForm').show();
  },

  hideForm: function(e) {
    this.$el.find('.js-addressForm').hide();
    this.showAddButton();
  },

  changeAddress: function(model) {
    this.model = model;
    this.render();
    this.showForm();
    this.load_state_cities();
    this.showAddButton();
  },

  addAddress: function() {
    this.model = new app.models.Address();
    this.render();
    this.showForm();
    this.load_state_cities();
    this.hideAddButton();
  },

  hideAddButton: function() {
    this.$el.find('.js-add_address').hide();
  },

  showAddButton: function() {
    this.$el.find('.js-add_address').show();
  },

  fetchAddress: function() {
    var it = this;
    $.ajax({
      url: "/api/v1/zip_code/"+this.$('#zip_code').val()+".json",
      dataType: "json",
      headers: { "Authorization": window.token }
    }).success(function(data) {
      it.$el.find('#state').val(data.state)[0].onchange();
      it.$el.find('#city').val(data.city);
      it.$el.find('#street').val(data.street);
      it.$el.find('#neighborhood').val(data.neighborhood);
      it.$el.find('#number').focus();
    });
  },

  initMasks: function() {
    this.$el.find("#zip_code").setMask("99999-999");
    this.$el.find("#telephone").setMask("(99)9999-9999");
    this.$el.find("#mobile").setMask("(99)9999-9999");
  },

  updateMobileMask: function() {
    var tel = "#mobile";
    dig9 = this.$el.find(tel).val().substring(4, 5);
    ddd  = this.$el.find(tel).val().substring(1, 3);
    if(dig9 == "9" && ddd.match(/11|12|13|14|15|16|17|18|19|21|22|24|27|28/)){
      $(tel).setMask("(99)99999-9999");
    } else {
      $(tel).setMask("(99)9999-9999");
    }
  },

  load_state_cities: function(){
  new dgCidadesEstados({
    cidade: document.getElementById('city'),
    estado: document.getElementById('state')
  });
}
});
