var FacebookAuthSuccess = (function(){
  function FacebookAuthSuccess(){ };

  FacebookAuthSuccess.prototype.config = function () {
    olookApp.subscribe('fb:auth:success', this.facade, {}, this);
  };

  FacebookAuthSuccess.prototype.facade = function (result) {
    if(result.redirectTo){
      if(result.newUser){
        log_event('action','new-facebook-user',{value: 'email'});
        console.log("new user");
      } else {
        console.log("existent user");
      }
      window.location = result.redirectTo;
    }
  };

  return FacebookAuthSuccess;
})();
