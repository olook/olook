app.views.Freight = Backbone.View.extend({
  template: _.template($('#tpl-freight').html()),
  render: function() {
    var html = this.template(this.model.toTpl());
    this.$el.html(html);
    return this;
  },

  remove: function() {
    this.$el.remove();
  }
});
