app.views.Debit = Backbone.View.extend({
  className: 'debit',
  template: _.template($("#tpl-debit").html()),

  initialize: function() {
    olookApp.subscribe('payment:debit:show', this.render, {}, this);
    olookApp.subscribe('payment:debit:hide', this.hide, {}, this);
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
