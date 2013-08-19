//= require state_cities

if(!states_and_cities) var states_and_cities = {};

states_and_cities.load_state_cities = function(){
  new dgCidadesEstados({
    cidade: document.getElementById('checkout_address_city'),
    estado: document.getElementById('checkout_address_state')
  });
}

states_and_cities.load_state_cities();
