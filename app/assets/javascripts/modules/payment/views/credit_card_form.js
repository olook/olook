//= require credit_card
app.views.CreditCardForm = Backbone.View.extend({
  className: 'creditCardForm',
  template: _.template($("#tpl-credit-card-form").html() || ""),
  model: null,

  initialize: function(opts) {
    this.cart = opts['cart'];
    olookApp.subscribe('payment:creditcard:show', this.render, {}, this);
    olookApp.subscribe('payment:creditcard:hide', this.hide, {}, this);
    this.model = new app.models.CreditCard();
  },

  events: {
    "blur #full_name, #number, #expiration_date, #security_code, #cpf" : "updateModel",
    "keyup #number" : "chooseFlag"
  },

  render: function(_model) {
    var html = this.template(_model.attributes);
    this.$el.html(html);
    this.$el.show();
    CreditCard.populateInstallmentsFor(this.$el.find("#installments"), this.cart.get('total') , CreditCard.installmentsNumberFor(this.cart.get('total'), false));
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
    this.cart.credit_card =  this.model;
    if (this.model.isValid()) {
      this.cart.set("payment_data", JSON.stringify(this.model.attributes));
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

  chooseFlag: function(number_element){
    var number = $(number_element.currentTarget).val();
    var flagClass = this.matchFlag(number)
    this.$('.flags span').removeClass('enabled');
    if(flagClass != null){
      this.$('.flags span.'+flagClass).addClass('enabled');
    }
  },

  matchFlag: function(number){
    if(/^4/.test(number)){
      return 'visa';
    } else if(/^5[1-5]/.test(number)){
      return 'mastercard';
    } else if(/^3(?:0[0-5]|[68][0-9])/.test(number)) {
      return 'diners';
    }
    return null;
  }

});
