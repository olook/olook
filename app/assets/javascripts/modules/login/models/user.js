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
    this.errors = {};

    if (StringUtils.isEmpty(attr.name)) {
      this.errors.name = ['Precisamos saber o seu nome completo'];
    }

    var names = attr.name.split(' ');
    if(names.length < 2) {
      this.errors.name = ['Precisamos saber o seu nome completo'];
    }

    if (StringUtils.isEmpty(attr.email)) {
      this.errors.email = ['Qual é o seu email, mesmo?'];
    }

    if (StringUtils.isEmpty(attr.password)) {
      this.errors.password = ['Por favor, digite uma senha com 6 dígitos'];
    }

    for (var key in this.errors) {
      if (hasOwnProperty.call(this.errors, key)) return this.errors;
    }

    return false;
  },

  initialize: function(values) {
    this.on('change:name', this.setFirstAndLastNames);
  },

  toJSON: function() {
    var names = this.get('name').split(' ');
    return { user: _.extend(_.pick(this.attributes, ['email', 'password']), {
      first_name: names.shift(),
      last_name: names.join(' '),
    }) };
  },

});
