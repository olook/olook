/* A classe-namespace. Objetos desta classe devem conter a instancia do mediator.
 * Alternativamente, podemos tambem criar metodos que tem como objetivo desacoplar o codigo de bibliotecas de manipulacao de
 * DOM e chamadas AJAX (ex.: jQuery)
 */
function OlookApp(_mediator) {
  var mediator = _mediator;

  shift = function(list) {
    return Array.prototype.slice.call(list, 1);
  }

  return{
    mediator: mediator,
    publish: function(){
      if (arguments.length == 0){
        throw "channel name is required";
      }
      args = shift(arguments);
      mediator.publish(arguments[0], args);
    },
    subscribe: function(channel){
      if (channel == null || channel == undefined){
        throw "channel is required";
      } else if(StringUtils.isEmpty(channel.name)){
        throw "channel name is required";
      } else if(channel.facade == null || channel.facade == undefined){
        throw "channel facade method is required";
      }
      
      mediator.subscribe(channel.name, channel.facade);
    }

  }
};

var olookApp = null;

$(function(){
  olookApp = olookApp || new OlookApp(new Mediator());
});