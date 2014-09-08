app.views.SelectedAddress = Backbone.View.extend({
  model: app.models.Address,
  class: 'selectedAddress',
  template: _.template($("#tpl-selected-address").html() || ""),

  initialize: function() {
    /*
      Events on model callbacks
     */

  },

  render: function() {
    var html = this.template(this.model.attributes);
    this.$el.html(html);
  },

});
