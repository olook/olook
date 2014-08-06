//= require modules/payment/models/payment
//= require modules/payment/models/credit_card
//= require modules/payment/collections/payments
//= require modules/payment/views/payment
//= require modules/payment/views/payments
//= require modules/payment/views/credit_card_form
//= require modules/payment/views/billet
//= require modules/payment/views/debit
//= require modules/payment/views/mercadopago

var PaymentController = (function(){
  function PaymentController(opts){
    this.cart = opts['cart'];
    this.payments = new app.collections.Payments();
    this.paymentsView = new app.views.Payments({collection: this.payments, cart: this.cart});
    this.creditCardFormView = new app.views.CreditCardForm({collection: this.payments, cart: this.cart});
    this.debitView = new app.views.Debit({collection: this.payments, cart: this.cart});
    this.billetView = new app.views.Billet({collection: this.payments, cart: this.cart});
    this.mercadoPagoView = new app.views.MercadoPago({collection: this.payments, cart: this.cart});
  };

  PaymentController.prototype.config = function(){
    this.paymentsView.$el.appendTo(app.content);
    this.creditCardFormView.$el.appendTo(this.paymentsView.paymentDetails);
    this.debitView.$el.appendTo(this.paymentsView.paymentDetails);
    this.billetView.$el.appendTo(this.paymentsView.paymentDetails);
    this.mercadoPagoView.$el.appendTo(this.paymentsView.paymentDetails);
    this.paymentsView.render();
    this.payments.fetch();

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
        case 'MercadoPagoPayment':
          olookApp.publish('payment:mercadopago:show', model);
          break;
      }
      olookApp.publish('checkout:payment_type', model);
    });

    $("#submit").click(function(){
      olookApp.publish('app:next_step');
    });
  };

  return PaymentController;
})();

