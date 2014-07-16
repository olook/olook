// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require underscore
//= require backbone
//= require_self
//= require ./modules/address/controller
//= require ./modules/freight/controller
//= require ./modules/cart_resume/controller
//= require mask

_.templateSettings = {
  interpolate: /\{\{(.+?)\}\}/g
};
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
    }
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
