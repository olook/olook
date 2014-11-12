var ModalRequest = (function(){
  function ModalRequest(selector) {
    this.selector = selector;
  };

  ModalRequest.prototype.config = function(){
    olookApp.subscribe('modal:request', this.facade, {}, this);
  };

  ModalRequest.prototype.facade = function(path){
    var params = {path: path};
    if(/rise|adlead/i.test(window.location.search)){
      params.partner = "nomodal";
    }
    this.selector.get("/modal", params).done(function(data){
      olookApp.publish("modal:show", data);
    }).fail(function() {
      olookApp.publish("modal:error");
    });
  };
  return ModalRequest;
})();

