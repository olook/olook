var FacebookAuth = (function(){
  function FacebookAuth() { };

  var displayBeforeChangeMessage = function(){
    olook.showLoadingScreen();
  };

  var displayLoginCompletedMessage = function(){
    olook.hideLoadingScreen();
  };

  FacebookAuth.prototype.config = function(){
    olookApp.subscribe('fb:auth:login', this.facade, {}, this);
    new FacebookAuthSuccess().config();
  };

  FacebookAuth.prototype.facade = function(response){
    this.authResponse = response.authResponse;
    this.status = response.status;
    if(this.status !== 'connected') {
      return false;
    }
    displayBeforeChangeMessage();
    $.ajax({
      url: '/facebook_connect',
      type: 'POST',
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify({ authResponse: this.authResponse })
    }).complete(function(){
      displayLoginCompletedMessage();
    }).success(function(result){
      olookApp.publish('fb:auth:success', result);
    });
  };

  return FacebookAuth;
})();

//Used on data-onlogin attribute in FB Login Button
loginFacebookModalFirst = function(response) {
  olookApp.publish('stats:log', {handler: 'facebookModalFirst'});
  olookApp.publish('fb:auth:login', response);
}

loginFacebookModalSecond = function(response) {
  olookApp.publish('stats:log', {handler: 'facebookModalSecond'});
  olookApp.publish('fb:auth:login', response);
}

loginFacebookQuiz = function(response) {
  olookApp.publish('stats:log', {handler: 'facebookQuiz'});
  olookApp.publish('fb:auth:login', response);
}

loginFacebookHeader = function(response) {
  olookApp.publish('stats:log', {handler: 'facebookHeader'});
  olookApp.publish('fb:auth:login', response);
}

loginFacebookPayment = function(response) {
  olookApp.publish('stats:log', {handler: 'facebookPayment'});
  olookApp.publish('fb:auth:login', response);
}
