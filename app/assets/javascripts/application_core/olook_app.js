/* A classe-namespace. Esta classe contem a instancia do mediator.
 * Alternativamente, podemos tambem criar metodos que tem como objetivo desacoplar o codigo de bibliotecas de manipulacao de
 * DOM e chamadas AJAX (ex.: jQuery)
 */
var OlookApp = function(_mediator) {

  var mediator = _mediator;

  return {
    getMediator: function(){
      return mediator;
    }
  };
};

var olookApp = null;

$(function(){
  olookApp = new OlookApp(new Mediator());
});