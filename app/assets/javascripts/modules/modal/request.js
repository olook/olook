var ModalRequest = (function(){
  function ModalRequest(selector) {
    this.selector = selector;
  };
  ModalRequest.prototype.config = function(){
    olookApp.subscribe('modal:request', this.facade);
  };

  ModalRequest.prototype.facade = function(path){
    this.selector.get("/modal", {path: path}).done(function(data){
      olookApp.publish("modal:show", data);
    }).fail(function() {
      olookApp.publish("modal:error");
    });
  };
  return ModalRequest;
})();

