app.models.CreditCard = Backbone.Model.extend({
  defaults: {
    bank: '',
    full_name: '',
    number: '',
    expiration_date: '',
    security_code: '',
    cpf: '',
    installment_number: ''
  },

  validate: function(attr) {
    errors = [];

    if (StringUtils.isEmpty(attr.full_name)) {
      errors.push({name: 'full_name', message: 'Digite o nome como impresso no cartão'});
    }
    
    if (StringUtils.isEmpty(attr.number)) {
      errors.push({name: 'number', message: 'Digite o número do cartão'});
    } else {
      luhn = this.validateCardnumber(attr.number)
      if(luhn == false){
        errors.push({name: 'number', message: 'Por favor, confira o número'});
      }
    }

    if (StringUtils.isEmpty(attr.security_code)) {
      errors.push({name: 'security_code', message: 'Digite o código de segurança'});
    } else if(!this.validateSecurityCode(attr.security_code)) {
      errors.push({name: 'security_code', message: 'Por favor, confira o cód. de segurança'});
    }

    if (StringUtils.isEmpty(attr.expiration_date)) {
      errors.push({name: 'expiration_date', message: 'Digite a data de validade'});
    }

    if (StringUtils.isEmpty(attr.expiration_date) || !this.validateExpirationDate(attr.expiration_date)) {
      errors.push({name: 'expiration_date', message: 'Por favor, confira a data de validade'});
    }

    if (StringUtils.isEmpty(attr.cpf)) {
      errors.push({name: 'cpf', message: 'Precisamos do CPF do titular'});
    } else if(!this.validateCpf(attr.cpf)){
      errors.push({name: 'cpf', message: 'Por favor, confira o CPF'});
    }

    return errors.length > 0 ? errors : false;
  },

  validateExpirationDate: function(expiration_date){
    return((/^((0[0-9])|1[0-2])\/\d{2}$/).test(expiration_date));
  },

  validateSecurityCode: function(security_code){
    return((/^\d{3,4}$/).test(security_code));
  },

  validateCpf: function(cpf){
    return((/^\d{11}$/).test(cpf.replace(/[ .-]/g, "")));
  },

  validateCardnumber: function(cardnumber) {
    if (!/^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$/g.test(cardnumber.replace(/[ ,-]/g, ""))) return false;
    return this.luhn(cardnumber);
  },
  luhn: function(cardnumber) {
    var getdigits = /\d/g;
    var digits = [];
    var match;

    while (match = getdigits.exec(cardnumber)) {
      digits.push(parseInt(match[0], 10));
    }
    var sum = 0;
    var alt = false;
    for (var i = digits.length - 1; i >= 0; i--) {
      if (alt) {
        digits[i] *= 2;
        if (digits[i] > 9) {
          digits[i] -= 9;
        }
      }
      sum += digits[i];
      alt = !alt;
    }
    if (sum % 10 == 0) {
      return true;
    } else {
      return false;
    }
  }
});
