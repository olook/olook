app.models.Debit = Backbone.Model.extend({
  validate: function(attr) {
    errors = [];

    if (StringUtils.isEmpty(attr.bank)) {
      errors.push({name: 'bank', message: 'Selecione o seu banco'});
    }

    return errors.length > 0 ? errors : false;
  },
});
