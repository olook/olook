//= require modules/payment/models/payment
//= require modules/payment/models/credit_card
//= require modules/payment/models/debit
//= require modules/payment/collections/payments
//= require modules/payment/views/payment
//= require modules/payment/views/payments
//= require modules/payment/views/credit_card_form
//= require modules/payment/views/billet
//= require modules/payment/views/debit

var PaymentController = (function(){
  function PaymentController(opts){
    this.cart = opts['cart'];
    this.payments = new app.collections.Payments();
    this.paymentsView = new app.views.Payments({collection: this.payments, cart: this.cart});
    this.creditCardFormView = new app.views.CreditCardForm({collection: this.payments, cart: this.cart});
    this.debitView = new app.views.Debit({collection: this.payments, cart: this.cart});
    this.billetView = new app.views.Billet({collection: this.payments, cart: this.cart});

    this.selectedAddressView = new app.views.SelectedAddress();
  };

  PaymentController.prototype.remove = function(){
    this.paymentsView.remove();
    olookApp.mediator.remove('payment:selected', this.paymentSelected);
  };

  PaymentController.prototype.config = function(){
    this.paymentsView.$el.appendTo(app.content);
    this.paymentsView.render();

    this.creditCardFormView.$el.prependTo(this.paymentsView.paymentDetails);
    this.debitView.$el.prependTo(this.paymentsView.paymentDetails);
    this.billetView.$el.prependTo(this.paymentsView.paymentDetails);
    this.payments.fetch();
    olookApp.subscribe('payment:selected', this.paymentSelected, {}, this);
    this.cart.on("change:payment_method", this.showPaymentDetail, this);

    this.selectedAddressView.model = new app.models.Address(this.cart.get('address'));
    this.selectedAddressView.render();
    this.selectedAddressView.$el.appendTo(this.paymentsView.selectedAddress);
  };

  PaymentController.prototype.paymentSelected = function(model) {
    olookApp.publish('checkout:payment_type', model);
  };

  PaymentController.prototype.showPaymentDetail = function(model){
    var model = this.payments.findByPaymentMethod(this.cart.get("payment_method"));
    switch(this.cart.get('payment_method')){
      case 'CreditCard':
        this.cart.attributes.payment_data["number"] = "";
        this.cart.attributes.payment_data["expiration_date"] = "";
        this.cart.attributes.payment_data["security_code"] = "";

        olookApp.publish('payment:creditcard:show', model );
      break;
      case 'Debit':
        this.cart.debit = null;
        olookApp.publish('payment:debit:show', model);
      break;
      case 'Billet':
        olookApp.publish('payment:billet:show', model);
      break;
    }
  };

  return PaymentController;
})();

