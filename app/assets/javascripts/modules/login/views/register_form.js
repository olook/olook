app.views.RegisterForm = Backbone.View.extend({
  className: 'register',
  template: _.template($("#tpl-register").html() || ""),
  model: app.models.User,

  initialize: function() {
    this.model = new app.models.User();
  },

  events: {
    "click .js-submit": "submit"
  },

  submit: function(e) {
    e.preventDefault();

    var values = _.object(_.map($('.js-registrationForm').serializeArray(), function(item) {
      return [item.name, item.value]
    }));

    this.model.set(values);
    this.model.save({}, {
      error: function(model, response) {

        JSON.parse(response.responseText).errors
        // TODO: Exibir feedback de erros

      },
      success: function(model, response) {
        window.location = '/beta/index'
      },
      
      wait: true // Add this
    });
  
  },

  render: function(obj) {
    var html = this.template();
    this.$el.html(html);
    FB.XFBML.parse(this.el);
  }  


});
