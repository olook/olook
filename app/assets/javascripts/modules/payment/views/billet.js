app.views.Billet = Backbone.View.extend({
  className: 'billet',
  template: _.template($("#tpl-billet").html() || ""),

  initialize: function() {
    olookApp.subscribe('payment:billet:show', this.render, {}, this);
    olookApp.subscribe('payment:billet:hide', this.hide, {}, this);
  },

  events: {
  },

  attr: function(model) {
    var exp = new Date(model.get('billet_expiration'));
    return {
      billet_expiration: exp.getDate() + "/" + ( exp.getMonth() + 1 ) + "/" + exp.getFullYear(),
    };
  },

  render: function(model) {
    var html = this.template(this.attr(model));
    this.$el.html(html);
    this.$el.show();
  },

  hide: function(){
    this.$el.hide();
  },

});
