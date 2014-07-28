app.views.LoginForm = Backbone.View.extend({
  className: 'login_user',
  template: _.template($("#tpl-login").html() || ""),

  events: {
    submit: "submit",
    "click .js-submit": "submit"
  },

  submit: function(e) {
    e.preventDefault();

    var values = _.object(_.map(this.$el('.js-loginForm').serializeArray(), function(item) {
      return [item.name, item.value]
    }));

    new app.models.Session().create(values, {
      error: function(model, response) {
        var errors = JSON.parse(response.responseText).errors;
        // TODO: Exibir feedback de erros
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
