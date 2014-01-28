//= require state_cities
//= require plugins/cep
//= require plugins/jquery.meio.mask.js

if(!states_and_cities) var states_and_cities = {};

states_and_cities.load_state_cities = function(){
  new dgCidadesEstados({
    cidade: document.getElementById('address_city'),
    estado: document.getElementById('address_state')
  });
}

function maskTel(tel){
  dig9 = $(tel).val().substring(4, 5);
  ddd  = $(tel).val().substring(1, 3);

  if(dig9 == "9" && ddd.match(/11|12|13|14|15|16|17|18|19|21|22|24|27|28/)){
    $(tel).setMask("(99)99999-9999");
  } else {
    $(tel).setMask("(99)9999-9999");
  }
}

$(function() {
  olook.cep('.zip_code', {
    estado: '#address_state',
    cidade: '#address_city',
    rua: '#address_street',
    bairro: '#address_neighborhood',
    applyHtmlTag: true,
    afterFail: function(){
      new dgCidadesEstados({
        cidade: document.getElementById(context.cidade.replace('#', '')),
        estado: document.getElementById(context.estado.replace('#', ''))
      });
    }
  });
  states_and_cities.load_state_cities();
  maskTel($("#address_telephone"));
  $("#address_telephone").keyup(function(){
    maskTel($("#address_telephone"));
  });;
  maskTel($("#address_mobile"));
  $("#address_mobile").keyup(function(){
      maskTel($("#address_mobile"));
  });;
});
