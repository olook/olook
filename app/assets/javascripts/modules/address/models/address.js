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
    full_name: '',
    mobile: ''
  },

  /**
   * Cidade e cep sao obrigatorios
   * @param  {[hash]} attr
   * @return {[boolean]} false is is valid, a hash otherwise
   */
  validate: function(attr) {
    errors = [];

    if (StringUtils.isEmpty(attr.zip_code) || !attr.zip_code.match(/\d{5}-\d{3}/g)) {
      errors.push({name: 'zip_code', message: 'Precisamos do seu CEP'});
    }

    if (StringUtils.isEmpty(attr.state)) {
      errors.push({name: 'state', message: 'Precisamos da sigla do estado (UF)'});
    }

    if (StringUtils.isEmpty(attr.city)) {
      errors.push({name: 'city', message: 'Qual é o nome da cidade, mesmo?'});
    }

    if (StringUtils.isEmpty(attr.street)) {
      errors.push({name: 'street', message: 'Precisamos do seu endereço completo'});
    }

    if (StringUtils.isEmpty(attr.number)) {
      errors.push({name: 'number', message: 'Precisamos do seu endereço completo'});
    }

    if (StringUtils.isEmpty(attr.neighborhood)) {
      errors.push({name: 'neighborhood', message: 'Qual é o seu bairro, mesmo?'});
    }

    if (StringUtils.isEmpty(attr.telephone) || !attr.telephone.match(/\((10)|([1-9][1-9])\)[2-9][0-9]{3}-[0-9]{4}/g)) {
      errors.push({name: 'telephone', message: 'Preencha seu telefone corretamente'});
    }

    if (!StringUtils.isEmpty(attr.mobile) && !attr.mobile.match(/\((10)|([1-9][1-9])\)9{0,1}[2-9][0-9]{3}-[0-9]{4}/g)) {
      errors.push({name: 'mobile', message: 'Preencha seu celular corretamente'});
    }

    return errors.length > 0 ? errors : false;
  }
  
});
