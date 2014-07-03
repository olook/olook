//= require lib/mediator
//= require_self
//= require application_core/scroll_events
//= require string_utils

/* A classe-namespace. Objetos desta classe devem conter a instancia do mediator.
 * Alternativamente, podemos tambem criar metodos que tem como objetivo desacoplar o codigo de bibliotecas de manipulacao de
 * DOM e chamadas AJAX (ex.: jQuery)
 */
var OlookApp = (function() {
  function OlookApp(_mediator) {
    this.mediator = _mediator;
    this.loadedModules = [];
  };

  var shift = function(list, starting_point) {
    return Array.prototype.slice.call(list, starting_point);
  };

  OlookApp.prototype.publish = function() {
    if (arguments.length == 0){
      throw "channel name is required";
    }
    // console.log('mediator ' + arguments[0] + ' fired');
    this.mediator.publish.apply(this.mediator, arguments);
  };

  OlookApp.prototype.subscribe = function() {
    if (arguments.length == 0){
      throw "channel name is required";
    } else if (arguments.length == 1){
      throw "channel facade method is required";
    }
    var options = (arguments.length >= 3) ? arguments[2] : null;
    var context = (arguments.length >= 4) ? arguments[3] : null;
    var single = (arguments.length >= 5) ? arguments[4] : null;
    // console.log('mediator ' + arguments[0] + ' subscribed by ' + arguments[1]);
    if(single) {
      if(this.loadedModules.indexOf(single) >= 0) return;
      this.loadedModules.push(single);
    }
    this.mediator.subscribe(arguments[0], arguments[1], options, context);
  };

  return OlookApp;
})();

var olookApp = new OlookApp(new Mediator());
