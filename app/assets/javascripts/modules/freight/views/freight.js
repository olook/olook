app.views.Freight = Backbone.View.extend({
  tagName: 'p',
  template: _.template($('#tpl-freight').html() || ""),
  events: {
    'click': 'selectFreight'
  },
  render: function() {
    this.$el.removeClass().addClass(this.classNameFromModel());
    var html = this.template(this.model.toTpl());
    this.$el.html(html);
    return this;
  },

  classNameFromModel: function() {
    return this.model.get('kind');
  },

  selectFreight: function() {
    this.$el.find('input[type=radio]').attr('checked', 'checked');
    olookApp.publish('freight:selected', this.model);
  },

  remove: function() {
    this.$el.remove();
  },
});
