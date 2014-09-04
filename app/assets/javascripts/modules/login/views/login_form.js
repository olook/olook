app.views.LoginForm = Backbone.View.extend({
  className: 'login_user',
  template: _.template($("#tpl-login").html() || ""),

  events: {
    submit: "submit",
    "click .js-submit": "submit"
  },

  submit: function(e) {
    e.preventDefault();

    eventTracker.trackEvent("BackboneCheckout", "login");

    var values = _.object(_.map(this.$el.find('.js-loginForm').serializeArray(), function(item) {
      return [item.name, item.value]
    }));

    var _this = this;

    new app.models.Session().save(values, {
      error: function(model, response) {
        var error = JSON.parse(response.responseText).error;
        if(!_this.$errorMsg){
          _this.$errorMsg = $('<span class="error"></span>');
          _this.$errorMsg.appendTo(_this.$el.find('p'));
        }
        _this.$errorMsg.html(error);
      },

      success: function(model, response) {
        olookApp.publish('app:next_step');
      },

      wait: true // wait server response to fire events on model
    });

  },

  render: function(obj) {
    this.$el.html(this.template());
  }


});
