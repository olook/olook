app.views.Freight = Backbone.View.extend({
  tagName: 'p',
  template: _.template($('#tpl-freight').html()),
  render: function() {
    this.$el.removeClass().addClass(this.classNameFromModel());
    var html = this.template(this.model.toTpl());
    this.$el.html(html);
    return this;
  },

  classNameFromModel: function() {
    return this.model.get('kind');
  },

  remove: function() {
    this.$el.remove();
  }
});
