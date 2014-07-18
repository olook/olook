app.models.User = Backbone.Model.extend({
  urlRoot: app.server_api_prefix + '/users',

  defaults: {
    first_name: '',
    last_name: '',
    email: '',
    password: ''
  },

  validate: function(attr) {
    errors = [];

    if (StringUtils.isEmpty(attr.email)) {
      errors.push({name: 'email', message: 'Qual é o seu email, mesmo?'});
    }
    
    if (StringUtils.isEmpty(attr.password)) {
      errors.push({name: 'password', message: 'Por favor, digite uma senha'});
    }

    return errors;
  },

  initialize: function(values) {
    var names = values.name.split(" ");
    this.set('first_name', names.shift());
    this.set('last_name', names.join(" "));
  }

});