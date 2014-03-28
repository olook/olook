var HomeEvents = (function(){
  function HomeEvents(){};

  var trackEvent = function(category, action){
    _gaq.push(['_trackEvent', category, action, '', , true]);
  };

  var trackClick = function(action, logged){
    var loginStatus = (logged) ? "logged" : "unlogged";
    var carouselClass =".js-"+loginStatus+"-carousel";
    $(carouselClass+" .elastislide-"+action).on("click", function(){
      trackEvent(loginStatus.capitalize()+"Home", action.capitalize());
    });
  };

  HomeEvents.prototype.config = function(){
    olookApp.subscribe('home:load', this.facade, {}, this);
  };

  HomeEvents.prototype.facade = function(){
    trackClick("prev", true);
    trackClick("next", true);
    trackClick("prev", false);
    trackClick("next", false);
  };

  return HomeEvents;
})();
