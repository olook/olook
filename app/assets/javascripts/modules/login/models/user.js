app.models.User = Backbone.Model.extend({
  urlRoot: app.server_api_prefix + '/users',

  defaults: {
    first_name: '',
    last_name: '',
    email: '',
    password: '',
    name: ''
  },

  validate: function(attr) {
    errors = [];

    if (StringUtils.isEmpty(attr.name)) {
      errors.push({name: 'name', message: 'Precisamos saber o seu nome completo'});
    }
    
    if (StringUtils.isEmpty(attr.email)) {
      errors.push({name: 'email', message: 'Qual é o seu email, mesmo?'});
    }
    
    if (StringUtils.isEmpty(attr.password)) {
      errors.push({name: 'password', message: 'Por favor, digite uma senha com 6 dígitos'});
    }

    return errors.length > 0 ? errors : false;
  },

  initialize: function(values) {
    this.on('change:name', this.setFirstAndLastNames);
  },

  setFirstAndLastNames: function(a) {
    var names = this.get('name').split(" ");
    this.set('first_name', names.shift());
    this.set('last_name', names.join(" "));
  }

});