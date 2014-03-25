var FacebookAuthSuccess = (function(){
  function FacebookAuthSuccess(){ };

  FacebookAuthSuccess.prototype.config = function () {
    olookApp.subscribe('fb:auth:success', this.facade, {}, this);
  };

  FacebookAuthSuccess.prototype.facade = function (result) {
    if(result.redirectTo){
      _gaq.push(['_trackEvent', 'FacebookLogin', 'ClickSubmit', true]);
      window.location = result.redirectTo;
    }
  };

  return FacebookAuthSuccess;
})();
