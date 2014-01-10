var MinicartUpdateManager = function(){

  var updateMinicart = function(){

  };

  return {
    init: function(){
      olook_app.getMediator().subscribe("updateMinicart", updateMinicart); 
    },
    facade: function(msg){
    }
  };
};

$(function(){
  olook_app.addModule("minicartUpdateManager", new MinicartUpdateManager());
});