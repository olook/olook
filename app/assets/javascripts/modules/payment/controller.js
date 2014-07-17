//= require modules/payment/models/payment
//= require modules/payment/models/credit_card
//= require modules/payment/collections/payments
//= require modules/payment/views/payment
//= require modules/payment/views/payments
//= require modules/payment/views/credit_card_form
//= require modules/payment/views/billet
//= require modules/payment/views/debit
//= require modules/payment/views/mercadopago
//= require modules/payment/mock/checkout

var PaymentController = (function(){
  function PaymentController(){
    this.payments = new app.collections.Payments();
    this.paymentsView = new app.views.Payments({collection: this.payments});
    this.creditCardFormView = new app.views.CreditCardForm({collection: this.payments});
    this.debitView = new app.views.Debit({collection: this.payments});
    this.billetView = new app.views.Billet({collection: this.payments});
    this.mercadoPagoView = new app.views.MercadoPago({collection: this.payments});
  };

  PaymentController.prototype.config = function(){
    this.paymentsView.$el.appendTo(app.content);
    this.creditCardFormView.$el.appendTo(app.content);
    this.debitView.$el.appendTo(app.content);
    this.billetView.$el.appendTo(app.content);
    this.mercadoPagoView.$el.appendTo(app.content);
    this.paymentsView.render();
    this.payments.fetch();

    $("#submit").click(function(){
      console.log("clicked");
    });
  };
  return PaymentController;
})();

olookApp.subscribe('app:init', function(){
  new PaymentController().config();
});

olookApp.subscribe('payment:selected', function(model) {
  olookApp.publish('payment:creditcard:hide');
  olookApp.publish('payment:debit:hide');
  olookApp.publish('payment:billet:hide');
  olookApp.publish('payment:mercadopago:hide');
  switch(model.get('type')){
    case 'CreditCard':
      olookApp.publish('payment:creditcard:show', model);
      break;
    case 'Debit':
      olookApp.publish('payment:debit:show', model);
      break;
    case 'Billet':
      olookApp.publish('payment:billet:show', model);
      break;
    case 'MercadoPago':
      olookApp.publish('payment:mercadopago:show', model);
      break;
  }
  olookApp.publish('checkout:payment_type', model);
});
