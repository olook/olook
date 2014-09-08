var EventTracker = (function(){
  function EventTracker(){};

  EventTracker.prototype.trackEvent = function(category, action, label){
    label = (label || "");
    _gaq.push(['_trackEvent', category, action, label, , true]);
  };

  return EventTracker;
})();

var eventTracker = new EventTracker();