app.views.RegisterForm = Backbone.View.extend({
  className: 'register',
  template: _.template($("#tpl-register").html() || ""),

  events: {
    "click .js-submit": "submit",
    submit: "submit"
  },

  submit: function(e) {
    e.preventDefault();

    var values = _.object(_.map($('.js-registrationForm').serializeArray(), function(item) {
      return [item.name, item.value]
    }));

    this.model = new app.models.User(values);

    var it = this;
    
    this.$el.find('p.error').remove()
    if(this.model.isValid()){
      this.model.save(values, {
        error: function(model, response) {
          it.renderError(JSON.parse(response.responseText));
        },
        success: function(model, response) {
          olookApp.publish('app:next_step');
        },

        wait: true // Add this
      });
    } else {
      this.renderError(this.model.errors);
    }

  },

  renderError: function(errors) {
    var it = this;
    _.each(errors, function(error, name) {
      var msg = error[0];
      var input = it.$el.find('[name=' + name + ']');
      if(input.length > 0) {
        var errorEl = input.next('.error');
        if(errorEl.length == 0){
          errorEl = $('<p class="error"></p>').insertAfter(input);
        }
        errorEl.html(msg);
      }
    });
  },

  render: function(obj) {
    var html = this.template();
    this.$el.html(html);
    FB.XFBML.parse(this.el);
  }


});
