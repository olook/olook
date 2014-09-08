app.views.Payments = Backbone.View.extend({
  template: _.template($('#tpl-payment-list').html()||""),
  className: 'payments',

  events: {
    'click .js-finishCheckout': 'finishCheckout',
    'click .js-back': 'back',
    "mouseover .Billet": "showDiscount",
    "mouseout .Billet": "hideDiscount",
  },

  initialize: function(opts) {
    this.cart = opts['cart'];
    this.collection.on('add', this.addOne, this);
    this.collection.on('reset', this.addAll, this);
    this.collection.on('payment:selected', this.paymentSelected, this);
    this.cart.on('change:payment_data', this.renderButton, this);
  },
  addOne: function(payment){
    var paymentView = new app.views.Payment({model: payment});
    this.paymentOptions.append(paymentView.render().el);

    var paymentMethod = this.cart.get('payment_method');
    if(paymentMethod == payment.attributes.type){ 
      paymentView.selectPayment();
    }
  },
  addAll: function(){
    this.collection.forEach(this.addOne, this);
  },
  remove: function() {
    Backbone.View.prototype.remove.apply(this, arguments); //super()
    this.paymentDetails.remove();
  },
  render: function(){
    this.$el.html(this.template({}));
    this.paymentDetails = this.$el.find('.payment-details');
    this.selectedAddress = this.$el.find('.js-selectedAddress');
    this.paymentOptions = this.$el.find('.payment-options');

    this.addAll();
    this.renderButton();
  },

  paymentSelected: function(model) {
    this.$el.find('.selected').removeClass('selected');
    olookApp.publish('payment:selected', model);
  }, 

  finishCheckout: function(e) {
    eventTracker.trackEvent("BackboneCheckout", "Finish", this.cart.get("payment_method"));
    e.preventDefault();
    olookApp.publish('app:next_step');
  },

  back: function(e) {
    eventTracker.trackEvent("BackboneCheckout", "BackToAddress");
    olookApp.publish('app:addressStep');
  },

  renderButton: function() {
    if(this.cart.stepValid()){
      this.$el.find(".js-finishCheckout").removeClass("disabled");
    } else if(!$(".js-finishCheckout").hasClass("disabled")){
      $(".js-finishCheckout").addClass("disabled");
    }
  },

  showDiscount: function(e){
    this.$el.find(".billet-discount").fadeIn();
  },

  hideDiscount: function(e){
    this.$el.find(".billet-discount").fadeOut();
  }


});
