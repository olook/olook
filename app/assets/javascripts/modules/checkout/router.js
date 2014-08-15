app.routers.CheckoutRouter = Backbone.Router.extend({
  initialize: function(opts) {
    this.session = opts['session'];
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
    var it = this;
    this.session.fetch({success: function() {
      it.startCart();
    }});
  },
  startCart: function() {
    var it = this;
    this.cart.fetch({success: function(cart) {

      if (cart.isEmpty()) {
        window.location = '/sacola';
      } else {
        it.checkStep();
      }

    }});
  },
  translateStep: function(step) {
    return this.stepsTranslation[step] || "";
  },
  checkStep: function() {
    var userId = this.session.id;
    Backbone.history.start({ root: "/beta/index" });
    if (userId) {
      var currentRoute = this.routes[Backbone.history.fragment];
      if(!currentRoute) {
        this.navigate("endereco", {trigger: true});
      }
    } else {
      this.navigate("login", {trigger: true});
    }
  },
  loginStep: function() {
    this.hideSteps();
    this.cart.set("step", "login");
    if(!this.loginController){
      this.facebookAuth = new FacebookAuth();
      this.facebookAuth.config();
      this.loginController = new LoginController({cart: this.cart});
    }
    this.loginController.config();
  },
  addressStep: function() {
    this.hideSteps();
    this.cart.set("step", "address");
    this.initializeCartResume();
    if(!this.addressController){
      this.addressController = new AddressController({cart: this.cart});
    }
    this.addressController.config();
  },
  paymentStep: function() {
    if(!this.cart.addressStepValid()){
      this.navigate("endereco", {trigger: true});
      return;
    }
    this.hideSteps();
    this.cart.set("step", "payment");
    this.initializeCartResume();
    if(!this.paymentController){
      this.paymentController = new PaymentController({cart: this.cart});
    }
    this.initializeCartResume();
    this.paymentController.config();
  },
  confirmationStep: function() {
    olookApp.publish("checkout:finish", this.cart);
  },
  hideSteps: function() {
    if(this.cartResume) {
      this.cartResume.remove();
      delete this.cartResume;
    }
    if(this.loginController) {
      this.loginController.remove();
      delete this.loginController;
    }
    if(this.addressController) {
      this.addressController.remove();
      delete this.addressController;
    }
    if(this.paymentController) {
      this.paymentController.remove();
      delete this.paymentController;
    }
  },
  initializeCartResume: function() {
    if(this.cartResume) return;
    this.cartResume = new CartResumeController({cart: this.cart});
    this.cartResume.config();
  },
});
