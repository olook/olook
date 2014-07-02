/**
 * Represents an Address
 */
app.models.Address = Backbone.Model.extend({
  urlRoot: '/api/v1/addresses',
  defaults: {
    country: 'BRA',
    zip_code: '',
    street: '',
    state: '',
    city: '',
    number: '',
    neighborhood: '',
    telephone: ''
  },

  /**
   * Cidade e cep sao obrigatorios
   * @param  {[hash]} attr
   * @return {[boolean]} false is is valid, a hash otherwise
   */
  validate: function(attr) {
    errors = [];

    if (StringUtils.isEmpty(attr.city)) {
      errors.push({name: 'city', message: 'Cidade é obrigatória'});
    }
    
    if (StringUtils.isEmpty(attr.zip_code)) {
      errors.push({name: 'zip_code', message: 'CEP é obrigatório'});
    }

    return errors.length > 0 ? errors : false;
  }
});