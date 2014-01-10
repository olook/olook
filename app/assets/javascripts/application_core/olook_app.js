var OlookApp = function() {

  var modules = {};
  var mediator = null;

  return {
    getMediator: function(){
      return mediator;
    },

    getModules: function(){
      return modules;
    },

    addModule: function(moduleName, module){
      modules[moduleName] = module;
      modules[moduleName].init();
    },

    init: function(){
      mediator = new Mediator();
    }
  };
};

var olook_app = null;

$(function(){
  olook_app.init();
});