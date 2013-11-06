//= require plugins/cep
//= require state_cities
//= require plugins/jquery.meio.mask

if(!states_and_cities) var states_and_cities = {};

states_and_cities.load_state_cities = function(){
  new dgCidadesEstados({
    cidade: document.getElementById('reseller_addresses_attributes_0_city'),
    estadoVal: resellerState,
    estado: document.getElementById('reseller_addresses_attributes_0_state'),
    cidadeVal: resellerCity
  });
}

function changeResellerType(){
  var common = $('#reseller_has_corporate_0');
  var corporate = $('#reseller_has_corporate_1');
  var cpf = $("li.cpf");
  var cnpj = $("li.cnpj");
  var corporate_name = $("li.corporate_name");
  if(corporate.attr("checked")) {
    cpf.hide();
    cnpj.show();
    corporate_name.show();
  }else{
    cpf.show();
    cnpj.hide();
    corporate_name.hide();
  }
  common.change(function(){
    cpf.show();
    cnpj.hide();
    corporate_name.hide();
  });
  corporate.change(function(){
    cpf.hide();
    cnpj.show();
    corporate_name.show();
  });
};

$(document).ready(function() {
  states_and_cities.load_state_cities();
  changeResellerType();
  $('#reseller_cpf').setMask("999.999.999-99");
  $('#reseller_cnpj').setMask("99.999.999/9999-99");
  $('#reseller_birthday').setMask("99/99/9999");
  $('#reseller_addresses_attributes_0_zip_code').setMask("99999-999");
  $('#reseller_addresses_attributes_0_number').setMask("999999999");
  
  olook.cep('.zip_code', {
    estado: '#reseller_addresses_attributes_0_state',
    cidade: '#reseller_addresses_attributes_0_city',
    rua: '#reseller_addresses_attributes_0_street',
    bairro: '#reseller_addresses_attributes_0_neighborhood',
    applyHtmlTag: false,
    afterSuccess: function(){
      $("#reseller_addresses_attributes_0_number").val("");
      $("#reseller_addresses_attributes_0_zip_code").removeClass("input_error").next().hide();
      $("#reseller_addresses_attributes_0_street").removeClass("input_error").next().hide();
      $("#reseller_addresses_attributes_0_neighborhood").removeClass("input_error").next().hide();
      $("#reseller_addresses_attributes_0_state").parent().removeClass("input_error").next().hide();
      $("#reseller_addresses_attributes_0_city").parent().removeClass("input_error").next().hide();
    },
    afterFail: function(){
      new dgCidadesEstados({
        cidade: document.getElementById('reseller_addresses_attributes_0_city'),
        estado: document.getElementById('reseller_addresses_attributes_0_state')
      });
    }
  });
});

