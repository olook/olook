var app = (function() {

  var api = {
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
      // ViewsFactory.list();
      ViewsFactory.form();
      return this;
    }
  };

  var ViewsFactory = {
      api: api,
      list: function() {
        if(!this.listView) {
          debugger;
          this.listView = new api.views.List({collection: api.addresses,el: $("#main")});
          this.listView.render();
        }
        return this.menuView;
      },

      form: function() {
        if(!this.formView) {        
          this.formView = new api.views.Form({collection: api.addresses,el: $("#main")}).on("saved", function() {
            api.router.navigate("", {trigger: true});
          });
          this.formView.render();
        }
        return this.formView;
      }
  }; 

  api.views = ViewsFactory;

  /* definir o router aqui */
  var Router = Backbone.Router.extend({
      api: api,
      routes: {
          "new": "newAddress",
          "edit/:index": "editAddress",
          "delete/:index": "deleteAddress",
          "": "list"
      },
      list: function(archive) {
        debugger;
        var view = api.views.list();
        api.changeContent(view.$el);
        view.render();
        console.log("listing");
      },
      newAddress: function() {
        console.log("new");
      },
      editAddress: function(index) {
        console.log("editing");
      },
      deleteAddress: function(index) {
        console.log("excluding");
      }
  });

  api.router = new Router();

  Backbone.history.start();

  return api;
})();

window.onload = function() {
  app.init();
} 