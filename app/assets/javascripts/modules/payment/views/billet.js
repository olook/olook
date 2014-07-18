app.views.Billet = Backbone.View.extend({
  className: 'billet',
  template: _.template($("#tpl-billet").html() || ""),

  initialize: function() {
    olookApp.subscribe('payment:billet:show', this.render, {}, this);
    olookApp.subscribe('payment:billet:hide', this.hide, {}, this);
  },

  events: {
  },

  render: function(model) {
    var html = this.template(model.attributes);
    this.$el.html(html);
    this.$el.show();
  },

  hide: function(){
    this.$el.hide();
  }

});
