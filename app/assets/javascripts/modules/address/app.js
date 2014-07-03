//= require_self
//= require modules/address/models/address
//= require modules/address/models/freight
//= require modules/address/collections/addresses
//= require modules/address/collections/freights
//= require modules/address/views/address
//= require modules/address/views/list
//= require modules/address/views/form
var app = (function() {

  var api = {
    server_api_prefix: '/api/v1',
    views: {},
    models: {},
    collections: {},
    addresses: null,
    content: null,
    changeContent: function(el) {
        this.content.empty().append(el);
        return this;
    },
    init: function() {
      this.content = $("#main");
      this.addresses = new api.collections.Addresses();
      this.addresses.fetch();
      ViewsFactory.list();
      ViewsFactory.form();
      return this;
    }
  };

  var ViewsFactory = {
      api: api,
      list: function() {
        if(!this.listView) {
          this.listView = new api.views.List({collection: api.addresses,el: $("#addressList")});
        }
        return this.listView;
      },

      form: function() {
        if(!this.formView) {
          this.formView = new api.views.Form({collection: api.addresses,el: $("#main")});
        }
        return this.formView;
      }
  }; 

  api.views = ViewsFactory;

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
} 
