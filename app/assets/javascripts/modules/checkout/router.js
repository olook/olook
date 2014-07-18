app.routers.CheckoutRouter = Backbone.Router.extend({
  initialize: function(opts) {
    this.cart = opts['cart'];
  },
  stepsTranslation: {
    address: "endereco",
    payment: "pagamento",
    confirmation: "confirmacao",
  },
  routes: {
    "": "addressStep",
    "endereco": "addressStep",
    "pagamento": "paymentStep",
    "confirmacao": "confirmationStep",
  },
  start: function() {
    Backbone.history.start();
  },
  translateStep: function(step) {
    return this.stepsTranslation[step] || "";
  },
  addressStep: function() {
    this.cart.set("step", "address");
    if(!this.addressController){
      this.addressController = new AddressController({cart: this.cart});
      this.addressController.config();
    }
  },
  paymentStep: function() {
    this.cart.set("step", "payment");
  },
  confirmationStep: function() {
    this.cart.set("step", "confirmation");
  }
});
