var FacebookAuth = (function(){
  function FacebookAuth() { };

  var displayBeforeChangeMessage = function(){
    if(typeof olook == 'object' && olook.showLoadingScreen)
      olook.showLoadingScreen();
  };

  var displayLoginCompletedMessage = function(){
    if(typeof olook == 'object' && olook.hideLoadingScreen)
      olook.hideLoadingScreen();
  };

  FacebookAuth.prototype.config = function(){
    olookApp.subscribe('fb:auth:login', this.facade, {}, this);
    olookApp.subscribe('fb:auth:before', displayBeforeChangeMessage);
    olookApp.subscribe('fb:auth:complete', displayLoginCompletedMessage);
    new FacebookAuthSuccess().config();
  };

  FacebookAuth.prototype.facade = function(response){
    this.authResponse = response.authResponse;
    this.status = response.status;
    if(this.status !== 'connected') {
      return false;
    }
    olookApp.publish("fb:auth:before");
    $.ajax({
      url: '/facebook_connect',
      type: 'POST',
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify({ authResponse: this.authResponse })
    }).complete(function(){
      olookApp.publish('fb:auth:complete');
    }).success(function(result){
      olookApp.publish('fb:auth:success', result);
    });
  };

  return FacebookAuth;
})();

//Used on data-onlogin attribute in FB Login Button
loginFacebook = function(response) {
  olookApp.publish('fb:auth:login', response);
}
