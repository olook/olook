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
    "change #full_name, #number, #expiration_date, #security_code, #cpf" : "promptError",
    "keyup #full_name, #number, #expiration_date, #security_code, #cpf" : "updateData",
    "keyup #number" : "chooseFlag"
  },

  render: function(_model) {
    this.updateFromCart();
    var html = this.template({method: _model.attributes, details: this.model.attributes});
    this.$el.html(html);
    this.$el.show();
    CreditCard.populateInstallmentsFor(this.$el.find("#installments"), this.cart.get('total') , CreditCard.installmentsNumberFor(this.cart.get('total'), false));
    this.initMasks();
    this.updateData();
    this.cart.trigger('change:payment_data');
  },

  hide: function(){
    this.$el.hide();
  },

  updateFromCart: function(){
    this.model.set(this.cart.attributes.payment_data);
  },

  updateData: function(e) {
    this.populateModel();

    this.updateCreditCardOnCart();

    if (this.model.isValid() && e) {
      this.clearError(e.currentTarget.id);
    } 

    this.cart.set("payment_data", this.model.attributes);
    this.cart.trigger('change:payment_data');
  },

  populateModel: function(){
    var values = this.formatValues();
    values = this.setBank(values);
    this.model.set(values);
  },

  setBank: function(values){
    if(!StringUtils.isEmpty(values["number"])){
      _.extend(values, {bank: this.matchFlag(values["number"])});
    }
    return values;
  },

  updateCreditCardOnCart: function(e){
    if(!this.cart.credit_card){
      this.cart.credit_card = this.model;
    } else if(e){
      this.cart.credit_card.set(e.currentTarget.id,this.model.get(e.currentTarget.id));
    }
  },

  formatValues: function(){
    var formValues = $('.js-creditCardForm').serializeArray();
    return (_.object(_.map(formValues, function(item) {
       return [item.name, item.value]
    })));
  },
  
  promptError: function(e){
    if (!this.model.isValid()) {
      this.updateError(e.currentTarget);
    }
  },

  updateError: function(el) {
    this.clearError(el.id);
    this.showError(el.id);
  },

  clearError: function(element_id) {
    $(".control-group."+element_id).find('.help-inline').text('');
    $(".control-group."+element_id).removeClass('error');
    $(".control-group."+element_id).find('.help-inline').hide();
  },

  showError: function(field) {
    _.each(this.model.validationError, function (error) {
      if(error.name === field){
        var controlGroup = this.$('.' + error.name);
        controlGroup.addClass('error');
        controlGroup.find('.help-inline').text(error.message);
        controlGroup.find('.help-inline').show();
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
  },

  initMasks: function() {
    this.$el.find("#number").setMask('9999 9999 9999 9999');
    this.$el.find("#expiration_date").setMask('99/99');
    this.$el.find("#security_code").setMask('9999');
    this.$el.find("#cpf").setMask('999.999.999-99');    
  }

});
