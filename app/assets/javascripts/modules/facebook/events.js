var FacebookEvents = (function(){
  function FacebookEvents(){};

  FacebookEvents.prototype.config = function(){
    olookApp.subscribe('fb:load', this.facade, {}, this);
  };

  FacebookEvents.prototype.facade = function(){
    FB.Event.subscribe('edge.create', function(url, element){
      olookApp.mediator.publish('fb:like', url, element);
    });

    FB.Event.subscribe('auth.statusChange', function(response){
      olookApp.mediator.publish('fb:auth:statusChange', response);
    });
  };

  return FacebookEvents;
})();
