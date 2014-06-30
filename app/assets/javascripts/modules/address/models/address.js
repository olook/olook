/**
 * Represents an Address
 */
app.models.Address = Backbone.Model.extend({

  defaults: {
    state: 'BRA'
  },

  /**
   * Cidade e cep sao obrigatorios
   * @param  {[hash]} attr
   * @return {[boolean]} false is is valid, a hash otherwise
   */
  validate: function(attr) {
    errors = [];

    if (!attr.city) {
      errors.push({name: 'city', message: 'Cidade é obrigatória'});
    }
    
    if (!attr.zip_code) {
      errors.push({name: 'zip_code', message: 'CEP é obrigatório'});
    }

    return errors.length > 0 ? errors : false;
  }
});