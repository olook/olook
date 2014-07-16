app.models.CreditCard = Backbone.Model.extend({
  defaults: {
    full_name: '',
    number: '',
    expiration_date: '',
    security_code: '',
    cpf: '',
    flag: '',
    installment_number: ''
  },

  validate: function(attr) {
    errors = [];

    if (StringUtils.isEmpty(attr.full_name)) {
      errors.push({name: 'full_name', message: 'Qual é o nome?'});
    }
    
    if (StringUtils.isEmpty(attr.number)) {
      errors.push({name: 'number', message: 'Precisamos do seu número'});
    } // todo: fazer algoritmo de luhn (LOON|LUM)

    if (StringUtils.isEmpty(attr.security_code)) {
      errors.push({name: 'security_code', message: 'security_code?'});
    }

    if (StringUtils.isEmpty(attr.expiration_date)) {
      errors.push({name: 'expiration_date', message: 'Também precisamos do expiration_date'});
    }

    if (StringUtils.isEmpty(attr.cpf)) {
      errors.push({name: 'cpf', message: 'Também precisamos do CPF'});
    }

    // if (StringUtils.isEmpty(attr.flag)) {
    //   errors.push({name: 'flag', message: 'Qual é o seu flag, mesmo?'});
    // }

    // if (StringUtils.isEmpty(attr.telephone)) {
    //   errors.push({name: 'telephone', message: 'É bom termos o seu telefone. Qualquer coisa, ligamos'});
    // }


    return errors.length > 0 ? errors : false;
  }  
});
