//= require modules/login/views/login_form
//= require modules/login/views/register_form
app.views.Identify = Backbone.View.extend({
  className: 'login',
  template: _.template($("#tpl-loginfb").html() || ""),
  model: app.models.User,

  initialize: function() {
    this.model = new app.models.User();
    this.loginForm = new app.views.LoginForm();
    this.registerForm = new app.views.RegisterForm();
  },

  render: function() {
    this.$el.html(this.template());
    FB.XFBML.parse(this.el);

    this.loginForm.render();
    this.$el.append(this.loginForm.el);
    this.registerForm.render();
    this.$el.append(this.registerForm.el);
  }


});
