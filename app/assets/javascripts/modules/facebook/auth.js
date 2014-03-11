var FacebookAuth = (function(){
  function FacebookAuth() { };

  FacebookAuth.prototype.config = function(){
    olookApp.subscribe('fb:auth:statusChange', this.facade, {}, this);
    new FacebookAuthSuccess().config();
  };

  FacebookAuth.prototype.facade = function(response){
    this.authResponse = response.authResponse;
    this.status = response.status;
    olookApp.publish('fb:auth:statusChange.before');
    $.ajax({
      url: '/facebook_connect',
      type: 'POST',
      contentType: 'application/json',
      dataType: 'json',
      data: JSON.stringify({ authResponse: this.authResponse })
    }).complete(function(){
      olookApp.publish('fb:auth:statusChange.complete');
    }).success(function(result){
      olookApp.publish('fb:auth:success', result);
    }).error(function(){
      olookApp.publish('fb:auth:error');
    });
  };

  return FacebookAuth;
})();
