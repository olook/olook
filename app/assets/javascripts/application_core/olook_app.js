//= require mediator
//= require_self
//= require application_core/scroll_events
//= require string_utils

/* A classe-namespace. Objetos desta classe devem conter a instancia do mediator.
 * Alternativamente, podemos tambem criar metodos que tem como objetivo desacoplar o codigo de bibliotecas de manipulacao de
 * DOM e chamadas AJAX (ex.: jQuery)
 */
function OlookApp(_mediator) {
  var mediator = _mediator;

  shift = function(list, starting_point) {
    return Array.prototype.slice.call(list, starting_point);
  }

  return{
    publish: function(){
      if (arguments.length == 0){
        throw "channel name is required";
      }
      args = shift(arguments,1);
      mediator.publish(arguments[0], args);
    },
    subscribe: function(){
      if (arguments.length == 0){
        throw "channel name is required";
      } else if (arguments.length == 1){
        throw "channel facade method is required";
      }
      var args = shift(arguments,2);

      mediator.subscribe(arguments[0], arguments[1], args);
    }

  }
};

olookApp = new OlookApp(new Mediator());
