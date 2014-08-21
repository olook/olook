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



$(document).ready(function() {
  states_and_cities.load_state_cities();

  $("#wholesale").click(function (e){
    e.preventDefault();
    $("html, body").delay(200).animate({scrollTop: $('#new_wholesale').offset().top - 100}, 1000)
  });
});


