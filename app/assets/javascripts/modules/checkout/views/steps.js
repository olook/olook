app.views.Steps = Backbone.View.extend({
  tagName: 'nav',
  id: 'steps',
  template: _.template($('#tpl-steps').html() || ""),
  render: function() {
    this.$el.html(this.template({}));
  }
});
