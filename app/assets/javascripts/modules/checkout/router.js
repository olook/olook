app.routers.CheckoutRouter = Backbone.Router.extend({
  initialize: function(opts) {
    this.session = opts['session'];
    this.session.on('sync', this.checkStep, this);
    this.cart = opts['cart'];
  },
  stepsTranslation: {
    login: "login",
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
    this.session.fetch();
  },
  translateStep: function(step) {
    return this.stepsTranslation[step] || "";
  },
  checkStep: function() {
    Backbone.history.start();
    var userId = this.session.id;
    if (userId) {
      this.navigate("endereco", {trigger: true});
    } else {
      this.navigate("login", {trigger: true});
    }
  },
  loginStep: function() {
    $(".cart_resume").remove();
    $("#address").remove();
    this.cart.set("step", "login");
    if(!this.loginController){
      this.facebookAuth = new FacebookAuth();
      this.facebookAuth.config();
      this.loginController = new LoginController({cart: this.cart});
      this.loginController.config();
    }
  },
  addressStep: function() {
    $(".login").remove();
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
  hideSteps: function() {
    if(this.loginController) {
      this.loginController.remove();
      delete this.loginController;
    }
  },
  initializeCartResume: function() {
    if(this.cartResume) return;
    this.cartResume = new CartResumeController({cart: this.cart});
    this.cartResume.config();
  },
});
