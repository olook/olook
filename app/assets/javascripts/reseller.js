//= require state_cities
//= require plugins/jquery.meio.mask

if(!states_and_cities) var states_and_cities = {};

states_and_cities.load_state_cities = function(){
  new dgCidadesEstados({
    cidade: document.getElementById('reseller_addresses_city'),
    estado: document.getElementById('reseller_addresses_state')
  });
}

function changeResellerType(){
  var common = $('#reseller_has_corporate_0');
  var corporate = $('#reseller_has_corporate_1');
  var common_fieldset = $("fieldset.common")
  var corporate_fieldset = $("fieldset.corporate")
  if(corporate.attr("checked")) {
    common_fieldset.hide();
    corporate_fieldset.show();
  }else{
    common_fieldset.show();
    corporate_fieldset.hide();
  }
  common.change(function(){
    common_fieldset.show();
    corporate_fieldset.hide();
  });
  corporate.change(function(){
    common_fieldset.hide();
    corporate_fieldset.show();
  });
};

$(function() {
  states_and_cities.load_state_cities();
  changeResellerType();
  $('#reseller_cpf').setMask("999.999.999-99");
});
