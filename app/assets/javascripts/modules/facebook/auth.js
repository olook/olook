var FacebookAuth = (function(){
  function FacebookAuth() { };

  var getUserData = function(callback) {
    FB.api('/me', callback);
  };

  FacebookAuth.prototype.config = function(){
    olookApp.subscribe('fb:auth:statusChange', this.facade, {}, this);
    // new FacebookAuthSuccess().config();
  };

  FacebookAuth.prototype.facade = function(response){
    olookApp.publish('fb:auth:statusChange:before');
    getUserData(function(userData){
      console.log(userData);
      $.ajax({
        url: '/facebook_connect',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({ facebookData: userData })
      }).complete(function(){
        olookApp.publish('fb:auth:statusChange:complete');
      }).success(function(result){
        olookApp.publish('fb:auth:success');
      }).error(function(){
        olookApp.publish('fb:auth:error');
      });
    });
  };



  return FacebookAuth;
})();
