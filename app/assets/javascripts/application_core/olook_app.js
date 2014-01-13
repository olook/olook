/* A classe-namespace. Objetos desta classe devem conter a instancia do mediator.
 * Alternativamente, podemos tambem criar metodos que tem como objetivo desacoplar o codigo de bibliotecas de manipulacao de
 * DOM e chamadas AJAX (ex.: jQuery)
 */
function OlookApp(mediator) {
  this.mediator = mediator;
};

var olookApp = null;

$(function(){
  olookApp = new OlookApp(new Mediator());
});