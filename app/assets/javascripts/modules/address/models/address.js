/**
 * Represents an Address
 */
app.models.Address = Backbone.Model.extend({
  urlRoot: app.server_api_prefix + '/addresses',
  defaults: {
    country: 'BRA',
    zip_code: '',
    street: '',
    state: '',
    city: '',
    number: '',
    neighborhood: '',
    telephone: '',
    complement: '',
    full_name: ''
  },

  /**
   * Cidade e cep sao obrigatorios
   * @param  {[hash]} attr
   * @return {[boolean]} false is is valid, a hash otherwise
   */
  validate: function(attr) {
    errors = [];

    if (StringUtils.isEmpty(attr.city)) {
      errors.push({name: 'city', message: 'Qual é o nome da cidade, mesmo?'});
    }
    
    if (StringUtils.isEmpty(attr.zip_code)) {
      errors.push({name: 'zip_code', message: 'Precisamos do seu CEP'});
    }

    if (StringUtils.isEmpty(attr.street)) {
      errors.push({name: 'street', message: 'Onde devemos entregar? Selecione um endereço'});
    }

    if (StringUtils.isEmpty(attr.number)) {
      errors.push({name: 'number', message: 'Também precisamos do número'});
    }

    if (StringUtils.isEmpty(attr.state)) {
      errors.push({name: 'state', message: 'Também precisamos da sigla do estado (UF)'});
    }

    if (StringUtils.isEmpty(attr.neighborhood)) {
      errors.push({name: 'neighborhood', message: 'Qual é o seu bairro, mesmo?'});
    }

    if (StringUtils.isEmpty(attr.telephone)) {
      errors.push({name: 'telephone', message: 'É bom termos o seu telefone. Qualquer coisa, ligamos'});
    }


    return errors.length > 0 ? errors : false;
  }
});
