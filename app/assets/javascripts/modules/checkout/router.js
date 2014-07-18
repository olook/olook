app.routers.CheckoutRouter = Backbone.Router.extend({
  initialize: function(opts) {
    this.cart = opts['cart'];
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
  addressStep: function() {
    this.cart.set("step", "address");
    this.controller = new AddressController({cart: this.cart}).config();
  },
  paymentStep: function() {
    console.log("payment");
    this.cart.set("step", "payment");
  },
  confirmationStep: function() {
    console.log("confirmation");
    this.cart.set("step", "confirmation");
  }
});
