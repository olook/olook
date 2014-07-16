app.views.Payment = Backbone.View.extend({
  tagName: 'p',
  template: _.template($('#tpl-payment').html() || ""),
  events: {
    'click': 'selectPayment'
  },
  render: function() {
    this.$el.removeClass().addClass(this.classNameFromModel());
    var html = this.template(this.model.attributes);
    this.$el.html(html);
    return this;
  },

  classNameFromModel: function() {
    return this.model.get('type');
  },

  selectPayment: function() {
    this.$el.find('input[type=radio]').attr('checked', 'checked');
    olookApp.publish('payment:selected', this.model);
  },

  remove: function() {
    this.$el.remove();
  },
});
