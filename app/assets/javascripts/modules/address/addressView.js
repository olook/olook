var AddressView = Backbone.View.extend({
  model: Address,
  template: _.template($("#template").html()),
  initialize: function() {
    this.model.on('sync', this.render());
  },
  render: function() {
    var dict = this.model.toJSON();
    var html = this.template(dict);
    this.$el.html(html);
  }
});