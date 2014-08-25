//= require plugins/cep
//= require state_cities
//= require plugins/jquery.meio.mask

if(!states_and_cities) var states_and_cities = {};

states_and_cities.load_state_cities = function(){
  new dgCidadesEstados({
    cidade: document.getElementById('wholesale_city'),
    estado: document.getElementById('wholesale_state'),

  });
}

function maskTel(tel){
  dig9 = $(tel).val().substring(5, 6);
  ddd  = $(tel).val().substring(1, 3);
  if(dig9 == "9" && ddd.match(/11|12|13|14|15|16|17|18|19|21|22|24|27|28/)){
    $(tel).setMask("(99) 99999-9999");
  } else {
    $(tel).setMask("(99) 9999-9999");
  }
}

$(document).ready(function() {
  states_and_cities.load_state_cities();
  $('#wholesale_cnpj').setMask("99.999.999/9999-99");
  $('#wholesale_zip_code').setMask("99999-999");
  $('#wholesale_telephone').keyup(function(){
      maskTel($(this));
  });
  $('#wholesale_cellphone').keyup(function(){
      maskTel($(this));
  });
  olook.cep('.zip_code', {
    estado: '#wholesale_state',
    cidade: '#wholesale_city',
    rua: '#wholesale_address',
    bairro: '#wholesale_neighborhood',
    applyHtmlTag: false,
    afterSuccess: function(){
      $("#wholesale_zip_code").removeClass("input_error").next().hide();
      $("#wholesale_address").removeClass("input_error").next().hide();
      $("#wholesale_neighborhood").removeClass("input_error").next().hide();
      $("#wholesale_state").parent().removeClass("input_error").next().hide();
      $("#wholesale_city").parent().removeClass("input_error").next().hide();
    },
    afterFail: function(){
      new dgCidadesEstados({
        cidade: document.getElementById('wholesale_city'),
        estado: document.getElementById('wholesale_state')
      });
    }
  });
});
