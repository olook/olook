app.collections.Addresses = Backbone.Collection.extend({
  model: app.models.Address,
  url: '/api/v1/addresses',

  initialize: function() {
    this.on('remove', this.onModelRemoved, this);
  },

  onModelRemoved: function (model, collection, options) {
    model.destroy();
  }


});