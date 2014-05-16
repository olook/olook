var ModalShow = (function(){
  function ModalShow() {};
  ModalShow.prototype.config = function(){
    olookApp.subscribe('modal:show', this.facade, {}, this);
  };

  ModalShow.prototype.facade = function(data){
    var start = new Date();
    olook.newModal(data.html, data.width, data.height, data.color, function(){
      _gaq.push(['_trackEvent', 'Modal', 'Close', data.name, ( new Date() - start )], true);
    });
  };
  return ModalShow;
})();
