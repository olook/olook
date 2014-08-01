//= require state_cities
app.views.Form = Backbone.View.extend({
  className: 'addressForm',
  template: _.template($("#tpl-address-form").html() || ""),

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
    'blur #zip_code': 'fetchAddress'
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
      this.$el.find('.help-inline').text('');
      this.$el.find('.control-group').removeClass('error');
      this.showErrors();
    }
  },

  updateModel: function() {
    var formValues = this.$el.find('.js-addressForm form').serializeArray();
    var values = _.object(_.map(formValues, function(item) {
       return [item.name, item.value]
    }));

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
    this.initMask();
  },

  showForm: function(e) {
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

  initMask: function() {
    this.$el.find(":input").inputmask();
  },

  updateMask: function() {
    var tel = "#mobile";
    dig9 = this.$el.find(tel).val().substring(4, 5);
    ddd  = this.$el.find(tel).val().substring(1, 3);
    if(dig9 == "9" && ddd.match(/11|12|13|14|15|16|17|18|19|21|22|24|27|28/)){
      // $(tel).inputmask({mask:"(99)99999-9999"});
    } else {
      // $(tel).inputmask({mask:"(99)9999-9999"});
    }
  },

  load_state_cities: function(){
  new dgCidadesEstados({
    cidade: document.getElementById('city'),
    estado: document.getElementById('state')
  });
}
});
