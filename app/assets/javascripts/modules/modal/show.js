var ModalShow = (function(){
  function ModalShow() {};
  ModalShow.prototype.config = function(){
    olookApp.subscribe('modal:show', this.facade);
  };

  ModalShow.prototype.facade = function(path){
    $.get("/modal", {path: path}).done(function(data){
      olook.newModal(data.html, data.width, data.height, data.color);
    }).fail(function() {
      olookApp.publish("modal:error");
    });
  };
  return ModalShow
})();
