var ModalShow = (function(){
  function ModalShow() {};
  ModalShow.prototype.config = function(){
    olookApp.subscribe('modal:show', this.facade);
    olookApp.publish('modal:show', document.URL);
  };

  ModalShow.prototype.facade = function(path){
    $.get("/modal", {path: path}).done(function(data){
      olook.newModal(data, 504, 610, '#fff');
    }).fail(function() {
      console.log("falhou")
    });
  };
  return ModalShow
})();
