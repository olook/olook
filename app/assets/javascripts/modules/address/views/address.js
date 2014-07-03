app.views.Address = Backbone.View.extend({
  model: app.models.Address,
  events: {
    'click input[type=radio]': 'selectAddress'
  },
  initialize: function() {
    /*
      To use {{ variable }} on the templates
     */
    this.template = _.template($("#address-template").html());

    /*
      Events
     */
    this.model.on('destroy', this.remove, this);
    this.model.on('change', this.render, this);
  },

  render: function() {
    var dict = this.model.toJSON();
    var html = this.template(dict);
    this.$el.html(html);
  },

  remove: function() {
    this.$el.remove();
  },

  selectAddress: function() {
    olookApp.publish('address:selected', this.model.attributes);
  }
});
