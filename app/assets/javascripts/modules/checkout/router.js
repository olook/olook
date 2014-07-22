app.routers.CheckoutRouter = Backbone.Router.extend({
  initialize: function(opts) {
    this.cart = opts['cart'];
    this.cart.on('sync', this.checkStep, this);
  },
  stepsTranslation: {
    address: "endereco",
    payment: "pagamento",
    confirmation: "confirmacao",
  },
  routes: {
    "login": "loginStep",
    "endereco": "addressStep",
    "pagamento": "paymentStep",
    "confirmacao": "confirmationStep",
  },
  start: function() {
    Backbone.history.start();
    this.cart.fetch();
  },
  translateStep: function(step) {
    return this.stepsTranslation[step] || "";
  },
  checkStep: function() {
    var userId = this.cart.get('user_id');
    if (userId) {
      this.addressStep();
    } else {
      this.loginStep();
    }
  },
  loginStep: function() {
    this.cart.set("step", "login");
    if(!this.loginController){
      this.loginController = new LoginController({cart: this.cart});
      this.loginController.config();
    }
  },
  addressStep: function() {
    this.cart.set("step", "address");
    this.initializeCartResume();
    if(!this.addressController){
      this.addressController = new AddressController({cart: this.cart});
      this.addressController.config();
    }
  },
  paymentStep: function() {
    this.cart.set("step", "payment");
    this.initializeCartResume();
  },
  confirmationStep: function() {
    this.cart.set("step", "confirmation");
    this.initializeCartResume();
  },
  initializeCartResume: function() {
    if(this.cartResume) return;
    this.cartResume = new CartResumeController({cart: this.cart});
    this.cartResume.config();
  },
});
