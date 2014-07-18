app.views.loginForm = Backbone.View.extend({

  el: $(".login"),
  template: _.template($("#tpl-login").html() || ""),
  model: app.models.User,

  initialize: function() {

    this.on('invalid', function(model, error){
      debugger;
    });

  },

  events: {
    "click .js-submit": "submit"
  },

  submit: function(e) {
    e.preventDefault();

    var values = _.object(_.map($('.js-registrationForm').serializeArray(), function(item) {
      return [item.name, item.value]
    }));

    this.model = new app.models.User(values);
    if (this.model.isValid()) {
      this.model.save();
    } else {
      console.log('show errors');
    }


    // $.post('/api/v1/users', values).done(function(data) {
    //     window.location = '/beta/index';
    // }).fail(function(data){
    //   alert('TODO: exibir os erros');
    // });    
  },

  render: function(obj) {
    var html = this.template();
    this.$el.html(html);
  }  


});