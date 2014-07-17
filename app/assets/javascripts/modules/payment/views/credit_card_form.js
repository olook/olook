app.views.CreditCardForm = Backbone.View.extend({
  className: 'creditCardForm',
  template: _.template($("#tpl-credit-card-form").html() || ""),
  model: null,

  initialize: function() {
    olookApp.subscribe('payment:creditcard:show', this.render, {}, this);
    olookApp.subscribe('payment:creditcard:hide', this.hide, {}, this);
    this.model = new app.models.CreditCard();
  },

  events: {
    "blur #full_name, #number, #expiration_date, #security_code, #cpf" : "updateModel"
  },

  render: function() {
    var html = this.template(this.model);
    this.$el.html(html);
    this.$el.show();
  },

  hide: function(){
    this.$el.hide();
  },

  updateModel: function(e) {
    var formValues = $('.js-creditCardForm').serializeArray();
    var values = _.object(_.map(formValues, function(item) {
       return [item.name, item.value]
    }));
    
    this.model.set(values);

    olookApp.publish('checkout:payment:credit_card:update', this.model.attributes)

    if (this.model.isValid()) {
    } else {
      this.updateError(e.currentTarget);
    }
  },
  
  updateError: function(el) {
    this.clearError(el.id);
    this.showError(el.id);
  },

  clearError: function(element_id) {
    $(".control-group."+element_id).find('.help-inline').text('');
  },

  showError: function(field) {
    _.each(this.model.validationError, function (error) {
      if(error.name === field){
        var controlGroup = this.$('.' + error.name);
        controlGroup.addClass('error');
        controlGroup.find('.help-inline').text(error.message);        
      }
    }, this);
  },

});
