app.views.CartResume = Backbone.View.extend({
  // tagName: 'li',
  // model: app.models.Address,
  // template: _.template($("#tpl-address").html()),
  // events: {
  //   'click input[type=radio]': 'selectAddress',
  //   'click ul': 'selectAddress',
  //   'click .js-changeAddress': 'changeAddress',
  //   'click .js-removeAddress': 'removeAddress',
  // },
  // initialize: function() {
  //   /*
  //     Events on model callbacks
  //    */
  //   this.model.on('destroy', this.remove, this);
  //   this.model.on('change', this.render, this);
  // },

  render: function() {
    this.$el.html(this.model.attributes.toString());
  },

  // remove: function() {
  //   this.$el.remove();
  // },

  // changeAddress: function() {
  //   olookApp.publish('address:change', this.model);
  // },

  // removeAddress: function() {
  //   this.model.destroy();
  // },

  // selectAddress: function() {
  //   this.$el.find('input[type=radio]').not(':checked').attr('checked', 'checked');
  //   olookApp.publish('address:selected', this.model.attributes);
  // }
});
