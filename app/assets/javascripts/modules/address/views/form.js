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


    var formValues = $('.js-addressForm form').serializeArray();
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
  },

  initMask: function() {
    $(":input").inputmask();
  },

  updateMask: function() {
    var tel = "#mobile";
    dig9 = $(tel).val().substring(4, 5);
    ddd  = $(tel).val().substring(1, 3);
    if(dig9 == "9" && ddd.match(/11|12|13|14|15|16|17|18|19|21|22|24|27|28/)){
      // $(tel).inputmask({mask:"(99)99999-9999"});
    } else {
      // $(tel).inputmask({mask:"(99)9999-9999"});
    }    
    // console.log(this.model.attributes.mobile);
  }
});
