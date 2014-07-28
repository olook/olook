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
    olookApp.subscribe('fb:auth:before', this.showLoading, {}, this);
    olookApp.subscribe('fb:auth:complete', this.hideLoading, {}, this);
  },

  showLoading: function() {
    this.loading = $(_.template($('#tpl-loading').html())());
    $('body').prepend(this.loading);
    this.loading.css({
      width: '100%',
      height: '100%',
      position: 'fixed',
      background: '#fff',
      opacity: '0.7',
      textAlign: 'center',
      zIndex: '1000',
      verticalAlign: 'middle',
    });
    this.loading.find('*:first').css({
      position: 'fixed',
      top: '50%',
      left: '50%',
      zIndex: '1001'
    });
  },

  hideLoading: function() {
    var load = this.loading;
    this.loading.fadeOut(function() {
      load.remove();
    });
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
