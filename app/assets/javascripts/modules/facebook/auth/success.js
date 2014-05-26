var FacebookAuthSuccess = (function(){
  function FacebookAuthSuccess(){ };

  FacebookAuthSuccess.prototype.config = function () {
    olookApp.subscribe('fb:auth:success', this.facade, {}, this);
  };

  FacebookAuthSuccess.prototype.facade = function (result) {
    if(result.redirectTo){
      if(result.newUser){
        olookApp.publish('stats:log', {value: 'email'});
        log_event('action','new-facebook-user',{value: 'email'});
      }
      window.location = result.redirectTo;
    }
  };

  return FacebookAuthSuccess;
})();
