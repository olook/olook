// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require application_core/olook_app
//= require underscore
//= require backbone
//= require_self
//= require ./modules/checkout/controller
//= require modules/facebook/events
//= require_tree ./modules/facebook/auth
//= require modules/facebook/auth
//= require modules/stats/facebook_stats_logger
//= require modules/analytics/event_tracker

_.templateSettings = {
  evaluate: /\<\%([\s\S]+?)\%\>/g,
  interpolate: /\{\{(.+?)\}\}/g
};

window.token = "Token token=f1eafc9f32b55abfba38cc8f487ba489";
var originalSync = Backbone.sync;
Backbone.sync = function(method, model, options) {
    options.headers = options.headers || {};
    _.extend(options.headers, { 'Authorization': window.token } );
    originalSync.call(model, method, model, options);
}
var app = (function() {
  var api = {
    server_api_prefix: '/api/v1',
    views: {},
    routers: {},
    models: {},
    collections: {},
    content: null,
    init: function() {
      this.content = $("#main");
      olookApp.publish('app:init');
      return this;
    },

    formatted_currency: function(value) {
      var signal = /^-/.test(value) ? "-" : ""
      value = Math.sqrt(Math.pow(value, 2));
      var intvalue = parseInt(value);
      var centsvalue = Math.round(( value - intvalue ) * 100);
      if(centsvalue < 10) {
        centsvalue = "0" + centsvalue;
      }
      var form = signal + " R$ " + intvalue + "," + centsvalue;
      if(/NaN/.test(form)) {
        return "---";
      }
      return form;
    },
  };

  return api;
})();

window.onload = function() {
  app.init();
};
