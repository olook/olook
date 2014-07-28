//= require modules/login/views/identify
//= require modules/login/models/user
//= require modules/login/models/session

var LoginController = (function() {
  function LoginController() {
    this.identify = new app.views.Identify();
  };

  LoginController.prototype.config = function () {
    this.identify.render();
    this.identify.$el.appendTo("#main");
  };

  return LoginController;
})();
