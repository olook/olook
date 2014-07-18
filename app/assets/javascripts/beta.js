// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require application_core/olook_app
//= require mask
//= require underscore
//= require backbone
//= require_self
//= require ./modules/address/controller
//= require ./modules/freight/controller
//= require ./modules/payment/controller
//= require ./modules/cart_resume/controller
//= require ./modules/checkout/controller

_.templateSettings = {
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
    models: {},
    collections: {},
    content: null,
    init: function() {
      this.content = $("#main");
      olookApp.publish('app:init');
      return this;
    },

    formatted_currency: function(value) {
      var intvalue = parseInt(value);
      var centsvalue = Math.round(( value - intvalue ) * 100);
      if(centsvalue < 10) {
        centsvalue = "0" + centsvalue;
      }
      return "R$ " + intvalue + "," + centsvalue;
    },
  };

  // /* definir o router aqui */
  // var Router = Backbone.Router.extend({
  //     api: api,
  //     routes: {
  //         "new": "newAddress",
  //         "edit/:index": "editAddress",
  //         "delete/:index": "deleteAddress",
  //         "": "list"
  //     },
  //     list: function(archive) {
  //       var view = api.views.list();
  //       api.changeContent(view.$el);
  //       view.render();
  //       console.log("listing");
  //     },
  //     newAddress: function() {
  //       console.log("new");
  //     },
  //     editAddress: function(index) {
  //       console.log("editing");
  //     },
  //     deleteAddress: function(index) {
  //       console.log("excluding");
  //     }
  // });

  // api.router = new Router();

  // Backbone.history.start();

  return api;
})();

window.onload = function() {
  app.init();
};
