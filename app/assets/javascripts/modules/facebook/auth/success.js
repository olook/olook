var FacebookAuthSuccess = (function(){
  function FacebookAuthSuccess(){ };

  FacebookAuthSuccess.prototype.config = function () {
    olookApp.subscribe('fb:auth:success', this.facade, {}, this);
  };

  FacebookAuthSuccess.prototype.facade = function (result) {
    if(result.redirectTo){
      window.location = result.redirectTo;
    }
  };

  return FacebookAuthSuccess;
})();
